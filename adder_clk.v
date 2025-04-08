module adder_clk (
    input wire clk,
    input wire reset,
    output reg add_clk
);

    reg [3:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            counter <= 0;
            add_clk <= 0;
        end
        else begin
            counter <= counter + 1;
            if (counter == 10) begin
                counter <= 0;
                add_clk <= ~add_clk;
            end
        end
    end

endmodule

