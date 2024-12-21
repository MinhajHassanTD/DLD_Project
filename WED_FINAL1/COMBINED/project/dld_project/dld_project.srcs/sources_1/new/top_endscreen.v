
module top_endscreen(
    input clk,
    input enable,
    input win,
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
    wire video_on;
    
    wire [3:0] red_end, green_end, blue_end;
    wire [3:0] red_win, green_win, blue_win;
    
    clk_div a(clk, clk_d);
    h_counter b(clk_d, h_count, trig_v);
    v_counter c(trig_v, clk_d, v_count);
    vga_sync d(h_count, v_count, h_sync, v_sync, video_on, x_loc, y_loc);
    
    // Instantiate end_game
    end_game end_game_inst(
        .clk_d(clk_d),
        .pixel_x(x_loc),
        .pixel_y(y_loc),
        .video_on(video_on),
        .red(red_end),
        .blue(blue_end),
        .green(green_end)
    );
    
    // Instantiate win_game
    win_game win_game_inst(
        .clk_d(clk_d),
        .pixel_x(x_loc),
        .pixel_y(y_loc),
        .video_on(video_on),
        .red(red_win),
        .blue(blue_win),
        .green(green_win)
    );
    
    // Use a multiplexer to select the correct output based on the win signal
    assign red = (win == 1) ? red_win : red_end;
    assign green = (win == 1) ? green_win : green_end;
    assign blue = (win == 1) ? blue_win : blue_end;
endmodule
