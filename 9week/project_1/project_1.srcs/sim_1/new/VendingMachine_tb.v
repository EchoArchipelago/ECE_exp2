`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/30 06:25:41
// Design Name: 
// Module Name: VendingMachine_tb
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


//module VendingMachine_tb();

// reg clk, rst, A, B, C; 
// wire state [2:0]; 
// wire y;
 
//VendingMachine vm (A_trig, B_trig, C_trig, clk, rst, A, B, C);

//    always begin
//        #1 clk = ~clk; 
//    end


//    initial begin
//        clk = 0;
//        rst = 1;

//        #10 rst = 0;
//        #10 rst = 1;
//        #5 A_trig = 1;
//        #5 A = 0;
//        #5 B = 1;
//        #5 B = 0;
//        #5 A = 1;
//        #5 A = 0;
//        #5 B = 1;
//        #5 B = 0;
//        #5 C = 0;
        
//        #10 rst = 0;
//        #10 rst = 1;
        
//        #5 A = 1;
//        #5 A = 0;
//        #5 B = 1;
//        #5 B = 0;
//        #5 C = 0;
//        $finish;
//    end

       
        
//endmodule

`timescale 1ns/1ns

module VendingMachine_tb;
    reg clk;
    reg rst;
    reg A, B, C;
    wire [2:0] state;
    wire y;
    
    // VendingMachine 모듈 인스턴스 생성
    VendingMachine UUT (
        .clk(clk),
        .rst(rst),
        .A(A),
        .B(B),
        .C(C),
        .state(state),
        .y(y)
    );


    always begin
        #1 clk = ~clk; 
    end

    // 모듈 초기화
    initial begin
        clk = 0;
        rst = 1;
        A = 0;
        B = 0;
        C = 0;

        #10 rst = 0;
        #10 rst = 1;



        #5 A = 1;
        #5 A = 0;
        #5 B = 1;
        #5 B = 0;
        #5 A = 1;
        #5 A = 0;
        #5 C = 1;
        
        #10 rst = 0;
        #10 rst = 1;
        
        #5 A = 1;
        #5 A = 0;
        #5 B = 1;
        #5 B = 0;
        #5 C = 1;
        #5


        $finish;
    end


endmodule
