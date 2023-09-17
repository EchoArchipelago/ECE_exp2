`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/17 13:29:47
// Design Name: 
// Module Name: comparator_tb
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


module comparator_tb();
    reg a,b;
    wire x,y,z;
    
    comparator cpr (a,b,x,y,z);
    

initial begin
    a=0; b=0; 
    #250             
    a=0; b=1; 
    #250    
    a=1; b=0;
    #250
    a=1; b=1;

end
   
endmodule
