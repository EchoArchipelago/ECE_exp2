`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 21:52:13
// Design Name: 
// Module Name: eightToOneMUX_tb
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


module eightToOneMUX_tb();

     wire [3:0] I0, I1, I2, I3, I4, I5, I6, I7;
     reg S0, S1, S2; 
     wire [3:0] O;
     
     eightToOneMUX e(I0, I1, I2, I3, I4, I5, I6, I7, S0, S1, S2, O);
     
     assign I0 = 4'b0000;
     assign I1 = 4'b0001;
     assign I2 = 4'b0101;
     assign I3 = 4'b1001;
     assign I4 = 4'b0110;
     assign I5 = 4'b1110;
     assign I6 = 4'b1010;
     assign I7 = 4'b1111;

     
     initial begin
    S0 =0; S1 = 0; S2 = 0;
    #125
    S0 =0; S1 = 0; S2 = 1;
    #125
    S0 =0; S1 = 1; S2 = 0;
    #125
    S0 =0; S1 = 1; S2 = 1;
    #125
    S0 =1; S1 = 0; S2 = 0;
    #125
    S0 =1; S1 = 0; S2 = 1;
    #125
    S0 =1; S1 = 1; S2 = 0;
    #125
    S0 =1; S1 = 1; S2 = 1;
    end
    
     

endmodule

