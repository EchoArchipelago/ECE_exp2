
module TrafficLight(
rst, clk, timescale, add_hour, emergency, LCD_E, LCD_RS, LCD_RW, LCD_DATA, pedestrian, E_T, W_T, S_T, N_T
    );

input rst, clk; //리셋과 클락 신호
input add_hour, emergency; // 1시간 추가신호와 긴급신호
input [1:0] timescale; 
// input IT_to_sec;
output LCD_E, LCD_RS, LCD_RW;
output wire [7:0] LCD_DATA;
//위의 두 변수는 LCD 모듈에서 사용됨.


output reg [3:0] E_T, W_T, S_T, N_T; //각각 동,서,남,북의 신호등을 표현하는데 사용, 초록,좌회전,노란색,적색신호가 꺼지고 켜짐을 표현한다. 
output reg [7:0] pedestrian; //동서남북의 보행자 신호를 표현. 



wire day_or_night; // 1이면 밤, 0이면 낮
wire add_hour_t, emergency_t; // 각 신호의 triggering신호.
wire [3:0] watch_H_one,watch_H_ten,watch_M_one,watch_M_ten,watch_S_one,watch_S_ten; // 

reg [3:0] t_state; // trafficlight 의 state
reg [2:0] t_state_for_saving_previous; // emergency 상태가 active일때, 원래 t_state를 잠시 저장해두는데 사용되는 변수.

reg [6:0] time_cnt; // 지정된 시간동안 원하는 trafficlight 신호가 출력되도록 하는데 사용되는 타임카운터.

reg emergency_active; // emergency 상태이면 1이, 그렇지 않으면 0이 되는 변수


integer emergency_cnt; // emergency_active가 1이면 time_cnt 대신에 emergency_cnt가 카운팅을 시작함. 


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
emergency_A = 4'b1000,




// TL_A     = 24'b10_10_01_01_0001_0001_1000_1000,
// TL_A_F   = 24'b00_00_01_01_0001_0001_1000_1000,
// TL_A_Y   = 24'b10_10_01_01_0011_0011_1010_1010,
// TL_A_Y_F = 24'b00_00_01_01_0011_0011_1010_1010,

// TL_B     = 24'b10_01_01_01_0001_0001_0001_1100,
// TL_B_F   = 24'b00_01_01_01_0001_0001_0001_1100,
// TL_B_Y   = 24'b10_01_01_01_0011_0011_0011_1110,
// TL_B_Y_F = 24'b00_01_01_01_0011_0011_0011_1110,

// TL_C     = 24'b01_10_01_01_0001_0001_1100_0001,
// TL_C_F   = 24'b01_00_01_01_0001_0001_1100_0001,
// TL_C_Y   = 24'b01_10_01_01_0011_0011_1110_0011,
// TL_C_Y_F = 24'b01_00_01_01_0011_0011_1110_0011,

// TL_D     = 24'b01_01_01_01_0001_0001_0100_0100,

// TL_D_Y   = 24'b01_01_01_01_0011_0011_0110_0110,


// TL_E     = 24'b01_01_10_10_1000_1000_0001_0001,
// TL_E_F   = 24'b01_01_00_00_1000_1000_0001_0001,
// TL_E_Y   = 24'b01_01_10_10_1010_1010_0011_0011,
// TL_E_Y_F = 24'b01_01_00_10_1010_1010_0011_0011,

// TL_F     = 24'b01_01_01_10_0001_1100_0001_0001,
// TL_F_F   = 24'b01_01_01_00_0001_1100_0001_0001,
// TL_F_Y   = 24'b01_01_01_10_0011_1110_0011_0011,
// TL_F_Y_F = 24'b01_01_01_00_0011_1110_0011_0011,

// TL_G     = 24'b01_01_10_01_1100_0001_0001_0001,
// TL_G_F   = 24'b01_01_00_01_1100_0001_0001_0001,
// TL_G_Y   = 24'b01_01_10_01_1110_0011_0011_0011,
// TL_G_Y_F = 24'b01_01_00_01_1110_0011_0011_0011,

// TL_H     = 24'b01_01_01_01_0100_0100_0001_0001,

// TL_H_Y   = 24'b01_01_01_01_0110_0110_0011_0011;


