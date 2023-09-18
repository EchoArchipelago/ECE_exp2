`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/18 01:53:25
// Design Name: 
// Module Name: fourToOneMUX
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


module fourToOneMUX(
    input wire [1:0] I0,I1,I2,I3,
    input wire S0,S1,
    output reg [1:0] O
    );

    
        always @ (*) begin
    
        case({S1, S0})
            3'b00 : O = I0;
            3'b01 : O = I1;
            3'b10 : O = I2;
            3'b11 : O = I3;
        endcase
    end
    
    
endmodule
