`include "../core/defines.v"

module CoNM_mem_tb(); 
	
	//Clock signal
	localparam clk_period = 10; 
	reg clk; 
	initial clk = 1'b0; 
	always #(clk_period/2) clk = ~clk; 
	
	reg rst; 
	
CoNM u_CoNM(
	.clk(clk), 
	.rst(rst), 
	.sb_pc_inst(sb_pc_inst), 
	.sb_csrgf_rdata(sb_csrgf_rdata), 
	.pc_sb_inst_addr(pc_sb_inst_addr), 
	
	.extl_sb_un_sign_o(extl_sb_un_sign_o), 
	.extl_sb_byte_mask_o(extl_sb_bybte_mask_o), 
	.extl_sb_mem_re_o(extl_sb_mem_re_o), 
	.extl_sb_mem_we_o(extl_sb_mem_we_o), 
	.extl_sb_addr_o(extl_sb_addr_o), 
	.extl_sb_mem_wdata_o(extl_sb_mem_wdata_o)
	);
	
sb u_sb(
	.clk(clk), 
	.rst(rst), 
	.m0_un_sign(m0_un_sign), 
	.m0_byte_mask(m0_byte_mask), 
	.m0_re(m0_re), 
	.m0_we(m0_we), 
	.m0_addr(m0_addr), 
	.m0_wdata(m0_wdata), 
	.m0_rdata(m0_rdata_o), 
	
	.m1_un_sign(m1_un_sign), 
	.m1_byte_mask(m1_byte_mask), 
	.m1_re(m1_re), 
	.m1_we(m1_we), 
	.m1_addr(m1_addr), 
	.m1_wdata(m1_wdata), 
	.m1_rdata(m1_rdata_o), 
	
	.s_rdata(s_rdata), 
	.s_rw_o(s_rw_o), 
	.s_addr_o(s_addr_o), 
	.s_wdata_o(s_wdata_o)
	); 