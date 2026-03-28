// APB Slave 

`timescale 10ns/1ps

module apb_slave_tb;
parameter IDLE = 2'b00;
parameter SETUP = 2'b01;
parameter ACCESS = 2'b10;

reg PCLK;
reg PRESETn;
wire [31:0]PADDR;
reg [31:0] wdata;
reg [31:0]addr;
reg write;
reg transfer;
wire PSELx;
wire PENABLE;
wire [31:0] PWDATA;
wire PWRITE;
reg PREADY;

apb_master dut (.PCLK(PCLK),
.PRESETn(PRESETn),
.PADDR(PADDR),
.wdata(wdata),
.addr(addr),
.write(write),
.transfer(transfer),
.PSELx(PSELx),
.PENABLE(PENABLE),
.PWDATA(PWDATA),
.PWRITE(PWRITE),
.PREADY(PREADY)
);

// Initialization
initial begin
  {PCLK, PRESETn, wdata, addr, write, transfer, PREADY} = 0; 
end	
	
// Clock
always #5 PCLK = ~PCLK;

// Test
initial begin
PRESETn = 0;
write = 1;
PREADY = 0;
#20;
PRESETn = 1;
@(posedge PCLK);
transfer = 1;
addr = 32'hfca_cafe;
wdata = 32'hface_cafe;
write = 1;

@(posedge PCLK)
transfer = 0;

repeat(3)
@(posedge PCLK);
PREADY = 1;
@(posedge PCLK);
PREADY = 0;
#50;
$finish();
end
endmodule
