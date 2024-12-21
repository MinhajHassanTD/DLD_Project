module debounce(
    input clk,              // 100 MHz clock
    input btn,              // raw button input
    output reg btn_clean    // debounced output
    );
    
    reg [19:0] counter = 0;  // counter for debouncing
    reg btn_sync1 = 0, btn_sync2 = 0;

    always @(posedge clk) begin
        btn_sync1 <= btn;           // Synchronize to clock domain
        btn_sync2 <= btn_sync1;     // Double synchronization
        if (btn_sync2 == btn_clean) begin
            counter <= 0;           // Reset counter if stable
        end else begin
            counter <= counter + 1; // Increment counter if unstable
            if (counter == 1_000_000) begin // Debounce threshold (~10ms)
                btn_clean <= btn_sync2; // Update debounced state
                counter <= 0;
            end
        end
    end
endmodule