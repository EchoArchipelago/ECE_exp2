module UpDownCounter_tb();
reg clk, rst, x;
wire [2:0] state;

UpDownCounter UDC (clk, rst, x, state);


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

    // x 값 변경
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
    #5 x = 0;

    $finish;
end

endmodule
