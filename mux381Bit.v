module mux_381bit(O,sel,I0,I1);
    input [380:0] I0, I1;
    input sel;
    output [380:0] O;
    wire nsel;
    wire [380:0]M0, M1;
    not (nsel,sel);

    genvar p;

    generate
        for(p=0;p<381;p=p+1)
        begin
            and O0(M0[p],nsel,I0[p]);
            and O1(M1[p],sel,I1[p]);

            or F0(O[p], M0[p], M1[p]);
        end
    endgenerate
    
endmodule