`timescale 1ns / 1ps

module tb_new_binary_score;

    // Inputs
    reg clk;
    reg reset;
    reg enable;

    // Outputs
    wire [3:0] one;
    wire [3:0] tenth;
    wire [3:0] hundredth;
    wire [3:0] thousandth;

    // Instantiate the Unit Under Test (UUT)
    new_binary_score uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .one(one),
        .tenth(tenth),
        .hundredth(hundredth),
        .thousandth(thousandth)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // 100MHz clock period
    end

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        enable = 0;

        // Wait for global reset
        #100;
        reset = 0;
        
        // Enable score counting
        enable = 1;

        // Run the simulation for some time to observe the output
        #1000000; // Adjust this based on your simulation needs

        // Disable score counting
        enable = 0;

        // Observe the final values
        #100;

        // End of simulation
        $stop;
    end
      
endmodule
