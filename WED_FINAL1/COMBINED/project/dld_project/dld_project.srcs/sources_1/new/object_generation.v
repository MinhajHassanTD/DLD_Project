`timescale 1ns / 1ps

module object_generation(
    input clk,                              // 100MHz from Basys 3
    input video_on,                         // from VGA controller
    input [9:0] x, y,                       // from VGA controller
    output reg [3:0] red,                   // red output to VGA
    output reg [3:0] green,                 // green output to VGA
    output reg [3:0] blue                   // blue output to VGA
    );
    
    parameter X_MAX = 639;                  // right border of display area
    parameter Y_MAX = 479;                  // bottom border of display area
    parameter SQ1_RED = 4'hF;               // red for square 1
    parameter SQ1_GREEN = 4'hF;             // green for square 1 (yellow = red + green)
    parameter SQ1_BLUE = 4'h0;              // blue for square 1
    parameter SQ2_RED = 4'h0;               // red for square 2
    parameter SQ2_GREEN = 4'hF;             // green for square 2
    parameter SQ2_BLUE = 4'h0;              // blue for square 2
    parameter BG_RED = 4'h0;                // red for background
    parameter BG_GREEN = 4'h0;              // green for background
    parameter BG_BLUE = 4'hF;               // blue for background
    parameter SQ1_SIZE = 64;                // size of square 1 (64x64)
    parameter SQ2_SIZE = 32;                // size of square 2 (32x32)
    parameter SQ1_VELOCITY_POS = 1;         // velocity for square 1
    parameter SQ2_VELOCITY_POS = 1;         // velocity for square 2
    
    // create a 60Hz refresh tick at the start of vsync 
    wire refresh_tick;
    assign refresh_tick = ((y == 481) && (x == 0)) ? 1 : 0;
    
    // square 1 boundaries and position
    wire [9:0] sq1_x_l, sq1_x_r;            // square 1 left and right boundary
    wire [9:0] sq1_y_t, sq1_y_b;            // square 1 top and bottom boundary
    reg [9:0] sq1_x_reg, sq1_y_reg;         // regs to track position for square 1
    
    // square 2 boundaries and position
    wire [9:0] sq2_x_l, sq2_x_r;            // square 2 left and right boundary
    wire [9:0] sq2_y_t, sq2_y_b;            // square 2 top and bottom boundary
    reg [9:0] sq2_x_reg, sq2_y_reg;         // regs to track position for square 2
    
    // register control for square 1
    always @(posedge clk) begin
        if(refresh_tick) begin
            if(sq1_x_reg + SQ1_SIZE - 1 >= X_MAX) begin
                sq1_x_reg <= 0;                // Reset square 1 to starting position
                sq1_y_reg <= Y_MAX - SQ1_SIZE; // Reset y position of square 1
            end else begin
                sq1_x_reg <= sq1_x_reg + SQ1_VELOCITY_POS; // Move square 1 to the right
            end
        end
    end
    
    // register control for square 2
    always @(posedge clk) begin
        if(refresh_tick) begin
            if(sq2_x_reg + SQ2_SIZE - 1 >= X_MAX) begin
                sq2_x_reg <= 0;                // Reset square 2 to starting position
                sq2_y_reg <= Y_MAX - SQ2_SIZE; // Reset y position of square 2
            end else begin
                sq2_x_reg <= sq2_x_reg + SQ2_VELOCITY_POS; // Move square 2 to the right
            end
        end
    end
    
    // square 1 boundaries
    assign sq1_x_l = sq1_x_reg;                   // left boundary of square 1
    assign sq1_y_t = sq1_y_reg;                   // top boundary (fixed at bottom) for square 1
    assign sq1_x_r = sq1_x_l + SQ1_SIZE - 1;      // right boundary of square 1
    assign sq1_y_b = sq1_y_t + SQ1_SIZE - 1;      // bottom boundary of square 1
    
    // square 2 boundaries
    assign sq2_x_l = sq2_x_reg;                   // left boundary of square 2
    assign sq2_y_t = sq2_y_reg;                   // top boundary (fixed at bottom) for square 2
    assign sq2_x_r = sq2_x_l + SQ2_SIZE - 1;      // right boundary of square 2
    assign sq2_y_b = sq2_y_t + SQ2_SIZE - 1;      // bottom boundary of square 2
    
    // square 1 status signal
    wire sq1_on;
    assign sq1_on = (sq1_x_l <= x) && (x <= sq1_x_r) &&
                    (sq1_y_t <= y) && (y <= sq1_y_b);
    
    // square 2 status signal
    wire sq2_on;
    assign sq2_on = (sq2_x_l <= x) && (x <= sq2_x_r) &&
                    (sq2_y_t <= y) && (y <= sq2_y_b);
    
    // RGB control for both squares
    always @* begin
        // Default to black outside display area
        red = 4'h0;
        green = 4'h0;
        blue = 4'h0;

        if (video_on) begin
            if (sq1_on) begin
                red = SQ1_RED;         // Yellow square 1 (red + green)
                green = SQ1_GREEN;
                blue = SQ1_BLUE;
            end else if (sq2_on) begin
                red = SQ2_RED;         // Green square 2
                green = SQ2_GREEN;
                blue = SQ2_BLUE;
            end else begin
                red = BG_RED;          // Blue background
                green = BG_GREEN;
                blue = BG_BLUE;
            end
        end
    end
    
endmodule