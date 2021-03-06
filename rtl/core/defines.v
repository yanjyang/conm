`define ZERO32            32'h0
`define DATA_WIDTH			  31:0
                              
//General flags               
`define RST               1'b0
`define UNRST             1'b1
`define JUMP              1'b1
`define UNJUMP            1'b0
`define WRITE_ENABLE	    1'b1
`define READ_ENABLE       1'b0

//Instruction parameters
`define INST_WIDTH		    31:0
`define INST_ADDR_WIDTH   31:0
`define INI_INST_ADDR    `ZERO32

//General integer register
`define REG_NUM					    32
`define REG_ADDR_WIDTH     4:0
`define ZERO_REG 			    5'h0

//MEM
`define MEM_NUM           4096
`define MEM_ADDR_WIDTH    31:0

//Op1 and op2 selection signals
`define OP1_SEL            1:0
`define OP1_NONE         2'b00
`define OP1_RS1          2'b01
`define OP1_IMM          2'b10

`define OP2_SEL            1:0
`define OP2_NONE         2'b00
`define OP2_RS2          2'b01
`define OP2_INST_ADDR    2'b10
`define OP2_IMM          2'b11

//ALU flags
`define ALU_SEL            3:0
`define ALU_NOP        4'b0000
`define ALU_ADD        4'b0001
`define ALU_SUB        4'b0010
`define ALU_SLL        4'b0011
`define ALU_SLT        4'b0100
`define ALU_XOR        4'b0101
`define ALU_SRL        4'b0110
`define ALU_SRA        4'b0111
`define ALU_OR         4'b1000
`define ALU_AND        4'b1001

//Branch selection signals
`define BR_SEL             2:0
`define BR_DISABLE      3'b000
`define BR_UNCON        3'b001
`define BR_EQ           3'b010
`define BR_NE           3'b011
`define BR_LT           3'b100
`define BR_GE           3'b101

//Writeback selection signals
`define WB_SEL             2:0
`define WB_NONE         3'b000
`define WB_RD           3'b001
`define WB_J_TYPE       3'b010
`define WB_IL_TYPE      3'b011
`define WB_MEM          3'b100
`define WB_CSR          3'b101

//Mem read or write signals 
`define MEM_RW             1:0
`define MEM_DISABLE      2'b00
`define MEM_READ         2'b01
`define MEM_WRITE        2'b10

//S/L byte selection signals
`define BYTE_SEL           3:0
`define SL_NONE        4'b0000
`define SL_BYTE        4'b0001
`define SL_HALFWORD    4'b0011
`define SL_WORD        4'b1111

//load sign signals
`define UNSIGNED    1'b0
`define SIGNED      1'b1

//CSRs, others might be needed while some below might be useless
`define CSR_ADDR_WIDTH    11:0

`define mstatus    12'h300	//*very complex
`define misa       12'h301	//32'h40020000
`define mie 	     12'h304	//mstatus and mask related?
`define mtvec      12'h305	//trap address
`define mscratch   12'h340	//temporary register data saving before exception
`define mepc			 12'h341	//the pc address before exception
`define mcause 		 12'h342	//exception cause indicator
`define mtval 		 12'h343	//opcode or memory address before exception
`define mip 			 12'h344	//pending related?
`define mcycle 		 12'hb00	//counting cycle times, lower 32 bits
`define mcycleh 	 12'hb80  //counting cycle times, higher 32 bits
`define mvendorid  12'hf11 	//32'h13109f5   
`define mdisable   12'h000  //indicating no csr operations
/*These might be totally useless
`define minstret 
`define minstreth 
`define msip 
*/

//NOP
`define NOP 			32'h13

//U format
`define LUI				7'b0110111
`define AUIPC 		7'b0010111

//UJ format
`define JAL 			7'b1101111
`define JALR 			7'b1100111

//B format *6
`define B_FORMAT	7'b1100011
`define BEQ 			3'b000
`define BNE 			3'b001
`define BLT 			3'b100
`define BGE 			3'b101
`define BLTU 			3'b110
`define BGEU 			3'b111

//I format, loads *5
`define IL_FORMAT 7'b0000011
`define LB 				3'b000
`define LH 				3'b001
`define LW 				3'b010
`define LBU 			3'b100
`define LHU 			3'b101

//S format *3
`define S_FORMAT 	7'b0100011
`define SB 				3'b000
`define SH 				3'b001
`define SW 				3'b010

//I format *9
`define I_FORMAT 	7'b0010011
`define ADDI 			3'b000
`define SLTI 			3'b010
`define SLTIU 		3'b011
`define XORI 			3'b100
`define ORI 			3'b110
`define ANDI			3'b111
`define SLLI 			3'b001
`define SRLI_SRAI 3'b101
	`define SRLI 		7'b0000000
	`define SRAI 		7'b0100000
	
//R format *10
`define R_FORMAT 	7'b0110011
`define ADD_SUB 	3'b000
	`define ADD 		7'b0000000
	`define SUB			7'b0100000
`define SLL 			3'b001
`define SLT 			3'b010
`define SLTU 			3'b011
`define XOR 			3'b100
`define SRL_SRA 	3'b101
	`define SRL 		7'b0000000
	`define SRA 		7'b0100000
`define OR 				3'b110
`define AND 			3'b111

//FENCE and FENCE.I
`define FENCE_FENCEI	7'b0001111
`define FENCE 		3'b000
`define FENCEI 		3'b001

//CSRs *8
`define CSR 			7'b111001
`define CSRRW 		3'b001
`define CSRRS			3'b010
`define CSRRC 		3'b011
`define CSRRWI 		3'b101
`define CSRRSI 		3'b110
`define CSRRCI		3'b111

//Environment *2
`define ECALL 		32'h73
`define EBREAK 		32'h100073