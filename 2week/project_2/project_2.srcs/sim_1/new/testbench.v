`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/10 14:01:46
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testbench(a, b, v, w, x, y, z);

reg a, b;
wire v, w, x, y, z;

assign v = a & b;
assign w = a | b;
assign x = a ^ b;
assign y = ~(a | b);
assign z = ~(a & b);


initial begin
    a = 1'b0;
    b = 1'b0;
    #20
    a = 1'b0;
    b = 1'b1;
    #20
    end



endmodule