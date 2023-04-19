/*
Joel Brigida
CDA 4240C: Digital Design Lab
This is a Positional Association Serial chain of 4 4bit adders.
*/

module adder( input  [3:0] A, B,
              output       COUT,
              output [3:0] SUM );

    wire C0, C1, C2;

    FullAdd FA0( A[0], B[0], 0, C0, SUM[0] );
    FullAdd FA1( A[1], B[1], C0, C1, SUM[1] );
    FullAdd FA2( A[2], B[2], C1, C2, SUM[2] );
    FullAdd FA3( A[3], B[3], C2, COUT, SUM[3] );

endmodule