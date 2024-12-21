module v_counter(
    input enable_v,
    input clk,
    output [9:0] v_count
    );
    reg [9:0] v_count;
    initial v_count <= 0;
    always @(posedge clk)
    begin
    if (v_count <= 523 & enable_v == 1)
    begin
    v_count <= v_count + 1;
    end
    else if (enable_v == 0 & v_count <= 523)
    begin
    v_count <= v_count;
    end
    else
    begin
    v_count <= 0;
    end
    end
endmodule