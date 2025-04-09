`default_nettype wire

module rx_module(
    input clk,
    input reset,
    input enable,
    input RxD,
    output [380:0] RxData,
    //output [7:0] data,
    //output [5:0] byte_counter,
    output done
);

    wire rx_clk;
    wire [5:0] byte_counter;
    //wire [7:0] data;
    reg [5:0] prev_byte_counter;
    reg [383:0] bits;
    
    BaudRateGenerator BR(.clk(clk),.rxClk(rx_clk));
    Uart8Receiver UUT(.clk(rx_clk),.en(enable),.in(RxD),.out(data),.byte_counter(byte_counter),.done(done));
    
    always @(posedge clk) begin
        if (reset) begin
            bits <= 384'b0;
            prev_byte_counter <= 6'b0;
        end else begin
            prev_byte_counter <= byte_counter;
            if(prev_byte_counter != byte_counter && enable) begin
                bits[(47 - prev_byte_counter) * 8 +: 8] <= data;
            end
        end
    end
    
    assign RxData = bits[380:0];
    
endmodule