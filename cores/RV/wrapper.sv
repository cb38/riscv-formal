
module rvfi_wrapper (
	input         clock,
	input         reset,
	`RVFI_OUTPUTS
	`RVFI_BUS_OUTPUTS
);
	(* keep *) `rvformal_rand_reg random_stall;
	(* keep *) `rvformal_rand_reg  irq;


	localparam AXI_DATA_WIDTH = 32;
	localparam AXI_ADDRESS_WIDTH = 32;

	localparam AXI_STRB_WIDTH = AXI_DATA_WIDTH / 8;

	// Instruction AXI read channel (AXI4-lite style)
	(* keep *)  wire                       instr_axi_ar_valid;
	(* keep *)  logic                      instr_axi_ar_ready;
	(* keep *)  wire [31:0]                instr_axi_ar_payload_addr;
	(* keep *)  wire [2:0]                 instr_axi_ar_payload_prot;
	(* keep *)  logic                      instr_axi_r_valid;
	(* keep *)  wire                       instr_axi_r_ready;
	(* keep *)  logic [31:0]               instr_axi_r_payload_data;
	(* keep *)  logic [1:0]                instr_axi_r_payload_resp;



	// Data AXI read/write channels (AXI4-lite style)
	(* keep *)  wire                       data_axi_aw_valid;
	(* keep *)  logic                      data_axi_aw_ready;
	(* keep *)  wire [31:0]                data_axi_aw_payload_addr;
	(* keep *)  wire [2:0]                 data_axi_aw_payload_prot;
	(* keep *)  wire                       data_axi_w_valid;
	(* keep *)  logic                      data_axi_w_ready;
	(* keep *)  wire [31:0]                data_axi_w_payload_data;
	(* keep *)  wire [3:0]                 data_axi_w_payload_strb;
	(* keep *)  logic                      data_axi_b_valid;
	(* keep *)  wire                       data_axi_b_ready;
	(* keep *)  logic [1:0]                data_axi_b_payload_resp;
	(* keep *)  wire                       data_axi_ar_valid;
	(* keep *)  logic                      data_axi_ar_ready;
	(* keep *)  wire [31:0]                data_axi_ar_payload_addr;
	(* keep *)  wire [2:0]                 data_axi_ar_payload_prot;
	(* keep *)  logic                      data_axi_r_valid;
	(* keep *)  wire                       data_axi_r_ready;
	(* keep *)  logic [31:0]               data_axi_r_payload_data;
	(* keep *)  logic [1:0]                data_axi_r_payload_resp;


	(* keep *) wire trap;

	RV uut (
		.clk      (clock    ),
		.reset      (reset    ),

		.instr_axi_ar_valid        (instr_axi_ar_valid),
		.instr_axi_ar_ready        (instr_axi_ar_ready),
		.instr_axi_ar_payload_addr (instr_axi_ar_payload_addr),
		.instr_axi_ar_payload_prot (instr_axi_ar_payload_prot),
		.instr_axi_r_valid         (instr_axi_r_valid),
		.instr_axi_r_ready         (instr_axi_r_ready),
		.instr_axi_r_payload_data  (instr_axi_r_payload_data),
		.instr_axi_r_payload_resp  (instr_axi_r_payload_resp),

		.data_axi_aw_valid         (data_axi_aw_valid),
		.data_axi_aw_ready         (data_axi_aw_ready),
		.data_axi_aw_payload_addr  (data_axi_aw_payload_addr),
		.data_axi_aw_payload_prot  (data_axi_aw_payload_prot),
		.data_axi_w_valid          (data_axi_w_valid),
		.data_axi_w_ready          (data_axi_w_ready),
		.data_axi_w_payload_data   (data_axi_w_payload_data),
		.data_axi_w_payload_strb   (data_axi_w_payload_strb),
		.data_axi_b_valid          (data_axi_b_valid),
		.data_axi_b_ready          (data_axi_b_ready),
		.data_axi_b_payload_resp   (data_axi_b_payload_resp),
		.data_axi_ar_valid         (data_axi_ar_valid),
		.data_axi_ar_ready         (data_axi_ar_ready),
		.data_axi_ar_payload_addr  (data_axi_ar_payload_addr),
		.data_axi_ar_payload_prot  (data_axi_ar_payload_prot),
		.data_axi_r_valid          (data_axi_r_valid),
		.data_axi_r_ready          (data_axi_r_ready),
		.data_axi_r_payload_data   (data_axi_r_payload_data),
		.data_axi_r_payload_resp   (data_axi_r_payload_resp),

		.irq (irq),

		`RVFI_CONN32
	);

`ifndef RISCV_FORMAL_MEM_FAULT
	always @* assume(!instr_axi_r_payload_resp[1]);
	always @* assume(!data_axi_r_payload_resp[1]);
	always @* assume(!data_axi_b_payload_resp[1]);
`endif

`ifdef RISCV_FORMAL_BUS

`define RISCV_FORMAL_CHANNEL_SIGNAL(channels, width, name) \
	(* keep *) reg [(width) - 1:0] imem_``name; assign rvfi_``name[0 * (width) +: (width)] = imem_``name;
`RVFI_BUS_SIGNALS
`undef RISCV_FORMAL_CHANNEL_SIGNAL

`define RISCV_FORMAL_CHANNEL_SIGNAL(channels, width, name) \
	(* keep *) reg [(width) - 1:0] dmem_r_``name; assign rvfi_``name[1 * (width) +: (width)] = dmem_r_``name;
`RVFI_BUS_SIGNALS
`undef RISCV_FORMAL_CHANNEL_SIGNAL

`define RISCV_FORMAL_CHANNEL_SIGNAL(channels, width, name) \
	(* keep *) reg [(width) - 1:0] dmem_w_``name; assign rvfi_``name[2 * (width) +: (width)] = dmem_w_``name;
`RVFI_BUS_SIGNALS
`undef RISCV_FORMAL_CHANNEL_SIGNAL
   // Instruction memory read channel
	(* keep *) `rvformal_rand_reg [`RISCV_FORMAL_BUSLEN-1:0] next_instr_axi_r_payload_data;
	(* keep *) `rvformal_rand_reg next_instr_axi_ar_ready;
	(* keep *) `rvformal_rand_reg next_instr_axi_r_valid;
  

	logic imem_req_valid_q;

	always @(posedge clock) begin
		instr_axi_ar_ready <= next_instr_axi_ar_ready;
		instr_axi_r_payload_data <= next_instr_axi_r_payload_data;
		instr_axi_r_valid <= next_instr_axi_r_valid && instr_axi_ar_valid && !imem_req_valid_q;
		imem_req_valid_q <= instr_axi_ar_valid && !reset;
	end

	always @* begin
		imem_bus_addr  = instr_axi_ar_payload_addr;
		imem_bus_insn  = 1;
		imem_bus_data  = 0;
		imem_bus_rmask = {`RISCV_FORMAL_BUSLEN / 8{1'b1}};
		imem_bus_wmask = {`RISCV_FORMAL_BUSLEN / 8{1'b0}};
		imem_bus_rdata = next_instr_axi_r_payload_data;
		imem_bus_wdata = 0;
		imem_bus_fault = 0;
		imem_bus_valid = next_instr_axi_r_valid && instr_axi_ar_valid && !imem_req_valid_q;

		instr_axi_r_payload_resp = 2'b00;
	end


   // Data memory read channel
	(* keep *) `rvformal_rand_reg [`RISCV_FORMAL_BUSLEN-1:0] next_data_axi_r_payload_data;
	(* keep *) `rvformal_rand_reg next_data_axi_ar_ready;
	(* keep *) `rvformal_rand_reg next_data_axi_r_valid;



	logic dmem_req_r_valid_q;

	always @(posedge clock) begin
		data_axi_ar_ready <= next_data_axi_ar_ready;
		data_axi_r_payload_data <= next_data_axi_r_payload_data;
		data_axi_r_valid <= next_data_axi_r_valid && data_axi_ar_valid && !dmem_req_r_valid_q ;
		dmem_req_r_valid_q <= data_axi_ar_valid && !reset;
	end

	always @* begin
		dmem_r_bus_addr  = data_axi_ar_payload_addr;
		dmem_r_bus_insn  = 0;
		dmem_r_bus_data  = 1;
		dmem_r_bus_rmask = {`RISCV_FORMAL_BUSLEN / 8{1'b1}};
		dmem_r_bus_wmask = {`RISCV_FORMAL_BUSLEN / 8{1'b0}};
		dmem_r_bus_rdata = next_data_axi_r_payload_data;
		dmem_r_bus_wdata = 0;
		dmem_r_bus_fault = 0;
		dmem_r_bus_valid = next_data_axi_r_valid && data_axi_ar_valid && !dmem_req_r_valid_q;

		data_axi_r_payload_resp = 2'b00;
	end

	// Data memory write channel
	(* keep *) `rvformal_rand_reg next_data_axi_aw_ready; // also used for w
	(* keep *) `rvformal_rand_reg next_data_axi_b_valid;

	logic dmem_req_w_valid_q;

	always @(posedge clock) begin
		data_axi_aw_ready <= next_data_axi_aw_ready;
		data_axi_w_ready <= next_data_axi_aw_ready;
		data_axi_b_valid <= next_data_axi_b_valid && data_axi_aw_valid && !dmem_req_w_valid_q;
		dmem_req_w_valid_q <= data_axi_aw_valid && !reset;
	end

	always @* begin
		dmem_w_bus_addr  = data_axi_aw_payload_addr;
		dmem_w_bus_insn  = 0;
		dmem_w_bus_data  = 1;
		dmem_w_bus_rmask = {`RISCV_FORMAL_BUSLEN / 8{1'b0}};
		dmem_w_bus_wmask = data_axi_w_payload_strb;
		dmem_w_bus_rdata = 0;
		dmem_w_bus_wdata = data_axi_w_payload_data;
		dmem_w_bus_fault = 0;
		dmem_w_bus_valid = next_data_axi_b_valid && data_axi_aw_valid && !dmem_req_w_valid_q;

		data_axi_b_payload_resp = 2'b00;
	end
`endif
`ifndef RISCV_FORMAL_BUS
/*
	// Minimal abstract AXI responses for non-bus checks
	(* keep *) `rvformal_rand_reg [31:0] instr_axi_r_payload_data;
	(* keep *) `rvformal_rand_reg instr_axi_ar_ready;
	(* keep *) `rvformal_rand_reg instr_axi_r_valid;

	


	
	(* keep *) `rvformal_rand_reg [31:0] data_axi_r_payload_data;
	(* keep *) `rvformal_rand_reg data_axi_ar_ready;
	//assign data_axi_ar_ready = 1 ;
	(* keep *) `rvformal_rand_reg data_axi_r_valid;
	(* keep *) `rvformal_rand_reg data_axi_aw_ready;
	(* keep *) `rvformal_rand_reg data_axi_b_valid;
	
*/
 


	// Minimal abstract AXI responses for non-bus checks
	(* keep *) `rvformal_rand_reg [31:0] next_instr_axi_r_payload_data;
	(* keep *) `rvformal_rand_reg next_instr_axi_ar_ready;
	(* keep *) `rvformal_rand_reg next_instr_axi_r_valid;

	logic imem_req_valid_q_nbus;

	wire instr_ar_fire_nbus = instr_axi_ar_valid && instr_axi_ar_ready;

	always @(posedge clock) begin
		instr_axi_ar_ready <= next_instr_axi_ar_ready;
		instr_axi_r_payload_data <= next_instr_axi_r_payload_data;
		instr_axi_r_valid <= next_instr_axi_r_valid && instr_ar_fire_nbus && !imem_req_valid_q_nbus;
		imem_req_valid_q_nbus <= instr_ar_fire_nbus && !reset;
		instr_axi_r_payload_resp <= 2'b00;
	end

	(* keep *) `rvformal_rand_reg [31:0] next_data_axi_r_payload_data;
	(* keep *) `rvformal_rand_reg next_data_axi_ar_ready;
	(* keep *) `rvformal_rand_reg next_data_axi_r_valid;
	(* keep *) `rvformal_rand_reg next_data_axi_aw_ready;
	(* keep *) `rvformal_rand_reg next_data_axi_b_valid;

	logic dmem_req_r_valid_q_nbus;
	logic dmem_req_w_valid_q_nbus;

	wire data_ar_fire_nbus = data_axi_ar_valid && data_axi_ar_ready;
	wire data_aw_fire_nbus = data_axi_aw_valid && data_axi_aw_ready;
	wire data_w_fire_nbus = data_axi_w_valid && data_axi_w_ready;

	always @(posedge clock) begin
		data_axi_ar_ready <= next_data_axi_ar_ready;
		data_axi_r_payload_data <= next_data_axi_r_payload_data;
		data_axi_r_valid <= next_data_axi_r_valid && data_ar_fire_nbus && !dmem_req_r_valid_q_nbus;
		dmem_req_r_valid_q_nbus <= data_ar_fire_nbus && !reset;
		data_axi_r_payload_resp <= 2'b00;

		data_axi_aw_ready <= next_data_axi_aw_ready;
		data_axi_w_ready <= next_data_axi_aw_ready;
		data_axi_b_valid <= next_data_axi_b_valid && data_aw_fire_nbus && data_w_fire_nbus && !dmem_req_w_valid_q_nbus;
		dmem_req_w_valid_q_nbus <= (data_aw_fire_nbus && data_w_fire_nbus) && !reset;
		data_axi_b_payload_resp <= 2'b00;
	end
 
`endif

`ifdef NERV_FAIRNESS
	reg [2:0] stalled = 0;
	always @(posedge clock) begin
		stalled <= {stalled, stall};
		assume (~stalled);
	end
`endif
endmodule
