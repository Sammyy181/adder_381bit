module cla_gen_32bit(P,G,Cin,Cout);

    input [31:0] P,G;
    input Cin;

    output wire [32:0] Cout;

    assign Cout[0] = Cin;
    cla_gen_4bit cla0(.P(P[3:0]),.G(G[3:0]),.Cin(Cin),.Cout(Cout[4:1]));

    genvar i;

    generate
        for(i=4;i<32;i=i+4)

        begin
            cla_gen_4bit cla1(.P(P[(i+3):i]),.G(G[(i+3):i]),.Cin(Cout[i]),.Cout(Cout[(i+4):(i+1)]));
        end
    endgenerate
endmodule