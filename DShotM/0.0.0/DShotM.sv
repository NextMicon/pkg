////////////////////////////////////////////////////////////////////////////
// DShotM (Master) /////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
//       : _  :_   _   _   _   _   _   _   _   _   _   _   _   _   _   _  //
// clk   :  |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| |_| | //
//       :    :_______                                                    //
// wstrb : ___/       \__________________________________________________ //
//       :    :                                                           //
// iosel : in | out                 | in                                  //
//       :    :   :_____    _____   :     :                               //
// tx    : ___:___/  \__\__/  \__\__:-----:------------------------------ //
//       :    :   :                 :     :_____    _____                 //
// rx    : ---:---:-----------------:-----/  \__\__/  \__\__:____:_______ //
//       :    :   :                 :     :                 :    :____    //
// ready : ___:___:_________________:_____:_________________:____/    \__ //
//       :    :   :                 :     :                 :    :        //
//      [0]  [1] [2]               [3]   [4]               [5]  [6]       //
////////////////////////////////////////////////////////////////////////////

// [1] 送信シーケンスは wstrb によって開始されます
// [2] ビットを出力します
// [3] 制御フレームの送信を終了し30us待機します
// [4] テレメトリの受信を開始します
// [5] 受信を終了しCRCを確認します
// [6] レジスタに受信データとチェックサムの合否を格納します

module DShotM #(
    parameter CLK_FREQ = 16000000,  // 16 mHz
    parameter SPEED    =   600000   // 600 kHz
) (
    input wire clk,
    input wire resetn,

    input wire valid,
    output reg ready,
    input wire [31:0] addr,
    input wire [3:0] wstrb,
    input wire [31:0] wdata,
    output reg [31:0] rdata,

    output reg  iosel,
    output reg  tx,
    input  wire rx
);

  reg [ 5:0] state;
  reg [ 3:0] bit_cnt;
  reg [ 1:0] phase_cnt;
  reg [ 5:0] time_cnt;

  reg [15:0] dsnd;
  reg [15:0] drcv;

  localparam TRANS_CNT = CLK_FREQ / SPEED / 3;  // = 8.88...

  localparam WAITING = 6'b000001;
  localparam CALC_TX = 6'b000010;
  localparam SENDING = 6'b000100;
  localparam WAIT_RX = 6'b001000;
  localparam RECVING = 6'b010000;
  localparam ENDING = 6'b100000;

  // always @(posedge clk) begin
  //   if (!resetn) begin  // [0] Initial state
  //     state <= WAITING;
  //     iosel <= 0;
  //     tx    <= 0;
  //   end else begin
  //     ready <= valid && state == ENDING;
  //     rdata <= {16'b0, drcv};
  //     (* full_case *)
  //     case (state)
  //       WAITING: begin
  //         if (wstrb) begin  // [1] Start
  //           dsnd <= {
  //             wdata[15:5],  // Moter Control Command
  //             wdata[4],  // Telemetry Request
  //             (wdata[7:4] ^ wdata[11:8] ^ wdata[15:12])  // CRC
  //           };
  //           state <= SENDING;
  //           bit_cnt <= 15;
  //           phase_cnt <= 0;
  //           time_cnt <= TRANS_CNT;
  //           tx <= 1;
  //         end
  //       end
  //       SENDING: begin
  //         case (phase_cnt)
  //           0: begin
  //             phase_cnt <= 1;
  //             tx <= dsnd[bit_cnt];
  //           end
  //           1: begin
  //             if (count != 0) begin  // [B]
  //               sclk <= 0;
  //               count <= count - 1;
  //               mosi <= dsnd[count];
  //               drcv[count] <= miso;
  //             end else begin  // [E] ENDING
  //               state <= ENDING;
  //               count <= 1;
  //             end
  //           end
  //         endcase
  //       end
  //       WAIT_RX: begin
  //       end
  //       RECVING: begin
  //       end
  //       ENDING: begin
  //         case (count)
  //           1: begin
  //             count <= 0;
  //           end
  //           0: begin
  //             state <= WAITING;
  //           end
  //         endcase
  //       end
  //     endcase
  //   end
  // end
endmodule
