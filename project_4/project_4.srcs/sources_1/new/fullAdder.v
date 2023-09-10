`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/10 21:25:48
// Design Name: 
// Module Name: fullAdder
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


module fullAdder(
    input a, b, cin,
    output s, cout
    );
    wire s, cout;
    wire s1;
    
    halfAdder HA1(.a(a),.b(b),.s(s1),.c(c1));
    halfAdder HA2(.a(s1),.b(cin),.s(s),.c(c2));
    
    assign cout = c1 | c2;
endmodule
