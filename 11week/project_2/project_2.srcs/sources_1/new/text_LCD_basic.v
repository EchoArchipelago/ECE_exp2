module text_LCD_basic(
rst, clk, LCD_E, LCD_RS, LCD_RW, LCD_DATA, LED_out
    );
input rst, clk;

output LCD_E, LCD_RS, LCD_RW;
output reg [7:0] LCD_DATA;
output reg [7:0] LED_out;

wire LCD_E;
reg LCD_RS, LCD_RW;

reg [2:0] state; 
parameter   DELAY = 3'b000,
            FUNCTION_SET = 3'b001,
            ENTRY_MODE = 3'b010,
            DISP_ONOFF = 3'b011,
            LINE1 = 3'b100,
            LINE2 = 3'b101,
            DELAY_T = 3'b110,
            CLEAR_DISP = 3'b111;

integer cnt;

always @(posedge clk or negedge rst)
begin
    if(!rst) begin
        state = DELAY;
        cnt = 0;
    end
    else
    begin
        case(state)
            DELAY : begin
                if(cnt >= 70) begin
                    LED_out = 8'b1000_0000;
                    state = FUNCTION_SET;
                    cnt = 0;
                end
                else cnt = cnt + 1;
            end
            FUNCTION_SET : begin
                if(cnt >= 30) begin
                    LED_out = 8'b0100_0000;
                    state = DISP_ONOFF;
                    cnt = 0;
                end
                else cnt = cnt + 1;
            end
            DISP_ONOFF : begin
                if(cnt >= 30) begin
                    LED_out = 8'b0010_0000;
                    state = ENTRY_MODE;
                    cnt = 0;
                end
                else cnt = cnt + 1;
            end
            ENTRY_MODE : begin
                if(cnt >= 30) begin
                    LED_out = 8'b0001_0000;
                    state = LINE1;
                    cnt = 0;
                end
                else cnt = cnt + 1;
            end
            LINE1 : begin
                if(cnt >= 20) begin
                    //{LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0001_1100;
                    LED_out = 8'b0000_1000;
                    state = DELAY_T;
                    cnt = 0;
                end
                else cnt = cnt + 1;
            end
            LINE2 : begin
                if(cnt >= 20) begin
                    //{LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0001_1100;
                    LED_out = 8'b0000_0100;
                    state = DELAY_T;
                    cnt = 0;
                end
                else cnt = cnt + 1;
            end
            DELAY_T : begin
                if(cnt >= 5) begin
                    LED_out = 8'b0000_0010;
                    state = CLEAR_DISP;
                    cnt = 0;
                end
                else cnt = cnt + 1;
            end
            CLEAR_DISP : begin
                if(cnt >= 5) begin
                    LED_out = 8'b0000_0001;
                    state = LINE1;
                    cnt = 0;
                end
                else cnt = cnt + 1;
            end
            default : state = DELAY;
        endcase
    end
end

always @(posedge clk or negedge rst)
begin
    if(!rst) 
        {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_1_00000000;
    else begin
        case(state)
            FUNCTION_SET :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0011_1000;
            DISP_ONOFF :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_1100;
            ENTRY_MODE :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0110;
            LINE1 :
                begin
                    case(cnt)
                    00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1000_0000;
                    01 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    02 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1000; // H
                    03 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0101; // E
                    04 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1100; // L
                    05 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1100; // L
                    06 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1111; // O
                    07 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    08 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_0111; // W
                    09 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1111; // O
                    10 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_0010; // R
                    11 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1100; // L
                    12 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_0100; // D
                    13 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0001; // !
                    14 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    15 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    16 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                endcase
           end
           LINE2 :
                begin
                    case(cnt)
                    00 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_1100_0000;
                    01 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010; // 2
                    02 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000; // 0
                    03 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010; // 2
                    04 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010; // 2
                    05 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100; // 4
                    06 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100; // 4
                    07 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000; // 0
                    08 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0000; // 0
                    09 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0010; // 2
                    10 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0011_0100; // 4
                    11 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; // 
                    12 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1011; // K
                    13 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0101_0011; // S
                    14 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0100_1000; // H
                    15 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    16 : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                    default : {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_0_0010_0000; //
                endcase
            end
            DELAY_T : 
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0010;
            CLEAR_DISP :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b0_0_0000_0001;
            default :
                {LCD_RS, LCD_RW, LCD_DATA} = 10'b1_1_0010_0000;
         endcase
     end
end

assign LCD_E = clk;

endmodule