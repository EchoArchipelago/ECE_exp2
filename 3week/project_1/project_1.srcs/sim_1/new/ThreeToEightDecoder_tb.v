`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 18:33:51
// Design Name: 
// Module Name: ThreeToEightDecoder_tb
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


module ThreeToEightDecoder_tb();
    reg x,y,z;
    wire [7:0] D;
    ThreeToEightDecoder TTED (x,y,z,D);
    
    initial begin
    x = 1'b0; y = 1'b0; z = 1'b0;
    #125
     x = 1'b0; y = 1'b0; z = 1'b1;
    #125
     x = 1'b0; y = 1'b1; z = 1'b0;
    #125
     x = 1'b0; y = 1'b1; z = 1'b1;
    #125
     x = 1'b1; y = 1'b0; z = 1'b0;
    #125
     x = 1'b1; y = 1'b0; z = 1'b1;
    #125
     x = 1'b1; y = 1'b1; z = 1'b0;
    #125
     x = 1'b1; y = 1'b1; z = 1'b1;
    end
    
endmodule
