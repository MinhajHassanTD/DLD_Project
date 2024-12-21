module game_score(
    input wire clk,          // Main clock input (e.g., 100 MHz)
    output reg [15:0] score  // 16-bit register to store the score
);

    // Clock Divider to generate 10 Hz from 100 MHz
    reg [22:0] count;  // 23-bit register to hold up to 5,000,000 (2^23 = 8,388,608)
    parameter div_value = 5000000 - 1;  // 4,999,999 for zero-based counting
    reg clk_d;

    initial begin
        clk_d = 0;
        count = 0;
    end

    always @(posedge clk) begin
        if (count == div_value) begin
            count <= 0;
            clk_d <= ~clk_d;
        end else begin
            count <= count + 1;
        end
    end

    // Score Increment Logic
    always @(posedge clk_d) begin
        // Increment the score
        if (score[3:0] < 4'd9) begin
            score[3:0] <= score[3:0] + 1; // Increment units
        end else begin
            score[3:0] <= 4'd0;
            if (score[7:4] < 4'd9) begin
                score[7:4] <= score[7:4] + 1; // Increment tens
            end else begin
                score[7:4] <= 4'd0;
                if (score[11:8] < 4'd9) begin
                    score[11:8] <= score[11:8] + 1; // Increment hundreds
                end else begin
                    score[11:8] <= 4'd0;
                    if (score[15:12] < 4'd9) begin
                        score[15:12] <= score[15:12] + 1; // Increment thousands
                    end else begin
                        score[15:12] <= 4'd0; // Reset to zero after 9999
                    end
                end
            end
        end
    end
endmodule
