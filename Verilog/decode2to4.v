/*
Joel Brigida
CDA 4240C: Digital Design Lab
This is a 2to4 decoder w/ Enable Example
*/

module dec2to4 (W, EN, Y);
    input [1:0] W;
    input EN;
    output reg [0:3];

    always @(W, EN) begin
        case({EN, W})
            3'b100: Y = 4'b1000;
            3'b101: Y = 4'b0100;
            3'b110: Y = 4'b0010;
            3'b111: Y = 4'b0001;
            default: Y = 4'b0000;
        endcase
    end

endmodule