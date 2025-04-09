module FSM(
    output reg enable_AB,
    output reg mux_AB,
    output reg mux_carry,
    output reg enable_S,
    output reg final_sel,
    output reg done,
    output reg enableCarry,
    output reg enableC0,
    input wire start,
    input wire clk,
    input wire reset 
    );
    
    reg [3:0] count;
    reg [2:0] state;
    reg start_count;
    reg [4:0] clk_counter;
    
    parameter IDLE = 3'b000;
    parameter LOAD = 3'b001;
    parameter ADD1 = 3'b010;
    parameter ADD2 = 3'b011;
    
    always @(posedge clk) begin
        if(reset) clk_counter <= 0;
        else if(start_count) begin
            if(clk_counter == 19) clk_counter <= 0;
            else clk_counter <= clk_counter + 1;
        end
    end
   
    always @(posedge clk) begin
        if (reset) count <= 0;
        else if(start_count && clk_counter == 19) count <= count + 1;
    end
    
    always @(posedge clk) begin
        if(reset) begin
            enable_AB <= 0;
            mux_AB <= 0;
            enable_S <= 0;
            mux_carry <= 0;
            enableC0 <= 0;
            enableCarry <= 0;
            final_sel <= 0;
            done <= 0;
            start_count <= 0;
            state <= IDLE;
        end 
        else begin
            enable_AB <= 0;
            enable_S <= 0;
            enableC0 <= 0;
            enableCarry <= 0;
            case(state)
                IDLE: begin
                    mux_AB <= 0;
                    mux_carry <= 0;
                    final_sel <= 0;
                    start_count <= 0;
                    
                    if(start && !done) state <= LOAD;
                end
                
                LOAD: begin
                    start_count <= 1;
                    mux_AB <= 0;
                    if (clk_counter == 9) enable_AB <= 1;
                    if (clk_counter == 19) enable_S <= 1;
                    
                    if (count == 1) state <= ADD1;
                    
                end
                
                ADD1: begin
                    mux_AB <= 1;
                    mux_carry <= 1;
                    if(clk_counter == 9) enable_AB <= 1;
                    if(clk_counter == 19) enable_S <= 1;
                    
                    if(count == 11) state <= ADD2;
                    
                end
                
                ADD2: begin
                    final_sel <= 1;
                    
                    if(clk_counter == 9) enable_AB <= 1;
                    if(clk_counter == 19) enable_S <= 1;
                    
                    if(count > 11) begin
                        done <= 1;
                        state <= IDLE;
                    end    
                end    
                
                default : state <= IDLE;
            endcase    
        end    
    end
endmodule
// This module implements a finite state machine (FSM) for an adder circuit.