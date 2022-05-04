module FSM
#(
  parameter State_width = 2,
  A = 2'b00,
  B = 2'b01,
  C = 2'b10
)
(
  input In1,
  input RST,
  input CLK, 
  output reg Out1
);
  
  reg [State_width-1:0] CurrentState, NextState;
  always @(In1) begin : proc_Combinational
    if(~RST) begin
      NextState <= A;
    end else begin
      case (CurrentState)
        A:
          if(In1) begin
            NextState <= B;
          end else begin
            NextState <= A;
          end
        B:
          if(In1) begin
            NextState <= B;
          end else begin
            NextState <= C;
          end
        C:
          if(In1) begin
            NextState <= A;
          end else begin
            NextState <= C;
          end
        default:
          NextState <= A;
      endcase
    end
  end //proc_Combinational

  always @(posedge CLK or negedge RST) begin : proc_Sequential
    if(~RST) begin
      CurrentState <= A;
    end else begin
      CurrentState <= NextState;
    end
  end //proc_Sequential

  // Output Logic
  assign Out1 = CurrentState[1];

endmodule // FSM