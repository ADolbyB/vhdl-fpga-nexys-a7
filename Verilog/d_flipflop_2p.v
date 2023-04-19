/*
Joel Brigida
CDA 4240C: Digital Design Lab
This is an example of 2 D Flip Flops in parallel
*/

module d_flipflop_2p (D, CLK, Q1, Q2);
    input D, CLK;
    output reg Q1, Q2;

    always @(posedge CLK) begin
        Q1 = D;
        Q2 = Q1;
    end

endmodule