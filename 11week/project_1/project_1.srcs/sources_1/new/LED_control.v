`timescale 1ns / 1ps
module LED_control(
clk, rst, bin, seg_data, seg_sel, led_signal
    );
    
input clk, rst;
input [7:0] bin;

wire [7:0] cnt;

output [7:0] seg_data;
output [7:0] seg_sel;
output reg led_signal;

counter8 c1(clk, rst, cnt);       // submodule that is upcounter
seg7_controller s1(clk, rst, bin, seg_data, seg_sel);  // submodule that control 7segment.

always @(posedge clk or posedge rst) begin
    if(rst) led_signal <= 0;
    else begin
        if(cnt <= bin) led_signal <=1;
        else if (cnt > bin) led_signal <=0;
    end
end
// this block is for making PWM signal. comparating  cnt of counter and bin that is handled  by DIP switch.  

endmodule
