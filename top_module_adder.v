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
    output wire reset_on
    );
    
    wire [380:0] data_A, data_B;
    
    assign reset_on = reset;
    
    //rx_module Rx_A(.clk(clk),.reset(reset),.enable(enable_A),.RxD(RxD),.RxData(data_A),.done(A_done));
    //rx_module Rx_B(.clk(clk),.reset(reset),.enable(enable_B),.RxD(RxD),.RxData(data_B),.done(B_done));
    
    //Edit this to the required input bits
    assign data_A = 381'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    assign data_B = 381'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
    
    wire [381:0] S;
    reg [5:0] counter;
      
    adder add(.A(data_A),.B(data_B),.clk(clk),.reset(reset),.start(start_add),.S(S[380:0]),.carry(S[381]),.done(add_done));
    
    Tx_381bit T1(.data(S),.start(start_Tx),.clk(clk),.reset(reset),.TxD(TxD),.done(Tx_done));
    
endmodule 