
module traffic_light(rst, clk, time_spd, add_hour, emgc_btn, LCD_E, LCD_RS, LCD_RW, LCD_DATA, N_C, W_C, S_C, E_C, pedestrian);

input rst, clk;
input add_hour, emgc_btn;
input [1:0] time_spd;

output LCD_E, LCD_RS, LCD_RW;
output wire [7:0] LCD_DATA;



output reg [3:0] E_C, W_C, S_C, N_C; // L,G,Y,R
output reg [7:0] pedestrian; // NR,NG,WR,WG,SR,SG,ER,EG



wire d_or_n;
wire add_hour_t, emgc_btn_t; 
wire [3:0] hour, min, sec;
reg [3:0] t_state; 
reg [2:0] prev_t_state;
reg emgc;
reg d_or_n_stay;

integer emgc_cnt;

wire LCD_E;

parameter 
A = 4'b0000,
B = 4'b0001,
C = 4'b0010,
D = 4'b0011,
E = 4'b0100,
F = 4'b0101,
G = 4'b0110,
H = 4'b0111,
E_A = 4'b1000,


// below blocks are TrafficLight state.
// 2bits are indicate pedstrian trafficlight, and 4bits are indicate car trafficlight.
// pedestrian traffic light outputs east, west, south, and north from the left.
// in short -> E_P, W_P, S_P, N_P, E_T, W_T, S_T, N_T  
// car traffic light outputs green, greenLeft, yellow, red from the left.
// _x     : normal state
// _x_F   : for indicate, pedestrian traffic light flashing, pedestrian green signal goes black.
// _x_Y   : yellow signal is turned on because it goes to next state.
// _x_Y_F : yellow signal is turned on and green signal of pedestrian traffic light goes black for indicate flashing.
TL_A     = 24'b10_10_01_01_0001_0001_1000_1000,
TL_A_F   = 24'b00_00_01_01_0001_0001_1000_1000,
TL_A_Y   = 24'b10_10_01_01_0011_0011_1010_1010,
TL_A_Y_F = 24'b00_00_01_01_0011_0011_1010_1010,

TL_B     = 24'b10_01_01_01_0001_0001_0001_1100,
TL_B_F   = 24'b00_01_01_01_0001_0001_0001_1100,
TL_B_Y   = 24'b10_01_01_01_0011_0011_0011_1110,
TL_B_Y_F = 24'b00_01_01_01_0011_0011_0011_1110,

TL_C     = 24'b01_10_01_01_0001_0001_1100_0001,
TL_C_F   = 24'b01_00_01_01_0001_0001_1100_0001,
TL_C_Y   = 24'b01_10_01_01_0011_0011_1110_0011,
TL_C_Y_F = 24'b01_00_01_01_0011_0011_1110_0011,

TL_D     = 24'b01_01_01_01_0001_0001_0100_0100,

TL_D_Y   = 24'b01_01_01_01_0011_0011_0110_0110,


TL_E     = 24'b01_01_10_10_1000_1000_0001_0001,
TL_E_F   = 24'b01_01_00_00_1000_1000_0001_0001,
TL_E_Y   = 24'b01_01_10_10_1010_1010_0011_0011,
TL_E_Y_F = 24'b01_01_00_10_1010_1010_0011_0011,

TL_F     = 24'b01_01_01_10_0001_1100_0001_0001,
TL_F_F   = 24'b01_01_01_00_0001_1100_0001_0001,
TL_F_Y   = 24'b01_01_01_10_0011_1110_0011_0011,
TL_F_Y_F = 24'b01_01_01_00_0011_1110_0011_0011,

TL_G     = 24'b01_01_10_01_1100_0001_0001_0001,
TL_G_F   = 24'b01_01_00_01_1100_0001_0001_0001,
TL_G_Y   = 24'b01_01_10_01_1110_0011_0011_0011,
TL_G_Y_F = 24'b01_01_00_01_1110_0011_0011_0011,

TL_H     = 24'b01_01_01_01_0100_0100_0001_0001,

