module h_counter(
    input clk,
    output [9:0] count,
    output trig_v
    );
    reg [9:0] count;
    reg trig_v;
    initial count <= 0;
    initial trig_v <= 0;
    always @(posedge clk)
    begin
    if (count <= 798)
    begin
    count <= count + 1;
    trig_v <= 0;
    end
    else
    begin
    count <= 0;
    trig_v <= 1;
    end
    end
endmodule