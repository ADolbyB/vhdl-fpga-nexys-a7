/*
Joel Brigida
CDA 4240C: Digital Design Lab
This is a Named Association Serial chain of 4 4bit adders.
*/

module adder( input  [3:0] A, B,
              output       COUT,
              output [3:0] SUM );

    wire C0, C1, C2;

    FullAdd FA0( .a(A[0]), .b(B[0]), .cin(0), .cout(C0), .sum(SUM[0]) );
    FullAdd FA1( .a(A[1]), .b(B[1]), .cin(C0), .cout(C1), .sum(SUM[1]) );
    FullAdd FA2( .a(A[2]), .b(B[2]), .cin(C1), .cout(C2), .sum(SUM[2]) );
    FullAdd FA3( .a(A[3]), .b(B[3]), .cin(C2), .cout(COUT), .sum(SUM[3]) );

endmodule