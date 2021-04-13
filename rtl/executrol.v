`include "defines.v"

module executrol(
	
	input wire rst, 
	
	//from id
	input wire [`INST_ADDR_WIDTH] inst_addr, 
	input wire rd_we, 
	input wire [`REG_ADDR_WIDTH] rd_waddr, 
	input wire csr_we, 
	input wire [`MEM_ADDR_WIDTH] csr_waddr, 
	input wire [`DATA_WIDTH] imm, 
	input wire [?] alu_sel, 
	input wire [?] op1_sel, 
	input wire [?] op2_sel, 
	input wire [?] b_sel, 
	input wire [1:0] mem_rw, 
	
	//from csregfile
	input wire [`DATA_WIDTH] rs1_rdata, 
	input wire [`DATA_WIDTH] rs2_rdata, 
	input wire [`DATA_WIDTH] csr_rdata, 
	
	//from sb
	input wire [`DATA_WIDTH] mem_rdata, 
	
	//to csregfile 
	output wire rd_we_o, 
	output wire [`REG_ADDR_WIDTH] rd_waddr_o, 
	output wire [`DATA_WIDTH] rd_wdata_o, 
	output wire csr_we_o, 
	output wire [`MEM_ADDR_WIDTH] csr_waddr_o, 
	output wire [`DATA_WIDTH] csr_wdata_o, 
	
	//to sb
	output wire mem_req_o, 
	output ? [`MEM_ADDR_WIDTH] mem_raddr_o, 
	output wire mem_we_o, 
	output ? [`MEM_ADDR_WIDTH] mem_waddr_o, 
	output ? [`DATA_WIDTH] mem_wdata_o, 
	
	//to pc
	output ? hold_o, 
	output ? jump_o, 
	output wire [`INST_ADDR_WIDTH] jump_addr_o
	); 
	
	