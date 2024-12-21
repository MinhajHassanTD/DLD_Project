module vga_sync (
    input [9:0] h_count,
    input [9:0] v_count,
    output h_sync,
    output v_sync,
    output video_on, // active area
    output [9:0] x_loc, // current pixel x- location
    output [9:0] y_loc // current pixel y-location
    );
    localparam HD = 640;
    localparam HF = 16;
    localparam HB = 48;
    localparam HR = 96;
    
    
    localparam VD = 480;
    localparam VF = 10;
    localparam VB = 33;
    localparam VR = 2;
    
    
    assign v_sync = (v_count < (VD+VF)) | (v_count >= (VD+VF+VR));
    assign h_sync = (h_count < (HD+HF)) | (h_count >= (HD+HF+HR));
    assign video_on = (h_count < HD) & (v_count < VD);
    assign x_loc = h_count;
    assign y_loc = v_count;
endmodule