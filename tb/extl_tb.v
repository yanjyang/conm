`include "defines.v"

module extl_tb(); 

	reg rst; 
	
	//from id
	reg [`INST_WIDTH] inst; 
	reg [`INST_ADDR_WIDTH] inst_addr; 
	reg [`REG_ADDR_WIDTH] rd_waddr; 
	reg [`CSR_ADDR_WIDTH] csr_waddr; 
	reg [`DATA_WIDTH] imm; 
	reg [`OP1_SEL] op1_sel; 
	reg [`OP2_SEL] op2_sel; 
	reg [`ALU_SEL] alu_sel; 
	reg [`BR_SEL] br_sel; 
	reg [`WB_SEL] wb_sel; 
	reg [`MEM_RW] mem_rw;
	reg [`BYTE_SEL] byte_sel; 
	reg un_sign; 
	
	//from csregfile
	reg [`DATA_WIDTH] rs1_rdata; 
	reg [`DATA_WIDTH] rs2_rdata; 
	reg [`DATA_WIDTH] csr_rdata; 
	
	//to csregfile 
	wire [`REG_ADDR_WIDTH] rd_waddr_o; 
	wire [`DATA_WIDTH] rd_wdata_o; 
	wire [`CSR_ADDR_WIDTH] csr_waddr_o; 
	wire [`DATA_WIDTH] csr_wdata_o; 
	
	//to sb
	wire [`BYTE_SEL] byte_sel_o; 
	wire un_sign_o; 
	wire mem_re_o; 
	wire [`MEM_ADDR_WIDTH] mem_raddr_o; 
	wire mem_we_o; 
	wire [`MEM_ADDR_WIDTH] mem_waddr_o; 
	wire [`DATA_WIDTH] mem_wdata_o; 
	
	//to pc
	wire hold_o; 
	wire jump_o; 
	wire [`INST_ADDR_WIDTH] jump_addr_o; 
	
executrol u_extl(
	.rst(rst), 
	.inst(inst), 
	.inst_addr(inst_addr), 
	.rd_waddr(rd_waddr), 
	.csr_waddr(csr_waddr), 
	.imm(imm), 
	.op1_sel(op1_sel), 
	.op2_sel(op2_sel), 
	.alu_sel(alu_sel), 
	.br_sel(br_sel), 
	.wb_sel(wb_sel), 
	.mem_rw(mem_rw), 
	.byte_sel(byte_sel), 
	.un_sign(un_sign), 
	.rs1_rdata(rs1_rdata), 
	.rs2_rdata(rs2_rdata), 
	.csr_rdata(csr_rdata), 
	
	.rd_waddr_o(rd_waddr_o), 
	.rd_wdata_o(rd_wdata_o), 
	.csr_waddr_o(csr_waddr_o), 
	.csr_wdata_o(csr_wdata_o),
	.un_sign_o(un_sign_o), 
	.byte_sel_o(byte_sel_o), 
	.mem_re_o(mem_re_o), 
	.mem_raddr_o(mem_raddr_o), 
	.mem_we_o(mem_we_o), 
	.mem_waddr_o(mem_waddr_o), 
	.mem_wdata_o(mem_wdata_o), 
	.hold_o(hold_o), 
	.jump_o(jump_o), 
	.jump_addr_o(jump_addr_o)
	);
	
	initial begin
		rst = `RST; 
		#10; 
		rst = 1'b1; 
		
		//10ns, addi x32, x1, 32'b1
		inst = 32'b00000000000100001000111110010011; 
		inst_addr = `INI_INST_ADDR; 
		rd_waddr = 5'b11111; 
		csr_waddr = 12'b1; 
		imm = 32'b1; 
		op1_sel = 2'b1; 
		op2_sel = 2'b11; 
		alu_sel = 4'b1; 
		br_sel = 3'b0; 
		wb_sel = 3'b1; 
		mem_rw = 2'b0; 
		byte_sel = 4'b0; 
		un_sign = 1; 
		rs1_rdata = 32'b101; 
		rs2_rdata = 32'b111; //actually rs2 and csr data are useless here
		csr_rdata = 32'b111; 
		#10; 
		
		//20ns, bge x1, x2, 32'b{19{1}}1011111100000
		inst = 32'b11111110001000001101000001100011; 
		inst_addr = 32'b100; 
		rd_waddr = 5'b0; 
		csr_waddr = 12'b111111100010; 
		imm = {{19{1'b1}}, 12'b101111110000, {1'b0}}; 
		op1_sel = 2'b1; 
		op2_sel = 2'b1; 
		alu_sel = 4'b10; 
		br_sel = 3'b101; 
		wb_sel = 3'b0; 
		mem_rw = 2'b0; 
		byte_sel = 4'b0; 
		un_sign = 1'b1; 
		rs1_rdata = 32'b11; 
		rs2_rdata = 32'b10; 
		csr_rdata = 32'b1; 
		#10; 
		
		//30ns, lh x32, 32'b11(x1)
		inst = 32'b00000000001100001001111110000011; 
		inst_addr = 32'b1000; 
		rd_waddr = 5'b11111; 
		csr_waddr = 12'b11; 
		imm = 32'b11; 
		op1_sel = 2'b1; 
		op2_sel = 2'b11; 
		alu_sel = 4'b1; 
		br_sel = 3'b0; 
		wb_sel = 3'b11; 
		mem_rw = 2'b1; 
		byte_sel = 4'b11; 
		un_sign = 1'b1; 
		rs1_rdata = 32'b1; 
		rs2_rdata = 32'b10; 
		csr_rdata = 32'b11; 
		#10; 
		
		//40ns, bgeu x1, x2, 32'b{19{1}}1011111100000
		inst = 32'b11111110001000001101000001100011; 
		inst_addr = 32'b100; 
		rd_waddr = 5'b0; 
		csr_waddr = 12'b111111100010; 
		imm = {{19{1'b1}}, 12'b101111110000, {1'b0}}; 
		op1_sel = 2'b1; 
		op2_sel = 2'b1; 
		alu_sel = 4'b10; 
		br_sel = 3'b101; 
		wb_sel = 3'b0; 
		mem_rw = 2'b0; 
		byte_sel = 4'b0; 
		un_sign = 1'b0; 
		rs1_rdata = 32'b1; 
		rs2_rdata = 32'b10; 
		csr_rdata = 32'b11; 
		#10; 
		
		//50ns, sb x2, 32'b{20{1}}100000000100(x1)
		inst = 32'b10000000001000001000001000100011; 
		inst_addr = 32'b1100; 
		rd_waddr = 5'b00100; 
		csr_waddr = 12'b10000000010; 
		imm = {{20{1'b1}}, 12'b100000000100}; 
		op1_sel = 2'b1; 
		op2_sel = 2'b11; 
		alu_sel = 4'b1; 
		br_sel = 3'b0; 
		wb_sel = 3'b100; 
		mem_rw = 2'b10; 
		byte_sel = 4'b1; 
		un_sign =1'b1; 
		rs1_rdata = 32'b11; 
		rs2_rdata = 32'b10; 
		csr_rdata = 32'b1; 
		#10; 
		
		//60ns, lui x32, 32'b101{12{0}}
		inst = 32'b00000000000000000101111110110111; 
		inst_addr = 32'b10000; 
		rd_waddr = 5'b11111; 
		csr_waddr = 12'b0; 
		imm = 32'b101000000000000; 
		op1_sel = 2'b10; 
		op2_sel = 2'b0; 
		alu_sel = 4'b1; 
		br_sel = 3'b0; 
		wb_sel = 3'b1; 
		mem_rw = 2'b0; 
		byte_sel = 4'b0; 
		un_sign =1'b1; 
		rs1_rdata = 32'b1; 
		rs2_rdata = 32'b10; 
		csr_rdata = 32'b11; 
		#10; 
		
		//70ns, auipc x32, 32'b110{12{0}}
		inst = 32'b00000000000000000110111110010111; 
		inst_addr = 32'b10100; 
		rd_waddr = 5'b11111; 
		csr_waddr = 12'b0; 
		imm = 32'b110000000000000; 
		op1_sel = 2'b10; 
		op2_sel = 2'b10; 
		alu_sel = 4'b1; 
		br_sel = 3'b0; 
		wb_sel = 3'b1; 
		mem_rw = 2'b0; 
		byte_sel = 4'b0; 
		un_sign =1'b1; 
		rs1_rdata = 32'b11; 
		rs2_rdata = 32'b10; 
		csr_rdata = 32'b1; 
		#10; 
		
		//80ns, jalr x32, 32'b{20{1}}100000000111(x1)
		inst = 32'b10000000011100001010111111100111; 
		inst_addr = 32'b11000; 
		rd_waddr = 5'b11111; 
		csr_waddr = 12'b100000000111; 
		imm = {{20{1'b1}}, 12'b100000000111}; 
		op1_sel = 2'b1; 
		op2_sel = 2'b10; 
		alu_sel = 4'b1; 
		br_sel = 3'b1; 
		wb_sel = 3'b10; 
		mem_rw = 2'b0; 
		byte_sel = 4'b0; 
		un_sign =1'b1; 
		rs1_rdata = 32'b1; 
		rs2_rdata = 32'b10; 
		csr_rdata = 32'b11; 
		#10; 
		/*
		
		//
		inst = 32'b
		inst_addr = 32'b
		rd_waddr = 5'b
		csr_waddr = 12'b
		imm = 32'b
		op1_sel = 2'b
		op2_sel = 2'b
		alu_sel = 4'b
		br_sel = 3'b
		wb_sel = 3'b
		mem_rw = 2'b
		byte_sel = 4'b
		un_sign =1'b
		rs1_rdata = 32'b
		rs2_rdata = 32'b
		csr_rdata = 32'b
		#10; 
		*/
	end
	
endmodule