module top_game(
    input clk,
    input enable,
    input reset,
    input jump,
    output reg win,
    output stopped, // work on this logic when collision handling with mario character
    output h_sync,
    output v_sync,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue
    );
    
    wire clk_d;
    reg clk_dd;
    wire [9:0] h_count;
    wire [9:0] v_count;
    wire trig_v;
    wire [9:0] x_loc;
    wire [9:0] y_loc;
    wire video_on;
    wire [3:0] one, tenth, hundredth; 
    wire jump_signal;
    
    new_binary_score score_inst ( 
        .clk(clk), 
        .reset(reset), 
        .enable(enable), 
        .one(one), 
        .tenth(tenth)
    );
        
    clk_div a(clk, clk_d);
    h_counter b(clk_d, h_count, trig_v);
    v_counter c(trig_v, clk_d, v_count);
    vga_sync d(h_count, v_count, h_sync, v_sync, video_on, x_loc, y_loc);
    
    debounce debouncer(
        .clk(clk),
        .btn(jump),
        .btn_clean(jump_signal)
        );

      integrated_system int_sys_inst( 
        .clk(clk), 
        .video_on(video_on),
        .enable(enable), 
        .x(x_loc), 
        .y(y_loc),
        .jump(jump_signal),
        .tenth(tenth), 
        .one(one), 
        .stop(stopped),
        .red(red), 
        .green(green), 
        .blue(blue) );

    // Always block to check the score and set the win signal
    always @(posedge clk or posedge reset) begin
        if (reset) begin   
            win <= 0;
        end else if (enable) begin
            if (one == 4'd0 && tenth == 4'd6) begin
                win <= 1;
            end else begin
                win <= 0;
            end
        end
    end
        
endmodule
