module posedge_register(D,enable,clk,Q,reset);
    input wire [380:0] D; 
    input wire enable, clk;
    input wire reset;
    
    output reg [380:0] Q;

    always @(posedge clk)
    begin
        if (reset) Q <= 0;
        else if(enable) Q <= D;
    end
endmodule