`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/29 19:33:10
// Design Name: 
// Module Name: StateMachine1_TB
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


`timescale 1ns/1ns

module StateMachine1_tb;
    reg clk;
    reg rst;
    reg x;
    wire [1:0] state;
    wire y;

    // StateMachine1 모듈 인스턴스 생성
    StateMachine1 UUT (
        .clk(clk),
        .rst(rst),
        .x(x),
        .state(state),
        .y(y)
    );

    // Clock Generation
    always begin
        #1 clk = ~clk; 
    end


    initial begin
        clk = 0;
        rst = 1;
        x = 0;

        #10 rst = 0;
        #10 rst = 1;



        #2 x = 1; // state = 01
        #2 x = 0; // state = 00
        #2 x = 1; // state = 01
        #2 x = 1; // state = 11
        #2 x = 1; // state = 10
        #2 x = 0; // state = 00
        #2 x = 1; // state = 01
        #2 x = 1; // state = 11
        #2 x = 1; // state = 10
        #2 x = 1; // state = 10
        #2 x = 0; // state = 00
        #2 x = 1; // state = 01
        #2 x = 1; // state = 11
        #2 x = 0; // state = 00
        #4
  

        
   
//        #5 x = 1;
//        #5 x = 0;

   
//        #5 x = 0;
//        #5 x = 1;

   
//        #5 x = 1;
//        #5 x = 1;

//        #5 x = 1;
//        #5 x = 0;

   
//        #5 x = 0;
//        #5 x = 1;

   
//        #5 x = 1;
//        #5 x = 1;
        
        $finish;
    end

endmodule
