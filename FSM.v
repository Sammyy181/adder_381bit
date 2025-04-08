module FSM(
    output reg enable_AB,
    output reg mux_AB,
    output reg mux_carry,
    output reg enable_S,
    output reg final_sel,
    output reg done,
    input wire start,
    input wire clk,
    input wire adder_clk,
    input wire reset 
    
);
    
    parameter IDLE = 3'b000;
    parameter LOAD = 3'b001;
    parameter ADD_1 = 3'b010;
    parameter ADD_2 = 3'b011;

    reg [2:0] state;
    reg [3:0] count;
    reg [3:0] counter;
    reg start_count;
    //reg adder_clk;

    always @(negedge adder_clk) begin
        if (reset) count <= 0;
        else if(start_count) count <= count + 1;
    end

    always @(posedge clk) begin
        if(reset) begin
            enable_AB <= 0;
            mux_AB <= 0;
            enable_S <= 0;
            mux_carry <= 0;
            final_sel <= 0;
            done <= 0;
            count <= 0;
            start_count <= 0;
            state <= IDLE;
        end
        else begin 
            case (state) 
                IDLE : begin

                    enable_AB <= 0;
                    mux_AB <= 0;
                    enable_S <= 0;
                    mux_carry <= 0;
                    final_sel <= 0;
                    start_count <= 0;

                    if(start && !done) state <= LOAD;
                end

                LOAD : begin
                    enable_AB <= 1;
                    mux_AB <= 0;
                    enable_S <= 1;
                    start_count <= 1;

                    if (count == 1) state <= ADD_1;
                end

                ADD_1 : begin
                    mux_AB <= 1;
                    mux_carry <= 1;
                    done <= 1;

                    if (count == 11) begin
                        state <= ADD_2;
                    end
                end

                ADD_2 : begin
                    final_sel <= 1;
                    if (count > 11) begin
                        state <= IDLE;
                    end
                end

                default : state <= 0;

            endcase
        end
    end

endmodule