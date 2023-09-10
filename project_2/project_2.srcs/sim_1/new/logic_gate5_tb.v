`timescale 10ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/10 11:41:27
// Design Name: 
// Module Name: logic_gate5
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


module logic_gate5_tb;

reg [1:0] a, b;

wire [1:0]v, w, x, y, z;

assign v = a & b;
assign w = a | b;
assign x = a ^ b;
assign y = ~(a & b);
assign z = ~(a ^ b);

initial begin
    a=2'b00; b=2'b00; 
    #6.25             
    a=2'b00; b=2'b01; 
    #6.25    
    a=2'b00; b=2'b10; 
    #6.25
    a=2'b00; b=2'b11;
    #6.25
    
    a=2'b01; b=2'b00; 
    #6.25             
    a=2'b01; b=2'b01; 
    #6.25   
    a=2'b01; b=2'b10; 
    #6.25
    a=2'b01; b=2'b11;
    #6.25
    
    a=2'b10; b=2'b00; 
    #6.25           
    a=2'b10; b=2'b01; 
    #6.25    
    a=2'b10; b=2'b10; 
    #6.25
    a=2'b10; b=2'b11;
    #6.25
    
    a=2'b11; b=2'b00; 
    #6.25             
    a=2'b11; b=2'b01; 
    #6.25   
    a=2'b11; b=2'b10; 
    #6.25
    a=2'b11; b=2'b11;
end


endmodule

