//////////////////////////////////////////////////////////////////
// RotEnc ////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////

module RotEnc #(
) (
    input wire clk,
    input wire resetn,

    input wire valid,
    output reg ready,
    input wire [3:0] wstrb,
    input wire [31:0] addr,
    input wire [31:0] wdata,
    output reg [31:0] rdata,

    input wire a,
    input wire b,
    input wire z
);

endmodule
