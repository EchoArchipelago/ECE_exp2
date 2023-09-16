//`timescale 1ns / 1ps


module logic_gate(a, b, x, y ,z);

input a, b;

output x,y,z;

wire x,y,z;

assign x = a & b;

assign y = a | b;

assign z = a ^ b;

endmodule
