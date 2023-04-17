/*
Joel Brigida
CDA 4240C: Digital Design Lab

This is a simple 8-bit tri-state buffer example in Verilog.
*/

module tri_state(input oe, input [7:0] a, output [7:0] y);

    assign y = oe ? a : 8'bZZZZZZZZ;

endmodule