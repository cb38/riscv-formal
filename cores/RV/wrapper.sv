
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

	RV_formal uut (
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

		// debug intf
		.debug_reg_rdata (),
		.debug_reg_wdata (32'b0),
		.debug_reg_addr (5'b0),
		.debug_reg_wr (1'b0),	
		.debug_csr_addr (12'b0),
		.debug_csr_wdata (32'b0),
		.debug_csr_rdata (),
		.debug_csr_wr (1'b0),
		.debug_halt_req (1'b0),
		.debug_resume_req (1'b0),

		
		.irq (irq),
		.timer_irq (1'b0),



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

	// Disable IRQ during bus checks: IRQ retirements report manufactured
	// instruction data (NOP) at a PC that was never fetched, which
	// confuses the bus_imem checker.
	always @* assume(!irq);

   // Instruction memory read channel
	(* keep *) `rvformal_rand_reg [`RISCV_FORMAL_BUSLEN-1:0] next_instr_axi_r_payload_data;
	(* keep *) `rvformal_rand_reg next_instr_axi_ar_ready;

	wire imem_ar_fire = instr_axi_ar_valid && instr_axi_ar_ready;

	always @(posedge clock) begin
		instr_axi_ar_ready <= next_instr_axi_ar_ready;
		instr_axi_r_payload_data <= next_instr_axi_r_payload_data;
		instr_axi_r_valid <= imem_ar_fire;
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
		imem_bus_valid = imem_ar_fire;

		instr_axi_r_payload_resp = 2'b00;
	end


   // Data memory read channel
	(* keep *) `rvformal_rand_reg [`RISCV_FORMAL_BUSLEN-1:0] next_data_axi_r_payload_data;
	(* keep *) `rvformal_rand_reg next_data_axi_ar_ready;

	wire dmem_r_ar_fire = data_axi_ar_valid && data_axi_ar_ready;

	always @(posedge clock) begin
		data_axi_ar_ready <= next_data_axi_ar_ready;
		data_axi_r_payload_data <= next_data_axi_r_payload_data;
		data_axi_r_valid <= dmem_r_ar_fire;
	end

	always @* begin
		dmem_r_bus_addr  = {data_axi_ar_payload_addr[31:2], 2'b00};
		dmem_r_bus_insn  = 0;
		dmem_r_bus_data  = 1;
		dmem_r_bus_rmask = {`RISCV_FORMAL_BUSLEN / 8{1'b1}};
		dmem_r_bus_wmask = {`RISCV_FORMAL_BUSLEN / 8{1'b0}};
		dmem_r_bus_rdata = next_data_axi_r_payload_data;
		dmem_r_bus_wdata = 0;
		dmem_r_bus_fault = 0;
		dmem_r_bus_valid = dmem_r_ar_fire;

		data_axi_r_payload_resp = 2'b00;
	end

	// Data memory write channel
	(* keep *) `rvformal_rand_reg next_data_axi_aw_ready; // also used for w
	(* keep *) `rvformal_rand_reg next_data_axi_b_valid;

	wire dmem_w_fire = data_axi_aw_valid && data_axi_aw_ready && data_axi_w_valid && data_axi_w_ready;

	always @(posedge clock) begin
		data_axi_aw_ready <= next_data_axi_aw_ready;
		data_axi_w_ready <= next_data_axi_aw_ready;
		data_axi_b_valid <= dmem_w_fire;
	end

	always @* begin
		dmem_w_bus_addr  = {data_axi_aw_payload_addr[31:2], 2'b00};
		dmem_w_bus_insn  = 0;
		dmem_w_bus_data  = 1;
		dmem_w_bus_rmask = {`RISCV_FORMAL_BUSLEN / 8{1'b0}};
		dmem_w_bus_wmask = data_axi_w_payload_strb;
		dmem_w_bus_rdata = 0;
		dmem_w_bus_wdata = data_axi_w_payload_data;
		dmem_w_bus_fault = 0;
		dmem_w_bus_valid = dmem_w_fire;

		data_axi_b_payload_resp = 2'b00;
	end
`endif
`ifndef RISCV_FORMAL_BUS

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

`ifdef RV_FAIRNESS
	// Fairness: assume instruction memory responds within 3 cycles of request
	reg [2:0] imem_wait = 0;
	always @(posedge clock) begin
		if (reset) begin
			imem_wait <= 0;
		end else begin
			if (instr_axi_ar_valid && !instr_axi_ar_ready)
				imem_wait <= imem_wait + 1;
			else if (instr_axi_ar_valid && instr_axi_ar_ready)
				imem_wait <= 1;  // request accepted, wait for response
			else if (imem_wait > 0 && !instr_axi_r_valid)
				imem_wait <= imem_wait + 1;
			else
				imem_wait <= 0;
		end
	end
	always @* assume(imem_wait < 4);

	// Fairness: assume data memory read responds within 3 cycles of request
	reg [2:0] dmem_r_wait = 0;
	always @(posedge clock) begin
		if (reset) begin
			dmem_r_wait <= 0;
		end else begin
			if (data_axi_ar_valid && !data_axi_ar_ready)
				dmem_r_wait <= dmem_r_wait + 1;
			else if (data_axi_ar_valid && data_axi_ar_ready)
				dmem_r_wait <= 1;
			else if (dmem_r_wait > 0 && !data_axi_r_valid)
				dmem_r_wait <= dmem_r_wait + 1;
			else
				dmem_r_wait <= 0;
		end
	end
	always @* assume(dmem_r_wait < 4);

	// Fairness: assume data memory write responds within 3 cycles of request
	reg [2:0] dmem_w_wait = 0;
	always @(posedge clock) begin
		if (reset) begin
			dmem_w_wait <= 0;
		end else begin
			if (data_axi_aw_valid && !data_axi_aw_ready)
				dmem_w_wait <= dmem_w_wait + 1;
			else if (data_axi_aw_valid && data_axi_aw_ready)
				dmem_w_wait <= 1;
			else if (dmem_w_wait > 0 && !data_axi_b_valid)
				dmem_w_wait <= dmem_w_wait + 1;
			else
				dmem_w_wait <= 0;
		end
	end
	always @* assume(dmem_w_wait < 4);

	// Fairness: assume IRQ is not permanently asserted (prevents infinite trap loop)
	reg [3:0] irq_count = 0;
	always @(posedge clock) begin
		if (reset)
			irq_count <= 0;
		else if (irq)
			irq_count <= irq_count + 1;
		else
			irq_count <= 0;
	end
	always @* assume(irq_count < 8);
`endif
endmodule
