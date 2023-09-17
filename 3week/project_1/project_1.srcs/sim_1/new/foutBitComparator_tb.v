`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 17:09:55
// Design Name: 
// Module Name: foutBitComparator_tb
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


module foutBitComparator_tb();

    reg [3:0] a,b;
    wire x,y,z;
    
    fourBitComparator FBC(a,b,x,y,z);
    
    initial begin
    a = 4'b0011; b= 4'b1000;
    #250
    a = 4'b0111; b= 4'b0001;
    #250
    a = 4'b1001; b= 4'b1001;
    #250
    a = 4'b1011; b= 4'b1111;

    end
    
    
endmodule
