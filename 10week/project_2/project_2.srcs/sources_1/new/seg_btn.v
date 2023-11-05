`timescale 1ns / 1ps



module seg_btn(
    clk, rst, btn, seg
    );
    
input clk, rst;
input [9:0] btn;
wire [9:0] btn_trig;
reg [3:0] state;
output reg [7:0] seg;

oneshot_universal #(.WIDTH(10)) u01(clk, rst, btn[9:0], btn_trig[9:0]);

    
always @(negedge rst or posedge clk) begin
    if(!rst) seg <= 8'b00000000;
    else begin
        case(state)
        0: seg <= 8'b11111100;
        1: seg <= 8'b11000000;
        2: seg <= 8'b11011010;
        3: seg <= 8'b11110010;
        4: seg <= 8'b01100110;
        5: seg <= 8'b10110110;
        6: seg <= 8'b10111110;
        7: seg <= 8'b11100000;
        8: seg <= 8'b11111110;
        9: seg <= 8'b11110110;
        default: seg <= 8'b00000000;
        endcase
    end
end

always @(posedge clk or negedge rst) begin
    if(!rst) state <= 4'b0000;
    else begin
        case (btn_trig)
        10'b0000000001 : state <= 4'b0000;
        10'b0000000010 : state <= 4'b0001;
        10'b0000000100 : state <= 4'b0010;
        10'b0000001000 : state <= 4'b0011;
        10'b0000010000 : state <= 4'b0100;
        10'b0000100000 : state <= 4'b0101;
        10'b0001000000 : state <= 4'b0110;
        10'b0010000000 : state <= 4'b0111;
        10'b0100000000 : state <= 4'b1000;
        10'b1000000000 : state <= 4'b1001;
        endcase
    end
end

endmodule
