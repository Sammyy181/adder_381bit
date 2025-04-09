`timescale 1ns / 1ps

module adder_sim();

    wire [380:0] data_A, data_B;
    reg clk, reset, start_add;
    wire [381:0] S;
    wire add_done;

    adder add(.A(data_A),.B(data_B),.clk(clk),.reset(reset),.start(start_add),.S(S[380:0]),.carry(S[381]),.done(add_done));
    
    assign data_A = 0;
    assign data_B = {5'b00000,376'h2121212121212121212121212121212121212121212121212121212121212121212121212121212121212121212121};
    
    initial clk <= 0;
    
    always @(*) begin
        #10 clk <= ~clk;
    end
    
    initial begin
        reset = 1;
        start_add = 0;
        #20 reset = 0;
        
        start_add = 1;
        #20 start_add = 0;
        
        $monitor ("Time = %0t | S = %h | done = %b", $time, S, add_done);
        
        #50000 $finish;
    end

endmodule
