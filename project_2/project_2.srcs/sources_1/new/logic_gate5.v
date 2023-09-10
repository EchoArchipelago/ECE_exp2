`timescale 10ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/10 11:41:27
// Design Name: 
// Module Name: logic_gate5
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


module logic_gate5(a ,b ,v, w, x, y, z);

input [1:0] a,b;
output [1:0] v, w, x, y, z;
wire [1:0] v,w,x,y,z;

assign v = a & b;
assign w = a | b;
assign x = a ^ b;
assign y = ~(a & b);
assign z = ~(a ^ b);



endmodule

