module LS161a
#(
    parameter Adder_Size = 4
)
(
    input [Adder_Size - 1:0] D,         // Parallel Input
    input CLK,                          // Clock
    input CLR_n,                        // Active Low Asynchronous Reset
    input LOAD_n,                       // Enable Parallel Input
    input ENP,                          // Count Enable Parallel
    input ENT,                          // Count Enable Trickle
    output reg [Adder_Size - 1:0] Q,        // Parallel Output 	
    output RCO                          // Ripple Carry Output (Terminal Count)
); 

always @(posedge CLK or negedge CLR_n) begin : proc_LS161a
    if(CLR_n == '0) begin
        Q <= '0; 
    end else begin
        if(LOAD_n == '0) begin
            Q <= D;
        end else begin
            if(ENP & ENT == '1) begin
                Q <= Q + 1;
            end // if(ENP & ENT == '1)
        end // if(LOAD_n == '0)
    end // if(CLR_n == 0)
end //proc_LS161a

assign RCO = (&(Q)) & (ENT); 

endmodule // LS161a