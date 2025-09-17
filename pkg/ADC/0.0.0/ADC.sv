//////////////////////////////////////////////////////////////
// SPI_Master ////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
//       : _  :_   _   _   _   _   _   _  :_   _   _   _    //
// clk   :  |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_  //
//       :    :___:___:___________________:___:__           //
// wstrb : ___/   :   :                   :   :  \_________ //
//       :    :   :   :                   :   :   :         //
// state : W  X SENDING                   XENDING X WAITING //
//       :    :___:___:_______     _______:___:___:         //
// count : ___/___7___X___6___X...X___0___X_1_X_0_\_0______ //
//       :    :   :___:    ___         ___:   :   :         //
// sclk  : _______/   \___/   \...\___/   \________________ //
//       :    :___:___:_______     _______:   :   :         //
// mosi  : ---<__[7]__X_[6]___X...X_[0]___>---------------- //
//       :    :___:___:_______     _______:   :   :         //
// miso  : ---<__[7]__X_[6]___X...X_[0]___>---------------- //
//       :    :   :   :                   :______ :         //
// ready : _______________________________/      \______    //
//       :    :   :   :                   :       :         //
//      [I]  [S] [A] [B]                 [E]     [W]        //
//////////////////////////////////////////////////////////////

// [S] 送受信はレジスタへの書き込み信号 wstrb によって開始されます
//     最初のデータをMOSIに出力します
// [A] ここでデータをキャプチャします
// [B] 次のデータをMOSIに出力します
// [E] 1 バイトの送受信を終了します
//     レジスタに受信データをセットし ready をアサートします
// ※ SSはGPIOで制御します

module ADC #(
    parameter CPOL = 0,
    parameter CPHA = 0
) (
    input wire clk,
    input wire resetn,

    input wire valid,
    output reg ready,
    input wire [31:0] addr,
    input wire [3:0] wstrb,
    input wire [31:0] wdata,
    output reg [31:0] rdata,

    output reg  sclk,
    output reg  mosi,
    input  wire miso
);

  reg [2:0] state;
  reg [2:0] count;
  reg [7:0] dsnd;
  reg [7:0] drcv;

  localparam WAITING = 3'b001;
  localparam SENDING = 3'b010;
  localparam ENDING = 3'b100;

  always @(posedge clk) begin
    if (!resetn) begin  // [I] Initial state
      state <= WAITING;
      count <= 0;
      sclk  <= 0;
      mosi  <= 0;
      dsnd  <= 0;
      drcv  <= 0;
    end else begin
      ready <= valid && state == ENDING;
      rdata <= {24'b0, dsnd};
      (* full_case *)
      case (state)
        WAITING: begin
          if (wstrb) begin  // [S] Start SENDING
            dsnd  <= wdata[7:0];  // Latch send data
            state <= SENDING;
            count <= 7;
            sclk  <= 0;
            mosi  <= wdata[7];
          end
        end
        SENDING: begin
          case (sclk)
            0: begin  // [A]
              sclk <= 1;
            end
            1: begin
              if (count != 0) begin  // [B]
                sclk <= 0;
                count <= count - 1;
                mosi <= dsnd[count];
                drcv[count] <= miso;
              end else begin  // [E] ENDING
                state <= ENDING;
                count <= 1;
              end
            end
          endcase
        end
        ENDING: begin
          case (count)
            1: begin
              count <= 0;
            end
            0: begin
              state <= WAITING;
            end
          endcase
        end
      endcase
    end
  end
endmodule