TL_H_Y   = 24'b01_01_01_01_0110_0110_0011_0011,

north = 2'b00,
west = 2'b01,
south = 2'b10,
east = 2'b11;

integer t_cnt;

Oneshot_Universal #(.WIDTH(2)) u1(clk, rst, {add_hour, emgc_btn}, {add_hour_t, emgc_btn_t});
Watch c1(rst, clk, timescale, add_hour_t, day_or_night,watch_H_ten,watch_H_one,watch_M_ten,watch_M_one,watch_S_ten,watch_S_one);
LCD l1(rst, clk, hour, min, sec, day_or_night, t_state, LCD_E, LCD_RS, LCD_RW, LCD_DATA);



always @(posedge clk or negedge rst)
begin
    if(!rst) begin
        t_state = B;
        t_cnt = 0;
        prev_t_state = H;
        d_or_n_stay = 1;
        emgc = 0;
    end
    else begin
        if(emgc_btn_t) emgc = !emgc;
        else begin
        if(d_or_n_stay) begin // night
            case(t_state)
                B : begin
                    if( t_cnt>= 10000) begin
                        if(emgc) begin
                            t_state = E_A;
                            t_cnt = 0;
                            prev_t_state = B;
                            d_or_n_stay = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            if(!d_or_n) begin
                                t_state = A;
                                t_cnt = 0;
                                prev_t_state = B;
                                d_or_n_stay = d_or_n;
                            end
                            else begin
                                t_state = A;
                                t_cnt = 0;
                                prev_t_state = B;
                                d_or_n_stay = d_or_n;
                            end
                        end 
                    end   
                    else begin//emgc
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                t_state = E_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                d_or_n_stay = d_or_n;
                                prev_t_state = B;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                A : begin
                    if(t_cnt >= 10000) begin
                        if(emgc) begin
                            t_state = E_A;
                            t_cnt = 0;
                            prev_t_state = A;
                            d_or_n_stay = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            if(!d_or_n) begin
                                t_state = A;
                                t_cnt = 0;
                                prev_t_state = A;
                                d_or_n_stay = d_or_n;
                            end
                            else begin
                                if(prev_t_state == B) begin
                                    t_state = C;
                                    t_cnt = 0;
                                    prev_t_state = A;
                                    d_or_n_stay = d_or_n;
                                end
                                else begin
                                    t_state = E;
                                    t_cnt = 0;
                                    prev_t_state = A;
                                    d_or_n_stay = d_or_n;
                                end
                            end
                        end 
                    end   
                    else begin//emgc
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                t_state = E_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                d_or_n_stay = d_or_n;
                                prev_t_state = A;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                C : begin
                    if(t_cnt >= 10000) begin
                        if(emgc) begin
                            t_state = E_A;
                            t_cnt = 0;
                            prev_t_state = C;
                            d_or_n_stay = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            if(!d_or_n) begin
                                t_state = A;
                                t_cnt = 0;
                                prev_t_state = C;
                                d_or_n_stay = d_or_n;
                            end
                            else begin
                                t_state = A;
                                t_cnt = 0;
                                prev_t_state = C;
                                d_or_n_stay = d_or_n;
                            end
                        end 
                    end   
                    else begin//emgc
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                t_state = E_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                d_or_n_stay = d_or_n;
                                prev_t_state = C;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                E : begin
                    if(t_cnt >= 10000) begin
                        if(emgc) begin
                            t_state = E_A;
                            t_cnt = 0;
                            prev_t_state = E;
                            d_or_n_stay = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            if(!d_or_n) begin
                                t_state = A;
                                t_cnt = 0;
                                prev_t_state = E;
                                d_or_n_stay = d_or_n;
                            end
                            else begin
                                t_state = H;
                                t_cnt = 0;
                                prev_t_state = E;
                                d_or_n_stay = d_or_n;
                            end
                        end 
                    end   
                    else begin//emgc
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                t_state = E_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                d_or_n_stay = d_or_n;
                                prev_t_state = E;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                H : begin
                    if(t_cnt >= 10000) begin
                        if(emgc) begin
                            t_state = E_A;
                            t_cnt = 0;
                            prev_t_state = H;
                            d_or_n_stay = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            if(!d_or_n) begin
                                t_state = A;
                                t_cnt = 0;
                                prev_t_state = H;
                                d_or_n_stay = d_or_n;
                            end
                            else begin
                                t_state = B;
                                t_cnt = 0;
                                prev_t_state = H;
                                d_or_n_stay = d_or_n;
                            end
                        end 
                    end   
                    else begin//emgc
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                t_state = E_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                d_or_n_stay = d_or_n;
                                prev_t_state = H;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                E_A : begin
                    if(t_cnt >= 15000) begin
                        if(!d_or_n) begin
                            t_state = A;
                            t_cnt = 0;
                            emgc = 0;
                            d_or_n_stay = d_or_n;
                        end
                        else begin
                            t_state = prev_t_state;
                            d_or_n_stay = d_or_n;
                            t_cnt = 0;
                            emgc = 0;
                        end 
                    end   
                    else t_cnt = t_cnt + 1;
                end
            endcase
        end
        
        
        
        //day
        else begin
            case(t_state)
                A : begin
                    if(t_cnt >= 5000) begin
                        if(emgc) begin
                            t_state = E_A;
                            t_cnt = 0;
                            prev_t_state = A;
                            d_or_n_stay = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            if(d_or_n) begin
                                t_state = B;
                                t_cnt = 0;
                                prev_t_state = A;
                                d_or_n_stay = d_or_n;
                            end
                            else begin
                                t_state = D;
                                t_cnt = 0;
                                prev_t_state = A;
                                d_or_n_stay = d_or_n;
                            end
                        end 
                    end   
                    else begin//emgc
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                t_state = E_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                d_or_n_stay = d_or_n;
                                prev_t_state = A;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                D : begin
                    if(t_cnt >= 5000) begin
                        if(emgc) begin
                            t_state = E_A;
                            t_cnt = 0;
                            prev_t_state = D;
                            d_or_n_stay = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            if(d_or_n) begin
                                t_state = B;
                                t_cnt = 0;
                                prev_t_state = D;
                                d_or_n_stay = d_or_n;
                            end
                            else begin
                                t_state = F;
                                t_cnt = 0;
                                prev_t_state = D;
                                d_or_n_stay = d_or_n;
                            end
                        end 
                    end   
                    else begin//emgc
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                t_state = E_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                d_or_n_stay = d_or_n;
                                prev_t_state = D;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                
                F : begin
                    if(t_cnt >= 5000) begin
                        if(emgc) begin
                            t_state = E_A;
                            t_cnt = 0;
                            prev_t_state = F;
                            d_or_n_stay = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            if(d_or_n) begin
                                t_state = B;
                                t_cnt = 0;
                                prev_t_state = F;
                                d_or_n_stay = d_or_n;
                            end
                            else begin
                                t_state = E;
                                t_cnt = 0;
                                prev_t_state = F;
                                d_or_n_stay = d_or_n;
                            end
                        end 
                    end   
                    else begin//emgc
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                t_state = E_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                d_or_n_stay = d_or_n;
                                prev_t_state = F;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                E : begin
                    if(t_cnt >= 5000) begin
                        if(emgc) begin
                            t_state = E_A;
                            t_cnt = 0;
                            prev_t_state = E;
                            d_or_n_stay = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            if(d_or_n) begin
                                t_state = B;
                                t_cnt = 0;
                                prev_t_state = E;
                                d_or_n_stay = d_or_n;
                            end
                            else begin
                                if(prev_t_state == F) begin
                                    t_state = G;
                                    t_cnt = 0;
                                    prev_t_state = E;
                                    d_or_n_stay = d_or_n;
                                end
                                else begin
                                    t_state = A;
                                    t_cnt = 0;
                                    prev_t_state = E;
                                    d_or_n_stay = d_or_n;
                                end
                            end
                        end 
                    end   
                    else begin//emgc
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                t_state = E_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                d_or_n_stay = d_or_n;
                                prev_t_state = E;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                G : begin
                    if(t_cnt >= 5000) begin
                        if(emgc) begin
                            t_state = E_A;
                            t_cnt = 0;
                            prev_t_state = G;
                            d_or_n_stay = d_or_n;
                            emgc_cnt = 0;
                        end
                        else begin
                            if(d_or_n) begin
                                t_state = B;
                                t_cnt = 0;
                                prev_t_state = G;
                                d_or_n_stay = d_or_n;
                            end
                            else begin
                                t_state = E;
                                t_cnt = 0;
                                prev_t_state = G;
                                d_or_n_stay = d_or_n;
                            end
                        end 
                    end   
                    else begin//emgc
                        if(emgc) begin
                            if(emgc_cnt >= 1000) begin
                                t_state = E_A;
                                t_cnt = 0;
                                emgc_cnt = 0;
                                d_or_n_stay = d_or_n;
                                prev_t_state = G;
                            end
                            else begin
                                t_cnt = t_cnt + 1;
                                emgc_cnt = emgc_cnt + 1;
                            end
                        end
                        else begin
                            t_cnt = t_cnt + 1;
                        end
                    end
                end
                
                E_A : begin
                    if(t_cnt >= 15000) begin
                        if(!d_or_n) begin
                            t_state = A;
                            t_cnt = 0;
                            emgc = 0;
                            d_or_n_stay = d_or_n;
                        end
                        else begin
                            t_state = prev_t_state;
                            d_or_n_stay = d_or_n;
                            t_cnt = 0;
                            emgc = 0;
                        end 
                    end   
                    else t_cnt = t_cnt + 1;
                end
            endcase
        end
        end
    end
