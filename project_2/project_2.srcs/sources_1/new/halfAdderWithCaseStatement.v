`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/10 20:12:48
// Design Name: 
// Module Name: halfAdderWithCaseStatement
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module halfAdderWithCaseStatement(
    input a, b, output reg s, c
    );
    //always 구문 내에서는 reg 타입의 변수만 변경할 수 잇으므로 output을 reg타입으로 선언해야한다는것을 명심하자.
always @(*) begin
    case ({a, b})
        2'b00: begin 
            c = 1'b0; 
            s = 1'b0;
        end
        2'b01: begin 
            c = 1'b0; 
            s = 1'b1;
        end
        2'b10: begin 
            c = 1'b0; 
            s = 1'b1;
        end
        2'b11: begin 
            c = 1'b1; 
            s = 1'b0;
        end
    endcase
end
endmodule
