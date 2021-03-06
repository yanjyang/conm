`include "../rtl/core/defines.v"

module csregfile_tb(); 

	//Clock signal
	localparam clk_period = 10; 
	reg clk; 
	initial clk = 1'b0; 
	always #(clk_period/2) clk = ~clk; 
	
	reg rst; 
	reg [`CSR_ADDR_WIDTH] csr_waddr; 
	reg [`DATA_WIDTH] csr_wdata; 
	reg [`CSR_ADDR_WIDTH] csr_raddr; 
	reg [`REG_ADDR_WIDTH] rd_waddr; 
	reg [`DATA_WIDTH] extl_rd_wdata; 
	reg [`DATA_WIDTH] sb_rd_wdata; 
	reg [`REG_ADDR_WIDTH] rs1_raddr; 
	reg [`REG_ADDR_WIDTH] rs2_raddr; 
	
	wire [`DATA_WIDTH] csr_rdata_o; 
	wire [`DATA_WIDTH] rs1_rdata_o; 
	wire [`DATA_WIDTH] rs2_rdata_o; 
	
csregfile u_csregfile(
	.clk(clk), 
	.rst(rst), 
	.csr_waddr(csr_waddr), 
	.csr_wdata(csr_wdata), 
	.csr_raddr(csr_raddr), 
	.rd_waddr(rd_waddr), 
	.extl_rd_wdata(extl_rd_wdata), 
	.sb_rd_wdata(sb_rd_wdata), 
	.rs1_raddr(rs1_raddr), 
	.rs2_raddr(rs2_raddr), 
	
	.csr_rdata_o(csr_rdata_o), 
	.rs1_rdata_o(rs1_rdata_o), 
	.rs2_rdata_o(rs2_rdata_o)
	); 
	
	initial begin
		rst = `RST; 
		#10; 
		
		rst = `UNRST; 
		
		//10ns, rd write
		rd_waddr = `ZERO_REG; 
		extl_rd_wdata = 32'hffff; 
		sb_rd_wdata = 32'hffff0000; 
		#10; 
		//20ns
		rd_waddr = 32'b1; 
		extl_rd_wdata = 32'b1000; 
		sb_rd_wdata = 32'b0; 
		#10; 
		//30ns
		rd_waddr = 32'b10; 
		extl_rd_wdata = 32'b0; 
		sb_rd_wdata = 32'b10; 
		#10; 
		
		rd_waddr = `ZERO_REG; 
		
		//40ns, csr write
		csr_waddr = `mdisable; 
		csr_wdata = 32'b111100; 
		#10; 
		//50ns
		csr_waddr = `mepc; 
		csr_wdata = 32'b11000011; 
		#10; 
		
		csr_waddr = `mdisable; 
		
		//60ns, rs read
		rs1_raddr = `ZERO_REG; 
		rs2_raddr = 32'b1; 
		#10; 
		//70ns
		rs1_raddr = 32'b10; 
		rs2_raddr = 32'b11; 
		#10; 
		
		//80ns, if rs read and rd write coincide
		rs1_raddr = 32'b100; 
		rd_waddr = 32'b100; 
		extl_rd_wdata = 32'b100; 
		sb_rd_wdata = 32'b0; 
		#10; 
		
		//90ns, csr read
		csr_raddr = `mepc; 
		#10; 
		//100ns
		csr_raddr = `mcycle; 
		#10; 
		//110ns
		csr_raddr = `mcycleh; 
		#10; 
		//120ns
		csr_raddr = `mvendorid; 
		#10; 
		
		//130 ns, if csr read and write coincide
		csr_raddr = `mstatus; 
		csr_waddr = `mstatus; 
		csr_wdata = 32'b10101010; 
		#10; 
	end
	
endmodule