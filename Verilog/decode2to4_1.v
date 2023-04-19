/*
Joel Brigida
CDA 4240C: Digital Design Lab
This is an alternate implementation of a 2to4 decoder w/ Enable.
*/

module dec2to4 (W, EN, Y);
    input [1:0] W;
    input EN;
    output reg [0:3];

    always @(W, EN) begin
        if (EN == 0)
            Y = 4'b0000;
        else
            case(W)
                0: Y = 4'b1000;
                1: Y = 4'b0100;
                2: Y = 4'b0010;
                3: Y = 4'b0001;
            endcase
    end

endmodule