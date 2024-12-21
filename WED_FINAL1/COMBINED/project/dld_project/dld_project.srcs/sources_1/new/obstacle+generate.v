`timescale 1ns / 1ps

module obstacle_vga (
    input wire clk,     // 100 MHz clock
    input wire video_on,
    input [9:0] x, y,
    output reg [3:0] red, green, blue
);

    // VGA timing parameters
    localparam H_ACTIVE = 640;            // Active horizontal pixels
    localparam H_FRONT_PORCH = 16;        // Front porch
    localparam H_SYNC_PULSE = 96;         // Sync pulse
    localparam H_BACK_PORCH = 48;         // Back porch
    localparam H_TOTAL = H_ACTIVE + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;

    localparam V_ACTIVE = 480;            // Active vertical pixels
    localparam V_FRONT_PORCH = 10;        // Front porch
    localparam V_SYNC_PULSE = 2;          // Sync pulse
    localparam V_BACK_PORCH = 33;         // Back porch
    localparam V_TOTAL = V_ACTIVE + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;

    // Horizontal and vertical counters
    reg [9:0] h_count = 0;
    reg [9:0] v_count = 0;

    // Generate horizontal and vertical sync signals
    assign hsync = (h_count >= (H_ACTIVE + H_FRONT_PORCH)) && 
                   (h_count < (H_ACTIVE + H_FRONT_PORCH + H_SYNC_PULSE));
    assign vsync = (v_count >= (V_ACTIVE + V_FRONT_PORCH)) && 
                   (v_count < (V_ACTIVE + V_FRONT_PORCH + V_SYNC_PULSE));

    // Detect active video region
    wire video_active = (h_count < H_ACTIVE) && (v_count < V_ACTIVE);

    // Compute x and y coordinates within the active video region
    wire [9:0] x = (video_active) ? h_count : 10'd0;
    wire [9:0] y = (video_active) ? v_count : 10'd0;

    // Obstacle Parameters
    localparam OBSTACLE_X_START = 200;
    localparam OBSTACLE_X_END = 300;
    localparam OBSTACLE_Y_START = 150;
    localparam OBSTACLE_Y_END = 200;

    // Determine pixel color (Obstacle region)
    wire obstacle_region = (x >= OBSTACLE_X_START && x < OBSTACLE_X_END &&
                            y >= OBSTACLE_Y_START && y < OBSTACLE_Y_END);

    // VGA color assignment
    assign vga_r = (video_active && obstacle_region) ? 4'b1111 : 4'b0000;  // Red obstacle
    assign vga_g = 4'b0000;  // No green
    assign vga_b = 4'b0000;  // No blue

    // Horizontal and vertical counters
    always @(posedge clk_100MHz or posedge rst) begin
        if (rst) begin
            h_count <= 0;
            v_count <= 0;
        end else begin
            // Increment horizontal counter
            if (h_count == H_TOTAL - 1) begin
                h_count <= 0;
                // Increment vertical counter
                if (v_count == V_TOTAL - 1) begin
                    v_count <= 0;
                end else begin
                    v_count <= v_count + 1;
                end
            end else begin
                h_count <= h_count + 1;
            end
        end
    end

endmodule