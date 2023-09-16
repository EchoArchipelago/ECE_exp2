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


module logic_gate5_tb();
reg  a, b;

wire v, w, x, y, z;

logic_gate5 u1(a,b,v,w,x,y,z);

initial begin
    a=0; b=0; 
    #25             
    a=0; b=1; 
    #25    
    a=1; b=0;
    #25
    a=1; b=1;

end


endmodule

