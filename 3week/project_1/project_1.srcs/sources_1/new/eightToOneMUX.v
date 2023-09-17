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
 //Selctor�� S�� �������� ���� I�� ���ڸ� ���ϰ�, �� ���ڿ� �˸´� input���� Output���� �������� 8:1 MUX�̴�.
     assign I0 = 4'b0000;
     assign I1 = 4'b0001;
     assign I2 = 4'b0101;
     assign I3 = 4'b1001;
     assign I4 = 4'b0110;
     assign I5 = 4'b1110;
     assign I6 = 4'b1010;
     assign I7 = 4'b1111;
     
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