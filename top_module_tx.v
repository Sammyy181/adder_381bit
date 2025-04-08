`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.03.2025 15:27:19
// Design Name: 
// Module Name: top_module_tx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module Tx_381bit(
    input wire [381:0] data,
    input wire clk,
    input wire start,
    input wire reset,
    output wire TxD,
    output reg done
    );
    
    parameter IDLE = 3'b000;
    parameter LOAD = 3'b001;
    parameter TRANSMIT = 3'b010;
    parameter NEXT_BYTE = 3'b011;
    parameter DONE = 3'b100;
    
    //wire [381:0] data;
    wire [383:0] transmit_out;
    
    //assign data = {6'b100001,376'h4142434445464748495041424344454647484950414243444546474849504142434445464748495041424344454647};
    
    assign transmit_out = {2'b00,data};
    reg transmit_start;
    wire busy;
    reg prev_busy;
    reg [7:0] byte;
    reg [2:0] state;
    reg [5:0] byte_counter;
    
    txuartlite TXD(.i_clk(clk),.i_reset(reset),.i_wr(transmit_start),.i_data(byte),.o_uart_tx(TxD),.o_busy(busy));
    
    always @(posedge clk) begin
        
        if (reset) begin
            state <= 0;
            byte <= 0;
            prev_busy <= 0;
            transmit_start <= 0;
            done <= 0;
            byte_counter <= 0;
        end
        else begin 
        transmit_start <= 0;
        prev_busy <= busy;
        case (state)
            IDLE : begin
                byte <= 0;
                prev_busy <= 0;
                
                if (start && !done) begin
                    state <= LOAD;
                    byte_counter <= 0;
                end
            end
            
            LOAD : begin
                byte <= transmit_out[(47 - byte_counter)*8 +: 8];
                state <= TRANSMIT;
            end
            
            TRANSMIT : begin
                transmit_start <= 1;
                state <= NEXT_BYTE;
            end
            
            NEXT_BYTE : begin             
                if (prev_busy && !busy) begin
                    if(byte_counter < 48) begin
                        byte_counter <= byte_counter + 1;
                        state <= LOAD;
                    end
                    else state <= DONE;
                end
            end
            
            DONE : begin
                transmit_start <= 0;
                done <= 1;
                state <= IDLE;
            end   
            
            default : transmit_start <= 0; 
        endcase
        end
    end
endmodule