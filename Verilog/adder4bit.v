/*
Joel Brigida
CDA 4240C: Digital Design Lab
This is a 4-bit Adder example in Verilog
*/


module adder(input [3:0] A, B, 
             output cout, 
             output [3:0] sum);

    wire [3:0] carry;   // Define a wire to store carry bits for each bit of the sum

    assign {cout, sum} = A + B;   // Add the inputs and assign the result to the outputs

    // Generate the carry bit for each bit of the sum
    // Note that the carry for the most significant bit is not used in this implementation
    assign carry = {A[0], A[1], A[2]} + {B[0], B[1], B[2]};
    
endmodule