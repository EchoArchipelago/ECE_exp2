`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 16:01:33
// Design Name: 
// Module Name: fourBitComparator
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


module fourBitComparator(
    input wire [3:0] a,b,
    output wire x,y,z
    );
    
    assign x = (a > b) ? 1'b1 : 1'b0;
    assign y = (a == b) ? 1'b1 : 1'b0;
    assign z = (a < b) ? 1'b1 : 1'b0;
endmodule
