/*
Joel Brigida
CDA 4240C: Digital Design Lab
This is a D Flip Flop Example
*/

module d_flipflop (D, CLK, Q);
    input D, CLK;
    output reg Q;

    always @(posedge CLK) begin
        Q = D;
    end

endmodule