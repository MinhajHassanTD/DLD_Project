`timescale 1ns / 1ps

 module integrated_pixel_gen(
    input clk,                          // Clock signal
    input enable,
    input video_on,                     // VGA controller signal
    input [9:0] x, y,                   // VGA pixel coordinates
    input [3:0] tenth, one,             // BCD inputs for the score
    output [9:0] enemy4_x_reg, enemy4_y_reg,  // Enemy 1 positions
    output [9:0] enemy5_x_reg, enemy5_y_reg,  // Enemy 1 positions
    output [9:0] enemy2_x_reg, enemy2_y_reg,  // Enemy 2 positions
    output [9:0] enemy4_width, enemy4_height,  // Enemy 1 size
    output [9:0] enemy2_width, enemy2_height,  // Enemy 2 size
    output [9:0] enemy5_width, enemy5_height,  // Enemy 2 size
    output reg [3:0] red, green, blue  
);

    // * Constants for Score Digits *
    localparam TENTH_X_L = 64;          // Left boundary of tenth digit
    localparam TENTH_X_R = 95;          // Right boundary of tenth digit
    localparam ONE_X_L = 96;            // Left boundary of ones digit
    localparam ONE_X_R = 127;           // Right boundary of ones digit
    localparam DIGIT_Y_T = 0;           // Top of digit region
    localparam DIGIT_Y_B = 63;          // Bottom of digit region

    // * Constants for Moving Objects *
    localparam X_MAX = 639;             // Screen width
    localparam Y_MAX = 479;             // Screen height
    localparam ENEMY1_WIDTH = 68;       // Width of enemy 1
    localparam ENEMY1_HEIGHT = 58;      // Height of enemy 1
    localparam ENEMY2_WIDTH = 28;       // Width of enemy 2
    localparam ENEMY2_HEIGHT = 38;      // Height of enemy 2
    localparam ENEMY3_WIDTH = 38;       // Width of enemy 1
    localparam ENEMY3_HEIGHT = 26;      // Height of enemy 1
    localparam ENEMY4_WIDTH = 62;       // Width of enemy 1
    localparam ENEMY4_HEIGHT = 54;      // Height of enemy 1
    localparam ENEMY5_WIDTH = 27;       // Width of enemy 1
    localparam ENEMY5_HEIGHT = 31;      // Height of enemy 1
    localparam GROUND_Y_T = Y_MAX - 32; // Top boundary of ground block
    localparam GROUND_Y_B = Y_MAX;      // Bottom boundary of ground block
    localparam GROUND_WIDTH = 640;       // Width of enemy 1
    localparam GROUND_HEIGHT = 32;      // Height of enemy 1

    // Color definitions
    localparam [3:0] BG_RED = 4'h8, BG_GREEN = 4'h5, BG_BLUE = 4'hB;  // Black background
    localparam [3:0] DIGIT_RED = 4'h0, DIGIT_GREEN = 4'hF, DIGIT_BLUE = 4'h0;  // Green digits
    localparam [3:0] GROUND_RED = 4'hF, GROUND_GREEN = 4'hF, GROUND_BLUE = 4'hF; // White ground

    // * Registers and Wires for Moving Objects *
        // * Registers and Wires for Moving Objects *
    reg [9:0] enemy1_x_reg = X_MAX - ENEMY1_WIDTH, enemy1_y_reg = GROUND_Y_T - ENEMY1_HEIGHT; // Enemy 1 position
    reg [9:0] enemy2_x_reg = X_MAX - ENEMY2_WIDTH, enemy2_y_reg = GROUND_Y_T - ENEMY2_HEIGHT; // Enemy 2 position
    reg [9:0] enemy3_x_reg = X_MAX - ENEMY3_WIDTH, enemy3_y_reg = GROUND_Y_T - ENEMY3_HEIGHT; // Enemy 3 position
    reg [9:0] enemy4_x_reg = X_MAX - ENEMY4_WIDTH, enemy4_y_reg = GROUND_Y_T - ENEMY4_HEIGHT; // Enemy 4 position
    reg [9:0] enemy5_x_reg = X_MAX - ENEMY5_WIDTH, enemy5_y_reg = GROUND_Y_T - ENEMY5_HEIGHT; // Enemy 5 position
    
    wire enemy1_on, enemy2_on, enemy3_on, enemy4_on, enemy5_on, ground_on;
    wire [9:0] enemy1_x_l, enemy1_x_r, enemy1_y_t, enemy1_y_b;
    wire [9:0] enemy2_x_l, enemy2_x_r, enemy2_y_t, enemy2_y_b;
    wire [9:0] enemy3_x_l, enemy3_x_r, enemy3_y_t, enemy3_y_b;
    wire [9:0] enemy4_x_l, enemy4_x_r, enemy4_y_t, enemy4_y_b;
    wire [9:0] enemy5_x_l, enemy5_x_r, enemy5_y_t, enemy5_y_b;

    
    // * Registers and Wires for Score Digits *
    wire TENTH_on, ONE_on;
    reg [6:0] char_addr;          // ROM character address
    reg [3:0] row_addr;           // ROM row address
    reg [2:0] bit_addr;           // ROM bit address
    wire [10:0] rom_addr;         // Combined ROM address
    wire [7:0] digit_word;        // Data from ROM
    wire digit_bit;
    
    // * ROM Instantiation for Score Digits *
    score_digit_rom digit_rom (
        .clk(clk),
        .addr(rom_addr),
        .data(digit_word)
    );
    
    // Instantiate ground ROM
    wire [11:0] ground_pixel;
    wire [14:0] ground_rom_addr = (y - GROUND_Y_T) * GROUND_WIDTH + (x - 0);
    
    ground_rom ground (
        .clk(clk),
        .addr(ground_rom_addr),
        .data(ground_pixel)
    );


    // Instantiate enemy ROMs
        // Instantiate enemy ROMs
    wire [11:0] enemy1_pixel, enemy2_pixel, enemy3_pixel, enemy4_pixel, enemy5_pixel;
    wire [11:0] enemy1_rom_addr = (y - enemy1_y_t) * ENEMY1_WIDTH + (x - enemy1_x_l);
    wire [11:0] enemy2_rom_addr = (y - enemy2_y_t) * ENEMY2_WIDTH + (x - enemy2_x_l);
    wire [11:0] enemy3_rom_addr = (y - enemy3_y_t) * ENEMY3_WIDTH + (x - enemy3_x_l);
    wire [11:0] enemy4_rom_addr = (y - enemy4_y_t) * ENEMY4_WIDTH + (x - enemy4_x_l);
    wire [11:0] enemy5_rom_addr = (y - enemy5_y_t) * ENEMY5_WIDTH + (x - enemy5_x_l);

    bowser_enemy_rom e1(
        .clk(clk),
        .addr(enemy1_rom_addr),
        .data(enemy1_pixel)
    );

    laal_enemy_rom e2 (
        .clk(clk),
        .addr(enemy2_rom_addr),
        .data(enemy2_pixel)
    );

    ghost_enemy_rom e3 (
        .clk(clk),
        .addr(enemy3_rom_addr),
        .data(enemy3_pixel)
    );

    scary_enemy_rom e4 (
        .clk(clk),
        .addr(enemy4_rom_addr),
        .data(enemy4_pixel)
    );

    dirt_enemy_rom e5 (
        .clk(clk),
        .addr(enemy5_rom_addr),
        .data(enemy5_pixel)
    );


     // * Moving Object Update Logic *
    reg [18:0] slow_count; // Increase counter width to slow down objects even more
    
    always @(posedge clk) begin
        slow_count <= slow_count + 1;
        if (slow_count == 0 && enable == 1) begin // Slow down the objects by using a counter
            // Update enemy 1 position
            if (enemy1_x_reg == 0)
                enemy1_x_reg <= X_MAX - ENEMY1_WIDTH; // Reset to right
            else begin
                if ({tenth, one} >= 8'd100)
                enemy1_x_reg <= enemy1_x_reg - 1; // Move left
            end
            
            // Update enemy 2 position
            if (enemy2_x_reg == 0)
                enemy2_x_reg <= X_MAX - ENEMY2_WIDTH; // Reset to right
            else begin
                if ({tenth, one} >= 8'd20)
                enemy2_x_reg <= enemy2_x_reg - 1; // Move left
            end
 
            if (enemy3_x_reg == 0)
                enemy3_x_reg <= X_MAX - ENEMY3_WIDTH; // Reset to right
            else begin
                if ({tenth, one} >= 8'd100)
                enemy3_x_reg <= enemy3_x_reg - 1; // Move left
            end
            
            if (enemy4_x_reg == 0)
                enemy4_x_reg <= X_MAX - ENEMY4_WIDTH; // Reset to right
            else begin
                if ({tenth, one} >= 8'd0)
                enemy4_x_reg <= enemy4_x_reg - 1; // Move left
            end
            
            if (enemy5_x_reg == 0)
                enemy5_x_reg <= X_MAX - ENEMY5_WIDTH; // Reset to right
            else begin
                if ({tenth, one} >= 8'd40)
                enemy5_x_reg <= enemy5_x_reg - 1; // Move left
            end
        end
         if (enable == 0) begin
                 enemy1_x_reg <= X_MAX - ENEMY1_WIDTH;
                 enemy1_y_reg <= GROUND_Y_T - ENEMY1_HEIGHT;
                 enemy2_x_reg <= X_MAX - ENEMY2_WIDTH;
                 enemy2_y_reg <= GROUND_Y_T - ENEMY2_HEIGHT;
                 enemy3_x_reg <= X_MAX - ENEMY3_WIDTH;
                 enemy3_y_reg <= GROUND_Y_T - ENEMY3_HEIGHT;
                 enemy4_x_reg <= X_MAX - ENEMY4_WIDTH;
                 enemy4_y_reg <= GROUND_Y_T - ENEMY4_HEIGHT;
                 enemy5_x_reg <= X_MAX - ENEMY5_WIDTH;
                 enemy5_y_reg <= GROUND_Y_T - ENEMY5_HEIGHT;
            end
        end


    // * Boundary Calculations for Moving Objects *
    assign enemy1_x_l = enemy1_x_reg;
    assign enemy1_x_r = enemy1_x_l + ENEMY1_WIDTH - 1;
    assign enemy1_y_t = enemy1_y_reg;
    assign enemy1_y_b = enemy1_y_t + ENEMY1_HEIGHT - 1;

    assign enemy2_x_l = enemy2_x_reg;
    assign enemy2_x_r = enemy2_x_l + ENEMY2_WIDTH - 1;
    assign enemy2_y_t = enemy2_y_reg;
    assign enemy2_y_b = enemy2_y_t + ENEMY2_HEIGHT - 1;

    assign enemy3_x_l = enemy3_x_reg;
    assign enemy3_x_r = enemy3_x_l + ENEMY3_WIDTH - 1;
    assign enemy3_y_t = enemy3_y_reg;
    assign enemy3_y_b = enemy3_y_t + ENEMY3_HEIGHT - 1;

    assign enemy4_x_l = enemy4_x_reg;
    assign enemy4_x_r = enemy4_x_l + ENEMY4_WIDTH - 1;
    assign enemy4_y_t = enemy4_y_reg;
    assign enemy4_y_b = enemy4_y_t + ENEMY4_HEIGHT - 1;

    assign enemy5_x_l = enemy5_x_reg;
    assign enemy5_x_r = enemy5_x_l + ENEMY5_WIDTH - 1;
    assign enemy5_y_t = enemy5_y_reg;
    assign enemy5_y_b = enemy5_y_t + ENEMY5_HEIGHT - 1;

    assign enemy1_on = (x >= enemy1_x_l && x <= enemy1_x_r) &&
                       (y >= enemy1_y_t && y <= enemy1_y_b);
    assign enemy2_on = (x >= enemy2_x_l && x <= enemy2_x_r) &&
                       (y >= enemy2_y_t && y <= enemy2_y_b);
    assign enemy3_on = (x >= enemy3_x_l && x <= enemy3_x_r) &&
                       (y >= enemy3_y_t && y <= enemy3_y_b);
    assign enemy4_on = (x >= enemy4_x_l && x <= enemy4_x_r) &&
                       (y >= enemy4_y_t && y <= enemy4_y_b);
    assign enemy5_on = (x >= enemy5_x_l && x <= enemy5_x_r) &&
                       (y >= enemy5_y_t && y <= enemy5_y_b);


    // * Boundary Calculations for Ground Block *
    assign ground_on = (y >= GROUND_Y_T && y <= GROUND_Y_B);

    // * Boundary Calculations for Score Digits *
    assign TENTH_on = (x >= TENTH_X_L && x <= TENTH_X_R) &&
                      (y >= DIGIT_Y_T && y <= DIGIT_Y_B);
    assign ONE_on = (x >= ONE_X_L && x <= ONE_X_R) &&
                    (y >= DIGIT_Y_T && y <= DIGIT_Y_B);

    // * ROM Address Logic for Digits *
    always @* begin
        char_addr = 7'b0;
        row_addr = y[5:2];        // Scale y to 32x64
        bit_addr = x[4:2];        // Scale x to 32x64

        if (TENTH_on)
            char_addr = {3'b011, tenth}; // Tenth digit character address
        else if (ONE_on)
            char_addr = {3'b011, one};   // Ones digit character address
    end

    assign rom_addr = {char_addr, row_addr};
    assign digit_bit = digit_word[~bit_addr];

    // * RGB Output Logic *
    always @* begin
        // Default background color
        red = BG_RED;
        green = BG_GREEN;
        blue = BG_BLUE;

        if (video_on) begin
            if (TENTH_on || ONE_on) begin
                // Display score digits (priority)
                if (digit_bit) begin
                    red = DIGIT_RED;
                    green = DIGIT_GREEN;
                    blue = DIGIT_BLUE;
                end
//            end else if (enemy1_on && {tenth, one} >= 8'd0) begin
//                // Display enemy 1
//                red = enemy1_pixel[11:8];
//                green = enemy1_pixel[7:4];
//                blue = enemy1_pixel[3:0];
            end else if (enemy2_on && {tenth, one} >= 8'd20) begin
                // Display enemy 2
                red = enemy2_pixel[11:8];
                green = enemy2_pixel[7:4];
                blue = enemy2_pixel[3:0];
//            end else if (enemy3_on && {tenth, one} >= 8'd40) begin
//                // Display enemy 2
//                red = enemy3_pixel[11:8];
//                green = enemy3_pixel[7:4];
//                blue = enemy3_pixel[3:0];
            end else if (enemy4_on && {tenth, one} >= 8'd0) begin
                // Display enemy 2
                red = enemy4_pixel[11:8];
                green = enemy4_pixel[7:4];
                green = enemy4_pixel[7:4];
                blue = enemy4_pixel[3:0];
           end else if (enemy5_on && {tenth, one} >= 8'd40) begin
                // Display enemy 5
                red = enemy5_pixel[11:8];
                green = enemy5_pixel[7:4];
                blue = enemy5_pixel[3:0];            
            end else if (ground_on) begin
                red = ground_pixel[11:8];
                green = ground_pixel[7:4];
                blue = ground_pixel[3:0];
            end
        end
    end
endmodule