// below blocks are TrafficLight state.
// 2bits are indicate pedstrian trafficlight, and 4bits are indicate car trafficlight.
// pedestrian traffic light outputs east, west, south, and north from the left.
// in short -> E_P, W_P, S_P, N_P, E_T, W_T, S_T, N_T  
// car traffic light outputs green, greenLeft, yellow, red from the left.
// _x     : normal state
// _x_F   : for indicate, pedestrian traffic light flashing, pedestrian green signal goes black.
// _x_Y   : yellow signal is turned on because it goes to next state.
// _x_Y_F : yellow signal is turned on and green signal of pedestrian traffic light goes black for indicate flashing.


TL_A     = 24'b01_10_01_10_1000_0001_1000_0001,
TL_A_F   = 24'b01_00_01_00_1000_0001_1000_0001,
TL_A_Y   = 24'b01_10_01_10_1010_0011_1010_0011,
TL_A_Y_F = 24'b01_00_01_00_1010_0011_1010_0011,

TL_B     = 24'b01_10_01_01_1100_0001_0001_0001,
TL_B_F   = 24'b01_00_01_01_1100_0001_0001_0001,
TL_B_Y   = 24'b01_10_01_01_1110_0011_0011_0011,
TL_B_Y_F = 24'b01_00_01_01_1110_0011_0011_0011,

TL_C     = 24'b01_01_01_10_0001_0001_1100_0001,
TL_C_F   = 24'b01_01_01_00_0001_0001_1100_0001,
TL_C_Y   = 24'b01_01_01_10_0011_0011_1110_0011,
TL_C_Y_F = 24'b01_01_01_00_0011_0011_1110_0011,

TL_D     = 24'b01_01_01_01_0100_0001_0100_0001,

TL_D_Y   = 24'b01_01_01_01_0110_0011_0110_0011,


TL_E     = 24'b10_01_10_01_0001_1000_0001_1000,
TL_E_F   = 24'b00_01_00_01_0001_1000_0001_1000,
TL_E_Y   = 24'b10_01_10_01_0011_1010_0011_1010,
TL_E_Y_F = 24'b00_01_00_01_0011_1010_0011_1010,

TL_F     = 24'b10_01_01_01_0001_1100_0001_0001,
TL_F_F   = 24'b00_01_01_01_0001_1100_0001_0001,
TL_F_Y   = 24'b10_01_01_01_0011_1110_0011_0011,
TL_F_Y_F = 24'b00_01_01_01_0011_1110_0011_0011,

TL_G     = 24'b01_01_10_01_0001_1100_0001_0001,
TL_G_F   = 24'b01_01_00_01_0001_1100_0001_0001,
TL_G_Y   = 24'b01_01_10_01_0011_1110_0011_0011,
TL_G_Y_F = 24'b01_01_00_01_0011_1110_0011_0011,

TL_H     = 24'b01_01_01_01_0001_0100_0001_0100,

TL_H_Y   = 24'b01_01_01_01_0011_0110_0011_0110;



Oneshot_Universal #(.WIDTH(2)) OU2(clk,rst,{add_hour,emergency}, {add_hour_t, emergency_trigger});
Watch C1(rst, clk, timescale, add_hour_t, day_or_night, watch_H_ten,watch_H_one,watch_M_ten,watch_M_one,watch_S_ten,watch_S_one,IT_to_sec_for_TL, dot_five_sec_for_TL);
LCD l1(rst, clk,watch_H_ten,watch_H_one,watch_M_ten,watch_M_one,watch_S_ten,watch_S_one, day_or_night, t_state, LCD_E,LCD_RS,LCD_RW,LCD_DATA);

//always @(negedge rst or posedge clk) begin
//    if (!rst) begin
//        emergency_trigger_reg <= 0;
//    end else begin
//        emergency_trigger_reg <= emergency_trigger_wire;
//    end
//end


////////////////////////////////////////////////////////////////////////////////////////////////



// always @(posedge clk or negedge rst) begin
//     if (!rst)
//         time_cnt <= 0;  
//     else begin
//         if (IT_to_sec_t) begin
//         time_cnt <= time_cnt + 1;
//         end
//     end  
// end


// // below blcok is time counter
// If the emergency is zero, the time counter is counted.
// If the emergencies are 1, the time counter stops counting and the emergencies counter stops
//Counting begins.

//always @(negedge rst or posedge clk) begin 
//    if(!rst) begin
//        time_cnt = 0;
//    end
//    else begin
//    if(IT_to_sec_t && !emergency_trigger) begin
//        time_cnt <= time_cnt +1;
//    end
//    end
//end



