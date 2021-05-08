`include "../rtl/core/defines.v"
`define REGS soc.u_CoNM.u_csregfile.regs

module tb(); 
	
	//Clock signal
	localparam clk_period = 10; 
	reg clk; 
	initial clk = 1'b0; 
	always #(clk_period/2) clk = ~clk; 
	
	reg rst; 
	
	reg [`INST_WIDTH] inst; 
	wire [`INST_ADDR_WIDTH] inst_addr_o; 
	
	integer r; 
	
soc_top soc(
	.clk(clk), 
	.rst(rst), 
	.inst(inst), 
	.inst_addr_o(inst_addr_o)
	);
	
	//general test benchmark
	initial begin
		rst = `RST; 
		#20; 
		rst = `UNRST; 
		$display("Here comes the test!");
		inst <= 32'h00000d13; //li x26, 0
		#10; 
		inst <= 32'h00000d93; //li x27, 0
		#10; 
		inst <= 32'b00000000000111010000111110010011; //addi x31, x26, 32'b1
		#30; 
		//hitherto, passed
			for (r = 0; r < 32; r = r + 1) 
				$display("x%2d = 0x%x", r, `REGS[r]); 
			$finish; 
	end
	
	//timeout
	initial begin
		#10000; 
		$display("Ooops...time out..."); 
		$finish; 
	end
	
endmodule