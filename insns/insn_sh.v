// DO NOT EDIT -- auto-generated from riscv-formal/insns/generate.py

module rvfi_insn_sh (
  input                                rvfi_valid,
  input [`RISCV_FORMAL_ILEN   - 1 : 0] rvfi_insn,
  input [`RISCV_FORMAL_XLEN   - 1 : 0] rvfi_pc_rdata,
  input [`RISCV_FORMAL_XLEN   - 1 : 0] rvfi_rs1_rdata,
  input [`RISCV_FORMAL_XLEN   - 1 : 0] rvfi_rs2_rdata,
  input [`RISCV_FORMAL_XLEN   - 1 : 0] rvfi_mem_rdata,

  output                                spec_valid,
  output                                spec_trap,
  output [                       4 : 0] spec_rs1_addr,
  output [                       4 : 0] spec_rs2_addr,
  output [                       4 : 0] spec_rd_addr,
  output [`RISCV_FORMAL_XLEN   - 1 : 0] spec_rd_wdata,
  output [`RISCV_FORMAL_XLEN   - 1 : 0] spec_pc_wdata,
  output [`RISCV_FORMAL_XLEN   - 1 : 0] spec_mem_addr,
  output [`RISCV_FORMAL_XLEN/8 - 1 : 0] spec_mem_rmask,
  output [`RISCV_FORMAL_XLEN/8 - 1 : 0] spec_mem_wmask,
  output [`RISCV_FORMAL_XLEN   - 1 : 0] spec_mem_wdata
);

  // S-type instruction format
  wire [`RISCV_FORMAL_XLEN-1:0] insn_imm = $signed({rvfi_insn[31:25], rvfi_insn[11:7]});
  wire [4:0] insn_rs2    = rvfi_insn[24:20];
  wire [4:0] insn_rs1    = rvfi_insn[19:15];
  wire [2:0] insn_funct3 = rvfi_insn[14:12];
  wire [6:0] insn_opcode = rvfi_insn[ 6: 0];

  // SH instruction
`ifdef RISCV_FORMAL_ALIGNED_MEM
  wire [`RISCV_FORMAL_XLEN-1:0] addr = rvfi_rs1_rdata + insn_imm;
  assign spec_valid = rvfi_valid && insn_funct3 == 3'b 001 && insn_opcode == 7'b 0100011;
  assign spec_rs1_addr = insn_rs1;
  assign spec_rs2_addr = insn_rs2;
  assign spec_mem_addr = addr & ~(`RISCV_FORMAL_XLEN/8-1);
  assign spec_mem_wmask = ((1 << 2)-1) << (addr-spec_mem_addr);
  assign spec_mem_wdata = rvfi_rs2_rdata << (8*(addr-spec_mem_addr));
  assign spec_pc_wdata = rvfi_pc_rdata + 4;
  assign spec_trap = (addr & (2-1)) != 0;
`else
  wire [`RISCV_FORMAL_XLEN-1:0] addr = rvfi_rs1_rdata + insn_imm;
  assign spec_valid = rvfi_valid && insn_funct3 == 3'b 001 && insn_opcode == 7'b 0100011;
  assign spec_rs1_addr = insn_rs1;
  assign spec_rs2_addr = insn_rs2;
  assign spec_mem_addr = addr;
  assign spec_mem_wmask = ((1 << 2)-1);
  assign spec_mem_wdata = rvfi_rs2_rdata;
  assign spec_pc_wdata = rvfi_pc_rdata + 4;
  assign spec_trap = 0;
`endif

  // default assignments
  assign spec_rd_addr = 0;
  assign spec_rd_wdata = 0;
  assign spec_mem_rmask = 0;
endmodule
