module cla_gen_4bit(P,G,Cin,Cout);
    input [3:0] P,G;
    input Cin;

    output wire [3:0] Cout;

    //assign Cout[0] = Cin;
    assign Cout[0] = G[0] | (P[0] & Cin);
    assign Cout[1] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign Cout[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    assign Cout[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & Cin);
endmodule