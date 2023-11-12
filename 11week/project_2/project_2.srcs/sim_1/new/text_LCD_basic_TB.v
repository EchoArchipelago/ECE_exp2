`timescale 1ns / 1ps

module text_LCD_basic_tb();

reg rst, clk;

wire LCD_E, LCD_RS, LCD_RW;
wire [7:0] LCD_DATA;
wire [7:0] LED_out;

text_LCD_basic t1(rst, clk, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out);

always begin
    #0.5 clk <= ~clk;
end

initial begin
    clk <= 0;
    rst <= 1;
    #5; rst <=0;
    #5; rst <=1;
    
end


    
endmodule