/*
Joel Brigida
CDA 4240C: Digital Design Lab

This is a simple 2-1 mux example using IF-ELSE statements
*/

module mux2to1(W0, W1, S, F);
    input W0, W1, S;
    output reg F;

    always @(W0, W1, S) begin   // Sensitivity List
        if (s == 0)
            F = W0;
        else
            F = W1;
    end

endmodule