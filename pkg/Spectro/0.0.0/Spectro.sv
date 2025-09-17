module Spectro (
    input wire clk,
    input wire resetn,

    input wire valid,
    output reg ready,
    input wire [3:0] wstrb,
    input wire [31:0] addr,
    input wire [31:0] wdata,
    output reg [31:0] rdata,

    input wire [7:0] in,
    input wire sample
);

  reg [31:0] threshold;
  reg [31:0] counter;

  always @(posedge clk) begin
    if (!resetn) begin
      threshold <= 0;
      counter   <= 0;
    end else begin
      ready <= valid;
      rdata <= threshold;
      if (wstrb[0]) threshold[7:0] <= wdata[7:0];
      if (wstrb[1]) threshold[15:8] <= wdata[15:8];
      if (wstrb[2]) threshold[23:16] <= wdata[23:16];
      if (wstrb[3]) threshold[31:24] <= wdata[31:24];
    end
  end

endmodule
