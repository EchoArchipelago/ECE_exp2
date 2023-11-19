`timescale 1ns / 1ps

module tb_LCD_cursor;

reg clk, rst;
reg [9:0] number_btn;
reg [1:0] control_btn;
wire LCD_E, LCD_RS, LCD_RW;
wire [7:0] LCD_DATA;
wire [7:0] LED_out;


LCD_cursor uut (
rst, clk, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out, number_btn, control_btn
);


always begin 
    #1 clk <= ~clk;
end


initial begin
    rst <= 0; clk <=0; number_btn <= 10'b0000_0000_00; control_btn <= 2'b00;
    #10 rst = 1; 
end


initial begin
    #600; 
    number_btn = 10'b0000_0000_00;
    #100; 
    number_btn = 10'b0000_0000_01;
    #100; 
    number_btn = 10'b0000_0000_10;
    #100;
    number_btn = 10'b0000_0001_00;
    #100;
    number_btn = 10'b0000_0100_00;
    #100;   
    control_btn = 2'b01;
    #100;
    control_btn = 2'b10;
    #100;
 
 // when cnt == 20, WRITE will begin, so time interval must be large enough.

end
endmodule