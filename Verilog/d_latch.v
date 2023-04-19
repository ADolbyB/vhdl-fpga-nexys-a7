/*
Joel Brigida
CDA 4240C: Digital Design Lab
This is a D-Latch Example
*/

module d_latch (D, CLK, Q);
    input D, CLK;
    output reg Q;

    always @(D, CLK) begin
        if (CLK)
            Q = D;
    end

endmodule