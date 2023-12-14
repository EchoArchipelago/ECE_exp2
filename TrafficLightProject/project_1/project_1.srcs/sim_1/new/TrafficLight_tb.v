`timescale 1ns / 1ps

module TrafficLight_tb;

reg rst, clk, add_hour, emergency;
reg [1:0] timescale;
wire LCD_E, LCD_RS, LCD_RW;
wire [7:0] LCD_DATA;
wire [3:0] E_T, W_T, S_T, N_T;
wire [7:0] pedestrian;

// TrafficLight 모듈 인스턴스 생성
TrafficLight uut (
    .rst(rst), 
    .clk(clk), 
    .timescale(timescale), 
    .add_hour(add_hour), 
    .emergency(emergency), 
    .LCD_E(LCD_E), 
    .LCD_RS(LCD_RS), 
    .LCD_RW(LCD_RW), 
    .LCD_DATA(LCD_DATA), 
    .pedestrian(pedestrian), 
    .E_T(E_T), 
    .W_T(W_T), 
    .S_T(S_T), 
    .N_T(N_T)
);

initial begin
    // 초기화
    clk = 0;
    rst = 0;
    add_hour = 0;
    emergency = 0;
    timescale = 0;

    // 리셋 신호
    #10;
    rst = 1;
    #10;
    rst = 0;
    #10;
    rst = 1;
    #100
    timescale = 2'b01;
    #100000
    timescale = 2'b00;
    #1000000
    timescale = 2'b01;
    #100000
    timescale = 2'b10;
    #100000
    timescale = 2'b11;
    #100000
    emergency = 1;
    #1000
    emergency = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
        #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    
        #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    #10000
    add_hour = 1;
    #10000
    add_hour = 0;
    
    
    

    // 시뮬레이션 종료
    #1000;
    $finish;
end

// 클록 생성
always #5 clk = ~clk;

endmodule