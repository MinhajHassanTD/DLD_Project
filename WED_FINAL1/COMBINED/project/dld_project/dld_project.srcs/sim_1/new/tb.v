`timescale 1ns / 1ps

module tb_new_binary_score;

    // Inputs
    reg clk;
    reg reset;
    reg enable;

    // Outputs
    wire [3:0] one, tenth, hundredth, thousandth;

    // Instantiate the DUT (Device Under Test)
    new_binary_score uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .one(one),
        .tenth(tenth),
        .hundredth(hundredth),
        .thousandth(thousandth)
    );

    // Clock generation: 100 MHz clock (10 ns period)
    always #5 clk = ~clk;

    // Testbench Logic
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        enable = 0;

        // Apply reset
        #20 reset = 0; // Deassert reset after 20 ns

        // Enable the counter
        #10 enable = 1;

        // Run simulation for a significant amount of time
        #500_000; // Simulate for 500,000 ns (500 µs)

        // Disable the counter
        enable = 0;

        // End the simulation
        #100 $finish;
    end

    // Monitor the outputs and key signals
    initial begin
        $monitor("Time: %0dns | r_10Hz: %b | one: %d | tenth: %d | hundredth: %d | thousandth: %d", 
                  $time, uut.r_10Hz, one, tenth, hundredth, thousandth);
    end

endmodule