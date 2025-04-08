module top_adder_module(
    input wire RxD,
    input wire clk,
    input wire reset,
    //input wire enable_A,
    //input wire enable_B,
    input wire start_add,
    input wire start_Tx,
    output wire TxD,
    //output wire A_done,
    //output wire B_done,
    output wire add_done,
    output wire Tx_done,
    output wire reset_on,
    output wire [7:0] sample
    //output wire [7:0] sample_B
    );
    
    wire [380:0] data_A, data_B;
    wire [380:0] debug_QA, debug_QB, debug_shift_A, debug_shift_B;
    
    assign reset_on = reset;
    //assign sample_B = data_B[7:0];
    
    //rx_module Rx_A(.clk(clk),.reset(reset),.enable(enable_A),.RxD(RxD),.RxData(data_A),.done(A_done));
    //rx_module Rx_B(.clk(clk),.reset(reset),.enable(enable_B),.RxD(RxD),.RxData(data_B),.done(B_done));
    //assign data_A = {317'b0,64'hffffffffffffffff};
    //assign data_B = {317'b0,64'hffffffffffffffff};
    assign data_A = 381'b0;
    assign data_B = {5'b00000,376'h2121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121};
    
    wire [381:0] S;
    reg [5:0] counter;
      
    adder add(.A(data_A),.B(data_B),.clk(clk),.reset(reset),.start(start_add),.S(S[380:0]),.carry(S[381]),.done(add_done),.debug_QA(debug_QA),.debug_QB(debug_QB),.debug_shift_A(debug_shift_A),.debug_shift_B(debug_shift_B));
    
    assign sample = S[7:0];
    
    Tx_381bit T1(.data(S),.start(start_Tx),.clk(clk),.reset(reset),.TxD(TxD),.done(Tx_done));
    
endmodule 