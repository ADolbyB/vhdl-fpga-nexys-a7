/*
Joel Brigida
CDA 4240C: Digital Design Lab
This is an example of a D Flip Flops with async reset
Uses Non-Blocking Assignment
*/

module flipflop_async (D, CLK, RESET, Q);
    input D, CLK, RESET;
    output reg Q;

    always @(negedge RESET, posedge CLK) begin
        if (!RESET)
            Q <= 0;
        else
            Q <= D;
    end

endmodule