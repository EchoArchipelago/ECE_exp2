`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/24 17:35:05
// Design Name: 
// Module Name: DFlipFlop_tb
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


module DFlipFlop_tb();

wire Q;
reg clk,D;

DFlipFlop DFF (D,clk,Q);

initial begin
    clk <= 0;
    #30 D <=0;
    #30 D <=1;
    #30 D <=0;
    #30 D <=1;
    #30 D <=0;
    #30 D <=1;
    end
always begin
    #5 clk <= ~clk;
    end
    


endmodule
