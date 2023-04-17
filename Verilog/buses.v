/*
Joel Brigida
CDA 4240C: Digital Design Lab

This is an example of concatenating parts of 2 buses into a new bus
*/
module buses(a_bus, b_bus, c_bus);

    input[7:0] a_bus;
    input[7:0] b_bus;
    output[7:0] c_bus;

    // signal concatenation:
    assign c_bus[5:0] = {b_bus[7], a_bus[6:3], 1'b0};

endmodule