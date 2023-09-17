`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 21:03:58
// Design Name: 
// Module Name: fourToTwoPriorityEncoder
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


module fourToTwoPriorityEncoder(
    input wire [3:0] D,
    output wire x,y,z
    );
    
    assign x = D[2] | D[3];
    assign y = D[3] | (~D[2] & D[1]);
    assign z = D[3] & D[2] & D[1] & D[0];
     
    
endmodule
