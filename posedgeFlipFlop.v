module posedge_flip_flop(D,reset,clk,Q);
    input wire D,reset,clk;
    output reg Q;

    always @(posedge clk or posedge reset)
    begin
        if(reset) Q <= 0;
        else Q <= D;
    end
endmodule