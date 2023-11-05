`timescale 1ns / 1ps

module seg_array_tb;
  reg clk;
  reg rst;
  reg btn;
  wire btn_trig;
  wire [7:0] seg_data;
  wire [7:0] seg_sel;


  seg_array uut (clk,rst,btn,seg_data,seg_sel);



  always begin
    #5 clk = ~clk;
  end


  initial begin
    clk <= 0;
    rst <= 1;
    btn <= 0;
    rst <= 0;
    #10
    rst <= 1;
    #10
    rst <= 1;

    #10 btn <= 1;
    #10 btn <= 0;
    #10 btn <= 1;
    #10 btn <= 0;
    #10 btn <= 1;
    #10 btn <= 0;
    #10 btn <= 1;
    #10 btn <= 0;
    #10 btn <= 1;
    #10 btn <= 0;
    #10 btn <= 1;
    #10 btn <= 0;
     #10 btn <= 1;
    #10 btn <= 0;
    #10 btn <= 1;
    #10 btn <= 0;
        #10 btn <= 1;
    #10 btn <= 0;
    #10 btn <= 1;
    #10 btn <= 0;
        #10 btn <= 1;
    #10 btn <= 0;
    #10 btn <= 1;
    #10 btn <= 0;
        #10 btn <= 1;
    #10 btn <= 0;
    #10 btn <= 1;
    #10 btn <= 0;
        #10 btn <= 1;
    #10 btn <= 0;
    #10 btn <= 1;
    #10 btn <= 0;
        #10 btn <= 1;
    #10 btn <= 0;
    #10 btn <= 1;
    #10 btn <= 0;
        #10 btn <= 1;
    #10 btn <= 0;
    #10 btn <= 1;
    #10 btn <= 0;
        #10 btn <= 1;
    #10 btn <= 0;
    #10 btn <= 1;
    #10 btn <= 0;
    


    $finish;
  end

endmodule