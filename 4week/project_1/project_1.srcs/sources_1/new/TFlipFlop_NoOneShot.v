`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/24 20:35:01
// Design Name: 
// Module Name: TFlipFlop_NoOneShot
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


module TFlipFlop_NoOneShot(
clk, rst, T, Q
    );
input T, clk, rst;
output reg Q;

always @(posedge clk or negedge rst)
begin
    if(!rst) //rst가 0이면 Q는 1'b0
        Q <= 1'b0;
    else if(T)  //T가 1이면 Q는 보수
        Q <= ~Q;
end
endmodule
