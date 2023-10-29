`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/30 07:36:40
// Design Name: 
// Module Name: UpCounter_tb
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

module UpCounter_tb;
    reg clk;
    reg rst;
    reg x;
    wire [1:0] state;
    
    // UpCounter 모듈 인스턴스 생성
    UpCounter UUT (
        .clk(clk),
        .rst(rst),
        .x(x),
        .state(state)
    );


    always begin
        #1 clk = ~clk; 
    end

    // 모듈 초기화
    initial begin
        clk = 0;
        rst = 1;
        x = 0;

        #10 rst = 0;
        #10 rst = 1;
        #5 x = 0;
        #5 x = 1;
        #5 x = 0;
        #5 x = 1;
                #5 x = 0;
        #5 x = 1;
        #5 x = 0;
        #5 x = 1;
                #5 x = 0;
        #5 x = 1;
        #5 x = 0;
        #5 x = 1;


        $finish;
    end



endmodule
