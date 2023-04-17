/*
Joel Brigida
CDA 4240C: Digital Design Lab

This is a simple 2-1 mux example in Verilog
*/

module mux(a, b, sel, y);

    input a;
    input b;
    input sel;
    output y;

    // y <= a WHEN sel = '0' ELSE b; -- VHDL equivalent assignment
    
    // if sel = 1 (TRUE) then y = b, else a
    assign y = sel ? b : a; // Ternary operator like C/C++ 

endmodule