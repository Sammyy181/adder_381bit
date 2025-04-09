module BaudRateGenerator  #(
    parameter CLOCK_RATE = 100000000, // board internal clock (def == 100MHz)
    parameter BAUD_RATE = 9600
)(
    input wire clk, // board clock
    output reg rxClk // baud rate for rx
);
parameter MAX_RATE_RX = CLOCK_RATE / (2 * BAUD_RATE * 16); // 16x oversample
parameter RX_CNT_WIDTH = $clog2(MAX_RATE_RX);

reg [RX_CNT_WIDTH - 1:0] rxCounter = 0;

initial begin
    rxClk = 1'b0;
end

always @(posedge clk) begin
    // rx clock
    if (rxCounter == MAX_RATE_RX[RX_CNT_WIDTH-1:0]) begin
        rxCounter <= 0;
        rxClk <= ~rxClk;
    end else begin
        rxCounter <= rxCounter + 1'b1;
    end
end

endmodule