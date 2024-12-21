module end_game(
    input clk_d,                  // Clock signal
    input [9:0] pixel_x,          // X-coordinate of the current pixel
    input [9:0] pixel_y,          // Y-coordinate of the current pixel
    input video_on,               // Video on signal (indicating valid area to display)
    output reg [3:0] red = 0,     // 4-bit Red output (VGA color component)
    output reg [3:0] green = 0,   // 4-bit Green output (VGA color component)
    output reg [3:0] blue = 0     // 4-bit Blue output (VGA color component)
);

    always @(posedge clk_d) begin
        if (video_on) begin
            // g conditions
            if (
                (pixel_x >= 50 && pixel_x <= 70 && pixel_y >= 50 && pixel_y <= 220) || // Left bar of G
                (pixel_x >= 50 && pixel_x <= 130 && pixel_y >= 200 && pixel_y <= 220) || //lower bar of G
                (pixel_x >= 50 && pixel_x <= 130 && pixel_y >= 50 && pixel_y <= 70) || //upper bar of G               
                (pixel_x >= 110 && pixel_x <= 130 && pixel_y >= 135 && pixel_y <= 220) || //right upper bar G
                (pixel_x >= 85 && pixel_x <= 130 && pixel_y >= 135 && pixel_y <= 155) || // mid bar G
                // A conditions
                (pixel_x >= 150 && pixel_x <= 170 && pixel_y >= 50 && pixel_y <= 220) || // Left vertical bar of A
                (pixel_x >= 210 && pixel_x <= 230 && pixel_y >= 50 && pixel_y <= 220) || // Right vertical bar of A
                (pixel_x >= 170 && pixel_x <= 210 && pixel_y >= 50 && pixel_y <= 70) || // Top bar of A
                (pixel_x >= 170 && pixel_x <= 210 && pixel_y >= 135 && pixel_y <= 155) || // Bottom bar of A
                // m conditions
                (pixel_x >= 250 && pixel_x <= 270 && pixel_y >= 50 && pixel_y <= 220) || // Left vertical bar of M
                (pixel_x >= 310 && pixel_x <= 330 && pixel_y >= 50 && pixel_y <= 220) || // Middle bar of M
                (pixel_x >= 280 && pixel_x <= 300 && pixel_y >= 50 && pixel_y <= 220) || //
                (pixel_x >= 250 && pixel_x <= 330 && pixel_y >= 50 && pixel_y <= 70) || 
               
                // e conditions
                (pixel_x >= 350 && pixel_x <= 410 && pixel_y >= 50 && pixel_y <= 70) || // Top bar of I
                (pixel_x >= 350 && pixel_x <= 410 && pixel_y >= 200 && pixel_y <= 220) ||
                (pixel_x >= 350 && pixel_x <= 410 && pixel_y >= 135 && pixel_y <= 155) || // Bottom bar of I
                (pixel_x >= 350 && pixel_x <= 370 && pixel_y >= 50 && pixel_y <= 220) || // Vertical bar of I
                
                //O conditions
                (pixel_x >= 250 && pixel_x <= 270 && pixel_y >= 270 && pixel_y <= 400) || // Left bar of O
                (pixel_x >= 270 && pixel_x <= 310 && pixel_y >= 380 && pixel_y <= 400) || //lower bar of O
                (pixel_x >= 270 && pixel_x <= 310 && pixel_y >= 270 && pixel_y <= 290) || //upper bar of O               
                (pixel_x >= 310 && pixel_x <= 330 && pixel_y >= 270 && pixel_y <= 400) || //right  bar O
                // V conditions
                (pixel_x >= 350 && pixel_x <= 370 && pixel_y >= 270 && pixel_y <= 390) || // Left diagonal of V
                (pixel_x >= 380 && pixel_x <= 400 && pixel_y >= 270 && pixel_y <= 390) || // Right diagonal of V
                (pixel_x >= 370 && pixel_x <= 380 && pixel_y >= 390 && pixel_y <= 410) || // Bottom tip of V
                
                // e conditions
                (pixel_x >= 420 && pixel_x <= 470 && pixel_y >= 270 && pixel_y <= 280) || // Top bar of I
                (pixel_x >= 420 && pixel_x <= 470 && pixel_y >= 330 && pixel_y <= 350) ||
                (pixel_x >= 420 && pixel_x <= 470 && pixel_y >= 380 && pixel_y <= 400) || // Bottom bar of I
                (pixel_x >= 420 && pixel_x <= 430 && pixel_y >= 270 && pixel_y <= 400) || // Vertical bar of I
                
                (pixel_x >= 490 && pixel_x <= 500 && pixel_y >= 270 && pixel_y <= 400) || 
                (pixel_x >= 520 && pixel_x <= 530 && pixel_y >= 270 && pixel_y <= 325) ||
                (pixel_x >= 530 && pixel_x <= 540 && pixel_y >= 335 && pixel_y <= 400) || 
                (pixel_x >= 490 && pixel_x <= 530 && pixel_y >= 270 && pixel_y <= 280) || 
                (pixel_x >= 490 && pixel_x <= 530 && pixel_y >= 325 && pixel_y <= 335)    
               
                
              
               
                
              
                
//                //Econditions
//                (pixel_x >= 200 && pixel_x <= 290 && pixel_y >= 270 && pixel_y <= 280) ||
//                (pixel_x >= 200 && pixel_x <= 290 && pixel_y >= 330 && pixel_y <= 340) ||
//                (pixel_x >= 200 && pixel_x <= 290 && pixel_y >= 390 && pixel_y <= 400)  ||
//                (pixel_x >= 200 && pixel_x <= 70 && pixel_y >= 270 && pixel_y <= 400)
                 // Right diagonal of N
                
//                // N conditions
//                (pixel_x >= 310 && pixel_x <= 400 && pixel_y >= 270 && pixel_y <= 280) || // Top bar of N
//                (pixel_x >= 310 && pixel_x <= 320 && pixel_y >= 280 && pixel_y <= 400) || // Left diagonal of N
//                (pixel_x >= 390 && pixel_x <= 400 && pixel_y >= 280 && pixel_y <= 400) || // Right diagonal of N
//                // S conditions
//                (pixel_x >= 410 && pixel_x <= 480 && pixel_y >= 270 && pixel_y <= 280) || // Top bar of S
//                (pixel_x >= 410 && pixel_x <= 420 && pixel_y >= 280 && pixel_y <= 400) || // Upper left curve of S
//                 // Bottom curve of S
//                // Right vertical curve of S
//                (pixel_x >= 410 && pixel_x <= 480 && pixel_y >= 390 && pixel_y <= 400) ||
//                (pixel_x >= 470 && pixel_x <= 480 && pixel_y >= 270 && pixel_y <= 400) 
                
            ) begin
                // Text color (light pink)
                red <= 4'hF;    // High red intensity
                green <= 4'h0;  // High green intensity
                blue <= 4'h0;   // High blue intensity (light pink)
            end else begin
                // Background color (black)
                red <= 4'h0;    // No red intensity
                green <= 4'h0;  // No green intensity
                blue <= 4'hF;   // No blue intensity
            end
        end else begin
            // Output black when outside the visible area
            red <= 4'b0000;
            green <= 4'b0000;
            blue <= 4'b0000;
        end
    end
endmodule

