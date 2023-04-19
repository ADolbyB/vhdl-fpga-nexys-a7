/*
Joel Brigida
CDA 4240C: Digital Design Lab

This is a simple 2-1 mux example using ALWAYS statement
*/

module mux2to1(W0, W1, S, F);
    input W0, W1, S;
    output reg F;

    always @(W0, W1, S) begin   // Sensitivity List
        F = S ? W1 : W0;        // Executes When A Sensitivity List Signal Changes
    end

endmodule