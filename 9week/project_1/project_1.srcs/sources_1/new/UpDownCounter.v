module UpDownCounter(clk, rst, x, up, state);

    input clk, rst;
    input x;
    reg u
    reg x_reg, x_trig;
    output reg [1:0] state;

    always @(negedge rst or posedge clk) begin
        if (!rst) begin
            {x_reg, x_trig} <= 2'b00;
        end
        else begin
            x_reg <= x;
            x_trig <= x & ~x_reg;
        end
    end

    always @(negedge rst or posedge clk) begin
        if (!rst) begin
            state <= 2'b00;
            up <= 1;
        end
        else begin
            case (state)
                2'b00: state <= x_trig ? 2'b01 : 2'b00;
                2'b01: state <= x_trig ? (up ? 2'b10 : 2'b00) : 2'b01;
                2'b10: state <= x_trig ? (up ? 2'b11 : 2'b01) : 2'b10;
                2'b11: begin
                    if (x_trig) begin
                        if (up == 1'b0) begin
                            state <= 2'b10;
                        end
                        else begin
                            state <= 2'b00;
                        end
                    end
                    else begin
                        state <= 2'b11;
                    end
                end
            endcase
        end
    end

endmodule
