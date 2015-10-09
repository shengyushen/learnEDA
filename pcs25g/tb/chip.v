module chip (
	reset_n,
	clkcore,
	rx_reversed,
	sendtime,
	rcvtime,

	clkpma_tx,
 clkpma_tx_div2,
 clkpma_rx0_div2,
	//tx 0
	txdata0,
	//rx 0
	clkpma_rx0,
	rxdata0,
	//tx 1
	txdata1,
	//rx 1
	clkpma_rx1,
	rxdata1,
	//tx 2
	txdata2,
	//rx 2
	clkpma_rx2,
	rxdata2,
	//tx 3
	txdata3,
	//rx 3
	clkpma_rx3,
	rxdata3,

	//selecting pcs25g or fec
	USE_PCS25G,
	//common config
	NO_DISSYNC,
	INFER_POLAR,
	GIVEN_POLAR,
	//fec config
	MD_BYPASS_CORR_ENABLE,
	MD_BYPASS_IND_ENABLE,
	//pcs25g config
	INFER_BLOCKLOCK,
	GIVEN_BLOCKLOCK,
	in_errorInjectionMode
	) ;
input [1:0] in_errorInjectionMode;
input 	reset_n;
input 	clkcore;
input		rx_reversed;
input  	sendtime;
input  	rcvtime;

input	clkpma_tx;
input clkpma_tx_div2;
input clkpma_rx0_div2;
`ifdef FOURTYG
output [63:0]	txdata0;
output [63:0]	txdata1;
output [63:0]	txdata2;
output [63:0]	txdata3;
input [63:0]	rxdata0;
input [63:0]	rxdata1;
input [63:0]	rxdata2;
input [63:0]	rxdata3;
`else 
output [31:0]	txdata0;
output [31:0]	txdata1;
output [31:0]	txdata2;
output [31:0]	txdata3;
input [31:0]	rxdata0;
input [31:0]	rxdata1;
input [31:0]	rxdata2;
input [31:0]	rxdata3;
`endif
	//tx 0
	//rx 0
input	clkpma_rx0;

	//tx 1
	//rx 1
input	clkpma_rx1;

	//tx 2
	//rx 2
input	clkpma_rx2;

	//tx 3
	//rx 3
input	clkpma_rx3;
reg	clkpma_rx0_w;
reg	clkpma_rx1_w;
reg	clkpma_rx2_w;
reg	clkpma_rx3_w;

always @(clkpma_rx0) begin clkpma_rx0_w <= #0.5 clkpma_rx0; end
always @(clkpma_rx1) begin clkpma_rx1_w <= #0.5 clkpma_rx1; end
always @(clkpma_rx2) begin clkpma_rx2_w <= #0.5 clkpma_rx2; end
always @(clkpma_rx3) begin clkpma_rx3_w <= #0.5 clkpma_rx3; end
	//rtl config
input USE_PCS25G;
//common config
input NO_DISSYNC;
input	INFER_POLAR;
input	[3:0] GIVEN_POLAR;
//fec config
input MD_BYPASS_CORR_ENABLE;
input MD_BYPASS_IND_ENABLE;
//pcs25g config
input	INFER_BLOCKLOCK;
input	[3:0] GIVEN_BLOCKLOCK;


wire [191:0]  txdata;
wire  txpop;

wire out_ideal;
gen192_sendtime inst_gen(
	.clk(clkcore),
	.data(txdata),
	.sendtime(sendtime),
	.out_txen(txpop),
	.ideal(out_ideal),
	.reset_n(reset_n)
);

wire	reset_n_core;
sync2stage inst_reset_n_core(.clk(clkcore),.data_in(reset_n),.data_out(reset_n_core));


wire [191:0]  rxdata;
wire rxpop;
wire syncing;
reg csr_reset_n;
wire rxerror;
pcsfec inst_pcs4x(
	.reset_n_core(reset_n_core),
	.clkcore(clkcore),
	//tx
	.llp_phy_data(txdata),
	.llp_phy_data_valid(txpop),
	.phy_llp_phy_idle(out_ideal),
	//rx
	.phy_llp_data(rxdata),
	.phy_llp_data_valid(rxpop),
	.phy_llp_data_error(rxerror),
	.phy_llp_ready(),

	.clkpma_tx(clkpma_tx),
	.clkpma_tx_div2(clkpma_tx_div2),
	.clkpma_rx0_div2(clkpma_rx0_div2),
	//tx 0
	.txdata0(txdata0),
	//rx 0
	.clkpma_rx0(clkpma_rx0_w),
	.rxdata0(rxdata0),
	//tx 1
	.txdata1(txdata1),
	//rx 1
	.clkpma_rx1(clkpma_rx1_w),
	.rxdata1(rxdata1),
	//tx 2
	.txdata2(txdata2),
	//rx 2
	.clkpma_rx2(clkpma_rx2_w),
	.rxdata2(rxdata2),
	//tx 3
	.txdata3(txdata3),
	//rx 3
	.clkpma_rx3(clkpma_rx3_w),
	.rxdata3(rxdata3),
	
	//common config and status
`ifndef FPGA_IMPLEMENTATION
`ifndef FOURTYG
	.in_USE_PCS25G(USE_PCS25G),
`endif
`endif
	.in_csr_reset_n(csr_reset_n),
	.in_dissync_enable(!NO_DISSYNC),
	.in_INFER_POLAR(INFER_POLAR),
	.in_GIVEN_POLAR(GIVEN_POLAR),
	.out_block_lock(),
	.out_counterDIV1M_rx0(),
	.out_counterDIV1M_rx1(),
	.out_counterDIV1M_rx2(),
	.out_counterDIV1M_rx3(),
	.out_counterDIV1M_tx() ,
	.out_counterDIV1M_core(),

	//pcs25g config and status
	.in_INFER_BLOCKLOCK(INFER_BLOCKLOCK),
	.in_GIVEN_BLOCKLOCK(GIVEN_BLOCKLOCK),
	.out_tx_block_lock(),
	.out_dissync_counter(),
	.out_lane_id(),
	.out_detectedpolar(),

	//fec config
	.in_MD_BYPASS_CORR_ENABLE(MD_BYPASS_CORR_ENABLE),
	.in_MD_BYPASS_IND_ENABLE(MD_BYPASS_IND_ENABLE),
  .in_unco_cw_count_reset(1'b0),
  .in_corr_cw_count_reset(1'b0),
	.in_symbol_err_count_reset(4'b0),
	.in_ram_enable(1'b0),
	.out_unco_cw_count_gray_l(),
	.out_unco_cw_count_gray_u(),
	.out_corr_cw_count_gray_l(),
	.out_corr_cw_count_gray_u(),
  .symbol_err_count_gray_l(),
  .symbol_err_count_gray_u(),
	.RX_MD_HI_SER(),
	.in_errorInjectionMode(in_errorInjectionMode)
);

initial begin
	//a soft reset for csr
	csr_reset_n=1'b1;
//	#50000 csr_reset_n=1'b0;
//	#200 csr_reset_n=1'b1;
end

wire correct;
chk192_sendtime inst_chk(
	.clk(clkcore),
	.reset_n(reset_n),
	.rcvtime(rcvtime),
	.data(rxdata),
	.pop(rxpop),
	.error(rxerror),
	.correct(correct)
);


endmodule
