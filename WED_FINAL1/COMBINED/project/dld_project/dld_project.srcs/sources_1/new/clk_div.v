module clk_div(
    input clk,
    output clk_d
    );
    reg clk_d;
    reg count;
    parameter div_value = 1;
    initial
    begin
    clk_d = 0;
    count = 0;
    end
    always @(posedge clk)
    begin
    if (count == div_value)
    begin
    count <= 0;
    clk_d = ~clk_d;
    end
    else
    count <= count + 1;
    end
endmodule