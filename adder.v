module adder(
    input wire [380:0] A,
    input wire [380:0] B,
    input wire clk,
    input wire reset,
    input wire start,
    output wire [380:0] S,
    output wire carry,
    output wire done,
    
    //Debug signals
    output wire [380:0] debug_QA,
    output wire [380:0] debug_QB,
    output wire [380:0] debug_shift_A,
    output wire [380:0] debug_shift_B
);
    // Storage and shifting of registers for A and B 
    wire [380:0] Ain, Bin, shift_A, shift_B;
    wire add_clk;
    wire [380:0] QA, QB;
    //reg [380:0] QA, QB;
    assign debug_shift_A = shift_A;
    assign debug_shift_B = shift_B;
    assign debug_QA = QA;
    assign debug_QB = QB;
    
    //Slow Clock
    adder_clk C1(.clk(clk),.reset(reset),.add_clk(add_clk));
    
    //FSM
    wire enable_AB, mux_AB, mux_carry, enable_S, final_sel; 

    FSM F1(.enable_AB(enable_AB),.mux_AB(mux_AB),.mux_carry(mux_carry),.enable_S(enable_S),.final_sel(final_sel),.done(done),.start(start),.clk(clk),.adder_clk(add_clk),.reset(reset));

    assign shift_A = {32'h00000000, QA[380:32]};
    assign shift_B = {32'h00000000, QB[380:32]};

    mux_381bit muxA (.O(Ain),.sel(mux_AB),.I0(A),.I1(shift_A));
    mux_381bit muxB (.O(Bin),.sel(mux_AB),.I0(B),.I1(shift_B));

    //FSM for enable_AB

    posedge_register RegA(.D(Ain),.enable(enable_AB),.clk(add_clk),.Q(QA),.reset(reset));
    posedge_register RegB(.D(Bin),.enable(enable_AB),.clk(add_clk),.Q(QB),.reset(reset)); 
    
    /*always @(posedge add_clk) begin
        if (reset) begin
            QA <= 0;
            QB <= 0;
        end
        else if(enable_AB && !mux_AB) begin
            QA <= Ain;
            QB <= Bin;
        end
        else if(enable_AB && mux_AB) begin
            QA <= shift_A;
            QB <= shift_B;
        end
    end */

    //FSM for carrying in (mux_carry)
    wire Co, Ci, C32;
    wire [31:0] sum_32;

    posedge_flip_flop Cstore (.D(Ci),.clk(add_clk),.Q(C32),.reset(reset));

    mux_carrysel MuxC (.carry(Co),.sel(mux_carry),.carry_sel(Ci));

    adder_32bit A1 (.aug(QA[31:0]),.add(QB[31:0]),.carry_in(C32),.S(sum_32),.carry_out(Co));

    //Final Sum storage mechanism
    wire [380:0] sum, sum1, sum0;
    wire Cout; 
     
    //FSM for enable_S
    posedge_register SumReg(.D(sum),.enable(enable_S),.clk(!add_clk),.Q(S),.reset(reset));

    // Deciding sum
    assign sum0 = {sum_32,S[380:32]};
    assign sum1 = {sum_32[28:0],S[380:29]};
    mux_381bit MuxS(.O(sum),.sel(final_sel),.I0(sum0),.I1(sum1));

    posedge_flip_flop CReg(.D(sum_32[29]),.clk(!add_clk),.Q(carry),.reset(reset));

endmodule