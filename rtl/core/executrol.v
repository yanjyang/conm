`include "defines.v"

module executrol(
	
	input wire rst, 
	
	//from id
	input wire [`INST_WIDTH] inst, 
	input wire [`INST_ADDR_WIDTH] inst_addr, 
	input wire [`REG_ADDR_WIDTH] rd_waddr, 
	input wire [`CSR_ADDR_WIDTH] csr_waddr, 
	input wire [`DATA_WIDTH] imm, 
	input wire [`OP1_SEL] op1_sel, 
	input wire [`OP2_SEL] op2_sel, 
	input wire [`ALU_SEL] alu_sel, 
	input wire [`BR_SEL] br_sel, 
	input wire [`WB_SEL] wb_sel, 
	input wire [`MEM_RW] mem_rw,
	input wire [`BYTE_SEL] byte_sel, 
	input wire un_sign, 
	
	//from csregfile
	input wire [`DATA_WIDTH] rs1_rdata, 
	input wire [`DATA_WIDTH] rs2_rdata, 
	input wire [`DATA_WIDTH] csr_rdata, 
	
	//to csregfile 
	output wire [`REG_ADDR_WIDTH] rd_waddr_o, 
	output wire [`DATA_WIDTH] rd_wdata_o, 
	output wire [`CSR_ADDR_WIDTH] csr_waddr_o, 
	output wire [`DATA_WIDTH] csr_wdata_o, 
	
	//to sb
	output wire [`BYTE_SEL] byte_sel_o, 
	output wire un_sign_o, 
	output wire mem_re_o, 
	output wire [`MEM_ADDR_WIDTH] mem_raddr_o, 
	output wire mem_we_o, 
	output wire [`MEM_ADDR_WIDTH] mem_waddr_o, 
	output wire [`DATA_WIDTH] mem_wdata_o, 
	
	//to pc
	output wire jump_o, 
	output wire [`INST_ADDR_WIDTH] jump_addr_o
	); 
	
	wire op1_none; 
	wire op1_rs1; 
	wire op1_imm; 
	wire [`DATA_WIDTH] op1; 
	
	wire op2_none; 
	wire op2_rs2; 
	wire op2_inst_addr; 
	wire op2_imm; 
	wire [`DATA_WIDTH] op2; 
	
	wire alu_nop; 
	wire alu_add; 
	wire alu_sub; 
	wire alu_sll; 
	wire alu_slt; 
	wire alu_sltu; 
	wire alu_xor; 
	wire alu_srl; 
	wire alu_sra; 
	wire alu_or; 
	wire alu_and; 
	wire [`DATA_WIDTH] alu_rslt; 
	
	wire br_disable; 
	wire br_uncon; 
	wire br_eq; 
	wire br_ne; 
	wire br_lt; 
	wire br_ge; 
	wire br_ltu; 
	wire br_geu; 
	
	wire wb_none; 
	wire wb_rd; 
	wire wb_j_type; 
	wire wb_il_type; 
	wire wb_mem; 
	wire wb_csr; 
	
	wire sl_none; 
	wire sl_byte; 
	wire sl_halfword; 
	wire sl_word; 
	
	//op1 selection
	assign op1_none = (op1_sel == `OP1_NONE); //not functioning
	assign op1_rs1 = (op1_sel == `OP1_RS1); 
	assign op1_imm = (op1_sel == `OP1_IMM); 
	assign op1 = 
		op1_rs1 ? rs1_rdata : 
		op1_imm ? imm : 
		`ZERO32; 
	
	//op2 selection
	assign op2_none = (op2_sel == `OP2_NONE); //not functioning
	assign op2_rs2 = (op2_sel == `OP2_RS2); 
	assign op2_inst_addr = (op2_sel == `OP2_INST_ADDR); 
	assign op2_imm = (op2_sel == `OP2_IMM); 
	assign op2 = 
		op2_rs2 ? rs2_rdata : 
		op2_inst_addr ? inst_addr : 
		op2_imm ? imm : 
		`ZERO32; 
	
	//ALU operation
	assign alu_nop = (alu_sel == `ALU_NOP); //not functioning
	assign alu_add = (alu_sel == `ALU_ADD); 
	assign alu_sub = (alu_sel == `ALU_SUB); 
	assign alu_sll = (alu_sel == `ALU_SLL); 
	assign alu_slt = (alu_sel == `ALU_SLT) & (un_sign == `SIGNED); 
	assign alu_sltu = (alu_sel == `ALU_SLT) & (un_sign == `UNSIGNED); 
	assign alu_xor = (alu_sel == `ALU_XOR); 
	assign alu_srl = (alu_sel == `ALU_SRL); 
	assign alu_sra = (alu_sel == `ALU_SRA); 
	assign alu_or = (alu_sel == `ALU_OR); 
	assign alu_and = (alu_sel == `ALU_AND); 
	assign alu_rslt = 
		alu_add ? (op1+op2) : 
		alu_sub ? (op1-op2) : 
		alu_sll ? (op1<<op2[4:0]) : 
		alu_slt ? ($signed(op1)<$signed(op2)) : 
		alu_sltu ? (op1<op2) : 
		alu_xor ? (op1^op2) : 
		alu_srl ? (op1>>op2[4:0]) : 
		alu_sra ? ({{31{op1[31]}}, 1'b0}<<(~op2[4:0])|(op1>>op2[4:0])) : 
		alu_or ? (op1|op2) : 
		alu_and ? (op1&op2) : 
		`ZERO32; 
	
	//branch selection
	assign br_disable = (br_sel == `BR_DISABLE); //not functioning
	assign br_uncon = (br_sel == `BR_UNCON); 
	assign br_eq = (br_sel == `BR_EQ); 
	assign br_ne = (br_sel == `BR_NE); 
	assign br_lt = (br_sel == `BR_LT) & (un_sign == `SIGNED); 
	assign br_ge = (br_sel == `BR_GE) & (un_sign == `SIGNED); 
	assign br_ltu = (br_sel == `BR_LT) & (un_sign == `UNSIGNED); 
	assign br_geu = (br_sel == `BR_GE) & (un_sign == `UNSIGNED); 
	
	assign jump_o = 
		(br_uncon | 
		(br_eq & (op1 == op2)) | 
		(br_ne & (op1 != op2)) | 
		(br_lt & ($signed(op1) < $signed(op2))) | 
		(br_ge & ($signed(op1) >= $signed(op2))) | 
		(br_ltu & (op1 < op2)) | 
		(br_geu & (op1 >= op2))) ? `JUMP : 
		`UNJUMP; 
	assign jump_addr_o = 
		br_uncon ? (alu_rslt&32'hfffffffe) : 
		(inst_addr+imm); 
		
	//write back selection
	assign wb_rd = (wb_sel == `WB_RD); 
	assign wb_j_type = (wb_sel == `WB_J_TYPE); 
	assign wb_il_type = (wb_sel == `WB_IL_TYPE); 
	assign wb_mem = (wb_sel == `WB_MEM); 
	assign wb_csr = (wb_sel == `WB_CSR); 
	assign wb_none = (wb_sel == `WB_NONE); //not functioning
	
	assign rd_waddr_o = 
		(wb_rd | wb_j_type | wb_il_type) ? rd_waddr : 
		`ZERO_REG; 
	assign rd_wdata_o = 
		wb_rd ? alu_rslt : 
		wb_j_type ? (inst_addr+32'h4) : 
		`ZERO32; 
	
	assign csr_waddr_o = 
		wb_csr ? csr_waddr : 
		`mdisable; 
	assign csr_wdata_o = 
		wb_csr ? alu_rslt : 
		`ZERO32; 
	
	//mem read or write selection  
	assign mem_re_o = (mem_rw == `MEM_READ); 
	assign mem_we_o = wb_mem & (mem_rw == `MEM_WRITE); 
	assign byte_sel_o = byte_sel; 
	assign un_sign_o = un_sign; 
	
	assign mem_raddr_o = 
		mem_re_o ? alu_rslt : 
		`ZERO32; 
	assign mem_waddr_o = 
		mem_we_o ? alu_rslt : 
		`ZERO32; 
	assign mem_wdata_o = 
		mem_we_o ? rs2_rdata : 
		`ZERO32; 
	
endmodule 