/*
Joel Brigida
CDA 4240C: Digital Design Lab
This is an example of a Finite State Machine with 3 states
Uses Non-Blocking Assignment
Output: S0 -> 0, S1 -> 0, S2 -> 1
*/

module FiniteState (Q, I, CLK, RST);
    input I, CLK, RST;
    output Q;
    reg Q;
    reg [1:0] state;
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;

    always @(posedge CLK or posedge RST)
        if (RST) begin
            state <= S0;
            Q <= 1'b0;
        end else begin
            case (state)
                S0: if (I == 1'b1) begin
                    state <= S1;    // Transition to S1 when I = 1
                    Q <= 1'b0;
                end else begin
                    state <= S0;    // Stay in S0
                    Q <= 1'b0;
                end

                S1: if (I == 1'b1) begin
                    state <= S2;    // Transition to S2 when I = 1
                    Q <= 1'b0;
                end else begin
                    state <= S1;    // Stay in S1
                    Q <= 1'b0;
                end

                S2: if (I == 1'b1) begin
                    state <= S2;    // Stay in S2 when I = 1
                    Q <= 1'b1;      // Output = 1 in S2
                end else begin
                    state <= S0;    // Transition to S1 when I = 0
                    Q <= 1'b0;
                end
            endcase
        end
endmodule