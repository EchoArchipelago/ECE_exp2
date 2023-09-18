`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/18 02:02:24
// Design Name: 
// Module Name: fourToOneMUX_tb
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


module fourToOneMUX_tb();
    
     wire [1:0] I0,I1,I2,I3;
     reg S0,S1;
     wire [1:0] O;
     
     fourToOneMUX FTOM(I0, I1, I2, I3, S0, S1, O);
     assign I0 = 2'b00;
     assign I1 = 2'b01;
     assign I2 = 2'b10;
     assign I3 = 2'b11;
     
     
    initial begin
    S0 =0; S1 =0;
    #250
    S0 =0; S1 = 1;
    #250
    S0 =1; S1 = 0;
    #250
    S0 =1; S1 = 1;
    end


endmodule
