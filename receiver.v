module Uart8Receiver (
    input  wire       clk,  // baud rate
    input  wire       en,
    input  wire       in,   // rx
    output reg  [7:0] out,  // received data
    output reg        done, // end on transaction
    output reg [5:0] byte_counter
);
    // states of state machine
    parameter RESET = 3'b000;
    parameter IDLE = 3'b001;
    parameter DATA_BITS = 3'b010;
    parameter STOP_BIT = 3'b011;
    parameter DONE = 3'b100;

    reg [2:0] state;
    reg [2:0] bitIdx = 3'b0; // for 8-bit data
    reg [1:0] inputSw = 2'b0; // shift reg for input signal state
    reg [3:0] clockCount = 4'b0; // count clocks for 16x oversample
    reg [7:0] receivedData = 8'b0; // temporary storage for input data

    initial begin
        out <= 8'b0;
        done <= 1'b0;
        byte_counter <= 0;
    end

    always @(posedge clk) begin
        inputSw = { inputSw[0], in };

        if (!en) begin
            state = RESET;
        end

        case (state)
            RESET: begin
                out <= 8'b0;
                done <= 1'b0;
                bitIdx <= 3'b0;
                clockCount <= 4'b0;
                receivedData <= 8'b0;
                byte_counter <= 0;
                if (en) begin
                    state <= IDLE;
                end
            end

            IDLE: begin
                if (&clockCount && !done) begin
                    state <= DATA_BITS;
                    out <= 8'b0;
                    bitIdx <= 3'b0;
                    clockCount <= 4'b0;
                    receivedData <= 8'b0;
                end else if (!(&inputSw) || |clockCount) begin
                    // Check bit to make sure it's still low
                    if (&inputSw) begin
                        state <= RESET;
                    end
                    clockCount <= clockCount + 4'b1;
                end
            end

            // Wait 8 full cycles to receive serial data
            DATA_BITS: begin
                if (&clockCount) begin // save one bit of received data
                    clockCount <= 4'b0;
                    // TODO: check the most popular value
                    receivedData[bitIdx] <= inputSw[0];
                    if (&bitIdx) begin
                        bitIdx <= 3'b0;
                        state <= STOP_BIT;
                    end else begin
                        bitIdx <= bitIdx + 3'b1;
                    end
                end else begin
                    clockCount <= clockCount + 4'b1;
                end
            end

            /*
            * Baud clock may not be running at exactly the same rate as the
            * transmitter. Next start bit is allowed on at least half of stop bit.
            */
            STOP_BIT: begin
                if (&clockCount || (clockCount >= 4'h8 && !(|inputSw))) begin
                    state <= IDLE;
                    out <= receivedData;
                    clockCount <= 4'b0;
                    byte_counter <= byte_counter + 1;
                        if(byte_counter == 47) begin
                            done <= 1'b1;
                            state <= DONE;
                        end
                end else begin
                    clockCount <= clockCount + 1;
                    // Check bit to make sure it's still high
                    if (!(|inputSw)) begin
                        state <= RESET;
                    end
                end
            end
            
            DONE : begin
                bitIdx <= 3'b0;
                clockCount <= 4'b0;
                receivedData <= 8'b0;
                done <= 1;
            end
   
            default: state <= IDLE;
        endcase
    end

endmodule