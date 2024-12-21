`timescale 1ns / 1ps

module new_binary_score(
    input clk,            // System clock (100 MHz)
    input reset,                 // Reset signal
    input enable,                // Enable signal to start/stop the clock
    output reg [3:0] one,        // BCD output for units
    output reg [3:0] tenth       // BCD output for tens
);

    // ********************************************************
    // Clock Divider to Generate 1Hz Signal
    reg [26:0] ctr_1Hz = 27'h0;  // 27-bit counter for 1 Hz generation
    reg clk_1Hz = 1'b0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ctr_1Hz <= 27'h0;
            clk_1Hz <= 1'b0;
        end else if (ctr_1Hz == 49_999_999) begin
            ctr_1Hz <= 27'h0;
            clk_1Hz <= ~clk_1Hz; // Toggle 1 Hz clock
        end else begin
            ctr_1Hz <= ctr_1Hz + 1;
        end
    end

    // ********************************************************
    // Score Accumulation Logic
    always @(posedge clk_1Hz or posedge reset) begin
        if (reset) begin
            one <= 4'd0;
            tenth <= 4'd0;
        end else if (enable) begin
            // Increment the score
            if (one < 4'd9) begin
                one <= one + 1;
            end else begin
                one <= 4'd0;
                if (tenth < 4'd9) begin
                    tenth <= tenth + 1;
                end else begin
                    tenth <= 4'd0; // Reset to zero after 99
                end
            end
        end
    end

endmodule