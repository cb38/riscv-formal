// Generator : SpinalHDL v1.13.0    git head : d9d72474863badf47d8585d187f3e04ae4749c59
// Component : RV
// Git hash  : 362f1e2061c97d2ef35561e6913f080155bc5b80

`timescale 1ns/1ps

module RV (
  output wire [31:0]   io_IO,
  (* keep *) output reg           rvfi_valid,
  (* keep *) output reg  [63:0]   rvfi_order,
  (* keep *) output reg  [31:0]   rvfi_insn,
  (* keep *) output reg           rvfi_trap,
  (* keep *) output reg           rvfi_halt,
  (* keep *) output reg           rvfi_intr,
  (* keep *) output reg  [4:0]    rvfi_rs1_addr,
  (* keep *) output reg  [4:0]    rvfi_rs2_addr,
  (* keep *) output reg  [31:0]   rvfi_rs1_rdata,
  (* keep *) output reg  [31:0]   rvfi_rs2_rdata,
  (* keep *) output reg  [4:0]    rvfi_rd_addr,
  (* keep *) output reg  [31:0]   rvfi_rd_wdata,
  (* keep *) output reg  [31:0]   rvfi_pc_rdata,
  (* keep *) output reg  [31:0]   rvfi_pc_wdata,
  (* keep *) output reg  [31:0]   rvfi_mem_addr,
  (* keep *) output reg  [3:0]    rvfi_mem_rmask,
  (* keep *) output reg  [3:0]    rvfi_mem_wmask,
  (* keep *) output reg  [31:0]   rvfi_mem_rdata,
  (* keep *) output reg  [31:0]   rvfi_mem_wdata,
  (* keep *) output reg  [31:0]   rvfi_csr_mstatus_wmask,
  (* keep *) output reg  [31:0]   rvfi_csr_mstatus_wdata,
  (* keep *) output reg  [31:0]   rvfi_csr_mepc_wmask,
  (* keep *) output reg  [31:0]   rvfi_csr_mepc_wdata,
  (* keep *) output reg  [31:0]   rvfi_csr_mcause_wmask,
  (* keep *) output reg  [31:0]   rvfi_csr_mcause_wdata,
  (* keep *) output reg  [1:0]    rvfi_ixl,
  (* keep *) output reg  [1:0]    rvfi_mode,
  output wire          instr_req_valid,
  input  wire          instr_req_ready,
  output wire [31:0]   instr_req_addr,
  input  wire          instr_rsp_valid,
  input  wire [31:0]   instr_rsp_data,
  output reg           data_req_valid,
  input  wire          data_req_ready,
  output reg           data_req_rden,
  output reg  [31:0]   data_req_rdaddr,
  output reg  [31:0]   data_req_wraddr,
  output reg           data_req_wren,
  output reg  [1:0]    data_req_size,
  output reg  [31:0]   data_req_data,
  input  wire          data_rsp_valid,
  input  wire [31:0]   data_rsp_data,
  input  wire          irq,
  input  wire          clk,
  input  wire          reset
);
  localparam InstrType_Undef = 13'd1;
  localparam InstrType_JAL = 13'd2;
  localparam InstrType_JALR = 13'd4;
  localparam InstrType_B = 13'd8;
  localparam InstrType_L = 13'd16;
  localparam InstrType_S = 13'd32;
  localparam InstrType_ALU_ADD = 13'd64;
  localparam InstrType_ALU = 13'd128;
  localparam InstrType_SHIFT = 13'd256;
  localparam InstrType_FENCE = 13'd512;
  localparam InstrType_E = 13'd1024;
  localparam InstrType_CSR = 13'd2048;
  localparam InstrType_MULDIV = 13'd4096;
  localparam InstrType_Undef_OH_ID = 0;
  localparam InstrType_JAL_OH_ID = 1;
  localparam InstrType_JALR_OH_ID = 2;
  localparam InstrType_B_OH_ID = 3;
  localparam InstrType_L_OH_ID = 4;
  localparam InstrType_S_OH_ID = 5;
  localparam InstrType_ALU_ADD_OH_ID = 6;
  localparam InstrType_ALU_OH_ID = 7;
  localparam InstrType_SHIFT_OH_ID = 8;
  localparam InstrType_FENCE_OH_ID = 9;
  localparam InstrType_E_OH_ID = 10;
  localparam InstrType_CSR_OH_ID = 11;
  localparam InstrType_MULDIV_OH_ID = 12;
  localparam MulOp_NONE = 5'd1;
  localparam MulOp_MUL = 5'd2;
  localparam MulOp_MULH = 5'd4;
  localparam MulOp_MULHSU = 5'd8;
  localparam MulOp_MULHU = 5'd16;
  localparam MulOp_NONE_OH_ID = 0;
  localparam MulOp_MUL_OH_ID = 1;
  localparam MulOp_MULH_OH_ID = 2;
  localparam MulOp_MULHSU_OH_ID = 3;
  localparam MulOp_MULHU_OH_ID = 4;
  localparam CsrCmd_NONE = 4'd1;
  localparam CsrCmd_WRITE = 4'd2;
  localparam CsrCmd_SET = 4'd4;
  localparam CsrCmd_CLEAR = 4'd8;
  localparam CsrCmd_NONE_OH_ID = 0;
  localparam CsrCmd_WRITE_OH_ID = 1;
  localparam CsrCmd_SET_OH_ID = 2;
  localparam CsrCmd_CLEAR_OH_ID = 3;
  localparam InstrFormat_R = 8'd1;
  localparam InstrFormat_I = 8'd2;
  localparam InstrFormat_S = 8'd4;
  localparam InstrFormat_B = 8'd8;
  localparam InstrFormat_U = 8'd16;
  localparam InstrFormat_J = 8'd32;
  localparam InstrFormat_Shamt = 8'd64;
  localparam InstrFormat_CSR = 8'd128;
  localparam InstrFormat_R_OH_ID = 0;
  localparam InstrFormat_I_OH_ID = 1;
  localparam InstrFormat_S_OH_ID = 2;
  localparam InstrFormat_B_OH_ID = 3;
  localparam InstrFormat_U_OH_ID = 4;
  localparam InstrFormat_J_OH_ID = 5;
  localparam InstrFormat_Shamt_OH_ID = 6;
  localparam InstrFormat_CSR_OH_ID = 7;
  localparam Op1Kind_Rs1 = 2'd0;
  localparam Op1Kind_Zero = 2'd1;
  localparam Op1Kind_Pc = 2'd2;

  wire       [31:0]   RegFile_RegMem_spinal_port0;
  wire       [31:0]   RegFile_RegMem_spinal_port1;
  wire                fetcher_fifo_io_push_ready;
  wire                fetcher_fifo_io_pop_valid;
  wire       [31:0]   fetcher_fifo_io_pop_payload;
  wire       [1:0]    fetcher_fifo_io_occupancy;
  wire       [1:0]    fetcher_fifo_io_availability;
  wire       [31:0]   _zz_fetch_down_PC;
  wire       [32:0]   _zz_decoder_rs1_33;
  wire       [31:0]   _zz_decoder_rs1_33_1;
  wire       [32:0]   _zz_decoder_rs1_33_2;
  wire       [31:0]   _zz_decoder_rs1_33_3;
  wire       [32:0]   _zz_decoder_rs2_33;
  wire       [31:0]   _zz_decoder_rs2_33_1;
  wire       [32:0]   _zz_decoder_rs2_33_2;
  wire       [31:0]   _zz_decoder_rs2_33_3;
  wire       [32:0]   _zz__zz_decoder_op2_33;
  wire       [31:0]   _zz__zz_decoder_op2_33_1;
  wire       [32:0]   _zz__zz_decoder_op2_33_2;
  wire       [32:0]   _zz__zz_decoder_op2_33_3;
  wire       [32:0]   _zz__zz_decoder_op2_33_4;
  wire       [9:0]    _zz_decoder_op1_op2_lsb;
  wire       [9:0]    _zz_decoder_op1_op2_lsb_1;
  wire       [20:0]   _zz__zz_decoder_rs2_imm;
  wire       [20:0]   _zz__zz_decoder_rs2_imm_1;
  wire       [20:0]   _zz__zz_decoder_rs2_imm_2;
  wire       [25:0]   _zz_exec_alu_alu_add_33;
  wire       [25:0]   _zz_exec_alu_alu_add_33_1;
  wire       [25:0]   _zz_exec_alu_alu_add_33_2;
  wire       [24:0]   _zz_exec_alu_alu_add_33_3;
  wire       [25:0]   _zz_exec_alu_alu_add_33_4;
  wire       [24:0]   _zz_exec_alu_alu_add_33_5;
  wire       [0:0]    _zz_exec_alu_rd_wdata_alu_lt;
  wire       [31:0]   _zz_exec_alu_rd_wdata;
  wire       [31:0]   _zz_exec_alu_rd_wdata_1;
  wire       [31:0]   _zz_exec_alu_rd_wdata_2;
  wire       [4:0]    _zz_exec_shift_shamt;
  wire       [32:0]   _zz_exec_shift_op1_33;
  wire       [32:0]   _zz_exec_shift_op1_33_1;
  wire       [32:0]   _zz_exec_shift_rd_wdata;
  wire       [32:0]   _zz_exec_shift_rd_wdata_1;
  wire       [32:0]   _zz_exec_shift_rd_wdata_2;
  wire       [32:0]   _zz_exec_shift_rd_wdata_3;
  wire       [31:0]   _zz_exec_jump_pc_jump;
  wire       [31:0]   _zz_exec_jump_pc_jump_1;
  wire       [31:0]   _zz_exec_jump_pc_jump_2;
  wire       [0:0]    _zz_exec_jump_pc_jump_3;
  wire       [4:0]    _zz__zz_exec_lsu_rd_wdata_1;
  wire       [31:0]   _zz__zz_exec_lsu_rd_wdata_2;
  wire       [7:0]    _zz__zz_exec_lsu_rd_wdata_2_1;
  wire       [31:0]   _zz__zz_exec_lsu_rd_wdata_2_2;
  wire       [7:0]    _zz__zz_exec_lsu_rd_wdata_2_3;
  wire       [31:0]   _zz__zz_exec_lsu_rd_wdata_2_4;
  wire       [15:0]   _zz__zz_exec_lsu_rd_wdata_2_5;
  wire       [31:0]   _zz__zz_exec_lsu_rd_wdata_2_6;
  wire       [15:0]   _zz__zz_exec_lsu_rd_wdata_2_7;
  wire                fetch_up_isCancel;
  wire                fetch_up_isReady;
  wire                fetch_up_isValid;
  wire                decode_down_isValid;
  wire                fetch_down_isValid;
  reg                 execute_up_rvfi_valid;
  reg        [63:0]   execute_up_rvfi_order;
  reg        [31:0]   execute_up_rvfi_insn;
  reg                 execute_up_rvfi_trap;
  reg                 execute_up_rvfi_halt;
  reg                 execute_up_rvfi_intr;
  reg        [4:0]    execute_up_rvfi_rs1_addr;
  reg        [4:0]    execute_up_rvfi_rs2_addr;
  reg        [31:0]   execute_up_rvfi_rs1_rdata;
  reg        [31:0]   execute_up_rvfi_rs2_rdata;
  reg        [4:0]    execute_up_rvfi_rd_addr;
  reg        [31:0]   execute_up_rvfi_rd_wdata;
  reg        [31:0]   execute_up_rvfi_pc_rdata;
  reg        [31:0]   execute_up_rvfi_pc_wdata;
  reg        [31:0]   execute_up_rvfi_mem_addr;
  reg        [3:0]    execute_up_rvfi_mem_rmask;
  reg        [3:0]    execute_up_rvfi_mem_wmask;
  reg        [31:0]   execute_up_rvfi_mem_rdata;
  reg        [31:0]   execute_up_rvfi_mem_wdata;
  reg        [31:0]   execute_up_rvfi_csr_mstatus_wmask;
  reg        [31:0]   execute_up_rvfi_csr_mstatus_wdata;
  reg        [31:0]   execute_up_rvfi_csr_mepc_wmask;
  reg        [31:0]   execute_up_rvfi_csr_mepc_wdata;
  reg        [31:0]   execute_up_rvfi_csr_mcause_wmask;
  reg        [31:0]   execute_up_rvfi_csr_mcause_wdata;
  reg        [1:0]    execute_up_rvfi_ixl;
  reg        [1:0]    execute_up_rvfi_mode;
  reg        [12:0]   execute_up_decoder_ITYPE;
  reg        [31:0]   execute_up_decoder_RS2_IMM;
  reg        [8:0]    execute_up_decoder_OP1_OP2_LSB;
  reg        [32:0]   execute_up_decoder_OP2_33;
  reg        [32:0]   execute_up_decoder_OP1_33;
  reg        [4:0]    execute_up_decoder_RD_ADDR_FINAL;
  reg        [31:0]   execute_up_INSTRUCTION;
  reg        [31:0]   execute_up_PC;
  wire                execute_down_isReady;
  reg        [31:0]   decode_up_INSTRUCTION;
  reg        [31:0]   decode_up_PC;
  wire                decode_down_isReady;
  wire                fetch_down_isReady;
  reg                 execute_down_valid;
  reg                 execute_up_valid;
  reg                 decode_down_valid;
  reg                 decode_up_valid;
  reg                 fetch_down_valid;
  reg                 fetch_up_ready;
  wire                fetch_up_cancel;
  reg                 decode_up_ready;
  wire                decode_up_cancel;
  reg                 decode_down_ready;
  reg                 execute_up_ready;
  wire                execute_down_rvfi_valid;
  wire       [63:0]   execute_down_rvfi_order;
  wire       [31:0]   execute_down_rvfi_insn;
  wire                execute_down_rvfi_trap;
  wire                execute_down_rvfi_halt;
  wire                execute_down_rvfi_intr;
  wire       [4:0]    execute_down_rvfi_rs1_addr;
  wire       [4:0]    execute_down_rvfi_rs2_addr;
  wire       [31:0]   execute_down_rvfi_rs1_rdata;
  wire       [31:0]   execute_down_rvfi_rs2_rdata;
  wire       [4:0]    execute_down_rvfi_rd_addr;
  wire       [31:0]   execute_down_rvfi_rd_wdata;
  wire       [31:0]   execute_down_rvfi_pc_rdata;
  wire       [31:0]   execute_down_rvfi_pc_wdata;
  wire       [31:0]   execute_down_rvfi_mem_addr;
  wire       [3:0]    execute_down_rvfi_mem_rmask;
  wire       [3:0]    execute_down_rvfi_mem_wmask;
  wire       [31:0]   execute_down_rvfi_mem_rdata;
  wire       [31:0]   execute_down_rvfi_mem_wdata;
  wire       [31:0]   execute_down_rvfi_csr_mstatus_wmask;
  wire       [31:0]   execute_down_rvfi_csr_mstatus_wdata;
  wire       [31:0]   execute_down_rvfi_csr_mepc_wmask;
  wire       [31:0]   execute_down_rvfi_csr_mepc_wdata;
  wire       [31:0]   execute_down_rvfi_csr_mcause_wmask;
  wire       [31:0]   execute_down_rvfi_csr_mcause_wdata;
  wire       [1:0]    execute_down_rvfi_ixl;
  wire       [1:0]    execute_down_rvfi_mode;
  wire       [4:0]    execute_down_decoder_RD_ADDR_FINAL;
  wire       [31:0]   execute_down_PC;
  wire       [8:0]    execute_down_decoder_OP1_OP2_LSB;
  wire                execute_up_isValid;
  wire       [31:0]   execute_down_decoder_RS2_IMM;
  wire       [32:0]   execute_down_decoder_OP2_33;
  wire       [32:0]   execute_down_decoder_OP1_33;
  wire       [31:0]   execute_down_INSTRUCTION;
  wire       [12:0]   execute_down_decoder_ITYPE;
  wire                decode_down_rvfi_valid;
  wire       [63:0]   decode_down_rvfi_order;
  wire       [31:0]   decode_down_rvfi_insn;
  wire                decode_down_rvfi_trap;
  wire                decode_down_rvfi_halt;
  wire                decode_down_rvfi_intr;
  wire       [4:0]    decode_down_rvfi_rs1_addr;
  wire       [4:0]    decode_down_rvfi_rs2_addr;
  wire       [31:0]   decode_down_rvfi_rs1_rdata;
  wire       [31:0]   decode_down_rvfi_rs2_rdata;
  wire       [4:0]    decode_down_rvfi_rd_addr;
  wire       [31:0]   decode_down_rvfi_rd_wdata;
  wire       [31:0]   decode_down_rvfi_pc_rdata;
  wire       [31:0]   decode_down_rvfi_pc_wdata;
  wire       [31:0]   decode_down_rvfi_mem_addr;
  wire       [3:0]    decode_down_rvfi_mem_rmask;
  wire       [3:0]    decode_down_rvfi_mem_wmask;
  wire       [31:0]   decode_down_rvfi_mem_rdata;
  wire       [31:0]   decode_down_rvfi_mem_wdata;
  wire       [31:0]   decode_down_rvfi_csr_mstatus_wmask;
  wire       [31:0]   decode_down_rvfi_csr_mstatus_wdata;
  wire       [31:0]   decode_down_rvfi_csr_mepc_wmask;
  wire       [31:0]   decode_down_rvfi_csr_mepc_wdata;
  wire       [31:0]   decode_down_rvfi_csr_mcause_wmask;
  wire       [31:0]   decode_down_rvfi_csr_mcause_wdata;
  wire       [1:0]    decode_down_rvfi_ixl;
  wire       [1:0]    decode_down_rvfi_mode;
  wire       [12:0]   decode_down_decoder_ITYPE;
  wire       [31:0]   decode_down_decoder_RS2_IMM;
  wire       [8:0]    decode_down_decoder_OP1_OP2_LSB;
  wire       [32:0]   decode_down_decoder_OP2_33;
  wire       [32:0]   decode_down_decoder_OP1_33;
  wire       [4:0]    decode_down_decoder_MUL_OP;
  wire       [3:0]    decode_down_decoder_CSR_CMD;
  wire       [4:0]    decode_down_decoder_CSR_ZIMM;
  wire                decode_down_decoder_CSR_USE_IMM;
  wire       [11:0]   decode_down_decoder_CSR_ADDR;
  wire       [4:0]    decode_down_decoder_RD_ADDR_FINAL;
  wire                decode_up_isValid;
  wire       [31:0]   decode_down_PC;
  wire       [31:0]   decode_down_INSTRUCTION;
  wire       [31:0]   fetch_down_INSTRUCTION;
  reg                 fetch_down_ready;
  wire       [31:0]   fetch_down_PC;
  wire                fetch_up_valid;
  wire                fetch_up_isFiring;
  reg                 _zz_execute_haltRequest_rv_l275;
  reg        [63:0]   rvfiOrder;
  reg        [31:0]   Iptr;
  reg                 flush;
  reg                 init;
  reg                 irqSyncStage0;
  reg                 irqSync;
  wire       [4:0]    RegFile_rs1_rd_addr;
  wire       [4:0]    RegFile_rs2_rd_addr;
  wire       [31:0]   RegFile_rs1_data;
  wire       [31:0]   RegFile_rs2_data;
  wire                RegFile_rd_wr;
  wire       [4:0]    RegFile_rd_wr_addr;
  wire       [31:0]   RegFile_rd_wr_data;
  wire       [31:0]   RegFile_rs1;
  wire       [31:0]   RegFile_rs2;
  reg                 memory_isFetch;
  wire                memory_readDone;
  wire       [31:0]   memory_rdData;
  wire       [31:0]   memory_rdInst;
  wire                when_rv_l275;
  wire                execute_haltRequest_rv_l275;
  reg        [31:0]   memory_rdAddrI;
  wire                when_rv_l296;
  reg                 fetcher_delayFiring;
  reg                 fetcher_delayFiring2;
  reg                 memory_isFetch_regNext;
  wire                decode_throwWhen_rv_l322;
  wire       [31:0]   decoder_instr;
  wire       [31:0]   decoder_pc;
  wire       [6:0]    decoder_opcode;
  wire       [2:0]    decoder_funct3;
  wire       [6:0]    decoder_funct7;
  wire       [4:0]    decoder_rd_addr;
  wire       [4:0]    decoder_rs1_addr;
  wire       [4:0]    decoder_rs2_addr;
  reg        [12:0]   decoder_itype;
  reg        [7:0]    decoder_iformat;
  reg                 decoder_sub;
  reg                 decoder_unsigned;
  wire       [11:0]   decoder_csr_addr;
  wire                decoder_csr_use_imm;
  wire       [4:0]    decoder_csr_zimm;
  wire       [3:0]    decoder_csr_cmd;
  wire                decoder_csr_supported;
  wire       [4:0]    decoder_mul_op;
  wire                decoder_valid;
  reg        [1:0]    decoder_op1_kind;
  wire       [6:0]    switch_rv_l366;
  wire                when_rv_l383;
  wire                when_rv_l389;
  wire                when_rv_l397;
  wire                when_rv_l403;
  wire       [2:0]    switch_rv_l409;
  wire                when_rv_l427;
  wire                when_rv_l434;
  wire                when_rv_l444;
  wire       [9:0]    switch_rv_l483;
  wire                when_rv_l508;
  wire                _zz_decoder_i_imm;
  reg        [19:0]   _zz_decoder_i_imm_1;
  wire       [31:0]   decoder_i_imm;
  wire                _zz_decoder_s_imm;
  reg        [19:0]   _zz_decoder_s_imm_1;
  wire       [31:0]   decoder_s_imm;
  wire                _zz_decoder_b_imm;
  reg        [19:0]   _zz_decoder_b_imm_1;
  wire       [31:0]   decoder_b_imm;
  wire                _zz_decoder_j_imm;
  reg        [10:0]   _zz_decoder_j_imm_1;
  wire       [31:0]   decoder_j_imm;
  wire       [11:0]   _zz_decoder_u_imm;
  wire       [31:0]   decoder_u_imm;
  reg                 decoder_illegal_csr;
  wire                when_rv_l558;
  wire                decoder_trap;
  wire                decoder_rs1_valid;
  wire                decoder_rs2_valid;
  wire                decoder_rd_valid;
  wire       [4:0]    decoder_rd_addr_final;
  wire       [32:0]   decoder_rs1_33;
  wire       [32:0]   decoder_rs2_33;
  wire       [32:0]   decoder_op1_33;
  reg        [32:0]   _zz_decoder_op1_33;
  wire       [32:0]   decoder_op2_33;
  reg        [32:0]   _zz_decoder_op2_33;
  wire       [8:0]    decoder_op1_op2_lsb;
  wire       [31:0]   decoder_rs2_imm;
  reg        [31:0]   _zz_decoder_rs2_imm;
  wire       [12:0]   exec_itype;
  wire       [31:0]   exec_instr;
  wire       [2:0]    exec_funct3;
  wire       [32:0]   exec_op1_33;
  wire       [32:0]   exec_op2_33;
  wire       [31:0]   exec_op1;
  wire       [31:0]   exec_op2;
  wire       [20:0]   exec_imm;
  wire                exec_valid;
  wire                fetch_throwWhen_rv_l700;
  wire                decode_throwWhen_rv_l700;
  reg                 exec_alu_rd_wr;
  reg        [31:0]   exec_alu_rd_wdata;
  wire                exec_alu_op_cin;
  wire       [32:0]   exec_alu_alu_add_33;
  wire       [31:0]   exec_alu_rd_wdata_alu_add;
  wire       [31:0]   exec_alu_rd_wdata_alu_lt;
  wire                exec_shift_rd_wr;
  wire       [31:0]   exec_shift_rd_wdata;
  wire       [4:0]    exec_shift_shamt;
  wire                exec_shift_shleft;
  wire       [32:0]   exec_shift_op1_33;
  reg                 exec_jump_take_jump;
  reg                 exec_jump_pc_jump_valid;
  wire       [31:0]   exec_jump_pc_jump;
  reg                 exec_jump_clr_lsb;
  wire       [31:0]   exec_jump_pc;
  reg        [31:0]   exec_jump_pc_op1;
  wire       [31:0]   exec_jump_pc_plus4;
  reg                 exec_jump_rd_wr;
  wire       [31:0]   exec_jump_rd_wdata;
  wire                _zz_exec_jump_take_jump;
  wire                _zz_exec_jump_take_jump_1;
  reg                 _zz_exec_jump_take_jump_2;
  reg                 exec_lsu_rd_wr;
  reg        [31:0]   exec_lsu_rd_wdata;
  wire       [31:0]   exec_lsu_lsu_addr;
  wire       [1:0]    exec_lsu_size;
  reg        [31:0]   exec_lsu_mem_wdata;
  wire                when_rv_l820;
  reg        [31:0]   _zz_exec_lsu_mem_wdata;
  wire                when_rv_l829;
  wire                when_rv_l831;
  wire                _zz_exec_lsu_rd_wdata;
  wire       [31:0]   _zz_exec_lsu_rd_wdata_1;
  reg        [31:0]   _zz_exec_lsu_rd_wdata_2;
  wire                exec_irq_taken;
  wire       [31:0]   exec_irq_target;
  wire                exec_mret_taken;
  wire       [31:0]   exec_mret_target;
  wire                exec_csrMstatusWrite;
  wire       [31:0]   exec_csrMstatusWmask;
  wire       [31:0]   exec_csrMstatusWdata;
  wire                exec_csrMepcWrite;
  wire       [31:0]   exec_csrMepcWmask;
  wire       [31:0]   exec_csrMepcWdata;
  wire                exec_csrMcauseWrite;
  wire       [31:0]   exec_csrMcauseWmask;
  wire       [31:0]   exec_csrMcauseWdata;
  wire                exec_mul_rd_wr;
  wire       [31:0]   exec_mul_rd_wdata;
  wire                exec_csr_rd_wr;
  wire       [31:0]   exec_csr_rd_wdata;
  wire                exec_rd_wr;
  reg        [31:0]   _zz_exec_rd_wdata;
  reg        [31:0]   _zz_exec_rd_wdata_1;
  reg        [31:0]   _zz_exec_rd_wdata_2;
  reg        [31:0]   _zz_exec_rd_wdata_3;
  reg        [31:0]   _zz_exec_rd_wdata_4;
  reg        [31:0]   _zz_exec_rd_wdata_5;
  wire       [31:0]   exec_rd_wdata;
  reg                 _zz_rvfi_valid;
  wire                when_rv_l1146;
  wire       [1:0]    _zz_rvfi_trap;
  wire       [1:0]    _zz_rvfi_trap_1;
  wire                decode_up_forgetOne;
  wire                when_CtrlLink_l198;
  wire                when_CtrlLink_l202;
  wire                when_CtrlLink_l198_1;
  wire                when_CtrlLink_l202_1;
  wire                when_CtrlLink_l191;
  wire                when_StageLink_l71;
  wire                when_StageLink_l71_1;
  `ifndef SYNTHESIS
  reg [55:0] execute_up_decoder_ITYPE_string;
  reg [55:0] execute_down_decoder_ITYPE_string;
  reg [55:0] decode_down_decoder_ITYPE_string;
  reg [47:0] decode_down_decoder_MUL_OP_string;
  reg [39:0] decode_down_decoder_CSR_CMD_string;
  reg [55:0] decoder_itype_string;
  reg [39:0] decoder_iformat_string;
  reg [39:0] decoder_csr_cmd_string;
  reg [47:0] decoder_mul_op_string;
  reg [31:0] decoder_op1_kind_string;
  reg [55:0] exec_itype_string;
  `endif

  (* ram_style = "distributed" *) reg [31:0] RegFile_RegMem [0:31];

  assign _zz_fetch_down_PC = (Iptr - 32'h00000004);
  assign _zz_decoder_rs1_33_1 = RegFile_rs1_data;
  assign _zz_decoder_rs1_33 = {1'd0, _zz_decoder_rs1_33_1};
  assign _zz_decoder_rs1_33_3 = RegFile_rs1_data;
  assign _zz_decoder_rs1_33_2 = {{1{_zz_decoder_rs1_33_3[31]}}, _zz_decoder_rs1_33_3};
  assign _zz_decoder_rs2_33_1 = RegFile_rs2_data;
  assign _zz_decoder_rs2_33 = {1'd0, _zz_decoder_rs2_33_1};
  assign _zz_decoder_rs2_33_3 = RegFile_rs2_data;
  assign _zz_decoder_rs2_33_2 = {{1{_zz_decoder_rs2_33_3[31]}}, _zz_decoder_rs2_33_3};
  assign _zz__zz_decoder_op2_33_1 = decoder_i_imm;
  assign _zz__zz_decoder_op2_33 = {1'd0, _zz__zz_decoder_op2_33_1};
  assign _zz__zz_decoder_op2_33_2 = {{1{decoder_i_imm[31]}}, decoder_i_imm};
  assign _zz__zz_decoder_op2_33_3 = {{1{decoder_s_imm[31]}}, decoder_s_imm};
  assign _zz__zz_decoder_op2_33_4 = {{1{decoder_u_imm[31]}}, decoder_u_imm};
  assign _zz_decoder_op1_op2_lsb = _zz_decoder_op1_op2_lsb_1;
  assign _zz_decoder_op1_op2_lsb_1 = ({{1'b0,decoder_op1_33[7 : 0]},decoder_sub} + {{1'b0,decoder_op2_33[7 : 0]},decoder_sub});
  assign _zz__zz_decoder_rs2_imm = decoder_i_imm[20 : 0];
  assign _zz__zz_decoder_rs2_imm_1 = decoder_b_imm[20 : 0];
  assign _zz__zz_decoder_rs2_imm_2 = decoder_j_imm[20 : 0];
  assign _zz_exec_alu_alu_add_33 = _zz_exec_alu_alu_add_33_1;
  assign _zz_exec_alu_alu_add_33_1 = ($signed(_zz_exec_alu_alu_add_33_2) + $signed(_zz_exec_alu_alu_add_33_4));
  assign _zz_exec_alu_alu_add_33_2 = {_zz_exec_alu_alu_add_33_3,exec_alu_op_cin};
  assign _zz_exec_alu_alu_add_33_3 = exec_op1_33[32 : 8];
  assign _zz_exec_alu_alu_add_33_4 = {_zz_exec_alu_alu_add_33_5,exec_alu_op_cin};
  assign _zz_exec_alu_alu_add_33_5 = exec_op2_33[32 : 8];
  assign _zz_exec_alu_rd_wdata_alu_lt = exec_alu_alu_add_33[32];
  assign _zz_exec_alu_rd_wdata = (exec_op1 ^ exec_op2);
  assign _zz_exec_alu_rd_wdata_1 = (exec_op1 | exec_op2);
  assign _zz_exec_alu_rd_wdata_2 = (exec_op1 & exec_op2);
  assign _zz_exec_shift_shamt = exec_op2[4 : 0];
  assign _zz_exec_shift_op1_33 = {exec_op1[31],exec_op1};
  assign _zz_exec_shift_op1_33_1 = {1'b0,exec_op1};
  assign _zz_exec_shift_rd_wdata = _zz_exec_shift_rd_wdata_1;
  assign _zz_exec_shift_rd_wdata_1 = (exec_shift_shleft ? _zz_exec_shift_rd_wdata_2 : _zz_exec_shift_rd_wdata_3);
  assign _zz_exec_shift_rd_wdata_2 = ($signed(exec_shift_op1_33) <<< exec_shift_shamt);
  assign _zz_exec_shift_rd_wdata_3 = ($signed(exec_shift_op1_33) >>> exec_shift_shamt);
  assign _zz_exec_jump_pc_jump = ($signed(exec_jump_pc_op1) + $signed(_zz_exec_jump_pc_jump_1));
  assign _zz_exec_jump_pc_jump_1 = {{11{exec_imm[20]}}, exec_imm};
  assign _zz_exec_jump_pc_jump_3 = exec_jump_clr_lsb;
  assign _zz_exec_jump_pc_jump_2 = {31'd0, _zz_exec_jump_pc_jump_3};
  assign _zz__zz_exec_lsu_rd_wdata_1 = ({3'd0,exec_lsu_lsu_addr[1 : 0]} <<< 2'd3);
  assign _zz__zz_exec_lsu_rd_wdata_2_1 = _zz_exec_lsu_rd_wdata_1[7 : 0];
  assign _zz__zz_exec_lsu_rd_wdata_2 = {{24{_zz__zz_exec_lsu_rd_wdata_2_1[7]}}, _zz__zz_exec_lsu_rd_wdata_2_1};
  assign _zz__zz_exec_lsu_rd_wdata_2_3 = _zz_exec_lsu_rd_wdata_1[7 : 0];
  assign _zz__zz_exec_lsu_rd_wdata_2_2 = {24'd0, _zz__zz_exec_lsu_rd_wdata_2_3};
  assign _zz__zz_exec_lsu_rd_wdata_2_5 = _zz_exec_lsu_rd_wdata_1[15 : 0];
  assign _zz__zz_exec_lsu_rd_wdata_2_4 = {{16{_zz__zz_exec_lsu_rd_wdata_2_5[15]}}, _zz__zz_exec_lsu_rd_wdata_2_5};
  assign _zz__zz_exec_lsu_rd_wdata_2_7 = _zz_exec_lsu_rd_wdata_1[15 : 0];
  assign _zz__zz_exec_lsu_rd_wdata_2_6 = {16'd0, _zz__zz_exec_lsu_rd_wdata_2_7};
  assign RegFile_RegMem_spinal_port0 = RegFile_RegMem[RegFile_rs1_rd_addr];
  assign RegFile_RegMem_spinal_port1 = RegFile_RegMem[RegFile_rs2_rd_addr];
  always @(posedge clk) begin
    if(RegFile_rd_wr) begin
      RegFile_RegMem[RegFile_rd_wr_addr] <= RegFile_rd_wr_data;
    end
  end

  StreamFifo fetcher_fifo (
    .io_push_valid   (fetcher_delayFiring2             ), //i
    .io_push_ready   (fetcher_fifo_io_push_ready       ), //o
    .io_push_payload (memory_rdInst[31:0]              ), //i
    .io_pop_valid    (fetcher_fifo_io_pop_valid        ), //o
    .io_pop_ready    (fetch_down_ready                 ), //i
    .io_pop_payload  (fetcher_fifo_io_pop_payload[31:0]), //o
    .io_flush        (flush                            ), //i
    .io_occupancy    (fetcher_fifo_io_occupancy[1:0]   ), //o
    .io_availability (fetcher_fifo_io_availability[1:0]), //o
    .clk             (clk                              ), //i
    .reset           (reset                            )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(execute_up_decoder_ITYPE)
      InstrType_Undef : execute_up_decoder_ITYPE_string = "Undef  ";
      InstrType_JAL : execute_up_decoder_ITYPE_string = "JAL    ";
      InstrType_JALR : execute_up_decoder_ITYPE_string = "JALR   ";
      InstrType_B : execute_up_decoder_ITYPE_string = "B      ";
      InstrType_L : execute_up_decoder_ITYPE_string = "L      ";
      InstrType_S : execute_up_decoder_ITYPE_string = "S      ";
      InstrType_ALU_ADD : execute_up_decoder_ITYPE_string = "ALU_ADD";
      InstrType_ALU : execute_up_decoder_ITYPE_string = "ALU    ";
      InstrType_SHIFT : execute_up_decoder_ITYPE_string = "SHIFT  ";
      InstrType_FENCE : execute_up_decoder_ITYPE_string = "FENCE  ";
      InstrType_E : execute_up_decoder_ITYPE_string = "E      ";
      InstrType_CSR : execute_up_decoder_ITYPE_string = "CSR    ";
      InstrType_MULDIV : execute_up_decoder_ITYPE_string = "MULDIV ";
      default : execute_up_decoder_ITYPE_string = "???????";
    endcase
  end
  always @(*) begin
    case(execute_down_decoder_ITYPE)
      InstrType_Undef : execute_down_decoder_ITYPE_string = "Undef  ";
      InstrType_JAL : execute_down_decoder_ITYPE_string = "JAL    ";
      InstrType_JALR : execute_down_decoder_ITYPE_string = "JALR   ";
      InstrType_B : execute_down_decoder_ITYPE_string = "B      ";
      InstrType_L : execute_down_decoder_ITYPE_string = "L      ";
      InstrType_S : execute_down_decoder_ITYPE_string = "S      ";
      InstrType_ALU_ADD : execute_down_decoder_ITYPE_string = "ALU_ADD";
      InstrType_ALU : execute_down_decoder_ITYPE_string = "ALU    ";
      InstrType_SHIFT : execute_down_decoder_ITYPE_string = "SHIFT  ";
      InstrType_FENCE : execute_down_decoder_ITYPE_string = "FENCE  ";
      InstrType_E : execute_down_decoder_ITYPE_string = "E      ";
      InstrType_CSR : execute_down_decoder_ITYPE_string = "CSR    ";
      InstrType_MULDIV : execute_down_decoder_ITYPE_string = "MULDIV ";
      default : execute_down_decoder_ITYPE_string = "???????";
    endcase
  end
  always @(*) begin
    case(decode_down_decoder_ITYPE)
      InstrType_Undef : decode_down_decoder_ITYPE_string = "Undef  ";
      InstrType_JAL : decode_down_decoder_ITYPE_string = "JAL    ";
      InstrType_JALR : decode_down_decoder_ITYPE_string = "JALR   ";
      InstrType_B : decode_down_decoder_ITYPE_string = "B      ";
      InstrType_L : decode_down_decoder_ITYPE_string = "L      ";
      InstrType_S : decode_down_decoder_ITYPE_string = "S      ";
      InstrType_ALU_ADD : decode_down_decoder_ITYPE_string = "ALU_ADD";
      InstrType_ALU : decode_down_decoder_ITYPE_string = "ALU    ";
      InstrType_SHIFT : decode_down_decoder_ITYPE_string = "SHIFT  ";
      InstrType_FENCE : decode_down_decoder_ITYPE_string = "FENCE  ";
      InstrType_E : decode_down_decoder_ITYPE_string = "E      ";
      InstrType_CSR : decode_down_decoder_ITYPE_string = "CSR    ";
      InstrType_MULDIV : decode_down_decoder_ITYPE_string = "MULDIV ";
      default : decode_down_decoder_ITYPE_string = "???????";
    endcase
  end
  always @(*) begin
    case(decode_down_decoder_MUL_OP)
      MulOp_NONE : decode_down_decoder_MUL_OP_string = "NONE  ";
      MulOp_MUL : decode_down_decoder_MUL_OP_string = "MUL   ";
      MulOp_MULH : decode_down_decoder_MUL_OP_string = "MULH  ";
      MulOp_MULHSU : decode_down_decoder_MUL_OP_string = "MULHSU";
      MulOp_MULHU : decode_down_decoder_MUL_OP_string = "MULHU ";
      default : decode_down_decoder_MUL_OP_string = "??????";
    endcase
  end
  always @(*) begin
    case(decode_down_decoder_CSR_CMD)
      CsrCmd_NONE : decode_down_decoder_CSR_CMD_string = "NONE ";
      CsrCmd_WRITE : decode_down_decoder_CSR_CMD_string = "WRITE";
      CsrCmd_SET : decode_down_decoder_CSR_CMD_string = "SET  ";
      CsrCmd_CLEAR : decode_down_decoder_CSR_CMD_string = "CLEAR";
      default : decode_down_decoder_CSR_CMD_string = "?????";
    endcase
  end
  always @(*) begin
    case(decoder_itype)
      InstrType_Undef : decoder_itype_string = "Undef  ";
      InstrType_JAL : decoder_itype_string = "JAL    ";
      InstrType_JALR : decoder_itype_string = "JALR   ";
      InstrType_B : decoder_itype_string = "B      ";
      InstrType_L : decoder_itype_string = "L      ";
      InstrType_S : decoder_itype_string = "S      ";
      InstrType_ALU_ADD : decoder_itype_string = "ALU_ADD";
      InstrType_ALU : decoder_itype_string = "ALU    ";
      InstrType_SHIFT : decoder_itype_string = "SHIFT  ";
      InstrType_FENCE : decoder_itype_string = "FENCE  ";
      InstrType_E : decoder_itype_string = "E      ";
      InstrType_CSR : decoder_itype_string = "CSR    ";
      InstrType_MULDIV : decoder_itype_string = "MULDIV ";
      default : decoder_itype_string = "???????";
    endcase
  end
  always @(*) begin
    case(decoder_iformat)
      InstrFormat_R : decoder_iformat_string = "R    ";
      InstrFormat_I : decoder_iformat_string = "I    ";
      InstrFormat_S : decoder_iformat_string = "S    ";
      InstrFormat_B : decoder_iformat_string = "B    ";
      InstrFormat_U : decoder_iformat_string = "U    ";
      InstrFormat_J : decoder_iformat_string = "J    ";
      InstrFormat_Shamt : decoder_iformat_string = "Shamt";
      InstrFormat_CSR : decoder_iformat_string = "CSR  ";
      default : decoder_iformat_string = "?????";
    endcase
  end
  always @(*) begin
    case(decoder_csr_cmd)
      CsrCmd_NONE : decoder_csr_cmd_string = "NONE ";
      CsrCmd_WRITE : decoder_csr_cmd_string = "WRITE";
      CsrCmd_SET : decoder_csr_cmd_string = "SET  ";
      CsrCmd_CLEAR : decoder_csr_cmd_string = "CLEAR";
      default : decoder_csr_cmd_string = "?????";
    endcase
  end
  always @(*) begin
    case(decoder_mul_op)
      MulOp_NONE : decoder_mul_op_string = "NONE  ";
      MulOp_MUL : decoder_mul_op_string = "MUL   ";
      MulOp_MULH : decoder_mul_op_string = "MULH  ";
      MulOp_MULHSU : decoder_mul_op_string = "MULHSU";
      MulOp_MULHU : decoder_mul_op_string = "MULHU ";
      default : decoder_mul_op_string = "??????";
    endcase
  end
  always @(*) begin
    case(decoder_op1_kind)
      Op1Kind_Rs1 : decoder_op1_kind_string = "Rs1 ";
      Op1Kind_Zero : decoder_op1_kind_string = "Zero";
      Op1Kind_Pc : decoder_op1_kind_string = "Pc  ";
      default : decoder_op1_kind_string = "????";
    endcase
  end
  always @(*) begin
    case(exec_itype)
      InstrType_Undef : exec_itype_string = "Undef  ";
      InstrType_JAL : exec_itype_string = "JAL    ";
      InstrType_JALR : exec_itype_string = "JALR   ";
      InstrType_B : exec_itype_string = "B      ";
      InstrType_L : exec_itype_string = "L      ";
      InstrType_S : exec_itype_string = "S      ";
      InstrType_ALU_ADD : exec_itype_string = "ALU_ADD";
      InstrType_ALU : exec_itype_string = "ALU    ";
      InstrType_SHIFT : exec_itype_string = "SHIFT  ";
      InstrType_FENCE : exec_itype_string = "FENCE  ";
      InstrType_E : exec_itype_string = "E      ";
      InstrType_CSR : exec_itype_string = "CSR    ";
      InstrType_MULDIV : exec_itype_string = "MULDIV ";
      default : exec_itype_string = "???????";
    endcase
  end
  `endif

  always @(*) begin
    _zz_execute_haltRequest_rv_l275 = 1'b0;
    if(when_rv_l275) begin
      _zz_execute_haltRequest_rv_l275 = 1'b1;
    end
  end

  assign RegFile_rs1 = RegFile_RegMem_spinal_port0;
  assign RegFile_rs2 = RegFile_RegMem_spinal_port1;
  assign RegFile_rs1_data = ((RegFile_rs1_rd_addr == 5'h0) ? 32'h0 : ((RegFile_rs1_rd_addr == RegFile_rd_wr_addr) ? RegFile_rd_wr_data : RegFile_rs1));
  assign RegFile_rs2_data = ((RegFile_rs2_rd_addr == 5'h0) ? 32'h0 : ((RegFile_rs2_rd_addr == RegFile_rd_wr_addr) ? RegFile_rd_wr_data : RegFile_rs2));
  always @(*) begin
    memory_isFetch = 1'b1;
    if(when_rv_l296) begin
      memory_isFetch = 1'b0;
    end
  end

  always @(*) begin
    data_req_wren = 1'b0;
    data_req_rden = 1'b0;
    data_req_valid = 1'b0;
    data_req_rdaddr = 32'h0;
    data_req_wraddr = 32'h0;
    data_req_size = 2'b00;
    data_req_data = 32'h0;
    exec_lsu_rd_wr = 1'b0;
    exec_lsu_rd_wdata = 32'h0;
    exec_lsu_mem_wdata = 32'h0;
    if(when_rv_l820) begin
      exec_lsu_mem_wdata = _zz_exec_lsu_mem_wdata;
      data_req_wraddr = exec_lsu_lsu_addr;
      data_req_data = exec_lsu_mem_wdata;
      data_req_wren = 1'b1;
      data_req_size = exec_lsu_size;
      data_req_valid = 1'b1;
    end
    if(when_rv_l829) begin
      data_req_rdaddr = exec_lsu_lsu_addr;
      data_req_rden = 1'b1;
      data_req_valid = 1'b1;
      if(when_rv_l831) begin
        exec_lsu_rd_wr = 1'b1;
        exec_lsu_rd_wdata = _zz_exec_lsu_rd_wdata_2;
      end
    end
  end

  assign memory_rdData = data_rsp_data;
  assign memory_readDone = data_rsp_valid;
  assign when_rv_l275 = (data_req_valid && (! data_req_ready));
  assign execute_haltRequest_rv_l275 = _zz_execute_haltRequest_rv_l275;
  always @(*) begin
    memory_rdAddrI = 32'h0;
    if(init) begin
      memory_rdAddrI = Iptr;
    end
  end

  assign instr_req_addr = memory_rdAddrI;
  assign instr_req_valid = memory_isFetch;
  assign memory_rdInst = instr_rsp_data;
  assign when_rv_l296 = (! init);
  assign fetch_up_valid = memory_isFetch_regNext;
  assign fetch_down_PC = _zz_fetch_down_PC;
  assign fetch_down_INSTRUCTION = fetcher_fifo_io_pop_payload;
  assign decode_throwWhen_rv_l322 = (! fetcher_fifo_io_pop_valid);
  assign decoder_instr = decode_down_INSTRUCTION;
  assign decoder_pc = decode_down_PC;
  assign decoder_opcode = decoder_instr[6 : 0];
  assign decoder_funct3 = decoder_instr[14 : 12];
  assign decoder_funct7 = decoder_instr[31 : 25];
  assign decoder_rd_addr = decoder_instr[11 : 7];
  assign decoder_rs1_addr = decoder_instr[19 : 15];
  assign decoder_rs2_addr = decoder_instr[24 : 20];
  always @(*) begin
    decoder_sub = 1'b0;
    decoder_unsigned = 1'b0;
    decoder_iformat = InstrFormat_R;
    decoder_itype = InstrType_Undef;
    decoder_op1_kind = Op1Kind_Rs1;
    case(switch_rv_l366)
      7'h37 : begin
        decoder_itype = InstrType_ALU_ADD;
        decoder_iformat = InstrFormat_U;
        decoder_op1_kind = Op1Kind_Zero;
      end
      7'h17 : begin
        decoder_itype = InstrType_ALU_ADD;
        decoder_iformat = InstrFormat_U;
        decoder_op1_kind = Op1Kind_Pc;
      end
      7'h6f : begin
        decoder_itype = InstrType_JAL;
        decoder_iformat = InstrFormat_J;
        decoder_op1_kind = Op1Kind_Pc;
      end
      7'h67 : begin
        if(when_rv_l383) begin
          decoder_itype = InstrType_JALR;
        end
        decoder_iformat = InstrFormat_I;
      end
      7'h63 : begin
        if(when_rv_l389) begin
          decoder_itype = InstrType_B;
        end
        decoder_iformat = InstrFormat_B;
        decoder_unsigned = (decoder_funct3[2 : 1] == 2'b11);
        decoder_sub = (decoder_funct3[2 : 1] != 2'b00);
      end
      7'h03 : begin
        if(when_rv_l397) begin
          decoder_itype = InstrType_L;
        end
        decoder_iformat = InstrFormat_I;
      end
      7'h23 : begin
        if(when_rv_l403) begin
          decoder_itype = InstrType_S;
        end
        decoder_iformat = InstrFormat_S;
      end
      7'h13 : begin
        case(switch_rv_l409)
          3'b000 : begin
            decoder_itype = InstrType_ALU_ADD;
            decoder_iformat = InstrFormat_I;
          end
          3'b010, 3'b011 : begin
            decoder_itype = InstrType_ALU;
            decoder_iformat = InstrFormat_I;
            decoder_unsigned = decoder_funct3[0];
            decoder_sub = 1'b1;
          end
          3'b100, 3'b110, 3'b111 : begin
            decoder_itype = InstrType_ALU;
            decoder_iformat = InstrFormat_I;
          end
          3'b001 : begin
            if(when_rv_l427) begin
              decoder_itype = InstrType_SHIFT;
            end
            decoder_iformat = InstrFormat_Shamt;
          end
          default : begin
            if(when_rv_l434) begin
              decoder_itype = InstrType_SHIFT;
            end
            decoder_iformat = InstrFormat_Shamt;
          end
        endcase
      end
      7'h33 : begin
        decoder_iformat = InstrFormat_R;
        if(when_rv_l444) begin
          case(decoder_funct3)
            3'b000 : begin
              decoder_itype = InstrType_Undef;
            end
            3'b001 : begin
              decoder_itype = InstrType_Undef;
            end
            3'b010 : begin
              decoder_itype = InstrType_Undef;
            end
            3'b011 : begin
              decoder_itype = InstrType_Undef;
            end
            default : begin
              decoder_itype = InstrType_Undef;
            end
          endcase
        end else begin
          case(switch_rv_l483)
            10'h0, 10'h100 : begin
              decoder_itype = InstrType_ALU_ADD;
              decoder_sub = decoder_funct7[5];
            end
            10'h004, 10'h006, 10'h007 : begin
              decoder_itype = InstrType_ALU;
            end
            10'h001, 10'h005, 10'h105 : begin
              decoder_itype = InstrType_SHIFT;
            end
            10'h002, 10'h003 : begin
              decoder_itype = InstrType_ALU;
              decoder_unsigned = decoder_funct3[0];
              decoder_sub = 1'b1;
            end
            default : begin
            end
          endcase
        end
      end
      7'h73 : begin
        if(when_rv_l508) begin
          decoder_itype = InstrType_E;
          decoder_iformat = InstrFormat_I;
        end else begin
          decoder_itype = InstrType_Undef;
        end
      end
      default : begin
      end
    endcase
  end

  assign decoder_csr_use_imm = 1'b0;
  assign decoder_csr_supported = 1'b0;
  assign decoder_csr_addr = decoder_instr[31 : 20];
  assign decoder_csr_zimm = decoder_instr[19 : 15];
  assign decoder_csr_cmd = CsrCmd_NONE;
  assign decoder_mul_op = MulOp_NONE;
  assign decoder_valid = decode_up_isValid;
  assign switch_rv_l366 = decoder_opcode;
  assign when_rv_l383 = (decoder_funct3 == 3'b000);
  assign when_rv_l389 = ((decoder_funct3 != 3'b010) && (decoder_funct3 != 3'b011));
  assign when_rv_l397 = (((decoder_funct3 != 3'b011) && (decoder_funct3 != 3'b110)) && (decoder_funct3 != 3'b111));
  assign when_rv_l403 = (((decoder_funct3 == 3'b000) || (decoder_funct3 == 3'b001)) || (decoder_funct3 == 3'b010));
  assign switch_rv_l409 = decoder_funct3;
  assign when_rv_l427 = (decoder_funct7 == 7'h0);
  assign when_rv_l434 = ((decoder_funct7 == 7'h0) || (decoder_funct7 == 7'h20));
  assign when_rv_l444 = (decoder_funct7 == 7'h01);
  assign switch_rv_l483 = {decoder_funct7,decoder_funct3};
  assign when_rv_l508 = (decoder_funct3 == 3'b000);
  assign _zz_decoder_i_imm = decoder_instr[31];
  always @(*) begin
    _zz_decoder_i_imm_1[19] = _zz_decoder_i_imm;
    _zz_decoder_i_imm_1[18] = _zz_decoder_i_imm;
    _zz_decoder_i_imm_1[17] = _zz_decoder_i_imm;
    _zz_decoder_i_imm_1[16] = _zz_decoder_i_imm;
    _zz_decoder_i_imm_1[15] = _zz_decoder_i_imm;
    _zz_decoder_i_imm_1[14] = _zz_decoder_i_imm;
    _zz_decoder_i_imm_1[13] = _zz_decoder_i_imm;
    _zz_decoder_i_imm_1[12] = _zz_decoder_i_imm;
    _zz_decoder_i_imm_1[11] = _zz_decoder_i_imm;
    _zz_decoder_i_imm_1[10] = _zz_decoder_i_imm;
    _zz_decoder_i_imm_1[9] = _zz_decoder_i_imm;
    _zz_decoder_i_imm_1[8] = _zz_decoder_i_imm;
    _zz_decoder_i_imm_1[7] = _zz_decoder_i_imm;
    _zz_decoder_i_imm_1[6] = _zz_decoder_i_imm;
    _zz_decoder_i_imm_1[5] = _zz_decoder_i_imm;
    _zz_decoder_i_imm_1[4] = _zz_decoder_i_imm;
    _zz_decoder_i_imm_1[3] = _zz_decoder_i_imm;
    _zz_decoder_i_imm_1[2] = _zz_decoder_i_imm;
    _zz_decoder_i_imm_1[1] = _zz_decoder_i_imm;
    _zz_decoder_i_imm_1[0] = _zz_decoder_i_imm;
  end

  assign decoder_i_imm = {_zz_decoder_i_imm_1,decoder_instr[31 : 20]};
  assign _zz_decoder_s_imm = decoder_instr[31];
  always @(*) begin
    _zz_decoder_s_imm_1[19] = _zz_decoder_s_imm;
    _zz_decoder_s_imm_1[18] = _zz_decoder_s_imm;
    _zz_decoder_s_imm_1[17] = _zz_decoder_s_imm;
    _zz_decoder_s_imm_1[16] = _zz_decoder_s_imm;
    _zz_decoder_s_imm_1[15] = _zz_decoder_s_imm;
    _zz_decoder_s_imm_1[14] = _zz_decoder_s_imm;
    _zz_decoder_s_imm_1[13] = _zz_decoder_s_imm;
    _zz_decoder_s_imm_1[12] = _zz_decoder_s_imm;
    _zz_decoder_s_imm_1[11] = _zz_decoder_s_imm;
    _zz_decoder_s_imm_1[10] = _zz_decoder_s_imm;
    _zz_decoder_s_imm_1[9] = _zz_decoder_s_imm;
    _zz_decoder_s_imm_1[8] = _zz_decoder_s_imm;
    _zz_decoder_s_imm_1[7] = _zz_decoder_s_imm;
    _zz_decoder_s_imm_1[6] = _zz_decoder_s_imm;
    _zz_decoder_s_imm_1[5] = _zz_decoder_s_imm;
    _zz_decoder_s_imm_1[4] = _zz_decoder_s_imm;
    _zz_decoder_s_imm_1[3] = _zz_decoder_s_imm;
    _zz_decoder_s_imm_1[2] = _zz_decoder_s_imm;
    _zz_decoder_s_imm_1[1] = _zz_decoder_s_imm;
    _zz_decoder_s_imm_1[0] = _zz_decoder_s_imm;
  end

  assign decoder_s_imm = {{_zz_decoder_s_imm_1,decoder_instr[31 : 25]},decoder_instr[11 : 7]};
  assign _zz_decoder_b_imm = decoder_instr[31];
  always @(*) begin
    _zz_decoder_b_imm_1[19] = _zz_decoder_b_imm;
    _zz_decoder_b_imm_1[18] = _zz_decoder_b_imm;
    _zz_decoder_b_imm_1[17] = _zz_decoder_b_imm;
    _zz_decoder_b_imm_1[16] = _zz_decoder_b_imm;
    _zz_decoder_b_imm_1[15] = _zz_decoder_b_imm;
    _zz_decoder_b_imm_1[14] = _zz_decoder_b_imm;
    _zz_decoder_b_imm_1[13] = _zz_decoder_b_imm;
    _zz_decoder_b_imm_1[12] = _zz_decoder_b_imm;
    _zz_decoder_b_imm_1[11] = _zz_decoder_b_imm;
    _zz_decoder_b_imm_1[10] = _zz_decoder_b_imm;
    _zz_decoder_b_imm_1[9] = _zz_decoder_b_imm;
    _zz_decoder_b_imm_1[8] = _zz_decoder_b_imm;
    _zz_decoder_b_imm_1[7] = _zz_decoder_b_imm;
    _zz_decoder_b_imm_1[6] = _zz_decoder_b_imm;
    _zz_decoder_b_imm_1[5] = _zz_decoder_b_imm;
    _zz_decoder_b_imm_1[4] = _zz_decoder_b_imm;
    _zz_decoder_b_imm_1[3] = _zz_decoder_b_imm;
    _zz_decoder_b_imm_1[2] = _zz_decoder_b_imm;
    _zz_decoder_b_imm_1[1] = _zz_decoder_b_imm;
    _zz_decoder_b_imm_1[0] = _zz_decoder_b_imm;
  end

  assign decoder_b_imm = {{{{_zz_decoder_b_imm_1,decoder_instr[7]},decoder_instr[30 : 25]},decoder_instr[11 : 8]},1'b0};
  assign _zz_decoder_j_imm = decoder_instr[31];
  always @(*) begin
    _zz_decoder_j_imm_1[10] = _zz_decoder_j_imm;
    _zz_decoder_j_imm_1[9] = _zz_decoder_j_imm;
    _zz_decoder_j_imm_1[8] = _zz_decoder_j_imm;
    _zz_decoder_j_imm_1[7] = _zz_decoder_j_imm;
    _zz_decoder_j_imm_1[6] = _zz_decoder_j_imm;
    _zz_decoder_j_imm_1[5] = _zz_decoder_j_imm;
    _zz_decoder_j_imm_1[4] = _zz_decoder_j_imm;
    _zz_decoder_j_imm_1[3] = _zz_decoder_j_imm;
    _zz_decoder_j_imm_1[2] = _zz_decoder_j_imm;
    _zz_decoder_j_imm_1[1] = _zz_decoder_j_imm;
    _zz_decoder_j_imm_1[0] = _zz_decoder_j_imm;
  end

  assign decoder_j_imm = {{{{{_zz_decoder_j_imm_1,decoder_instr[31]},decoder_instr[19 : 12]},decoder_instr[20]},decoder_instr[30 : 21]},1'b0};
  assign _zz_decoder_u_imm[11 : 0] = 12'h0;
  assign decoder_u_imm = {decoder_instr[31 : 12],_zz_decoder_u_imm};
  always @(*) begin
    decoder_illegal_csr = 1'b0;
    if(when_rv_l558) begin
      decoder_illegal_csr = 1'b1;
    end
  end

  assign when_rv_l558 = (decoder_itype[InstrType_CSR_OH_ID]);
  assign decoder_trap = ((decoder_itype[InstrType_Undef_OH_ID]) || decoder_illegal_csr);
  assign decoder_rs1_valid = (((((((decoder_iformat[InstrFormat_R_OH_ID]) || (decoder_iformat[InstrFormat_I_OH_ID])) || (decoder_iformat[InstrFormat_S_OH_ID])) || (decoder_iformat[InstrFormat_B_OH_ID])) || (decoder_iformat[InstrFormat_Shamt_OH_ID])) || ((decoder_iformat[InstrFormat_CSR_OH_ID]) && (! decoder_csr_use_imm))) && (! decoder_trap));
  assign decoder_rs2_valid = ((((decoder_iformat[InstrFormat_R_OH_ID]) || (decoder_iformat[InstrFormat_S_OH_ID])) || (decoder_iformat[InstrFormat_B_OH_ID])) && (! decoder_trap));
  assign decoder_rd_valid = ((((((decoder_iformat[InstrFormat_R_OH_ID]) || (decoder_iformat[InstrFormat_I_OH_ID])) || (decoder_iformat[InstrFormat_U_OH_ID])) || (decoder_iformat[InstrFormat_J_OH_ID])) || (decoder_iformat[InstrFormat_Shamt_OH_ID])) || (decoder_iformat[InstrFormat_CSR_OH_ID]));
  assign decoder_rd_addr_final = (decoder_rd_valid ? decoder_rd_addr : 5'h0);
  assign decode_down_decoder_RD_ADDR_FINAL = decoder_rd_addr_final;
  assign decode_down_decoder_CSR_ADDR = decoder_csr_addr;
  assign decode_down_decoder_CSR_USE_IMM = decoder_csr_use_imm;
  assign decode_down_decoder_CSR_ZIMM = decoder_csr_zimm;
  assign decode_down_decoder_CSR_CMD = decoder_csr_cmd;
  assign decode_down_decoder_MUL_OP = decoder_mul_op;
  assign decoder_rs1_33 = (decoder_unsigned ? _zz_decoder_rs1_33 : _zz_decoder_rs1_33_2);
  assign decoder_rs2_33 = (decoder_unsigned ? _zz_decoder_rs2_33 : _zz_decoder_rs2_33_2);
  always @(*) begin
    case(decoder_op1_kind)
      Op1Kind_Rs1 : begin
        _zz_decoder_op1_33 = decoder_rs1_33;
      end
      Op1Kind_Zero : begin
        _zz_decoder_op1_33 = 33'h0;
      end
      default : begin
        _zz_decoder_op1_33 = {1'd0, decoder_pc};
      end
    endcase
  end

  assign decoder_op1_33 = _zz_decoder_op1_33;
  assign decode_down_decoder_OP1_33 = decoder_op1_33;
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (decoder_iformat[InstrFormat_R_OH_ID]) : begin
        _zz_decoder_op2_33 = decoder_rs2_33;
      end
      (decoder_iformat[InstrFormat_I_OH_ID]) : begin
        _zz_decoder_op2_33 = (decoder_unsigned ? _zz__zz_decoder_op2_33 : _zz__zz_decoder_op2_33_2);
      end
      (decoder_iformat[InstrFormat_S_OH_ID]) : begin
        _zz_decoder_op2_33 = _zz__zz_decoder_op2_33_3;
      end
      (decoder_iformat[InstrFormat_U_OH_ID]) : begin
        _zz_decoder_op2_33 = _zz__zz_decoder_op2_33_4;
      end
      (decoder_iformat[InstrFormat_Shamt_OH_ID]) : begin
        _zz_decoder_op2_33 = {decoder_rs2_33[32 : 5],decoder_instr[24 : 20]};
      end
      default : begin
        _zz_decoder_op2_33 = decoder_rs2_33;
      end
    endcase
  end

  assign decoder_op2_33 = (_zz_decoder_op2_33 ^ (decoder_sub ? 33'h1ffffffff : 33'h0));
  assign decode_down_decoder_OP2_33 = decoder_op2_33;
  assign decoder_op1_op2_lsb = _zz_decoder_op1_op2_lsb[9 : 1];
  assign decode_down_decoder_OP1_OP2_LSB = decoder_op1_op2_lsb;
  always @(*) begin
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (decoder_iformat[InstrFormat_I_OH_ID]) : begin
        _zz_decoder_rs2_imm = {RegFile_rs2_data[31 : 21],_zz__zz_decoder_rs2_imm};
      end
      (decoder_iformat[InstrFormat_B_OH_ID]) : begin
        _zz_decoder_rs2_imm = {RegFile_rs2_data[31 : 21],_zz__zz_decoder_rs2_imm_1};
      end
      (decoder_iformat[InstrFormat_J_OH_ID]) : begin
        _zz_decoder_rs2_imm = {RegFile_rs2_data[31 : 21],_zz__zz_decoder_rs2_imm_2};
      end
      default : begin
        _zz_decoder_rs2_imm = RegFile_rs2_data;
      end
    endcase
  end

  assign decoder_rs2_imm = _zz_decoder_rs2_imm;
  assign decode_down_decoder_RS2_IMM = decoder_rs2_imm;
  assign decode_down_decoder_ITYPE = decoder_itype;
  assign RegFile_rs1_rd_addr = decoder_rs1_addr;
  assign RegFile_rs2_rd_addr = decoder_rs2_addr;
  assign decode_down_rvfi_valid = decode_up_isValid;
  assign decode_down_rvfi_order = rvfiOrder;
  assign decode_down_rvfi_insn = decoder_instr;
  assign decode_down_rvfi_trap = decoder_trap;
  assign decode_down_rvfi_halt = 1'b0;
  assign decode_down_rvfi_intr = 1'b0;
  assign decode_down_rvfi_rs1_addr = (decoder_rs1_valid ? decoder_rs1_addr : 5'h0);
  assign decode_down_rvfi_rs2_addr = (decoder_rs2_valid ? decoder_rs2_addr : 5'h0);
  assign decode_down_rvfi_rs1_rdata = (decoder_rs1_valid ? RegFile_rs1_data : 32'h0);
  assign decode_down_rvfi_rs2_rdata = (decoder_rs2_valid ? RegFile_rs2_data : 32'h0);
  assign decode_down_rvfi_rd_addr = ((! decoder_trap) ? decoder_rd_addr_final : 5'h0);
  assign decode_down_rvfi_rd_wdata = 32'h0;
  assign decode_down_rvfi_pc_rdata = decoder_pc;
  assign decode_down_rvfi_pc_wdata = 32'h0;
  assign decode_down_rvfi_mem_addr = 32'h0;
  assign decode_down_rvfi_mem_rmask = 4'b0000;
  assign decode_down_rvfi_mem_wmask = 4'b0000;
  assign decode_down_rvfi_mem_rdata = 32'h0;
  assign decode_down_rvfi_mem_wdata = 32'h0;
  assign exec_itype = execute_down_decoder_ITYPE;
  assign exec_instr = execute_down_INSTRUCTION;
  assign exec_funct3 = exec_instr[14 : 12];
  assign exec_op1_33 = execute_down_decoder_OP1_33;
  assign exec_op2_33 = execute_down_decoder_OP2_33;
  assign exec_op1 = exec_op1_33[31 : 0];
  assign exec_op2 = exec_op2_33[31 : 0];
  assign exec_imm = execute_down_decoder_RS2_IMM[20 : 0];
  assign exec_valid = execute_up_isValid;
  always @(*) begin
    flush = 1'b0;
    if(exec_jump_take_jump) begin
      flush = 1'b1;
    end
    if(exec_irq_taken) begin
      flush = 1'b1;
    end else begin
      if(exec_mret_taken) begin
        flush = 1'b1;
      end else begin
        if(exec_jump_take_jump) begin
          flush = 1'b1;
        end
      end
    end
  end

  assign fetch_throwWhen_rv_l700 = flush;
  assign decode_throwWhen_rv_l700 = flush;
  always @(*) begin
    exec_alu_rd_wr = 1'b0;
    exec_alu_rd_wdata = exec_alu_rd_wdata_alu_add;
    (* parallel_case *)
    case(1) // synthesis parallel_case
      (exec_itype[InstrType_ALU_ADD_OH_ID]) : begin
        exec_alu_rd_wr = 1'b1;
        exec_alu_rd_wdata = exec_alu_rd_wdata_alu_add;
      end
      (exec_itype[InstrType_ALU_OH_ID]) : begin
        case(exec_funct3)
          3'b010, 3'b011 : begin
            exec_alu_rd_wr = 1'b1;
            exec_alu_rd_wdata = exec_alu_rd_wdata_alu_lt;
          end
          3'b100 : begin
            exec_alu_rd_wr = 1'b1;
            exec_alu_rd_wdata = _zz_exec_alu_rd_wdata;
          end
          3'b110 : begin
            exec_alu_rd_wr = 1'b1;
            exec_alu_rd_wdata = _zz_exec_alu_rd_wdata_1;
          end
          3'b111 : begin
            exec_alu_rd_wr = 1'b1;
            exec_alu_rd_wdata = _zz_exec_alu_rd_wdata_2;
          end
          default : begin
          end
        endcase
      end
      default : begin
      end
    endcase
  end

  assign exec_alu_op_cin = execute_down_decoder_OP1_OP2_LSB[8];
  assign exec_alu_alu_add_33 = {_zz_exec_alu_alu_add_33[25 : 1],execute_down_decoder_OP1_OP2_LSB[7 : 0]};
  assign exec_alu_rd_wdata_alu_add = exec_alu_alu_add_33[31 : 0];
  assign exec_alu_rd_wdata_alu_lt = {31'd0, _zz_exec_alu_rd_wdata_alu_lt};
  assign exec_shift_rd_wr = (exec_itype[InstrType_SHIFT_OH_ID]);
  assign exec_shift_shamt = _zz_exec_shift_shamt;
  assign exec_shift_shleft = (! exec_funct3[2]);
  assign exec_shift_op1_33 = (exec_instr[30] ? _zz_exec_shift_op1_33 : _zz_exec_shift_op1_33_1);
  assign exec_shift_rd_wdata = _zz_exec_shift_rd_wdata[31 : 0];
  always @(*) begin
    exec_jump_take_jump = 1'b0;
    exec_jump_pc_jump_valid = 1'b0;
    exec_jump_clr_lsb = 1'b0;
    exec_jump_pc_op1 = exec_jump_pc;
    exec_jump_rd_wr = 1'b0;
    if(execute_up_isValid) begin
      (* parallel_case *)
      case(1) // synthesis parallel_case
        (exec_itype[InstrType_B_OH_ID]) : begin
          exec_jump_pc_jump_valid = 1'b1;
          exec_jump_take_jump = _zz_exec_jump_take_jump_2;
        end
        (exec_itype[InstrType_JAL_OH_ID]) : begin
          exec_jump_pc_jump_valid = 1'b1;
          exec_jump_take_jump = 1'b1;
          exec_jump_rd_wr = 1'b1;
        end
        (exec_itype[InstrType_JALR_OH_ID]) : begin
          exec_jump_pc_jump_valid = 1'b1;
          exec_jump_pc_op1 = exec_op1;
          exec_jump_take_jump = 1'b1;
          exec_jump_clr_lsb = 1'b1;
          exec_jump_rd_wr = 1'b1;
        end
        default : begin
        end
      endcase
    end
  end

  assign exec_jump_pc = execute_down_PC;
  assign exec_jump_pc_plus4 = (exec_jump_pc + 32'h00000004);
  assign exec_jump_rd_wdata = exec_jump_pc_plus4;
  assign _zz_exec_jump_take_jump = ($signed(exec_op1) == $signed(exec_op2));
  assign _zz_exec_jump_take_jump_1 = exec_alu_rd_wdata_alu_lt[0];
  always @(*) begin
    _zz_exec_jump_take_jump_2 = 1'b0;
    case(exec_funct3)
      3'b000 : begin
        _zz_exec_jump_take_jump_2 = _zz_exec_jump_take_jump;
      end
      3'b001 : begin
        _zz_exec_jump_take_jump_2 = (! _zz_exec_jump_take_jump);
      end
      3'b100, 3'b110 : begin
        _zz_exec_jump_take_jump_2 = _zz_exec_jump_take_jump_1;
      end
      3'b101, 3'b111 : begin
        _zz_exec_jump_take_jump_2 = (! _zz_exec_jump_take_jump_1);
      end
      default : begin
      end
    endcase
  end

  assign exec_jump_pc_jump = ((exec_jump_take_jump ? _zz_exec_jump_pc_jump : exec_jump_pc_plus4) & (~ _zz_exec_jump_pc_jump_2));
  assign exec_lsu_lsu_addr = exec_alu_rd_wdata_alu_add;
  assign exec_lsu_size = exec_funct3[1 : 0];
  assign when_rv_l820 = (exec_itype[InstrType_S_OH_ID]);
  always @(*) begin
    case(exec_lsu_size)
      2'b00 : begin
        _zz_exec_lsu_mem_wdata = {{{execute_down_decoder_RS2_IMM[7 : 0],execute_down_decoder_RS2_IMM[7 : 0]},execute_down_decoder_RS2_IMM[7 : 0]},execute_down_decoder_RS2_IMM[7 : 0]};
      end
      2'b01 : begin
        _zz_exec_lsu_mem_wdata = {execute_down_decoder_RS2_IMM[15 : 0],execute_down_decoder_RS2_IMM[15 : 0]};
      end
      default : begin
        _zz_exec_lsu_mem_wdata = execute_down_decoder_RS2_IMM;
      end
    endcase
  end

  assign when_rv_l829 = (exec_itype[InstrType_L_OH_ID]);
  assign when_rv_l831 = (memory_readDone == 1'b1);
  assign _zz_exec_lsu_rd_wdata = (! exec_funct3[2]);
  assign _zz_exec_lsu_rd_wdata_1 = (memory_rdData >>> _zz__zz_exec_lsu_rd_wdata_1);
  always @(*) begin
    case(exec_lsu_size)
      2'b00 : begin
        _zz_exec_lsu_rd_wdata_2 = (_zz_exec_lsu_rd_wdata ? _zz__zz_exec_lsu_rd_wdata_2 : _zz__zz_exec_lsu_rd_wdata_2_2);
      end
      2'b01 : begin
        _zz_exec_lsu_rd_wdata_2 = (_zz_exec_lsu_rd_wdata ? _zz__zz_exec_lsu_rd_wdata_2_4 : _zz__zz_exec_lsu_rd_wdata_2_6);
      end
      default : begin
        _zz_exec_lsu_rd_wdata_2 = _zz_exec_lsu_rd_wdata_1;
      end
    endcase
  end

  assign exec_irq_taken = 1'b0;
  assign exec_irq_target = 32'h0;
  assign exec_mret_taken = 1'b0;
  assign exec_mret_target = 32'h0;
  assign exec_csrMstatusWrite = 1'b0;
  assign exec_csrMstatusWmask = 32'h0;
  assign exec_csrMstatusWdata = 32'h0;
  assign exec_csrMepcWrite = 1'b0;
  assign exec_csrMepcWmask = 32'h0;
  assign exec_csrMepcWdata = 32'h0;
  assign exec_csrMcauseWrite = 1'b0;
  assign exec_csrMcauseWmask = 32'h0;
  assign exec_csrMcauseWdata = 32'h0;
  assign exec_mul_rd_wr = 1'b0;
  assign exec_mul_rd_wdata = 32'h0;
  assign exec_csr_rd_wr = 1'b0;
  assign exec_csr_rd_wdata = 32'h0;
  assign exec_rd_wr = ((execute_up_isValid && (((((exec_alu_rd_wr || exec_jump_rd_wr) || exec_shift_rd_wr) || exec_lsu_rd_wr) || exec_mul_rd_wr) || exec_csr_rd_wr)) && (execute_down_decoder_RD_ADDR_FINAL != 5'h0));
  always @(*) begin
    _zz_exec_rd_wdata[0] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[1] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[2] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[3] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[4] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[5] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[6] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[7] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[8] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[9] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[10] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[11] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[12] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[13] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[14] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[15] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[16] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[17] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[18] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[19] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[20] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[21] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[22] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[23] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[24] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[25] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[26] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[27] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[28] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[29] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[30] = exec_alu_rd_wr;
    _zz_exec_rd_wdata[31] = exec_alu_rd_wr;
  end

  always @(*) begin
    _zz_exec_rd_wdata_1[0] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[1] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[2] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[3] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[4] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[5] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[6] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[7] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[8] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[9] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[10] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[11] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[12] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[13] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[14] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[15] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[16] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[17] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[18] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[19] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[20] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[21] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[22] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[23] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[24] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[25] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[26] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[27] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[28] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[29] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[30] = exec_jump_rd_wr;
    _zz_exec_rd_wdata_1[31] = exec_jump_rd_wr;
  end

  always @(*) begin
    _zz_exec_rd_wdata_2[0] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[1] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[2] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[3] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[4] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[5] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[6] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[7] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[8] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[9] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[10] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[11] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[12] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[13] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[14] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[15] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[16] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[17] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[18] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[19] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[20] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[21] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[22] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[23] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[24] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[25] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[26] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[27] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[28] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[29] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[30] = exec_shift_rd_wr;
    _zz_exec_rd_wdata_2[31] = exec_shift_rd_wr;
  end

  always @(*) begin
    _zz_exec_rd_wdata_3[0] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[1] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[2] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[3] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[4] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[5] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[6] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[7] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[8] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[9] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[10] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[11] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[12] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[13] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[14] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[15] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[16] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[17] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[18] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[19] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[20] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[21] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[22] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[23] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[24] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[25] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[26] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[27] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[28] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[29] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[30] = exec_lsu_rd_wr;
    _zz_exec_rd_wdata_3[31] = exec_lsu_rd_wr;
  end

  always @(*) begin
    _zz_exec_rd_wdata_4[0] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[1] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[2] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[3] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[4] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[5] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[6] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[7] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[8] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[9] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[10] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[11] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[12] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[13] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[14] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[15] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[16] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[17] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[18] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[19] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[20] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[21] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[22] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[23] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[24] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[25] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[26] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[27] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[28] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[29] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[30] = exec_mul_rd_wr;
    _zz_exec_rd_wdata_4[31] = exec_mul_rd_wr;
  end

  always @(*) begin
    _zz_exec_rd_wdata_5[0] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[1] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[2] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[3] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[4] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[5] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[6] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[7] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[8] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[9] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[10] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[11] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[12] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[13] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[14] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[15] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[16] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[17] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[18] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[19] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[20] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[21] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[22] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[23] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[24] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[25] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[26] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[27] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[28] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[29] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[30] = exec_csr_rd_wr;
    _zz_exec_rd_wdata_5[31] = exec_csr_rd_wr;
  end

  assign exec_rd_wdata = ((((((_zz_exec_rd_wdata & exec_alu_rd_wdata) | (_zz_exec_rd_wdata_1 & exec_jump_rd_wdata)) | (_zz_exec_rd_wdata_2 & exec_shift_rd_wdata)) | (_zz_exec_rd_wdata_3 & exec_lsu_rd_wdata)) | (_zz_exec_rd_wdata_4 & exec_mul_rd_wdata)) | (_zz_exec_rd_wdata_5 & exec_csr_rd_wdata));
  assign RegFile_rd_wr = exec_rd_wr;
  assign RegFile_rd_wr_addr = execute_down_decoder_RD_ADDR_FINAL;
  assign RegFile_rd_wr_data = exec_rd_wdata;
  assign when_rv_l1146 = ((execute_up_isValid && exec_jump_pc_jump_valid) && (! (exec_jump_pc_jump[1 : 0] == 2'b00)));
  assign _zz_rvfi_trap = exec_funct3[1 : 0];
  assign _zz_rvfi_trap_1 = exec_funct3[1 : 0];
  assign decode_up_forgetOne = (|decode_throwWhen_rv_l322);
  assign decode_up_cancel = (|{decode_throwWhen_rv_l700,decode_throwWhen_rv_l322});
  assign fetch_up_cancel = (|fetch_throwWhen_rv_l700);
  always @(*) begin
    fetch_down_valid = fetch_up_valid;
    if(when_CtrlLink_l198) begin
      fetch_down_valid = 1'b0;
    end
  end

  always @(*) begin
    fetch_up_ready = fetch_down_isReady;
    if(when_CtrlLink_l202) begin
      fetch_up_ready = 1'b1;
    end
  end

  assign when_CtrlLink_l198 = (|fetch_throwWhen_rv_l700);
  assign when_CtrlLink_l202 = (|fetch_throwWhen_rv_l700);
  always @(*) begin
    decode_down_valid = decode_up_valid;
    if(when_CtrlLink_l198_1) begin
      decode_down_valid = 1'b0;
    end
  end

  always @(*) begin
    decode_up_ready = decode_down_isReady;
    if(when_CtrlLink_l202_1) begin
      decode_up_ready = 1'b1;
    end
  end

  assign when_CtrlLink_l198_1 = (|{decode_throwWhen_rv_l700,decode_throwWhen_rv_l322});
  assign when_CtrlLink_l202_1 = (|decode_throwWhen_rv_l700);
  assign decode_down_PC = decode_up_PC;
  assign decode_down_INSTRUCTION = decode_up_INSTRUCTION;
  always @(*) begin
    execute_down_valid = execute_up_valid;
    execute_up_ready = execute_down_isReady;
    if(when_CtrlLink_l191) begin
      execute_down_valid = 1'b0;
      execute_up_ready = 1'b0;
    end
  end

  assign when_CtrlLink_l191 = (|execute_haltRequest_rv_l275);
  assign execute_down_PC = execute_up_PC;
  assign execute_down_INSTRUCTION = execute_up_INSTRUCTION;
  assign execute_down_decoder_RD_ADDR_FINAL = execute_up_decoder_RD_ADDR_FINAL;
  assign execute_down_decoder_OP1_33 = execute_up_decoder_OP1_33;
  assign execute_down_decoder_OP2_33 = execute_up_decoder_OP2_33;
  assign execute_down_decoder_OP1_OP2_LSB = execute_up_decoder_OP1_OP2_LSB;
  assign execute_down_decoder_RS2_IMM = execute_up_decoder_RS2_IMM;
  assign execute_down_decoder_ITYPE = execute_up_decoder_ITYPE;
  assign execute_down_rvfi_valid = execute_up_rvfi_valid;
  assign execute_down_rvfi_order = execute_up_rvfi_order;
  assign execute_down_rvfi_insn = execute_up_rvfi_insn;
  assign execute_down_rvfi_trap = execute_up_rvfi_trap;
  assign execute_down_rvfi_halt = execute_up_rvfi_halt;
  assign execute_down_rvfi_intr = execute_up_rvfi_intr;
  assign execute_down_rvfi_rs1_addr = execute_up_rvfi_rs1_addr;
  assign execute_down_rvfi_rs2_addr = execute_up_rvfi_rs2_addr;
  assign execute_down_rvfi_rs1_rdata = execute_up_rvfi_rs1_rdata;
  assign execute_down_rvfi_rs2_rdata = execute_up_rvfi_rs2_rdata;
  assign execute_down_rvfi_rd_addr = execute_up_rvfi_rd_addr;
  assign execute_down_rvfi_rd_wdata = execute_up_rvfi_rd_wdata;
  assign execute_down_rvfi_pc_rdata = execute_up_rvfi_pc_rdata;
  assign execute_down_rvfi_pc_wdata = execute_up_rvfi_pc_wdata;
  assign execute_down_rvfi_mem_addr = execute_up_rvfi_mem_addr;
  assign execute_down_rvfi_mem_rmask = execute_up_rvfi_mem_rmask;
  assign execute_down_rvfi_mem_wmask = execute_up_rvfi_mem_wmask;
  assign execute_down_rvfi_mem_rdata = execute_up_rvfi_mem_rdata;
  assign execute_down_rvfi_mem_wdata = execute_up_rvfi_mem_wdata;
  assign execute_down_rvfi_csr_mstatus_wmask = execute_up_rvfi_csr_mstatus_wmask;
  assign execute_down_rvfi_csr_mstatus_wdata = execute_up_rvfi_csr_mstatus_wdata;
  assign execute_down_rvfi_csr_mepc_wmask = execute_up_rvfi_csr_mepc_wmask;
  assign execute_down_rvfi_csr_mepc_wdata = execute_up_rvfi_csr_mepc_wdata;
  assign execute_down_rvfi_csr_mcause_wmask = execute_up_rvfi_csr_mcause_wmask;
  assign execute_down_rvfi_csr_mcause_wdata = execute_up_rvfi_csr_mcause_wdata;
  assign execute_down_rvfi_ixl = execute_up_rvfi_ixl;
  assign execute_down_rvfi_mode = execute_up_rvfi_mode;
  always @(*) begin
    fetch_down_ready = decode_up_ready;
    if(when_StageLink_l71) begin
      fetch_down_ready = 1'b1;
    end
  end

  assign when_StageLink_l71 = (! decode_up_isValid);
  always @(*) begin
    decode_down_ready = execute_up_ready;
    if(when_StageLink_l71_1) begin
      decode_down_ready = 1'b1;
    end
  end

  assign when_StageLink_l71_1 = (! execute_up_isValid);
  assign fetch_up_isFiring = ((fetch_up_isValid && fetch_up_isReady) && (! fetch_up_isCancel));
  assign fetch_up_isValid = fetch_up_valid;
  assign fetch_up_isReady = fetch_up_ready;
  assign fetch_up_isCancel = fetch_up_cancel;
  assign fetch_down_isValid = fetch_down_valid;
  assign fetch_down_isReady = fetch_down_ready;
  assign decode_up_isValid = decode_up_valid;
  assign decode_down_isValid = decode_down_valid;
  assign decode_down_isReady = decode_down_ready;
  assign execute_up_isValid = execute_up_valid;
  assign execute_down_isReady = 1'b1;
  assign io_IO = 32'h00000001;
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      rvfiOrder <= 64'h0;
      rvfi_valid <= 1'b0;
      rvfi_order <= 64'h0;
      rvfi_insn <= 32'h0;
      rvfi_trap <= 1'b0;
      rvfi_halt <= 1'b0;
      rvfi_intr <= 1'b0;
      rvfi_rs1_addr <= 5'h0;
      rvfi_rs2_addr <= 5'h0;
      rvfi_rd_addr <= 5'h0;
      rvfi_rs1_rdata <= 32'h0;
      rvfi_rs2_rdata <= 32'h0;
      rvfi_rd_wdata <= 32'h0;
      rvfi_pc_rdata <= 32'h0;
      rvfi_pc_wdata <= 32'h0;
      rvfi_mem_addr <= 32'h0;
      rvfi_mem_rmask <= 4'b0000;
      rvfi_mem_rdata <= 32'h0;
      rvfi_mem_wmask <= 4'b0000;
      rvfi_mem_wdata <= 32'h0;
      rvfi_csr_mstatus_wmask <= 32'h0;
      rvfi_csr_mstatus_wdata <= 32'h0;
      rvfi_csr_mepc_wmask <= 32'h0;
      rvfi_csr_mepc_wdata <= 32'h0;
      rvfi_csr_mcause_wmask <= 32'h0;
      rvfi_csr_mcause_wdata <= 32'h0;
      rvfi_ixl <= 2'b01;
      rvfi_mode <= 2'b11;
      Iptr <= 32'h0;
      init <= 1'b0;
      irqSyncStage0 <= 1'b0;
      irqSync <= 1'b0;
      memory_isFetch_regNext <= 1'b0;
      decode_up_valid <= 1'b0;
      execute_up_valid <= 1'b0;
    end else begin
      init <= 1'b1;
      irqSyncStage0 <= irq;
      irqSync <= irqSyncStage0;
      memory_isFetch_regNext <= memory_isFetch;
      if(fetch_up_isFiring) begin
        Iptr <= (Iptr + 32'h00000004);
      end
      if(decode_up_isValid) begin
        rvfiOrder <= (rvfiOrder + 64'h0000000000000001);
      end
      if(exec_jump_take_jump) begin
        Iptr <= exec_jump_pc_jump;
      end
      if(exec_irq_taken) begin
        Iptr <= exec_irq_target;
      end else begin
        if(exec_mret_taken) begin
          Iptr <= exec_mret_target;
        end else begin
          if(exec_jump_take_jump) begin
            Iptr <= exec_jump_pc_jump;
          end
        end
      end
      rvfi_valid <= _zz_rvfi_valid;
      if(execute_up_isValid) begin
        rvfi_order <= execute_down_rvfi_order;
        rvfi_pc_rdata <= execute_down_rvfi_pc_rdata;
        rvfi_insn <= execute_down_rvfi_insn;
        rvfi_trap <= execute_down_rvfi_trap;
        rvfi_halt <= execute_down_rvfi_halt;
        rvfi_intr <= execute_down_rvfi_intr;
        rvfi_rs1_addr <= execute_down_rvfi_rs1_addr;
        rvfi_rs2_addr <= execute_down_rvfi_rs2_addr;
        rvfi_rd_addr <= execute_down_rvfi_rd_addr;
        rvfi_rs1_rdata <= execute_down_rvfi_rs1_rdata;
        rvfi_rs2_rdata <= execute_down_rvfi_rs2_rdata;
        rvfi_rd_wdata <= 32'h0;
        if(exec_rd_wr) begin
          rvfi_rd_wdata <= exec_rd_wdata;
        end
        rvfi_mem_addr <= 32'h0;
        rvfi_mem_rmask <= 4'b0000;
        rvfi_mem_rdata <= 32'h0;
        rvfi_mem_wmask <= 4'b0000;
        rvfi_mem_wdata <= 32'h0;
        rvfi_csr_mstatus_wmask <= 32'h0;
        rvfi_csr_mstatus_wdata <= 32'h0;
        rvfi_csr_mepc_wmask <= 32'h0;
        rvfi_csr_mepc_wdata <= 32'h0;
        rvfi_csr_mcause_wmask <= 32'h0;
        rvfi_csr_mcause_wdata <= 32'h0;
        if(exec_csrMstatusWrite) begin
          rvfi_csr_mstatus_wmask <= exec_csrMstatusWmask;
          rvfi_csr_mstatus_wdata <= exec_csrMstatusWdata;
        end
        if(exec_csrMepcWrite) begin
          rvfi_csr_mepc_wmask <= exec_csrMepcWmask;
          rvfi_csr_mepc_wdata <= exec_csrMepcWdata;
        end
        if(exec_csrMcauseWrite) begin
          rvfi_csr_mcause_wmask <= exec_csrMcauseWmask;
          rvfi_csr_mcause_wdata <= exec_csrMcauseWdata;
        end
        rvfi_ixl <= 2'b01;
        rvfi_mode <= 2'b11;
      end
      if(execute_up_isValid) begin
        if(exec_jump_pc_jump_valid) begin
          rvfi_pc_wdata <= exec_jump_pc_jump;
        end else begin
          rvfi_pc_wdata <= (execute_down_rvfi_pc_rdata + 32'h00000004);
        end
      end
      (* parallel_case *)
      case(1) // synthesis parallel_case
        (exec_itype[InstrType_B_OH_ID])|
        (exec_itype[InstrType_JAL_OH_ID])|
        (exec_itype[InstrType_JALR_OH_ID]) : begin
          if(when_rv_l1146) begin
            rvfi_trap <= 1'b1;
          end
        end
        (exec_itype[InstrType_L_OH_ID]) : begin
          if(execute_up_isValid) begin
            rvfi_mem_addr <= {exec_lsu_lsu_addr[31 : 2],2'b00};
            rvfi_mem_rmask <= (((_zz_rvfi_trap == 2'b00) ? 4'b0001 : ((_zz_rvfi_trap == 2'b01) ? 4'b0011 : 4'b1111)) <<< exec_lsu_lsu_addr[1 : 0]);
            rvfi_trap <= (((_zz_rvfi_trap == 2'b01) && exec_lsu_lsu_addr[0]) || ((_zz_rvfi_trap == 2'b10) && (! (exec_lsu_lsu_addr[1 : 0] == 2'b00))));
          end
        end
        (exec_itype[InstrType_S_OH_ID]) : begin
          if(execute_up_isValid) begin
            rvfi_mem_addr <= {exec_lsu_lsu_addr[31 : 2],2'b00};
            rvfi_mem_wmask <= (((_zz_rvfi_trap_1 == 2'b00) ? 4'b0001 : ((_zz_rvfi_trap_1 == 2'b01) ? 4'b0011 : 4'b1111)) <<< exec_lsu_lsu_addr[1 : 0]);
            rvfi_mem_wdata <= exec_lsu_mem_wdata;
            rvfi_trap <= (((_zz_rvfi_trap_1 == 2'b01) && exec_lsu_lsu_addr[0]) || ((_zz_rvfi_trap_1 == 2'b10) && (! (exec_lsu_lsu_addr[1 : 0] == 2'b00))));
          end
        end
        default : begin
        end
      endcase
      if(exec_irq_taken) begin
        rvfi_order <= rvfiOrder;
        rvfi_pc_rdata <= Iptr;
        rvfi_insn <= 32'h00000013;
        rvfi_trap <= 1'b1;
        rvfi_halt <= 1'b0;
        rvfi_intr <= 1'b1;
        rvfi_rs1_addr <= 5'h0;
        rvfi_rs2_addr <= 5'h0;
        rvfi_rd_addr <= 5'h0;
        rvfi_rs1_rdata <= 32'h0;
        rvfi_rs2_rdata <= 32'h0;
        rvfi_rd_wdata <= 32'h0;
        rvfi_mem_addr <= 32'h0;
        rvfi_mem_rmask <= 4'b0000;
        rvfi_mem_rdata <= 32'h0;
        rvfi_mem_wmask <= 4'b0000;
        rvfi_mem_wdata <= 32'h0;
        rvfi_pc_wdata <= exec_irq_target;
        rvfi_csr_mstatus_wmask <= exec_csrMstatusWmask;
        rvfi_csr_mstatus_wdata <= exec_csrMstatusWdata;
        rvfi_csr_mepc_wmask <= exec_csrMepcWmask;
        rvfi_csr_mepc_wdata <= exec_csrMepcWdata;
        rvfi_csr_mcause_wmask <= exec_csrMcauseWmask;
        rvfi_csr_mcause_wdata <= exec_csrMcauseWdata;
        rvfi_ixl <= 2'b01;
        rvfi_mode <= 2'b11;
      end
      if(decode_up_forgetOne) begin
        decode_up_valid <= 1'b0;
      end
      if(fetch_down_isReady) begin
        decode_up_valid <= fetch_down_isValid;
      end
      if(decode_down_isReady) begin
        execute_up_valid <= decode_down_isValid;
      end
    end
  end

  always @(posedge clk) begin
    fetcher_delayFiring <= fetch_up_isFiring;
    fetcher_delayFiring2 <= fetcher_delayFiring;
    _zz_rvfi_valid <= (execute_up_isValid || exec_irq_taken);
    if(fetch_down_isReady) begin
      decode_up_PC <= fetch_down_PC;
      decode_up_INSTRUCTION <= fetch_down_INSTRUCTION;
    end
    if(decode_down_isReady) begin
      execute_up_PC <= decode_down_PC;
      execute_up_INSTRUCTION <= decode_down_INSTRUCTION;
      execute_up_decoder_RD_ADDR_FINAL <= decode_down_decoder_RD_ADDR_FINAL;
      execute_up_decoder_OP1_33 <= decode_down_decoder_OP1_33;
      execute_up_decoder_OP2_33 <= decode_down_decoder_OP2_33;
      execute_up_decoder_OP1_OP2_LSB <= decode_down_decoder_OP1_OP2_LSB;
      execute_up_decoder_RS2_IMM <= decode_down_decoder_RS2_IMM;
      execute_up_decoder_ITYPE <= decode_down_decoder_ITYPE;
      execute_up_rvfi_valid <= decode_down_rvfi_valid;
      execute_up_rvfi_order <= decode_down_rvfi_order;
      execute_up_rvfi_insn <= decode_down_rvfi_insn;
      execute_up_rvfi_trap <= decode_down_rvfi_trap;
      execute_up_rvfi_halt <= decode_down_rvfi_halt;
      execute_up_rvfi_intr <= decode_down_rvfi_intr;
      execute_up_rvfi_rs1_addr <= decode_down_rvfi_rs1_addr;
      execute_up_rvfi_rs2_addr <= decode_down_rvfi_rs2_addr;
      execute_up_rvfi_rs1_rdata <= decode_down_rvfi_rs1_rdata;
      execute_up_rvfi_rs2_rdata <= decode_down_rvfi_rs2_rdata;
      execute_up_rvfi_rd_addr <= decode_down_rvfi_rd_addr;
      execute_up_rvfi_rd_wdata <= decode_down_rvfi_rd_wdata;
      execute_up_rvfi_pc_rdata <= decode_down_rvfi_pc_rdata;
      execute_up_rvfi_pc_wdata <= decode_down_rvfi_pc_wdata;
      execute_up_rvfi_mem_addr <= decode_down_rvfi_mem_addr;
      execute_up_rvfi_mem_rmask <= decode_down_rvfi_mem_rmask;
      execute_up_rvfi_mem_wmask <= decode_down_rvfi_mem_wmask;
      execute_up_rvfi_mem_rdata <= decode_down_rvfi_mem_rdata;
      execute_up_rvfi_mem_wdata <= decode_down_rvfi_mem_wdata;
      execute_up_rvfi_csr_mstatus_wmask <= decode_down_rvfi_csr_mstatus_wmask;
      execute_up_rvfi_csr_mstatus_wdata <= decode_down_rvfi_csr_mstatus_wdata;
      execute_up_rvfi_csr_mepc_wmask <= decode_down_rvfi_csr_mepc_wmask;
      execute_up_rvfi_csr_mepc_wdata <= decode_down_rvfi_csr_mepc_wdata;
      execute_up_rvfi_csr_mcause_wmask <= decode_down_rvfi_csr_mcause_wmask;
      execute_up_rvfi_csr_mcause_wdata <= decode_down_rvfi_csr_mcause_wdata;
      execute_up_rvfi_ixl <= decode_down_rvfi_ixl;
      execute_up_rvfi_mode <= decode_down_rvfi_mode;
    end
  end


endmodule

module StreamFifo (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire [31:0]   io_push_payload,
  output reg           io_pop_valid,
  input  wire          io_pop_ready,
  output reg  [31:0]   io_pop_payload,
  input  wire          io_flush,
  output wire [1:0]    io_occupancy,
  output wire [1:0]    io_availability,
  input  wire          clk,
  input  wire          reset
);

  wire       [0:0]    _zz__zz_1;
  reg        [31:0]   _zz_logic_pop_async_readed;
  reg        [31:0]   logic_vec_0;
  reg        [31:0]   logic_vec_1;
  reg                 logic_ptr_doPush;
  wire                logic_ptr_doPop;
  wire                logic_ptr_full;
  wire                logic_ptr_empty;
  reg        [1:0]    logic_ptr_push;
  reg        [1:0]    logic_ptr_pop;
  wire       [1:0]    logic_ptr_occupancy;
  wire       [1:0]    logic_ptr_popOnIo;
  wire                when_Stream_l1455;
  reg                 logic_ptr_wentUp;
  wire                io_push_fire;
  wire       [1:0]    _zz_1;
  wire                logic_pop_addressGen_valid;
  wire                logic_pop_addressGen_ready;
  wire       [0:0]    logic_pop_addressGen_payload;
  wire                logic_pop_addressGen_fire;
  wire       [31:0]   logic_pop_async_readed;
  wire                logic_pop_addressGen_translated_valid;
  wire                logic_pop_addressGen_translated_ready;
  wire       [31:0]   logic_pop_addressGen_translated_payload;

  assign _zz__zz_1 = logic_ptr_push[0:0];
  always @(*) begin
    case(logic_pop_addressGen_payload)
      1'b0 : _zz_logic_pop_async_readed = logic_vec_0;
      default : _zz_logic_pop_async_readed = logic_vec_1;
    endcase
  end

  assign when_Stream_l1455 = (logic_ptr_doPush != logic_ptr_doPop);
  assign logic_ptr_full = (((logic_ptr_push ^ logic_ptr_popOnIo) ^ 2'b10) == 2'b00);
  assign logic_ptr_empty = (logic_ptr_push == logic_ptr_pop);
  assign logic_ptr_occupancy = (logic_ptr_push - logic_ptr_popOnIo);
  assign io_push_ready = (! logic_ptr_full);
  assign io_push_fire = (io_push_valid && io_push_ready);
  always @(*) begin
    logic_ptr_doPush = io_push_fire;
    io_pop_valid = logic_pop_addressGen_translated_valid;
    io_pop_payload = logic_pop_addressGen_translated_payload;
    if(logic_ptr_empty) begin
      io_pop_valid = io_push_valid;
      io_pop_payload = io_push_payload;
      if(io_pop_ready) begin
        logic_ptr_doPush = 1'b0;
      end
    end
  end

  assign _zz_1 = ({1'd0,1'b1} <<< _zz__zz_1);
  assign logic_pop_addressGen_valid = (! logic_ptr_empty);
  assign logic_pop_addressGen_payload = logic_ptr_pop[0:0];
  assign logic_pop_addressGen_fire = (logic_pop_addressGen_valid && logic_pop_addressGen_ready);
  assign logic_ptr_doPop = logic_pop_addressGen_fire;
  assign logic_pop_async_readed = _zz_logic_pop_async_readed;
  assign logic_pop_addressGen_translated_valid = logic_pop_addressGen_valid;
  assign logic_pop_addressGen_ready = logic_pop_addressGen_translated_ready;
  assign logic_pop_addressGen_translated_payload = logic_pop_async_readed;
  assign logic_pop_addressGen_translated_ready = io_pop_ready;
  assign logic_ptr_popOnIo = logic_ptr_pop;
  assign io_occupancy = logic_ptr_occupancy;
  assign io_availability = (2'b10 - logic_ptr_occupancy);
  always @(posedge clk or posedge reset) begin
    if(reset) begin
      logic_ptr_push <= 2'b00;
      logic_ptr_pop <= 2'b00;
      logic_ptr_wentUp <= 1'b0;
    end else begin
      if(when_Stream_l1455) begin
        logic_ptr_wentUp <= logic_ptr_doPush;
      end
      if(io_flush) begin
        logic_ptr_wentUp <= 1'b0;
      end
      if(logic_ptr_doPush) begin
        logic_ptr_push <= (logic_ptr_push + 2'b01);
      end
      if(logic_ptr_doPop) begin
        logic_ptr_pop <= (logic_ptr_pop + 2'b01);
      end
      if(io_flush) begin
        logic_ptr_push <= 2'b00;
        logic_ptr_pop <= 2'b00;
      end
    end
  end

  always @(posedge clk) begin
    if(io_push_fire) begin
      if(_zz_1[0]) begin
        logic_vec_0 <= io_push_payload;
      end
      if(_zz_1[1]) begin
        logic_vec_1 <= io_push_payload;
      end
    end
  end


endmodule
