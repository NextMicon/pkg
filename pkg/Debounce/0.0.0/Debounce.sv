module Debounce #(
    parameter DELAY_CNT = 128
) (
    input wire clk,
    input wire resetn,

    input  wire in,
    output reg  rise,
    output reg  out,
    output reg  fall
);

  reg [$clog2(DELAY_CNT)-1:0] cnt = 0;
  reg [1:0] shift = 2'b00;

  // Shift Reg to Syncronize input
  always @(posedge clk) begin
    shift <= {shift[0], in};
  end

  always @(posedge clk) begin
    if (cnt == 0) begin  // Waiting Edge
      if (shift == 2'b01) begin  // Detect Rising Edge
        rise <= 1;
        fall <= 0;
        out  <= 1;
        cnt  <= DELAY_CNT - 1;
      end else if (shift == 2'b10) begin  // Detect Falling Edge
        rise <= 0;
        fall <= 1;
        out  <= 0;
        cnt  <= DELAY_CNT - 1;
      end
    end else begin  // Ignore Change until DLAY_CNT * clk
      rise <= 0;
      fall <= 0;
      cnt  <= cnt - 1;
    end
  end

endmodule
