/*
Joel Brigida
CDA 4240C: Digital Design Lab
This is a 4to1 mux example using a compound ternary operator
*/

module mux4to1 (W0, W1, W2, W3, SEL, F);
    input W0, W1, W2, W3;
    input [1:0] SEL;
    output F;

    assign F = SEL[1] ? (SEL[0] ? W3 : W2) : (SEL[0] ? W1 : W0);

endmodule