// APB Master Protocol 

module apb_master 
#( parameter IDLE = 2'b00,
   parameter SETUP = 2'b01,
   parameter ACCESS = 2'b10
)(
input PCLK,
input PRESETn,
output [31:0]PADDR,
input [31:0] wdata,
input [31:0]addr,
input write,
input transfer,
output PSELx,
output PENABLE,
output [31:0] PWDATA,
output PWRITE,
input PREADY);

reg [1:0] state, next_state;

always @(posedge PCLK or negedge PRESETn) begin 
  if (!PRESETn)
    state <= IDLE;
  else
    state <= next_state;
end

always @(*) begin
 case (state)
    IDLE : begin
	       if (transfer)
		    next_state = SETUP;
		   else
		    next_state = IDLE;
		   end
		   
    SETUP : begin
			 next_state = ACCESS;
			end
			
	ACCESS : begin
	         if (PREADY) begin
			  if (transfer)
		       next_state = SETUP;
			  else
			   next_state = IDLE;
			 end
			 else
			  next_state = ACCESS;
			end
		
	default : next_state = IDLE;
  endcase
end

assign PSELx = (state != IDLE) ? 1'b1 : 1'b0;
assign PENABLE = (state == ACCESS) ? 1'b1 : 1'b0;
assign PADDR = (state != IDLE) ? addr : 32'b0;
assign PWDATA = (state != IDLE) ? wdata : 32'b0;
assign PWRITE = (state != IDLE) ? write : 32'b0;

endmodule