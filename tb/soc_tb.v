`include "../rtl/core/defines.v"
`define REGS soc.u_CoNM.u_csregfile.regs
`define IMEM soc.imem.mem_unit
`define DMEM soc.dmem.mem_unit

module soc_tb();

	//Clock signal
	localparam clk_period = 20; 
	reg clk; 
	initial clk = 1'b0; 
	always #(clk_period/2) clk = ~clk; 
	
	reg rst; 
	
	wire [`DATA_WIDTH] x3 = `REGS[3]; 
	wire [`DATA_WIDTH] x10 = `REGS[10]; 
	wire [`DATA_WIDTH] x26 = `REGS[26]; 
	wire [`DATA_WIDTH] x27 = `REGS[27]; 
	
	wire [`DATA_WIDTH] ex_end_flag = `DMEM[4]; 
	wire [`DATA_WIDTH] begin_sign = `DMEM[2]; 
	wire [`DATA_WIDTH] end_sign = `DMEM[3]; 
	
	integer r; 
	integer fd; 
	
CoNM_soc_top soc(
	.clk(clk), 
	.rst(rst) 
	);
	
	initial begin
		rst = `RST; 
		
		$display("Here comes another test!"); 
		#40; 
		rst = `UNRST; 
		#200; 
		
		wait (ex_end_flag == 32'h1); 
		fd = $fopen("sign.output"); 
		for (r = begin_sign; r < end_sign; r = r+4) begin
			$fdisplay(fd, "%x", `IMEM[r[31:2]]); 
		end
		$fclose(fd); 
	
		$finish; 
	end
	
	initial begin
		#500000; 
		$display("Ooops...time out..."); 
		$finish; 
	end
	
	initial begin
		$readmemh("D:/Work/GraduationP/conm/tb/inst.data", `IMEM); 
	end
	
	initial begin
		$dumpfile("another_soc_tb.vcd"); 
		$dumpvars(0, soc_tb); 
	end
	
endmodule