end

//light

always @(posedge clk or negedge rst)
begin
    if(!rst) {N_C,W_C,S_C,E_C,pedestrian} <= 24'b0000_0000_0000_0000_00_00_00_00;
    else begin
        if(d_or_n_stay) begin // night
            case(t_state)
                B : begin
                    if(emgc) {N_C,W_C,S_C,E_C,pedestrian} <= TL_B_Y;
                    else begin
                        if(t_cnt < 5000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_B;
                        else if(t_cnt >= 5000 & t_cnt < 5500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_B_F;
                        else if(t_cnt >= 5500 & t_cnt < 6000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_B;
                        else if(t_cnt >= 6000 & t_cnt < 6500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_B_F;
                        else if(t_cnt >= 6500 & t_cnt < 7000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_B;
                        else if(t_cnt >= 7000 & t_cnt < 7500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_B_F;
                        else if(t_cnt >= 7500 & t_cnt < 8000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_B;
                        else if(t_cnt >= 8000 & t_cnt < 8500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_B_F;
                        else if(t_cnt >= 8500 & t_cnt < 9000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_B;
                        else if(t_cnt >= 9000 & t_cnt < 9500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_B_Y_F;
                        else {N_C,W_C,S_C,E_C,pedestrian} <= TL_B_Y;
                    end
                end
                
                A : begin
                    if(emgc) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_Y;
                    else begin
                        if(t_cnt < 5000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A;
                        else if(t_cnt >= 5000 & t_cnt < 5500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_F;
                        else if(t_cnt >= 5500 & t_cnt < 6000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A;
                        else if(t_cnt >= 6000 & t_cnt < 6500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_F;
                        else if(t_cnt >= 6500 & t_cnt < 7000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A;
                        else if(t_cnt >= 7000 & t_cnt < 7500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_F;
                        else if(t_cnt >= 7500 & t_cnt < 8000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A;
                        else if(t_cnt >= 8000 & t_cnt < 8500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_F;
                        else if(t_cnt >= 8500 & t_cnt < 9000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A;
                        else if(t_cnt >= 9000 & t_cnt < 9500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_Y_F;
                        else {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_Y;
                    end
                end
                
                C : begin
                    if(emgc) {N_C,W_C,S_C,E_C,pedestrian} <= TL_C_Y;
                    else begin
                        if(t_cnt < 5000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_C;
                        else if(t_cnt >= 5000 & t_cnt < 5500) {N_C,W_C,S_C,E_C,pedestrian} <=TL_C_F;
                        else if(t_cnt >= 5500 & t_cnt < 6000) {N_C,W_C,S_C,E_C,pedestrian} <=TL_C;
                        else if(t_cnt >= 6000 & t_cnt < 6500) {N_C,W_C,S_C,E_C,pedestrian} <=TL_C_F;
                        else if(t_cnt >= 6500 & t_cnt < 7000) {N_C,W_C,S_C,E_C,pedestrian} <=TL_C;
                        else if(t_cnt >= 7000 & t_cnt < 7500) {N_C,W_C,S_C,E_C,pedestrian} <=TL_C_F;
                        else if(t_cnt >= 7500 & t_cnt < 8000) {N_C,W_C,S_C,E_C,pedestrian} <=TL_C;
                        else if(t_cnt >= 8000 & t_cnt < 8500) {N_C,W_C,S_C,E_C,pedestrian} <=TL_C_F;
                        else if(t_cnt >= 8500 & t_cnt < 9000) {N_C,W_C,S_C,E_C,pedestrian} <=TL_C;
                        else if(t_cnt >= 9000 & t_cnt < 9500) {N_C,W_C,S_C,E_C,pedestrian} <=TL_C_Y_F;
                        else {N_C,W_C,S_C,E_C,pedestrian} <= TL_C_Y;
                    end
                end
                
                E : begin
                if(emgc) {N_C,W_C,S_C,E_C,pedestrian} <= TL_E_Y;
                    else begin
                        if(t_cnt < 5000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_E;
                        else if(t_cnt >= 5000 & t_cnt < 5500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_E_F;
                        else if(t_cnt >= 5500 & t_cnt < 6000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_E;
                        else if(t_cnt >= 6000 & t_cnt < 6500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_E_F;
                        else if(t_cnt >= 6500 & t_cnt < 7000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_E;
                        else if(t_cnt >= 7000 & t_cnt < 7500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_E_F;
                        else if(t_cnt >= 7500 & t_cnt < 8000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_E;
                        else if(t_cnt >= 8000 & t_cnt < 8500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_E_F;
                        else if(t_cnt >= 8500 & t_cnt < 9000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_E;
                        else if(t_cnt >= 9000 & t_cnt < 9500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_E_Y_F;
                        else {N_C,W_C,S_C,E_C,pedestrian} <= TL_E_Y;
                    end
                end
                
                H : begin
                    if(emgc) {N_C,W_C,S_C,E_C,pedestrian} <= TL_H_Y;
                    else begin
                        if(t_cnt < 8500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_H;
                        else {N_C,W_C,S_C,E_C,pedestrian} <= TL_H_Y;
                        end
                    end
                
                E_A : begin
                    if(t_cnt < 7500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A;
                    else if(t_cnt >= 7500 & t_cnt < 8000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_F;
                    else if(t_cnt >= 8000 & t_cnt < 8500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A;
                    else if(t_cnt >= 8500 & t_cnt < 9000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_F;
                    else if(t_cnt >= 9000 & t_cnt < 9500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A;
                    else if(t_cnt >= 9500 & t_cnt < 10000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_F;
                    else if(t_cnt >= 10000 & t_cnt < 10500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A;
                    else if(t_cnt >= 10500 & t_cnt < 11000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_F;                
                    else if(t_cnt >= 11000 & t_cnt < 11500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A;
                    else if(t_cnt >= 11500 & t_cnt < 12000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_F;
                    else if(t_cnt >= 12000 & t_cnt < 12500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A;
                    else if(t_cnt >= 12500 & t_cnt < 13000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_F;
                    else if(t_cnt >= 13000 & t_cnt < 13500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A;                    
                    else if(t_cnt >= 13500 & t_cnt < 14000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_F;
                    else if(t_cnt >= 14000 & t_cnt < 14500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_Y;
                    else {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_Y_F;
                end
            endcase
        end
        
        else begin
            case(t_state)
                A : begin
                    if(emgc) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_Y;
                    else begin
                        if(t_cnt < 2500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A;
                        else if(t_cnt >= 2500 & t_cnt < 3000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_F;
                        else if(t_cnt >= 3000 & t_cnt < 3500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A;
                        else if(t_cnt >= 3500 & t_cnt < 4000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_F;
                        else if(t_cnt >= 4000 & t_cnt < 4500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_Y;
                        else {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_Y_F;
                    end
                end
                
                D : begin
                    if(emgc) {N_C,W_C,S_C,E_C,pedestrian} <= TL_D_Y;
                    else begin
                        if(t_cnt < 3500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_D;
                        else {N_C,W_C,S_C,E_C,pedestrian} <= TL_D_Y;
                    end
                end
                
                F : begin
                    if(emgc) {N_C,W_C,S_C,E_C,pedestrian} <= TL_F_Y;
                    else begin
                        if(t_cnt < 2500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_F;
                        else if(t_cnt >= 2500 & t_cnt < 3000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_F_F;
                        else if(t_cnt >= 3000 & t_cnt < 3500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_F;
                        else if(t_cnt >= 3500 & t_cnt < 4000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_F_F;
                        else if(t_cnt >= 4000 & t_cnt < 4500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_F_Y;
                        else {N_C,W_C,S_C,E_C,pedestrian} <= TL_F_Y_F;
                    end
                end
                
                E : begin
                    if(emgc) {N_C,W_C,S_C,E_C,pedestrian} <= TL_E_Y;
                    else begin
                        if(t_cnt < 2500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_E;
                        else if(t_cnt >= 2500 & t_cnt < 3000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_E_F;
                        else if(t_cnt >= 3000 & t_cnt < 3500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_E;
                        else if(t_cnt >= 3500 & t_cnt < 4000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_E_F;
                        else if(t_cnt >= 4000 & t_cnt < 4500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_E_Y;
                        else {N_C,W_C,S_C,E_C,pedestrian} <= TL_E_Y_F;
                    end
                end
                
                G : begin
                    if(emgc) {N_C,W_C,S_C,E_C,pedestrian} <= TL_G_Y;
                    else begin
                        if(t_cnt < 2500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_G;
                        else if(t_cnt >= 2500 & t_cnt < 3000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_G_F;
                        else if(t_cnt >= 3000 & t_cnt < 3500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_G;
                        else if(t_cnt >= 3500 & t_cnt < 4000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_G_F;
                        else if(t_cnt >= 4000 & t_cnt < 4500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_G_Y;
                        else {N_C,W_C,S_C,E_C,pedestrian} <= TL_G_Y_F;
                    end
                end
                
                E_A : begin
                    if(t_cnt < 7500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A;
                    else if(t_cnt >= 7500 & t_cnt < 8000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_F;
                    else if(t_cnt >= 8000 & t_cnt < 8500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A;
                    else if(t_cnt >= 8500 & t_cnt < 9000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_F;
                    else if(t_cnt >= 9000 & t_cnt < 9500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A;
                    else if(t_cnt >= 9500 & t_cnt < 10000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_F;
                    else if(t_cnt >= 10000 & t_cnt < 10500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A;
                    else if(t_cnt >= 10500 & t_cnt < 11000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_F;                
                    else if(t_cnt >= 11000 & t_cnt < 11500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A;
                    else if(t_cnt >= 11500 & t_cnt < 12000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_F;
                    else if(t_cnt >= 12000 & t_cnt < 12500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A;
                    else if(t_cnt >= 12500 & t_cnt < 13000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_F;
                    else if(t_cnt >= 13000 & t_cnt < 13500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A;                    
                    else if(t_cnt >= 13500 & t_cnt < 14000) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_F;
                    else if(t_cnt >= 14000 & t_cnt < 14500) {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_Y;
                    else {N_C,W_C,S_C,E_C,pedestrian} <= TL_A_Y_F;
                end
            endcase
        end
    end
end

endmodule
