`timescale 1ns / 1ps

module jumping_mario(
    input clk,                              // 100MHz clock
    input video_on,                         // from VGA controller
    input [9:0] x, y,                       // current pixel coordinates from VGA controller
    input jump,                             // input signal to trigger jump
    output reg [3:0] red,                   // red output to VGA
    output reg [3:0] green,                 // green output to VGA
    output reg [3:0] blue,                  // blue output to VGA
    output [9:0] mario_x_reg,               // Mario's x position register
    output [9:0] mario_y_reg,               // Mario's y position register
    output [9:0] mario_size                 // Mario's size
);

    parameter X_MAX = 639;                  // right border of display area
    parameter Y_MAX = 479;                  // bottom border of display area
    parameter BG_RED = 4'h0;                // red for background
    parameter BG_GREEN = 4'h0;              // green for background
    parameter BG_BLUE = 4'h0;               // blue for background
    parameter MARIO_WIDTH = 56;             // width of Mario sprite
    parameter MARIO_HEIGHT = 64;            // height of Mario sprite
    parameter JUMP_HEIGHT = 245;             // height of the jump
    parameter GRAVITY_DELAY = 0;            // reduce delay for faster gravity effect                                                                                                                                  

    // create a 60Hz refresh tick at the start of vsync 
    wire refresh_tick;
    assign refresh_tick = ((y == 481) && (x == 0)) ? 1 : 0;

    // Mario boundaries and position
    reg [9:0] mario_x = 30;                 // initial x position
    reg [9:0] mario_y = Y_MAX - MARIO_HEIGHT - 32; // initial y position (bottom of screen)
    wire [9:0] mario_x_l, mario_x_r, mario_y_t, mario_y_b; // boundaries of Mario

    // jumping state and counter
    reg jumping = 0;                        // flag for jump phase
    reg [3:0] gravity_counter = 0;          // gravity delay counter

    // Mario boundaries
    assign mario_x_l = mario_x;
    assign mario_x_r = mario_x + MARIO_WIDTH - 1;
    assign mario_y_t = mario_y;
    assign mario_y_b = mario_y + MARIO_HEIGHT - 1;

    // Output assignments
    assign mario_x_reg = mario_x;
    assign mario_y_reg = mario_y;
    assign mario_size = MARIO_HEIGHT;

    // Instantiate mario_rom
    wire [11:0] sprite_pixel;
    wire [11:0] rom_addr = (y - mario_y_t) * MARIO_WIDTH + (x - mario_x_l);
    
    mario_rom rom (
        .clk(clk),
        .addr(rom_addr),
        .data(sprite_pixel)
    );

    // Mario movement logic
    always @(posedge clk) begin
        if (refresh_tick) begin
            if (jump && !jumping) begin
                jumping <= 1;                        // Start jump
                mario_y <= mario_y - JUMP_HEIGHT;    // Move Mario up
            end else if (jumping) begin
                if (gravity_counter == GRAVITY_DELAY) begin
                    gravity_counter <= 0;
                    mario_y <= mario_y + 1;          // Apply gravity
                    if (mario_y >= Y_MAX - MARIO_HEIGHT - 32) begin
                        mario_y <= Y_MAX - MARIO_HEIGHT - 32; // Stop at ground
                        jumping <= 0;                // End jump
                    end
                end else begin
                    gravity_counter <= gravity_counter + 1;
                end
            end
        end
    end

    // Mario status signal
    wire mario_on;
    assign mario_on = (mario_x_l <= x) && (x <= mario_x_r) &&
                      (mario_y_t <= y) && (y <= mario_y_b);

    // RGB control for Mario and background
    always @* begin
        // Default to background color
        red = BG_RED;
        green = BG_GREEN;
        blue = BG_BLUE;

        if (video_on) begin
            if (mario_on) begin
                red = sprite_pixel[11:8];       // Mario sprite color
                green = sprite_pixel[7:4];
                blue = sprite_pixel[3:0];
            end else begin
                red = BG_RED;                   // Background color
                green = BG_GREEN;
                blue = BG_BLUE;
            end
        end
    end
    
endmodule
