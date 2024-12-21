module SimpleScoreDisplayWithClockGen(
    input wire clk,          // Main clock input (e.g., 50 MHz)
    input wire rst,          // Reset signal (active high)
    input wire game_active,  // Game state signal (1 = active, 0 = paused)
    output reg [3:0] digit1, // Leftmost digit (thousands)
    output reg [3:0] digit2, // Second digit (hundreds)
    output reg [3:0] digit3, // Third digit (tens)
    output reg [3:0] digit4  // Rightmost digit (units)
);

    // Clock Divider for 1 Hz signal generation
    parameter INPUT_CLOCK_FREQ = 50_000_000; // 50 MHz clock input
    parameter DESIRED_FREQ = 1;              // 1 Hz clock output for score updates
    parameter CLOCK_DIVIDER = INPUT_CLOCK_FREQ / (2 * DESIRED_FREQ);
    reg [31:0] clock_counter;               // Counter for clock division
    reg score_clk;                          // Generated clock for score updates

    // Clock Divider Logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            clock_counter <= 0;
            score_clk <= 0;
        end else begin
            if (clock_counter >= CLOCK_DIVIDER - 1) begin
                clock_counter <= 0;
                score_clk <= ~score_clk; // Toggle the generated clock signal
            end else begin
                clock_counter <= clock_counter + 1;
            end
        end
    end

    // Score Increment Logic
    always @(posedge score_clk or posedge rst) begin
        if (rst) begin
            // Reset all digits to zero
            digit1 <= 4'b0000;
            digit2 <= 4'b0000;
            digit3 <= 4'b0000;
            digit4 <= 4'b0000;
        end else if (game_active) begin
            // Increment the score
            if (digit4 < 9) begin
                digit4 <= digit4 + 1; // Increment the rightmost digit
            end else begin
                digit4 <= 0;
                if (digit3 < 9) begin
                    digit3 <= digit3 + 1;
                end else begin
                    digit3 <= 0;
                    if (digit2 < 9) begin
                        digit2 <= digit2 + 1;
                    end else begin
                        digit2 <= 0;
                        if (digit1 < 9) begin
                            digit1 <= digit1 + 1;
                        end else begin
                            digit1 <= 0; // Reset to zero after 9999
                        end
                    end
                end
            end
        end
    end
endmodule