// always @ (negedge rst or posedge clk) begin
//    if(!rst) begin
//        emergency_trigger_reg <= 0;
//        emergency_cnt <= 0;
//    end
//    else begin
//    if(IT_to_sec_for_TL && emergency_trigger) begin
//        t_state_for_saving_previous <= t_state;
//        emergency_cnt <= emergency_cnt +1;
//    end
//    if (emergency_cnt == 15) begin
//        emergency_cnt <= 0;
//        emergency_trigger_reg <= 0;
//        t_state <= t_state_for_saving_previous;
//    end
//    end
// end

// always @(posedge clk) begin 
//     if(IT_to_sec_t) begin
//         time_cnt <= time_cnt +1;
//     end
//     end




//always @ (negedge rst or posedge clk) begin
//    if(!rst) begin
//    end
//    if(emergency_t) begin
//    t_state_for_saving_previous <= t_state;
//    t_state <= A;
//    emergency_cnt <= emergency_cnt +1;
//    end
//    if(emergency_cnt == 15) begin
//        t_state <= t_state_for_saving_previous;
//    end
//end


//always @(negedge rst or posedge clk) begin
//    if(!rst) begin
//    time_cnt <= 0;
//    else begin
//    if(IT_to_sec_t) begin
//    time_cnt <= time_cnt +1;
//    end
//end


/////////////////////////////////////////////////////////////////////


// always @(negedge rst or posedge clk) begin 
//     if(!rst) begin
//         time_cnt = 0;
//     end
//     else begin
//     if(IT_to_sec_for_TL) begin
//         time_cnt <= time_cnt +1;
//     end
//     end
// end

