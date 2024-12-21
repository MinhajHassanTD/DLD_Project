module main_game(
    input clk_d,                  // Clock signal
    input [9:0] pixel_x,          // X-coordinate of the current pixel
    input [9:0] pixel_y,          // Y-coordinate of the current pixel
    input video_on,               // Video on signal (indicating valid area to display)
    output reg [3:0] red = 0,     // 4-bit Red output (VGA color component)
    output reg [3:0] green = 0,   // 4-bit Green output (VGA color component)
    output reg [3:0] blue = 0     // 4-bit Blue output (VGA color component)
);

    always @(posedge clk_d) begin
        if (video_on) 
        begin
            red <= 4'hF;
            green <= 4'hF;
            blue <= 4'hF;
        end 
        else 
        begin
            red <= 4'b0000;
            green <= 4'b0000;
            blue <= 4'b0000;
        end
    end   

endmodule