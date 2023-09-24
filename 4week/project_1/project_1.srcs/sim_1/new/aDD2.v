`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/24 16:38:56
// Design Name: 
// Module Name: aDD2
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


module test();

wire A, B, C, D;

initial begin
  A = 4;
  B = 9;
  C = 14;
  D = 19;

  // A + B * 2
  C <= A + B * 2;

  // Print(C)
  $display("A + B * 2 = %d", C);

  // (A + B) * 2
  D <= (A + B) * 2;

  // Print(D)
  $display("(A + B) * 2 = %d", D);

  // A + B * C
  E <= A + B * C;

  // Print(E)
  $display("A + B * C = %d", E);
end

endmodule