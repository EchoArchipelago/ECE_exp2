`timescale 1ns / 1ps

module Watch_tb;

reg rst, clk, add_hour;
reg [1:0] timescale;
wire day_or_night, dot_five_sec_for_TL, IT_to_sec_for_TL;
wire [3:0] watch_H_ten, watch_H_one, watch_M_ten, watch_M_one, watch_S_ten, watch_S_one;

// Instantiate the Watch module
Watch uut (
    .rst(rst), 
    .clk(clk), 
    .timescale(timescale), 
    .add_hour(add_hour), 
    .day_or_night(day_or_night), 
    .watch_H_ten(watch_H_ten), 
    .watch_H_one(watch_H_one), 
    .watch_M_ten(watch_M_ten), 
    .watch_M_one(watch_M_one), 
    .watch_S_ten(watch_S_ten), 
    .watch_S_one(watch_S_one), 
    .IT_to_sec_for_TL(IT_to_sec_for_TL), 
    .dot_five_sec_for_TL(dot_five_sec_for_TL)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk; // Generate a clock with period of 10ns
end

// Test stimulus
initial begin
    // Initialize inputs
    rst = 1;
    add_hour = 0;
    timescale = 2'b00; // Set timescale to 'one'

    // Reset the Watch module
    #10 rst = 0;
    #10 rst = 1;

    // Simulate time passing and checking outputs
    #100 timescale = 2'b01; // Change timescale to 'ten'
    #100 timescale = 2'b10; // Change timescale to 'hundred'

    // Simulate adding an hour
    #200 add_hour = 1;
    #10 add_hour = 0;

    // Further test cases can be added here...

    #1000 $finish; // End simulation after a certain time
end

// Optionally, add a monitor to display changes in outputs
initial begin
    $monitor("Time: %t, H_ten: %d, H_one: %d, M_ten: %d, M_one: %d, S_ten: %d, S_one: %d, Day_or_Night: %b, IT_to_sec_for_TL: %b, dot_five_sec_for_TL: %b", 
        $time, watch_H_ten, watch_H_one, watch_M_ten, watch_M_one, watch_S_ten, watch_S_one, day_or_night, IT_to_sec_for_TL, dot_five_sec_for_TL);
end

endmodule

