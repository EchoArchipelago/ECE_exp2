`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/24 20:38:28
// Design Name: 
// Module Name: TFlipFlop_NoOneshot_tb
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


module TFlipFlop_NoOneshot_tb();

reg clk, rst, T;
wire Q;

TFlipFlop_NoOneShot TFF(clk,rst,T,Q);

initial begin
    clk <= 0;
    rst <= 1;
    #10 rst <= 0;
    #10 rst <= 1;
    #80 T <= 1;
    #100 T <= 0;
    #80 T <= 1;
    #100 T <= 0;
    #80 T <= 1;
    #100 T <= 0;
    #80 T <= 1;
end

always begin
    #5 clk <= ~clk;
end
    
endmodule
