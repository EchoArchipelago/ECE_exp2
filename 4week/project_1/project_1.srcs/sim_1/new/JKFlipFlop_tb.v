`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/24 19:22:23
// Design Name: 
// Module Name: JKFlipFlop_tb
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


module JKFlipFlop_tb();

reg J, K, clk;
wire Q;

JKFlipFlop JFF (clk,J,K,Q);

initial begin
  clk <= 0;
    J = 0; K = 0;
    #30
    J = 0; K = 1;
    #30
    J = 0; K = 0;
    #30
    J = 1; K = 0;
    #30
    J = 0; K = 0;
    #30
    J = 1; K = 1;
    #30
    J = 0; K = 0;
    end
    
always begin
    #5 clk <= ~clk;
    end
    

endmodule
