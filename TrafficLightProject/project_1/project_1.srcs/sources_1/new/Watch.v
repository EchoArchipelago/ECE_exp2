`timescale 1ns / 1ps

module Watch(
rst, clk, timescale, add_hour, day_or_night, watch_H_ten,watch_H_one,watch_M_ten,watch_M_one,watch_S_ten,watch_S_one,IT_to_sec_for_TL, dot_five_sec_for_TL 
    );

input rst, clk;
input add_hour;
input [1:0] timescale;
output reg day_or_night;
output reg dot_five_sec_for_TL;
output reg IT_to_sec_for_TL;
output reg [3:0] 
watch_H_ten,
watch_H_one,
watch_M_ten,
watch_M_one,
watch_S_ten,
watch_S_one;

// dot_five_sec_for_TL and IT_to_sec_for_Tl is for describe 1 second and 0.5 second in TrafficLight module.


reg  IT_to_sec, dot_five_sec,//Internal_Time to second of watch
Sec_one_to_Sec_ten, Sec_ten_to_Min_one, 
Min_one_to_Min_ten, Min_ten_to_Hr_one, 
Hr_one_to_Hr_ten, Hr_clear;

wire IT_to_sec_t, dot_five_sec_t,
Sec_one_to_Sec_ten_t, Sec_ten_to_Min_one_t, 
Min_one_to_Min_ten_t, Min_ten_to_Hr_one_t,
Hr_one_to_Hr_ten_t, Hr_clear_t;

reg [16:0] Internal_Time;

parameter 
    one = 2'b00,
    ten = 2'b01,
    hundred = 2'b10,
    twohundred = 2'b11;

Oneshot_Universal #(.WIDTH(8)) OU1(clk, rst, 
{IT_to_sec, dot_five_sec,
Sec_one_to_Sec_ten, Sec_ten_to_Min_one, 
Min_one_to_Min_ten, Min_ten_to_Hr_one, 
Hr_one_to_Hr_ten, Hr_claer}, 
{IT_to_sec_t, dot_five_sec_t,
Sec_one_to_Sec_ten_t, Sec_ten_to_Min_one_t, 
Min_one_to_Min_ten_t, Min_ten_to_Hr_one_t,
Hr_one_to_Hr_ten_t, Hr_clear_t});



always @(negedge rst or posedge clk) begin  // About timescale
    if(!rst) begin
    Internal_Time = 0;
    IT_to_sec = 0;
    end
    else begin
        case(timescale)

        one:
        if(Internal_Time >= 10000) begin
            IT_to_sec <= 1;
            Internal_Time <= 0;
            dot_five_sec <= 0;
        end 
        else if(Internal_Time >= 5000) begin
            IT_to_sec <= 0;
            dot_five_sec <= 1;
            Internal_Time <= Internal_Time +1;
        end else begin
            Internal_Time <= Internal_Time + 1;
            IT_to_sec <= 0;
        end


        ten:
        if(Internal_Time >= 1000) begin
            IT_to_sec <= 1;
            Internal_Time <= 0;
            dot_five_sec <= 0;
        end 
        else if(Internal_Time >= 500) begin
            IT_to_sec <= 0;
            dot_five_sec <= 1;
            Internal_Time <= Internal_Time +1;
        end else begin
            Internal_Time <= Internal_Time + 1;
            IT_to_sec <= 0;
        end


        
        hundred:
        if(Internal_Time >= 100) begin
            IT_to_sec <= 1;
            Internal_Time <= 0;
            dot_five_sec <= 0;
        end
        else if(Internal_Time >= 50) begin
            IT_to_sec <= 0;
            dot_five_sec <= 1;
            Internal_Time <= Internal_Time +1;
        end else begin
            Internal_Time <= Internal_Time + 1;
            IT_to_sec <= 0;
        end


        twohundred: 
        if(Internal_Time >= 50) begin
            IT_to_sec <= 1;
            Internal_Time <= 0;
            dot_five_sec <= 0;
        end
        else if(Internal_Time >= 25) begin
            IT_to_sec <= 0;
            dot_five_sec <= 1;
            Internal_Time <= Internal_Time +1;
        end else begin
            Internal_Time <= Internal_Time + 1;
            IT_to_sec <= 0;
        end
        endcase
    end
end




always @(negedge rst or posedge clk) begin
    if(!rst) begin
    IT_to_sec_for_TL = 0;
    dot_five_sec_for_TL = 0;
    end
    else begin
        if(IT_to_sec_t) begin
            IT_to_sec_for_TL <= 1;
        end
            else if (!IT_to_sec_t) begin
                IT_to_sec_for_TL <= 0;
            
        end
        
        if(dot_five_sec) begin
            dot_five_sec_for_TL <= 1;
        end
            else if (!dot_five_sec) begin
                dot_five_sec_for_TL <= 0;
            end
        end
    end





always @(negedge rst or posedge clk) begin
    if (!rst) begin
        watch_S_one = 4'b0000;
        Sec_one_to_Sec_ten = 0;
    end
    else begin
        if(IT_to_sec_t) begin
            if(watch_S_one == 4'b1001) begin
                watch_S_one <= 0;
                Sec_one_to_Sec_ten <= 1;
                // IT_to_sec <= 0;
            end
            else begin
                watch_S_one <= watch_S_one + 1;
                Sec_one_to_Sec_ten <= 0;
                // IT_to_sec <= 0;
            end
        end
    end
end



always @(negedge rst or posedge clk) begin
    if (!rst) begin
        watch_S_ten = 4'b0000;
        Sec_ten_to_Min_one = 0;
    end
    else begin
        if(Sec_one_to_Sec_ten_t) begin
            if(watch_S_ten == 4'b0101) begin
                watch_S_ten <= 0;
                Sec_ten_to_Min_one <= 1;
//                Sec_one_to_Sec_ten <= 0;
            end
            else begin
                watch_S_ten <= watch_S_ten + 1;
                Sec_ten_to_Min_one <= 0;
//                Sec_one_to_Sec_ten <= 0;
            end
        end
    end
end


always @(negedge rst or posedge clk) begin
    if (!rst) begin
        watch_M_one = 4'b0000;
        Min_one_to_Min_ten = 0;
    end
    else begin
        if(Sec_ten_to_Min_one_t) begin
            if(watch_M_one == 4'b1001) begin
                watch_M_one <= 0;
                Min_one_to_Min_ten <= 1;
//                Sec_ten_to_Min_one <= 0;
            end
            else begin
                watch_M_one <= watch_M_one + 1;
                Min_one_to_Min_ten <= 0;
//                Sec_ten_to_Min_one <= 0;
            end
        end
    end
end


always @(negedge rst or posedge clk) begin
    if (!rst) begin
        watch_M_ten = 4'b0000;
        Min_ten_to_Hr_one = 0;
    end
    else begin
        if(Min_one_to_Min_ten_t) begin
            if(watch_M_ten == 4'b0101) begin
                watch_M_ten <= 0;
                Min_ten_to_Hr_one <= 1;
//                Min_one_to_Min_ten <=0;
            end
            else begin
                watch_M_ten <= watch_M_ten + 1;
                Min_ten_to_Hr_one <= 0;
//                Min_one_to_Min_ten <= 0;
            end
        end
    end
end


always @(negedge rst or posedge clk) begin
    if (!rst) begin
        watch_H_one = 4'b0000;
        Hr_one_to_Hr_ten = 0;
        Hr_clear = 0;
    end
    else begin
        if(Min_ten_to_Hr_one_t | add_hour) begin
            if(watch_H_one == 4'b1001) begin
                watch_H_one <= 0;
                Hr_clear <= 0;
                Hr_one_to_Hr_ten <= 1;
//                Min_ten_to_Hr_one <= 0;
            end
            else begin
                if((watch_H_ten == 4'b0010) & (watch_H_one == 4'b0011)) begin
                    watch_H_one <= 0;
                    Hr_clear <= 1;
                    Hr_one_to_Hr_ten <=1;
//                    Min_ten_to_Hr_one <= 0;
                end
                else begin
                    watch_H_one <= watch_H_one +1;
                    Hr_clear <= 0;
                    Hr_one_to_Hr_ten <=0;
//                    Min_ten_to_Hr_one <= 0;
                end
            end
        end
    end
end


always @(negedge rst or posedge clk) begin
    if (!rst) begin
        watch_H_ten = 4'b0000;
    end
    else begin
        if(Hr_one_to_Hr_ten_t & Hr_clear == 1) begin
                watch_H_ten = 0;

        end
        else if(Hr_one_to_Hr_ten_t & Hr_clear == 0) begin
                watch_H_ten <= watch_H_ten +1;

            end
        end
    end




always @(negedge rst or posedge clk) begin
    if (!rst) begin
        day_or_night = 1; // 0 is day , 1 is night
    end
        else begin
            if((watch_H_ten == 0) & (watch_H_one >= 8)) begin
                day_or_night <= 0;
            end
            else if((watch_H_ten == 1) & (watch_H_one >=0)) begin
                day_or_night <= 0;
            end
            else if((watch_H_ten) == 2 & (watch_H_one <=2)) begin
                day_or_night <= 0;
            end
            else begin  
                day_or_night <= 1;
            end
        end
    end



endmodule
