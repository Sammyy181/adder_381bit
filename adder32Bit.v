module adder_32bit (aug,add,carry_in,S,carry_out);

    input wire[31:0] aug,add;
    input carry_in;

    output [31:0] S;
    output carry_out;

    wire [31:0] Pin,Gin;
    wire [32:0] Cout;

    genvar p;

    generate
        for(p=0;p<32;p=p+1)
        begin
            xor Pgate (Pin[p],aug[p],add[p]);
            and Ggate (Gin[p],aug[p],add[p]);
        end
    endgenerate

    cla_gen_32bit carries (.P(Pin),.G(Gin),.Cin(carry_in),.Cout(Cout));

    genvar q;

    generate
        for(q=0;q<32;q=q+1)
        begin
            xor  Sgate (S[q],Pin[q],Cout[q]);
        end
    endgenerate

    assign carry_out = Cout[32];

endmodule