`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/24 21:30:20
// Design Name: 
// Module Name: TFlipFlop_WithOneShot_tb
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


module TFlipFlop_WithOneShot_tb( );

reg clk, rst, T;
wire Q;

TFlipFlop_WithOneShot TFFWOS(clk, rst, T, Q);

initial begin
    clk <=0;
    rst <= 1;
    T <= 0;
    #10 rst <=0;
    #10 rst <=1;
    #80 T <=0;
    #200 T <=1;
    #80 T <=0;
    #200 T <=1;
    #80 T <=0;
    #200 T <=1;
    #80 T <=0;
end

always begin
    #5 clk <= ~clk;
end
    
endmodule
