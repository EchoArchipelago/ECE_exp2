`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 17:39:25
// Design Name: 
// Module Name: ThreeToEightDecoder
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


module ThreeToEightDecoder(
    input wire x, y, z,
    output reg [7:0] D
    );
    
    always @({x, y, z})
    begin
        case({x, y, z})
            3'b000 : D = 8'b00000001;
            3'b001 : D = 8'b00000010;
            3'b010 : D = 8'b00000100;
            3'b011 : D = 8'b00001000;
            3'b100 : D = 8'b00010000;
            3'b101 : D = 8'b00100000;
            3'b110 : D = 8'b01000000;
            3'b111 : D = 8'b10000000;
        endcase
    end
    
endmodule
