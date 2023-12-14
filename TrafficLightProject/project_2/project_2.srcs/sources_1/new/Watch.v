`timescale 1ns / 1ps

module Watch(
clk, rst, timescale, add_hour, day_or_night, watch_H_ten,watch_H_one,watch_M_ten,watch_M_one,watch_S_ten,watch_S_one 
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

reg IT_to_sec, //Internal_Time to second of watch
Sec_one_to_Sec_ten, Sec_ten_to_Min_one, 
Min_one_to_Min_ten, Min_ten_to_Hr_one, 
Hr_one_to_Hr_ten, Hr_clear;

wire IT_to_sec_t, 
Sec_one_to_Sec_ten_t, Sec_ten_to_Min_one_t, 
Min_one_to_Min_ten_t, Min_ten_to_Hr_one_t,
Hr_one_to_Hr_ten_t, Hr_clear_t;

reg [12:0] Internal_Time;

parameter 
    one = 2'b00,
    ten = 2'b01,
    hundred = 2'b10,
    twohundred = 2'b11;

Oneshot_Universal #(.WIDTH(7)) OU1(clk, rst, 
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
        end
        ten: if(Internal_Time >= 100) begin
            IT_to_sec = 1;
            Internal_Time = 0;
        end else begin
            Internal_Time = Internal_Time + 1;
        end
        hundred: if(Internal_Time >= 10) begin
            IT_to_sec = 1;
            Internal_Time = 0;
        end else begin
            Internal_Time = Internal_Time + 1;
        end
        twohundred: if(Internal_Time >= 5) begin
            IT_to_sec = 1;
            Internal_Time = 0;
        end else begin
            Internal_Time = Internal_Time + 1;
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

// When a signal is received to trigger a 10 second band to rise by 1, a signal is generated to trigger a 1 minute band to rise by 0 if the 10 second band is 5
// If the number is less than 5, 1 minute is increased.

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

// When a signal is received to trigger a one-minute increase, if the one-minute increase is 9, you are 0 and generate a signal to trigger a ten-minute increase
// If the number is less than 9, 1 minute is increased



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

// When a signal is received to trigger a 10 minute band to rise by 1, a signal is generated to trigger a 1 hour band to rise by 0 if the 10 minute band is 5
// In the case of numbers less than 5, 1 in the 10th range goes up


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

// The upper block represents the place of work in the hour of the clock. If the minute reaches 60 minutes and an hour is triggered or the add_hour button is pressed, the number of hours of work increases by one.
// If the time is triggered when the time is 9, then the time goes back to zero, otherwise 1 is added.
// If an additional hour is triggered when the decimal place is 2 and the decimal place is 3 (that is, 23 o'clock), both the decimal place and the decimal place must be 00. I'll change my job to zero
// A signal for changing the decimal place to 0 is generated (Hr_clear), and the block dealing with the decimal place receives it so that the decimal place becomes 0.
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


// The upper block represents ten digits of the hour of the clock. When the trigger signal is received when the number of work digits is 9, the number of work digits becomes 0, and the trigger signal (Hr_one_to_ten_t) is given to the number of ten digits.
// If the hour 1's rising signal is triggered when the decimal place is 2, and the decimal place is 3, the block dealing with the decimal place changes the decimal place to 0
// Give the trigger signal separately (Hr_clear_t)
// If you get a signal that triggers 10 hour band 1 to go up, and at the same time you get a signal that triggers 10 hour band 0
// The ten-hour period is zero. (23:xx:xx)
// Otherwise, 1 is added in the 10 hour period.
// This way, you can convert to 00:xx:xx if you press the add 1 hour button when it's 23:xx:xx.

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

// 08:00 to 09:00 -> day, 10:00 to 19:00 -> day, 20:00 to 22:00 -> day, everything else is night.



endmodule


