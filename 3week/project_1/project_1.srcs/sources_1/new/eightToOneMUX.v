`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 21:51:50
// Design Name: 
// Module Name: eightToOneMUX
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



module eightToOneMUX(
    input wire [3:0] I0, I1, I2, I3, I4, I5, I6, I7,
    input wire S0, S1, S2, 
    output reg [3:0] O 
    );
 //Selctor인 S의 이진값에 따라 I의 숫자를 정하고, 그 숫자에 알맞는 input값을 Output으로 내보내는 8:1 MUX이다.

     
         always @ (*) begin
    
        case({S2, S1, S0})
            3'b000 : O = I0;
            3'b001 : O = I1;
            3'b010 : O = I2;
            3'b011 : O = I3;
            3'b100 : O = I4;
            3'b101 : O = I5;
            3'b110 : O = I6;
            3'b111 : O = I7;
        endcase
    end
 
endmodule