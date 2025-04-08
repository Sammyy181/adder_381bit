module mux_carrysel(carry,sel,carry_sel);

    //Chooses carry bit if sel is set to 1
    input carry, sel;
    output carry_sel;

    and mux (carry_sel,carry,sel);
endmodule