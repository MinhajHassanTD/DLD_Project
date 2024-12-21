module top_startscreen(
    input clk,
    input enable,
    output h_sync,
    output v_sync,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue
    );
    
    wire clk_d;
    wire [9:0] h_count;
    wire [9:0] v_count;
    wire trig_v;
    wire [9:0] x_loc;
    wire [9:0] y_loc;
    
    clk_div a(clk, clk_d);
    h_counter b(clk_d, h_count, trig_v);
    v_counter c(trig_v, clk_d, v_count);
    vga_sync d(h_count, v_count, h_sync, v_sync, video_on, x_loc, y_loc);
    start_game e(clk_d, x_loc, y_loc, video_on, red, blue, green);
endmodule