`timescale 1ns / 1ps

module pixel_score_gen(
    input clk,
    input video_on,
    input [9:0] x, y,
    input [3:0] tenth, one,       // BCD inputs for the score
    output reg [3:0] red, green, blue // Separate outputs for RGB
);
    // *** Constant Declarations ***

    // Score Digit sections (32 x 64 each) in top-left region
    localparam TENTH_X_L = 64;    // Adjusted for two digits
    localparam TENTH_X_R = 95;
    localparam ONE_X_L = 96;
    localparam ONE_X_R = 127;
    localparam DIGIT_Y_T = 0;     // Top of the screen
    localparam DIGIT_Y_B = 63;    // Bottom of the digit

    // Object Status Signals
    wire TENTH_on, ONE_on;

    // ROM Interface Signals
    wire [10:0] rom_addr;
    reg [6:0] char_addr;         // 3'b011 + BCD value of score component
    wire [6:0] char_addr_tenth, char_addr_one;
    reg [3:0] row_addr;          // Row address of digit
    wire [3:0] row_addr_tenth, row_addr_one;
    reg [2:0] bit_addr;          // Column address of ROM data
    wire [2:0] bit_addr_tenth, bit_addr_one;
    wire [7:0] digit_word;       // Data from ROM
    wire digit_bit;

    // Assign character addresses for score digits
    assign char_addr_tenth = {3'b011, tenth};
    assign char_addr_one = {3'b011, one};

    // Scale coordinates for ROM lookup
    assign row_addr_tenth = y[5:2]; // Scaling to 32x64
    assign bit_addr_tenth = x[4:2]; // Scaling to 32x64
    assign row_addr_one = y[5:2];
    assign bit_addr_one = x[4:2];

    // Score digit sections assert signals
    assign TENTH_on = (TENTH_X_L <= x) && (x <= TENTH_X_R) &&
                      (DIGIT_Y_T <= y) && (y <= DIGIT_Y_B);
    assign ONE_on = (ONE_X_L <= x) && (x <= ONE_X_R) &&
                    (DIGIT_Y_T <= y) && (y <= DIGIT_Y_B);

    // Instantiate digit ROM
    score_digit_rom cdr(.clk(clk), .addr(rom_addr), .data(digit_word));

    // Mux for ROM Addresses and RGB    
    always @* begin
        // Default color (black background)
        red = 4'h0;
        green = 4'h0;
        blue = 4'h0;

        // Set digit color to green for all positions
        if (TENTH_on) begin
            char_addr = char_addr_tenth;
            row_addr = row_addr_tenth;
            bit_addr = bit_addr_tenth;
            if (digit_bit) begin
                green = 4'hF; // Green for active pixels
            end
        end else if (ONE_on) begin
            char_addr = char_addr_one;
            row_addr = row_addr_one;
            bit_addr = bit_addr_one;
            if (digit_bit) begin
                green = 4'hF; // Green for active pixels
            end
        end else if (video_on) begin
            // Background remains black if no digit is active
            red = 4'h0;
            green = 4'h0;
            blue = 4'h0;
        end
    end

    // ROM Interface
    assign rom_addr = {char_addr, row_addr};
    assign digit_bit = digit_word[~bit_addr];

endmodule