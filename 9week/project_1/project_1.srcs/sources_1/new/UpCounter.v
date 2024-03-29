`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/30 07:26:54
// Design Name: 
// Module Name: UpCounter
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


module UpCounter(clk,rst,x,state

    );
    input clk, rst;
    input x;
    reg x_reg, x_trig;
    output reg [1:0] state;
    
    always @(negedge rst or posedge clk) begin
    if(!rst) begin 
        {x_reg, x_trig} <= 2'b00;
    end
    else begin
        x_reg <= x;
        x_trig <= x & ~x_reg;
    end
end

always @(negedge rst or posedge clk) begin
    if(!rst) state <= 2'b00;
    else begin
        case(state)
            2'b00 : state <= x_trig ? 2'b01 : 2'b00;
            2'b01 : state <= x_trig ? 2'b10 : 2'b01;
            2'b10 : state <= x_trig ? 2'b11 : 2'b10;
            2'b11 : state <= x_trig ? 2'b00 : 2'b11;
        endcase
    end
end
  
endmodule
