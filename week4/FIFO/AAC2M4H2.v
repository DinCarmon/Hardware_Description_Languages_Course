module FIFO8x9
#(
  parameter Data_width = 9,  //# of bits in word
            Addr_width = 3  // # of address bits
)
(
  input clk, rst,                       // Clock, Reset
  input RdPtrClr, WrPtrClr,             // To reset the read / write pointer
  input RdInc, WrInc,                   // Read / Write pointer increment signal
  input [Data_width-1:0] DataIn,        // Data input bus
  output reg [Data_width-1:0] DataOut,  // Date output bus
  input rden, wren                      // Read / Write output enable
	);
  
  //signal declarations
	reg [Data_width-1:0] fifo_array[2**Addr_width-1:0];
	reg [Addr_width-1:0] wrptr, rdptr;
  integer i;

  always @(posedge clk or negedge rst) begin : proc_FIFO
    if(~rst) begin
      for (i=0; i< 2**Addr_width; i=i+1)
        fifo_array[i] <= '0;
      wrptr <= '0;
      rdptr <= '0;
    end else begin
      if(rden) begin
        DataOut <= fifo_array[rdptr];
      end
      if(wren) begin
        fifo_array[wrptr] <= DataIn;
      end
    end
  end

  always @(posedge RdInc) begin : proc_RdInc
    rdptr <= rdptr + 1;
  end

  always @(posedge WrInc) begin : proc_WrInc
    wrptr <= wrptr + 1;
  end
endmodule // FIFO8x9