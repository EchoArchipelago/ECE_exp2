`timescale 1us / 1ns


module LED_CONTROL_TB();

reg clk, rst;
reg [7:0] bin;

wire [7:0] seg_data, seg_sel;
wire led_signal;

LED_control LC (clk, rst, bin, seg_data, seg_sel, led_signal);

always begin 
#0.5 clk <= ~clk; // Set clock as 1MHz
end

initial begin
    clk <=0; rst <=1; bin <= 8'b0000_0000;
    #1; rst <=0;
    #100000; bin <=8'b0000_0000;
    #100000; bin <=8'b0011_1111;
    #100000; bin <=8'b0111_1111;
    #100000; bin <=8'b1011_1111;
    #100000; bin <=8'b1111_1111;
    
end



endmodule
