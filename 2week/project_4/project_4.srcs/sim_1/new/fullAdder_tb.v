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


module testbench_fullAdder;
    // Inputs
    reg a, b, cin;
    // Outputs
    wire s, cout;
    
    // Instantiate the fullAdder module
    fullAdder uut (
        .a(a),
        .b(b),
        .cin(cin),
        .s(s),
        .cout(cout)
    );
    
    initial begin
    a=0; b=0; cin=0;
    #10
    a=0; b=0; cin=1;
    #10
    a=0; b=1; cin=0;
    #10
    a=0; b=1; cin=1;
    #10
    a=1; b=0; cin=0;
    #10
    a=1; b=0; cin=1;
    #10
    a=1; b=1; cin=0;
    #10
    a=1; b=1; cin=1;
end
    
    
endmodule
