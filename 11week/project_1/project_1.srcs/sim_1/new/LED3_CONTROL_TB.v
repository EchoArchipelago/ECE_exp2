`timescale 1us / 1ns

module LED3_control_tb();

reg clk, rst;
reg [7:0] btn;

wire [3:0] led_signal_R;
wire [3:0] led_signal_G;
wire [3:0] led_signal_B;

LED3_control c1(clk, rst, btn, led_signal_R, led_signal_G, led_signal_B);

initial begin 
    clk <= 0; rst <= 1; btn <= 8'b00000001;
    #100000; rst <= 0;
    #100000; rst <= 1;
    #100000; btn <= 8'b00000001;
    #100000; btn <= 8'b00000010;
    #100000; btn <= 8'b00000100;
    #100000; btn <= 8'b00000100;
    #100000; btn <= 8'b00001000;
    #100000; btn <= 8'b00010000;
    #100000; btn <= 8'b00100000;
    #100000; btn <= 8'b01000000;
    #100000; btn <= 8'b10000000;
    
end

always begin
    #0.5 clk <= ~clk;
end
endmodule