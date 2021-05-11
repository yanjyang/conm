`include "../rtl/core/defines.v"
`define REGS soc.u_CoNM.u_csregfile.regs

module CoNM_soc_tb(); 
	
	//Clock signal
	localparam clk_period = 20; 
	reg clk; 
	initial clk = 1'b0; 
	always #(clk_period/2) clk = ~clk; 
	
	reg rst; 
	
	wire [`DATA_WIDTH] x3 = `REGS[3]; 
	wire [`DATA_WIDTH] x26 = `REGS[26]; 
	wire [`DATA_WIDTH] x27 = `REGS[27]; 
	
	integer r; 
	
CoNM_soc_top soc(
	.clk(clk), 
	.rst(rst)
	);
	
	//read mem data
	initial begin
		$readmemh("D:/Work/GraduationP/conm/tests/isa/rv32ui-p-addi.verilog", soc.imem.mem_unit); 
	end
	
	//general test benchmark
	initial begin
		rst = `RST; 
		$display("Here comes the test!");
		#40; 
		rst = `UNRST; 
		#200; 
		
		wait(x26 == 32'b1)
		#100; 
		if (x27 == 32'b1) begin 
			$display("~~~~~~~~~~~~~~~~~~~ TEST_PASS ~~~~~~~~~~~~~~~~~~~"); 
			$display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"); 
			$display("~~~~~~~~~ #####     ##     ####    #### ~~~~~~~~~"); 
			$display("~~~~~~~~~ #    #   #  #   #       #     ~~~~~~~~~"); 
			$display("~~~~~~~~~ #    #  #    #   ####    #### ~~~~~~~~~"); 
			$display("~~~~~~~~~ #####   ######       #       #~~~~~~~~~"); 
			$display("~~~~~~~~~ #       #    #  #    #  #    #~~~~~~~~~"); 
			$display("~~~~~~~~~ #       #    #   ####    #### ~~~~~~~~~"); 
			$display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"); 
		end else begin 
			$display("~~~~~~~~~~~~~~~~~~~ TEST_FAIL ~~~~~~~~~~~~~~~~~~~~"); 
			$display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"); 
			$display("~~~~~~~~~~######    ##       #    #     ~~~~~~~~~~"); 
			$display("~~~~~~~~~~#        #  #      #    #     ~~~~~~~~~~"); 
			$display("~~~~~~~~~~#####   #    #     #    #     ~~~~~~~~~~"); 
			$display("~~~~~~~~~~#       ######     #    #     ~~~~~~~~~~"); 
			$display("~~~~~~~~~~#       #    #     #    #     ~~~~~~~~~~"); 
			$display("~~~~~~~~~~#       #    #     #    ######~~~~~~~~~~"); 
			$display("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"); 
			$display("fail testnum = %2d", x3); 
			for (r = 0; r < 32; r = r + 1) 
				$display("x%2d = 0x%x", r, `REGS[r]); 
			end
			$finish; 
	end
	
	//timeout
	initial begin
		#50000; 
		$display("Ooops...time out..."); 
		$finish; 
	end
	
endmodule