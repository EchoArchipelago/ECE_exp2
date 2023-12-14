`timescale 1ns / 1ps

module Watch(
clk, rst, timescale, add_hour, day_or_night, IT_to_sec, watch_H_ten,watch_H_one,watch_M_ten,watch_M_one,watch_S_ten,watch_S_one 
    );

input clk, rst;
input add_hour;
input [1:0] timescale;
output reg day_or_night;
output reg [3:0] 
watch_H_ten,
watch_H_one,
watch_M_ten,
watch_M_one,
watch_S_ten,
watch_S_one;

output reg IT_to_sec;
reg  //Internal_Time to second of watch
Sec_one_to_Sec_ten, Sec_ten_to_Min_one, 
Min_one_to_Min_ten, Min_ten_to_Hr_one, 
Hr_one_to_Hr_ten, Hr_clear;

wire IT_to_sec_t, 
Sec_one_to_Sec_ten_t, Sec_ten_to_Min_one_t, 
Min_one_to_Min_ten_t, Min_ten_to_Hr_one_t,
Hr_one_to_Hr_ten_t, Hr_clear_t;

reg [11:0] Internal_Time; //save  2^11-1 data. 

parameter 
    one = 2'b00,
    ten = 2'b01,
    hundred = 2'b10,
    twohundred = 2'b11;

oneshot_universal #(.WIDTH(7)) OU1(clk, rst, 
{IT_to_sec, 
Sec_one_to_Sec_ten, Sec_ten_to_Min_one, 
Min_one_to_Min_ten, Min_ten_to_Hr_one, 
Hr_one_to_Hr_ten, Hr_claer}, 
{IT_to_sec_t, 
Sec_one_to_Sec_ten_t, Sec_ten_to_Min_one_t, 
Min_one_to_Min_ten_t, Min_ten_to_Hr_one_t,
Hr_one_to_Hr_ten_t, Hr_clear_t});



always @(negedge rst or posedge clk) begin  // About timescale
    if(~rst) begin
    Internal_Time = 0;
    IT_to_sec = 0;
    end
    else begin
        case(timescale)
        one: if(Internal_Time >= 1000) begin
            IT_to_sec = 1;
            Internal_Time = 0;
        end else begin
            Internal_Time = Internal_Time + 1;
            IT_to_sec = 0;
        end
        ten: if(Internal_Time >= 100) begin
            IT_to_sec = 1;
            Internal_Time = 0;
        end else begin
            Internal_Time = Internal_Time + 1;
            IT_to_sec = 0;
        end
        hundred: if(Internal_Time >= 10) begin
            IT_to_sec = 1;
            Internal_Time = 0;
        end else begin
            Internal_Time = Internal_Time + 1;
            IT_to_sec = 0;
        end
        twohundred: if(Internal_Time >= 5) begin
            IT_to_sec = 1;
            Internal_Time = 0;
        end else begin
            Internal_Time = Internal_Time + 1;
            IT_to_sec = 0;
        end
        endcase
    end
end

// above block is for controilling timescale, when we set clock to 1Khz. 
// Internal_Time is 1Khz, so it rises once every 0.001 seconds
//, and uses it to change the timescale using IT_to_sec, a coefficient that actually changes the sec of the clock


always @(negedge rst or posedge clk) begin
    if (~rst) begin
        watch_S_one = 4'b0000;
        Sec_one_to_Sec_ten = 0;
    end
    else begin
        if(IT_to_sec_t) begin
            if(watch_S_one == 4'b1001) begin
                watch_S_one <= 0;
                Sec_one_to_Sec_ten <= 1;
                
            end
            else begin
                watch_S_one <= watch_S_one + 1;
                Sec_one_to_Sec_ten <= 0;
            end
        end
    end
end

// internal time이 1이되면 watch의 second의 1초대가 1 오름
// watch의 second의 1초대가 9일때 1 오르면  second의 1초대가 0이 되며, 10초대가 1 오르도록 트리거링 하는 신호를 생성함

always @(negedge rst or posedge clk) begin
    if (~rst) begin
        watch_S_ten = 4'b0000;
        Sec_ten_to_Min_one = 0;
    end
    else begin
        if(Sec_one_to_Sec_ten_t) begin
            if(watch_S_ten == 4'b0101) begin
                watch_S_ten <= 0;
                Sec_ten_to_Min_one <= 1;
            end
            else begin
                watch_S_ten <= watch_S_ten + 1;
                Sec_ten_to_Min_one <= 0;
            end
        end
    end
end

// 10초대가 1오르도록 트리거링 하는 신호를 받았을때, 10초대가 5인경우에는 0이 되면서 1분대가 1 오르도록 트리거링하는 신호를 생성
// 5미만의 숫자인 경우 1분대가 1이 오름.

// above two blocks are for describing number of second of watch. 
// The first one is for  displaying the one second unit of the watch.
// The second one is for displaying the ten second unit of the watch.

always @(negedge rst or posedge clk) begin
    if (~rst) begin
        watch_M_one = 4'b0000;
        Min_one_to_Min_ten = 0;
    end
    else begin
        if(Sec_ten_to_Min_one_t) begin
            if(watch_M_one == 4'b1001) begin
                watch_M_one <= 0;
                Min_one_to_Min_ten <= 1;
            end
            else begin
                watch_M_one <= watch_M_one + 1;
                Min_one_to_Min_ten <= 0;
            end
        end
    end
end

// 1분대가 1 오르도록 트리거링 하는 신호를 받았을 때, 1분대가 9인경우네는 0이 되면서 10분대가 1오르도록 트리거링하는 신호를 생성
// 9미만의 숫자인 경우 1분대가 1이 오름



always @(negedge rst or posedge clk) begin
    if (~rst) begin
        watch_M_ten = 4'b0000;
        Min_ten_to_Hr_one = 0;
    end
    else begin
        if(Min_one_to_Min_ten_t) begin
            if(watch_S_ten == 4'b0101) begin
                watch_S_ten <= 0;
                Min_ten_to_Hr_one <= 1;
            end
            else begin
                watch_M_ten <= watch_M_ten + 1;
                Min_ten_to_Hr_one <= 0;
            end
        end
    end
end

// 10분대가 1 오르도록 트리거링 하는 신호를 받았을 때, 10분대가 5인 경우에는 0이 되면서 1시간대가 1오르도록 트리거링하는 신호를 생성
// 5미만의 숫자인 경우에는 10분대가 1이 오름


// above two blocks are for describing number of minute of watch. 
// The first one is for  displaying the one minute unit of the watch.
// The second one is for displaying the ten minute unit of the watch.

always @(negedge rst or posedge clk) begin
    if (~rst) begin
        watch_H_one = 4'b0000;
        Hr_one_to_Hr_ten = 0;
        Hr_clear <= 0;
    end
    else begin
        if(Min_ten_to_Hr_one_t || add_hour) begin
            if(watch_H_one == 9) begin
                watch_H_one <= 0;
                Hr_one_to_Hr_ten <= 1;
            end
            else begin
                if(watch_H_ten == 4'b0010 && watch_H_one == 4'b0011) begin
                    watch_H_one <= 0;
                    Hr_clear <= 1;
                    Hr_one_to_Hr_ten <=0;
                end
                else begin
                    watch_H_one <= watch_H_one +1;
                    Hr_clear <= 0;
                    Hr_one_to_Hr_ten <=0;
                end
            end
        end
    end
end

// 윗 블록은 시계의 hour의 일의 자리를 표현한것이다. 분이 60분이되어 1시간이 트리거 되거나 add_hour버튼을 눌르면, 시간의 일의 자리가 하나 늘어난다.
// 만약 시간이 9였을때 트리거링되면 시간은 0으로 돌아가고, 그렇지 않은 경우엔 1이 더해진다.
// 만약 십의자리가 2, 일의자리가 3 (즉 23시) 일때 1시간 추가가 트리거링 되면, 십의자리와 일의자리가 모두 00이 되어야 한다. 일의 자리를 0으로 바꾸고
// 십의자리를 0으로 바꾸도록 하는 신호를 생성하여(Hr_clear), 십의 자리를 다루는 블록에서 이를 받아 십의 자리를 0이 되도록 하게 한다. 

always @(negedge rst or posedge clk) begin
    if (~rst) begin
        watch_H_ten = 4'b0000;
        Hr_clear = 0;
    end
    else begin
        if(Hr_one_to_Hr_ten_t) begin
            if(Hr_clear_t) begin
                watch_H_ten <= 0;
            end
            else begin
                watch_H_ten <= watch_H_ten +1;
                Hr_clear <= 0;
            end
        end
    end
end


// 윗 블록은 시계의 hour의 십의 자리를 표현한것이다. 일의 자리가 9일때 트리거 신호를 받으면 일의자리는 0이되면서 십의 자리에 트리거 신호((Hr_one_to_Hr_ten_t)를 준다.
// 만약 십의자리가 2, 일의자리가 3일때, hour의 1의자리 올리기 신호가 트리거링되면, 일의자리를 다루는 블록에서는 일의 자리를 0으로 바꾸고, 십의 자리를 0으로 바꾸는
// 트리거 신호를 따로 준다(Hr_clear_t)
// 10시간대가 1이 오르게 트리거링 하는 신호가 들어왔을 때, 동시에 10시간대가 0이 되도록 트리거링 하는 신호가 들어오면  
// 10시간대는 0이 된다. (23:xx:xx일때 )
// 그렇지 않은 경우에는 10시간대에 1이 추가된다. 
// 이렇게 해야 23:xx:xx일때 1시간 추가 버튼을 누른 경우 00:xx:xx로 변환이 가능하다.

always @(negedge rst or posedge clk) begin
    if (~rst) begin
        day_or_night = 1; // 0 is day , 1 is night
    end
        else begin
            if(watch_H_ten == 0 && watch_H_one >=8) begin
                day_or_night <= 0;
            end
            else if(watch_H_ten == 1 && watch_H_one >=0) begin
                day_or_night <= 0;
            end
            else if(watch_H_ten == 2 && watch_H_one <=2) begin
                day_or_night <= 0;
            end
            else begin  
                day_or_night <= 1;
            end
        end
    end

// 08시~09시대 -> day, 10시대~ 19시대 -> day, 20시대~ 22시대-> day 그외는 전부 night.



endmodule

