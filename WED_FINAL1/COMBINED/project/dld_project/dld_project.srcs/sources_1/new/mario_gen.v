`timescale 1ns / 1ps

module mario_pixel_gen (
    input clk,             // Clock input
    input video_on,        // VGA controller signal
    input [9:0] x,         // VGA horizontal coordinate
    input [9:0] y,         // VGA vertical coordinate
    output reg [3:0] red,  // Red component of RGB
    output reg [3:0] green,// Green component of RGB
    output reg [3:0] blue  // Blue component of RGB
);
    // Mario top-left position
    parameter MARIO_X = 100;
    parameter MARIO_Y = 100;

    // Mario dimensions
    parameter MARIO_WIDTH = 16;
    parameter MARIO_HEIGHT = 16;

    // Pixel Color Definitions
    localparam [11:0] RED    = 12'hF00;
    localparam [11:0] GREEN  = 12'h0F0;
    localparam [11:0] BLUE   = 12'h00F;
    localparam [11:0] BLACK  = 12'h000;
    localparam [11:0] PEACH  = 12'hFFA;  // Skin tone

    // Relative position inside Mario sprite
    wire [3:0] mario_x = x - MARIO_X; // Horizontal relative position
    wire [3:0] mario_y = y - MARIO_Y; // Vertical relative position

    always @(posedge clk) begin
        // Default to black background
        red = 4'b0000;
        green = 4'b0000;
        blue = 4'b0000;

        if (video_on) begin
            // Check if within Mario's bounding box
            if ((x >= MARIO_X) && (x < MARIO_X + MARIO_WIDTH) &&
                (y >= MARIO_Y) && (y < MARIO_Y + MARIO_HEIGHT)) begin
                // Define pixel colors based on Mario's sprite
                case ({mario_y, mario_x}) // 8-bit address combining y and x
                    8'b00000000: {red, green, blue} = RED;    // Example pixel (row 0, col 0)
                    8'b00000001: {red, green, blue} = GREEN;  // Example pixel (row 0, col 1)
                    8'b00000010: {red, green, blue} = PEACH;  // Example pixel (row 0, col 2)
                    // Add other pixels for Mario's sprite here...
                    default: {red, green, blue} = BLACK;      // Default for unhandled pixels
                endcase
            end
        end
    end
endmodule