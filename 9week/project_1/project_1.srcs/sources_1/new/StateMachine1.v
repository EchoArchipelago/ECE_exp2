
module StateMachine1(clk, rst, x, y, state);

input clk, rst, x;
output reg [1:0] state;
output reg y;

always @(negedge rst or posedge clk) begin
    if(!rst) state <= 2'b00; //rst이 0이되면 state가 2'b00이 된다. 
    else if(state <= 2'b00 && x<= 1'b0) begin {state,y} <= 3'b000; end 
    else if(state <= 2'b00 && x<= 1'b1) begin {state,y} <= 3'b010; end 
    else if(state <= 2'b01 && x<= 1'b0) begin {state,y} <= 3'b001; end
    else if(state <= 2'b01 && x<= 1'b1) begin {state,y} <= 3'b110; end
    else if(state <= 2'b10 && x<= 1'b0) begin {state,y} <= 3'b001; end
    else if(state <= 2'b10 && x<= 1'b1) begin {state,y} <= 3'b100; end
    else if(state <= 2'b11 && x<= 1'b0) begin {state,y} <= 3'b001; end
    else if(state <= 2'b11 && x<= 1'b1) begin {state,y} <= 3'b100; end
    end
    
        
endmodule
