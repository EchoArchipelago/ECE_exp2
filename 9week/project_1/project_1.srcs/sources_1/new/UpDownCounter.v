module UpDownCounter(clk, rst, x, state);

    input clk, rst;
    input x;
    reg up;
    reg x_reg, x_trig;
    output reg [2:0] state;

//
    always @(negedge rst or posedge clk) begin
        if (!rst) begin
            {x_reg, x_trig} <= 2'b00;
        end
        else begin
            x_reg <= x;
            x_trig <= x & ~x_reg;
        end
    end 

//  block1 : oneshot triger



// below paragraph is block 2, which defines counter.  when up is positive, counter is upcounter, up is negative, counter is downcounter.
    always @(negedge rst or posedge clk) begin
        if (!rst) begin
            state <= 2'b000;
            up <= 1;
        end
        else begin
            case (state)
                3'b000: begin
                    if (x == 1) begin 
                    state <= 3'b001;
                    up <=1;
                    end
                    else
                    state <= 3'b000;
                end
                3'b001: state<= x_trig ? (up ? 3'b010 : 3'b000) : 3'b001;
                3'b010: state<= x_trig ? (up ? 3'b011 : 3'b001) : 3'b010;
                3'b011: state<= x_trig ? (up ? 3'b100 : 3'b010) : 3'b011;
                3'b100: state<= x_trig ? (up ? 3'b101 : 3'b011) : 3'b100;
                3'b101: state<= x_trig ? (up ? 3'b110 : 3'b100) : 3'b101;
                3'b110: state<= x_trig ? (up ? 3'b111 : 3'b101) : 3'b110;
                3'b111: begin
                    if (x == 1) begin
                        state <= 3'b110;
                        up <= 0; // up 신호를 0으로 설정
                         end
                        else
                        state <= 3'b111;
end
            endcase
    end
    end
                
            

endmodule
