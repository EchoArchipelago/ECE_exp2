`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 21:08:30
// Design Name: 
// Module Name: fourToTwoPriorityEncoder_tb
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


module fourToTwoPriorityEncoder_tb();
    reg [3:0] D;
    wire x, y, z;
    
    fourToTwoPriorityEncoder fTTPE(D,x,y,z);
    
    initial begin
    D = 4'b0000;
    #200
    D = 4'b1000;
    #200
    D = 4'b1011;
    #200
    D = 4'b0101;
    #200
    D = 4'b0001;
    end
    
     
endmodule
