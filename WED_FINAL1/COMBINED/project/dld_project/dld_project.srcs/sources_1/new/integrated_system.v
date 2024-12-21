`timescale 1ns / 1ps

module integrated_system(
    input clk,                          // Clock signal
    input video_on,                     // VGA controller signal
    input  enable,
    input [9:0] x, y,                   // VGA pixel coordinates
    input jump,                         // Jump signal for the square
    input [3:0] tenth, one,             // BCD inputs for the score
    output reg [3:0] red, green, blue,  // Combined RGB outputs
    output reg stop                     // Stop signal for collision detection
);
    // *** Internal Signals ***
    // Jumping square
    wire [9:0] jsq_x_l, jsq_x_r, jsq_y_t, jsq_y_b; // Jumping square boundaries
    wire jsq_active;                               // Jumping square active flag
    wire [3:0] jsq_red, jsq_green, jsq_blue;       // RGB for jumping square
    wire [9:0] jsq_x_reg, jsq_y_reg, jsq_size;     // Internal signals for jumping square

    // Moving objects and score
    wire [9:0] enemy1_x_l, enemy1_x_r, enemy1_y_t, enemy1_y_b; // Enemy 1 boundaries
    wire [9:0] enemy2_x_l, enemy2_x_r, enemy2_y_t, enemy2_y_b; // Enemy 2 boundaries
    wire [9:0] enemy3_x_l, enemy3_x_r, enemy3_y_t, enemy3_y_b; // Enemy 2 boundaries
    wire [3:0] obj_red, obj_green, obj_blue;                   // RGB for objects/score

    // Active flags for obstacles
    wire enemy1_active, enemy2_active;

    // *** Jumping Square Instance ***
    jumping_mario jsq_inst (
        .clk(clk),
        .video_on(video_on),
        .x(x),
        .y(y),
        .jump(jump),
        .red(jsq_red),
        .green(jsq_green),
        .blue(jsq_blue),
        .mario_x_reg(jsq_x_reg),
        .mario_y_reg(jsq_y_reg),
        .mario_size(jsq_size)
    );

    // Active flag and boundaries for jumping square
    assign jsq_active = (jsq_red != 4'h0) || (jsq_green != 4'h0) || (jsq_blue != 4'h0);
    assign jsq_x_l = jsq_x_reg;
    assign jsq_x_r = jsq_x_reg + jsq_size - 1;
    assign jsq_y_t = jsq_y_reg;
    assign jsq_y_b = jsq_y_reg + jsq_size - 1;

    // *** Moving Objects and Score Instance ***
    integrated_pixel_gen ipg_inst (
        .clk(clk),
        .enable(enable),
        .video_on(video_on),
        .x(x),
        .y(y),
        .tenth(tenth),
        .one(one),
        .red(obj_red),
        .green(obj_green),
        .blue(obj_blue),
        .enemy4_x_reg(enemy1_x_l),
        .enemy4_y_reg(enemy1_y_t),
        .enemy2_x_reg(enemy2_x_l),
        .enemy2_y_reg(enemy2_y_t),
        .enemy5_x_reg(enemy3_x_l),
        .enemy5_y_reg(enemy3_y_t),
        .enemy4_width(enemy1_width),
        .enemy4_height(enemy1_height),
        .enemy2_width(enemy2_width),
        .enemy2_height(enemy2_height),
        .enemy5_width(enemy3_width),
        .enemy5_height(enemy3_height)
    );

    // Active flags for enemies
    assign enemy1_x_r = enemy1_x_l + enemy1_width - 1;
    assign enemy1_y_b = enemy1_y_t + enemy1_height - 1;

    assign enemy2_x_r = enemy2_x_l + enemy2_width - 1;
    assign enemy2_y_b = enemy2_y_t + enemy2_height - 1;
    
    assign enemy3_x_r = enemy3_x_l + enemy3_width - 1;
    assign enemy3_y_b = enemy3_y_t + enemy3_height - 1;

    // *** Collision Detection Logic ***
    always @(posedge clk) begin
        stop <= 0; // Default to no collision

        // Check for collision with Enemy 1
        if ((jsq_x_r >= enemy1_x_l && jsq_x_l <= enemy1_x_r) && // Horizontal overlap
            (jsq_y_b >= enemy1_y_t && jsq_y_t <= enemy1_y_b))  // Vertical overlap
            stop <= 1;
            

        // Check for collision with Enemy 2
        if ((jsq_x_r >= enemy2_x_l && jsq_x_l <= enemy2_x_r) && // Horizontal overlap
            (jsq_y_b >= enemy2_y_t && jsq_y_t <= enemy2_y_b))  // Vertical overlap
            stop <= 1;
       
//        // Check for collision with Enemy 3
//        if ((jsq_x_r >= enemy3_x_l && jsq_x_l <= enemy3_x_r) && // Horizontal overlap
//            (jsq_y_b >= enemy3_y_t && jsq_y_t <= enemy3_y_b))  // Vertical overlap
//            stop <= 1;
            
    end

    // *** Combined RGB Logic ***
    always @* begin
        // Default to black background
        red = 4'h0;
        green = 4'h0;
        blue = 4'h0;

        if (video_on) begin
            if (jsq_active) begin
                // Priority to jumping square
                red = jsq_red;
                green = jsq_green;
                blue = jsq_blue;
            end else begin
                // Render moving objects and score if no jumping square
                red = obj_red;
                green = obj_green;
                blue = obj_blue;
            end
        end
    end

endmodule
