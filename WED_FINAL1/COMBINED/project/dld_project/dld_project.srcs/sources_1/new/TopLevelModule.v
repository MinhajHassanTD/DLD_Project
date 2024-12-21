`timescale 1ns / 1ps

module TopLevelModule(
    input clk,
    input PS2Clk,
    input PS2Data,
    input jump,
    output h_sync,
    output v_sync,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue
);
    // DEFINING STATES
    parameter START_SCREEN_STATE = 2'b00;
    parameter GAME_STATE = 2'b01;
    parameter END_SCREEN_STATE = 2'b10;
    
    reg [1:0] state, next_state;
    
    reg start_button, reset;
    wire oflag;
    wire [15:0] keycode; 

    // DEFINING INTERNAL ENABLE SIGNALS
    reg enable_startscreen, enable_game, enable_endscreen;
    wire stopped;
    // DEFINING INTERNAL WIRES FOR RGB, HSYNC, AND VSYNC SIGNALS
    wire [3:0] start_red, start_green, start_blue;
    wire [3:0] game_red, game_green, game_blue;
    wire [3:0] end_red, end_green, end_blue;
    wire start_hsync, start_vsync;
    wire game_hsync, game_vsync;
    wire end_hsync, end_vsync;
    
    PS2 P1(
        .clk(clk),
        .kclk(PS2Clk),
        .kdata(PS2Data),
        .keycode(keycode),
        .oflag(oflag)
        );
        
   always @(posedge clk) begin
        if (oflag) begin
                case (keycode[7:0])
                8'h2D: begin
                reset <= 1;
                end
                8'h5A: begin
                start_button <= 1;
                end
                default: begin
                    start_button <= 0;
                    reset <= 0;
                end
            endcase
        end else begin
            start_button <= 0;
            reset <= 0;
        end
    end

    // MODULE INSTANCES
    top_startscreen start_screen (
        .clk(clk),
        .enable(enable_startscreen),
        .h_sync(start_hsync),
        .v_sync(start_vsync),
        .red(start_red),
        .green(start_green),
        .blue(start_blue)
    );

    top_game game (
        .clk(clk),
        .enable(enable_game),
        .reset(reset),
        .jump(jump),
        .win(win),
        .stopped(stopped),
        .h_sync(game_hsync),
        .v_sync(game_vsync),
        .red(game_red),
        .green(game_green),
        .blue(game_blue)
    );

    top_endscreen end_screen (
        .clk(clk),
        .enable(enable_endscreen),
        .win(win),
        .h_sync(end_hsync),
        .v_sync(end_vsync),
        .red(end_red),
        .green(end_green),
        .blue(end_blue)
    );

    // STATE MACHINE
    always @(posedge clk or posedge reset) begin
        if (reset) 
            state <= START_SCREEN_STATE;
        else 
            state <= next_state;
    end

    always @(*) begin
        // Default assignments
        next_state = state;
        enable_startscreen = 1'b0;
        enable_game = 1'b0;
        enable_endscreen = 1'b0;

        case (state)
            START_SCREEN_STATE: begin
                enable_startscreen = 1'b1; // Enable the start screen
                if (start_button) 
                    next_state = GAME_STATE; // Transition to game state on button press
            end
            GAME_STATE: begin
                enable_game = 1'b1; // Enable the game module
                if (win)
                    next_state = END_SCREEN_STATE; // Transition to end screen on game over
                if (stopped)
                    next_state = END_SCREEN_STATE; // Transition to end screen on game over
            end
            END_SCREEN_STATE: begin
                enable_endscreen = 1'b1; // Enable the end screen
                if (reset) 
                    next_state = START_SCREEN_STATE; // Go back to start screen on reset
            end
            default: begin
                next_state = START_SCREEN_STATE; // Default to start screen
            end
        endcase
    end

    // ASSIGNING OUTPUT VALUES
    assign red = (state == START_SCREEN_STATE) ? start_red : (state == GAME_STATE) ? game_red : end_red;
    assign green = (state == START_SCREEN_STATE) ? start_green : (state == GAME_STATE) ? game_green : end_green;
    assign blue = (state == START_SCREEN_STATE) ? start_blue : (state == GAME_STATE) ? game_blue : end_blue;
    assign h_sync = (state == START_SCREEN_STATE) ? start_hsync : (state == GAME_STATE) ? game_hsync : end_hsync;
    assign v_sync = (state == START_SCREEN_STATE) ? start_vsync : (state == GAME_STATE) ? game_vsync : end_vsync;
    
endmodule