always @(posedge clk or negedge rst) begin // in night mode
    if(!rst) begin
        t_state = B;
        time_cnt = 0;
        emergency_cnt = 0;
        emergency_active = 0;
    end else begin
        if ( day_or_night & emergency_active ==0 ) begin
        if(time_cnt >= 0 & time_cnt < 10) begin
            t_state <= B;
        end
        if(time_cnt >= 10 & time_cnt < 20) begin
            t_state <= A;
        end
        if(time_cnt >= 20 & time_cnt < 30) begin
            t_state <= C;
        end
        if(time_cnt >= 30 & time_cnt < 40) begin
            t_state <= A;
        end
        if(time_cnt >= 40 & time_cnt < 50) begin
            t_state <= E;
        end
        if(time_cnt >= 50 & time_cnt < 60) begin
            t_state <= H;
        end
        if(time_cnt == 60) begin
            t_state <= B;
            time_cnt <= 0;
        end
        end


        if ( !day_or_night & emergency_active ==0 ) begin
        if(time_cnt >= 0 & time_cnt < 5) begin
            t_state <= A;
        end
        if(time_cnt >= 5 & time_cnt < 10) begin
            t_state <= D;
        end
        if(time_cnt >= 10 & time_cnt < 15) begin
            t_state <= F;
        end
        if(time_cnt >= 15 & time_cnt < 20) begin
            t_state <= E;
        end
        if(time_cnt >= 20 & time_cnt < 25) begin
            t_state <= G;
        end
        if(time_cnt >= 25 & time_cnt < 30) begin
            t_state <= E;
        end
        if(time_cnt == 30) begin
            t_state <= A;
            time_cnt <= 0;
        end
        end

        // if(emergency_trigger == 1 ) begin
        //     t_state_for_saving_previous <= t_state;
        // end

        if(IT_to_sec_for_TL & emergency_active == 0) begin
        time_cnt <= time_cnt +1;
        end

        if( ({watch_H_ten,watch_H_one,watch_M_ten,watch_M_one,watch_S_ten,watch_S_one} == 24'b0000_1000_0000_0000_0000_0000) |
    {watch_H_ten,watch_H_one,watch_M_ten,watch_M_one,watch_S_ten,watch_S_one} == 24'b0010_0011_0000_0000_0000_0000) begin
        time_cnt <= 0; // time_cnt is reset at 08:00:00, 23:00:00, because  day_or_night is changed. 
    end
        if((watch_H_ten == 4'b0000 & watch_H_one == 4'b0111) | watch_H_ten == 4'b0010 & watch_H_one == 4'b0010  ) begin
        if(add_hour_t) begin
            time_cnt <=0; // at 07:xx:xx or 22:xx:xx, if add_hour is triggered, day_or_night is changed, so time_cnt must be reset.
        end
    end
    if (emergency_trigger == 1 && !emergency_active) begin
            // emergency_trigger?? ???????? 1??? ?????? ???
            emergency_active <= 1; // emergency ?????? ?????????
            t_state_for_saving_previous <= t_state; // emergency ???????? ?????? ?????? state?? ?????????? ?????? state?? ?????.
            t_state <= emergency_A; // state??? emergency_A???????? ???.
        end

        if (emergency_active == 1) begin
            // emergency ???????? ?????????????????? ???
            if(IT_to_sec_for_TL) begin
                if (emergency_cnt < 15) begin
                    emergency_cnt <= emergency_cnt + 1;
                end else begin
                    emergency_active <= 0; // emergency ?????? ??????
                    emergency_cnt <= 0; // emergency ?????? ??????
                    t_state <= t_state_for_saving_previous;
                end
            end
        end 
        // else begin
        //     // emergency ???????? ?????????????????? ???
        //     t_state <= t_state_for_saving_previous; //emergency?? ????????? state?? ??? 
        //     end

end
end
// always @(negedge rst or posedge clk) begin
//     if(!rst) begin
//         emergency_cnt = 0;

 // emergency ?????? ??????? ?????? ???????????

// always @(posedge clk or negedge rst) begin
//     if(!rst) begin
//         emergency_cnt <= 0;
//         emergency_active <= 0;
//     end else begin
//         if (emergency_trigger == 1 && !emergency_active) begin
//             // emergency_trigger?? ???????? 1??? ?????? ???
//             emergency_active <= 1; // emergency ?????? ?????????
//             t_state_for_saving_previous <= t_state; // emergency ???????? ?????? ?????? state?? ?????????? ?????? state?? ?????.
//             t_state <= emergency_A; // state??? emergency_A???????? ???.
//         end

//         if (emergency_active) begin
//             // emergency ???????? ?????????????????? ???
//             if(IT_to_sec_for_TL) begin
//                 if (emergency_cnt < 15) begin
//                     emergency_cnt <= emergency_cnt + 1;
//                 end else begin
//                     emergency_active <= 0; // emergency ?????? ??????
//                     emergency_cnt <= 0; // emergency ?????? ??????
//                 end
//             end
//         end else begin
//             // emergency ???????? ?????????????????? ???
//             t_state <= t_state_for_saving_previous; //emergency?? ????????? state?? ??? 
//             end
//         end
//     end







// always @(negedge rst or posedge clk) begin // in night mode
//     if(!rst && day_or_night ) begin
//         t_state = B;
//         t_state_for_saving_previous = H;
//     end
//     else begin
//         if ( !day_or_night && emergency ==0 ) begin
//         if(time_cnt >= 0 && time_cnt < 10) begin
//             t_state <= B;
//         end
//         if(time_cnt >= 10 && time_cnt < 20) begin
//             t_state <= A;
//         end
//         if(time_cnt >= 20 && time_cnt < 30) begin
//             t_state <= C;
//         end
//         if(time_cnt >= 30 && time_cnt < 40) begin
//             t_state <= A;
//         end
//         if(time_cnt >= 40 && time_cnt < 50) begin
//             t_state <= E;
//         end
//         if(time_cnt >= 50 && time_cnt < 60) begin
//             t_state <= H;
//         end
//         if(time_cnt == 60) begin
//             t_state <= B;
//             time_cnt <= 0;
//         end
//         end
//     end
// end









always @(posedge clk or negedge rst)
begin
    if(!rst) begin
        {pedestrian, E_T, W_T, S_T, N_T} <= 24'b10_00_00_00_1000_0000_0000_0000;
    end else begin
            if(day_or_night & !emergency_active ) begin // in night
                if((time_cnt <=5))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_B;
                else if((time_cnt ==5 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_B_F;
                else if((time_cnt ==6 & dot_five_sec_for_TL == 0))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_B;
                else if((time_cnt ==6 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_B_F;
                else if((time_cnt ==7 & dot_five_sec_for_TL == 0))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_B;
                else if((time_cnt ==7 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_B_F;
                else if((time_cnt ==8 & dot_five_sec_for_TL == 0))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_B;
                else if((time_cnt ==8 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_B_F;
                else if((time_cnt ==9 & dot_five_sec_for_TL == 0))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_B_Y;
                else if((time_cnt ==9 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_B_Y_F;

                else if((time_cnt <=15 & time_cnt >= 10))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A;
                else if((time_cnt ==15 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_F;
                else if((time_cnt ==16 & dot_five_sec_for_TL == 0))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A;
                else if((time_cnt ==16 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_F;
                else if((time_cnt ==17 & dot_five_sec_for_TL == 0))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A;
                else if((time_cnt ==17 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_F;
                else if((time_cnt ==18 & dot_five_sec_for_TL == 0))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A;
                else if((time_cnt ==18 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_F;
                else if((time_cnt ==19 & dot_five_sec_for_TL == 0))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_Y;
                else if((time_cnt ==19 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_Y_F;

                else if((time_cnt <=25 & time_cnt >= 20))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_C;
                else if((time_cnt ==25 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_C_F;
                else if((time_cnt ==26 & dot_five_sec_for_TL == 0))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_C;
                else if((time_cnt ==26 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_C_F;
                else if((time_cnt ==27 & dot_five_sec_for_TL == 0))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_C;
                else if((time_cnt ==27 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_C_F;
                else if((time_cnt ==28 & dot_five_sec_for_TL == 0))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_C;
                else if((time_cnt ==28 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_C_F;
                else if((time_cnt ==29 & dot_five_sec_for_TL == 0))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_C_Y;
                else if((time_cnt ==29 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_C_Y_F;

                else if((time_cnt <=35 & time_cnt >= 30))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A;
                else if((time_cnt ==35 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_F;
                else if((time_cnt ==36 & dot_five_sec_for_TL == 0))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A;
                else if((time_cnt ==36 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_F;
                else if((time_cnt ==37 & dot_five_sec_for_TL == 0))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A;
                else if((time_cnt ==37 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_F;
                else if((time_cnt ==38 & dot_five_sec_for_TL == 0))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A;
                else if((time_cnt ==38 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_F;
                else if((time_cnt ==39 & dot_five_sec_for_TL == 0))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_Y;
                else if((time_cnt ==39 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_Y_F;

                else if((time_cnt <=45 & time_cnt >= 40))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_E;
                else if((time_cnt ==45 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_E_F;
                else if((time_cnt ==46 & dot_five_sec_for_TL == 0))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_E;
                else if((time_cnt ==46 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_E_F;
                else if((time_cnt ==47 & dot_five_sec_for_TL == 0))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_E;
                else if((time_cnt ==47 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_E_F;
                else if((time_cnt ==48 & dot_five_sec_for_TL == 0))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_E;
                else if((time_cnt ==48 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_E_F;
                else if((time_cnt ==49 & dot_five_sec_for_TL == 0))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_E_Y;
                else if((time_cnt ==49 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_E_Y_F;

                else if((time_cnt <=55 & time_cnt >= 50))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_H;
                else if((time_cnt ==55 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_H;
                else if((time_cnt ==56 & dot_five_sec_for_TL == 0))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_H;
                else if((time_cnt ==56 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_H;
                else if((time_cnt ==57 & dot_five_sec_for_TL == 0))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_H;
                else if((time_cnt ==57 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_H;
                else if((time_cnt ==58 & dot_five_sec_for_TL == 0))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_H;
                else if((time_cnt ==58 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_H;
                else if((time_cnt ==59 & dot_five_sec_for_TL == 0))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_H_Y;
                else if((time_cnt ==59 & dot_five_sec_for_TL == 1))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_H_Y;
                end

            if (!day_or_night & !emergency_active) begin // in day
                if((time_cnt <=2)) {pedestrian, E_T, W_T, S_T, N_T} <= TL_A;
                else if((time_cnt ==2) & dot_five_sec_for_TL == 1) {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_F;
                else if((time_cnt ==3) & dot_five_sec_for_TL == 0) {pedestrian, E_T, W_T, S_T, N_T} <= TL_A;
                else if((time_cnt ==3) & dot_five_sec_for_TL == 1) {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_F;
                else if((time_cnt ==4) & dot_five_sec_for_TL == 0) {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_Y;
                else if((time_cnt ==4) & dot_five_sec_for_TL == 1) {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_Y_F;

                else if((time_cnt <=7 & time_cnt >= 5)) {pedestrian, E_T, W_T, S_T, N_T} <= TL_D;
                else if((time_cnt ==7) & dot_five_sec_for_TL == 1) {pedestrian, E_T, W_T, S_T, N_T} <= TL_D;
                else if((time_cnt ==8) & dot_five_sec_for_TL == 0) {pedestrian, E_T, W_T, S_T, N_T} <= TL_D;
                else if((time_cnt ==8) & dot_five_sec_for_TL == 1) {pedestrian, E_T, W_T, S_T, N_T} <= TL_D;
                else if((time_cnt ==9) & dot_five_sec_for_TL == 0) {pedestrian, E_T, W_T, S_T, N_T} <= TL_D_Y;
                else if((time_cnt ==9) & dot_five_sec_for_TL == 1) {pedestrian, E_T, W_T, S_T, N_T} <= TL_D_Y;

                else if((time_cnt <=12 & time_cnt >= 10)) {pedestrian, E_T, W_T, S_T, N_T} <= TL_F;
                else if((time_cnt ==12) & dot_five_sec_for_TL == 1) {pedestrian, E_T, W_T, S_T, N_T} <= TL_F_F;
                else if((time_cnt ==13) & dot_five_sec_for_TL == 0) {pedestrian, E_T, W_T, S_T, N_T} <= TL_F;
                else if((time_cnt ==13) & dot_five_sec_for_TL == 1) {pedestrian, E_T, W_T, S_T, N_T} <= TL_F_F;
                else if((time_cnt ==14) & dot_five_sec_for_TL == 0) {pedestrian, E_T, W_T, S_T, N_T} <= TL_F_Y;
                else if((time_cnt ==14) & dot_five_sec_for_TL == 1) {pedestrian, E_T, W_T, S_T, N_T} <= TL_F_Y_F;

                else if((time_cnt <=17 & time_cnt >= 15)) {pedestrian, E_T, W_T, S_T, N_T} <= TL_E;
                else if((time_cnt ==17) & dot_five_sec_for_TL == 1) {pedestrian, E_T, W_T, S_T, N_T} <= TL_E_F;
                else if((time_cnt ==18) & dot_five_sec_for_TL == 0) {pedestrian, E_T, W_T, S_T, N_T} <= TL_E;
                else if((time_cnt ==18) & dot_five_sec_for_TL == 1) {pedestrian, E_T, W_T, S_T, N_T} <= TL_E_F;
                else if((time_cnt ==19) & dot_five_sec_for_TL == 0) {pedestrian, E_T, W_T, S_T, N_T} <= TL_E_Y;
                else if((time_cnt ==19) & dot_five_sec_for_TL == 1) {pedestrian, E_T, W_T, S_T, N_T} <= TL_E_Y_F;
                

                else if((time_cnt <=22 & time_cnt >= 20)) {pedestrian, E_T, W_T, S_T, N_T} <= TL_G;
                else if((time_cnt ==22) & dot_five_sec_for_TL == 1) {pedestrian, E_T, W_T, S_T, N_T} <= TL_G_F;
                else if((time_cnt ==23) & dot_five_sec_for_TL == 0) {pedestrian, E_T, W_T, S_T, N_T} <= TL_G;
                else if((time_cnt ==23) & dot_five_sec_for_TL == 1) {pedestrian, E_T, W_T, S_T, N_T} <= TL_G_F;
                else if((time_cnt ==24) & dot_five_sec_for_TL == 0) {pedestrian, E_T, W_T, S_T, N_T} <= TL_G_Y;
                else if((time_cnt ==24) & dot_five_sec_for_TL == 1) {pedestrian, E_T, W_T, S_T, N_T} <= TL_G_Y_F;


                else if((time_cnt <=27 & time_cnt >= 25)) {pedestrian, E_T, W_T, S_T, N_T} <= TL_E;
                else if((time_cnt ==27) & dot_five_sec_for_TL == 1) {pedestrian, E_T, W_T, S_T, N_T} <= TL_E_F;
                else if((time_cnt ==28) & dot_five_sec_for_TL == 0) {pedestrian, E_T, W_T, S_T, N_T} <= TL_E;
                else if((time_cnt ==28) & dot_five_sec_for_TL == 1) {pedestrian, E_T, W_T, S_T, N_T} <= TL_E_F;
                else if((time_cnt ==29) & dot_five_sec_for_TL == 0) {pedestrian, E_T, W_T, S_T, N_T} <= TL_E_Y;
                else if((time_cnt ==29) & dot_five_sec_for_TL == 1) {pedestrian, E_T, W_T, S_T, N_T} <= TL_E_Y_F;
        end

        if (emergency_active) begin // in emergency
            if(emergency_cnt <= 7) {pedestrian, E_T, W_T, S_T, N_T} <= TL_A;
            else if ((emergency_cnt == 7) & (dot_five_sec_for_TL == 1)) {pedestrian, E_T, W_T, S_T, N_T} <= TL_A;
            else if ((emergency_cnt == 8) & (dot_five_sec_for_TL == 0)) {pedestrian, E_T, W_T, S_T, N_T} <= TL_A;
            else if ((emergency_cnt == 8) & (dot_five_sec_for_TL == 1)) {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_F;
            else if ((emergency_cnt == 9) & (dot_five_sec_for_TL == 0)) {pedestrian, E_T, W_T, S_T, N_T} <= TL_A;
            else if ((emergency_cnt == 9) & (dot_five_sec_for_TL == 1)) {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_F;
            else if ((emergency_cnt == 10) & (dot_five_sec_for_TL == 0)) {pedestrian, E_T, W_T, S_T, N_T} <= TL_A;
            else if ((emergency_cnt == 10) & (dot_five_sec_for_TL == 1)) {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_F;
            else if ((emergency_cnt == 11) & (dot_five_sec_for_TL == 0)) {pedestrian, E_T, W_T, S_T, N_T} <= TL_A;
            else if ((emergency_cnt == 11) & (dot_five_sec_for_TL == 1)) {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_F;
            else if ((emergency_cnt == 12) & (dot_five_sec_for_TL == 0)) {pedestrian, E_T, W_T, S_T, N_T} <= TL_A;
            else if ((emergency_cnt == 12) & (dot_five_sec_for_TL == 1)) {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_F;
            else if ((emergency_cnt == 13) & (dot_five_sec_for_TL == 0)) {pedestrian, E_T, W_T, S_T, N_T} <= TL_A;
            else if ((emergency_cnt == 13) & (dot_five_sec_for_TL == 1)) {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_F;
            else if ((emergency_cnt == 14) & (dot_five_sec_for_TL == 0)) {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_Y;
            else if ((emergency_cnt == 14) & (dot_five_sec_for_TL == 1)) {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_Y_F;
        end
end
end




// always @(posedge clk or negedge rst)
// begin
//     if(!rst) begin
//         {pedestrian, E_T, W_T, S_T, N_T} <= 24'b10_10_10_10_0000_0000_0000_0000;
//     end
//         else begin 
//             if((time_cnt <=5))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_B;
//             else if((time_cnt ==6))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_B_F;
//             else if((time_cnt ==7))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_B;
//             else if((time_cnt ==8))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_B_F;
//             else if((time_cnt ==9))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_B_Y;
//             else if((time_cnt <=15 & time_cnt >= 10))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A;
//             else if((time_cnt ==16))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_F;
//             else if((time_cnt ==17))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A;
//             else if((time_cnt ==18))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_F;
//             else if((time_cnt ==19))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_Y;
//             else if((time_cnt <=25 & time_cnt >= 20))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_C;
//             else if((time_cnt ==26))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_C_F;
//             else if((time_cnt ==27))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_C;
//             else if((time_cnt ==28))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_C_F;
//             else if((time_cnt ==29))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_C_Y;
//             else if((time_cnt <=35 & time_cnt >= 30))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A;
//             else if((time_cnt ==36))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_F;
//             else if((time_cnt ==37))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A;
//             else if((time_cnt ==38))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_F;
//             else if((time_cnt ==39))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_A_Y;
//             else if((time_cnt <=45 & time_cnt >= 40))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_E;
//             else if((time_cnt ==46))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_E_F;
//             else if((time_cnt ==47))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_E;
//             else if((time_cnt ==48))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_E_F;
//             else if((time_cnt ==49))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_E_Y;
//             else if((time_cnt <=55 & time_cnt >= 50))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_H;
//             else if((time_cnt ==56))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_H;
//             else if((time_cnt ==57))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_H;
//             else if((time_cnt ==58))  {pedestrian, E_T, W_T, S_T, N_T} <= TL_H;
//             else if((time_cnt ==59))  begin {pedestrian, E_T, W_T, S_T, N_T} <= TL_H_Y;  
//             end
//         end
// end




// always @(negedge rst or posedge clk) begin
//     if(!rst) begin
//         emergency_cnt = 0;
//     end
//     else begin
//         if( !day_or_night && emergency ==1 ) begin
//             t_state_for_saving_previous <= t_state
//             t_state = A;

endmodule












