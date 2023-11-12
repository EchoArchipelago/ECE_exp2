
module seg7_controller(
clk, rst, bin, seg_data, seg_sel
    );

input clk, rst;
input [7:0] bin;

wire [11:0] bcd;
reg [3:0] display_bcd;

output reg [7:0] seg_data;
output reg [7:0] seg_sel;

bin2bcd b1(clk, rst, bin, bcd);

always @(posedge clk or posedge rst) begin
    if(rst) seg_sel <= 8'b1111_1110;
    else begin 
        seg_sel <= {seg_sel[6:0],seg_sel[7]};
    end
end

always @(*) begin
    case (display_bcd[3:0])
        0: seg_data = 8'b1111_1100;
        1: seg_data = 8'b0110_0000;
        2: seg_data = 8'b1101_1010;
        3: seg_data = 8'b1111_0010;
        4: seg_data = 8'b1111_1100;
        5: seg_data = 8'b1011_0110;
        6: seg_data = 8'b1011_1110;
        7: seg_data = 8'b1110_0000;
        8: seg_data = 8'b1111_1110;
        9: seg_data = 8'b1111_0110;
        default: seg_data = 8'b0000_0000;
    endcase
end

always @(*) begin
    case (seg_sel)
        8'b1111_1110 : display_bcd = bcd[3:0];
        8'b1111_1101 : display_bcd = bcd[7:4];
        8'b1111_1011 : display_bcd = bcd[11:8];
        8'b1111_0111 : display_bcd = 4'b000;
        8'b1110_1111 : display_bcd = 4'b000;
        8'b1101_1111 : display_bcd = 4'b000;
        8'b1011_1111 : display_bcd = 4'b000;
        8'b0111_1111 : display_bcd = 4'b000;
        default : display_bcd = 4'b000;
    endcase
end

endmodule
