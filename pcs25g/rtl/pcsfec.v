module pcsfec (
	//common IO
	reset_n_core,
	clkcore,
	//tx
	llp_phy_data,
	llp_phy_data_valid,
	phy_llp_phy_idle,
	//rx
	phy_llp_data,
	phy_llp_data_valid,
	phy_llp_data_error,
	phy_llp_ready,
	
	
	clkpma_tx,
	clkpma_rx0_div2,
	clkpma_tx_div2,
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

	//config and status for pcs25g	
	in_INFER_BLOCKLOCK,//default 1
	in_GIVEN_BLOCKLOCK,//0
	out_tx_block_lock,//this is used for tx
	out_dissync_counter,
	out_lane_id,
	out_detectedpolar,
	
	//config and status for cgfec
	in_MD_BYPASS_CORR_ENABLE,//default 0
	in_MD_BYPASS_IND_ENABLE,//default 0
  in_unco_cw_count_reset,//default 0
  in_corr_cw_count_reset,//default 0
  in_symbol_err_count_reset,//default 0
  in_ram_enable,//default 0
	out_unco_cw_count_gray_l,
	out_unco_cw_count_gray_u,
	out_corr_cw_count_gray_l,
	out_corr_cw_count_gray_u,
  symbol_err_count_gray_l,
  symbol_err_count_gray_u,
	RX_MD_HI_SER,
	
	//configuration and status for common
	//selecting pcs25g or cgfec
`ifndef FPGA_IMPLEMENTATION
`ifndef FOURTYG
	in_USE_PCS25G,//default 1 to use old pcs, 0 to use fec
`endif
`endif
	in_csr_reset_n,//need to write 0 and the 1 to reset the pcsfec core, default 1
	in_dissync_enable,//default 1
	in_INFER_POLAR,//default 1
	in_GIVEN_POLAR,//0
	in_errorInjectionMode,// default 0 no error
	out_block_lock,
	out_counterDIV1M_rx0,
	out_counterDIV1M_rx1,
	out_counterDIV1M_rx2,
	out_counterDIV1M_rx3,
	out_counterDIV1M_tx ,
	out_counterDIV1M_core
);
input reset_n_core;
input clkcore;
input   in_dissync_enable;
input	in_INFER_POLAR;
input	[3:0] in_GIVEN_POLAR;
input [1:0] in_errorInjectionMode;//00 : no error , 01: 10^-3, 10: 10^-5, 11: 10^-7
input	in_INFER_BLOCKLOCK;
input	[3:0] in_GIVEN_BLOCKLOCK;
output	[7:0]	out_detectedpolar;

input in_MD_BYPASS_CORR_ENABLE;
input in_MD_BYPASS_IND_ENABLE;
input  in_unco_cw_count_reset;
input  in_corr_cw_count_reset;
input [3:0]   in_symbol_err_count_reset;
input          in_ram_enable;
output [15:0]  out_unco_cw_count_gray_l;
output [15:0]  out_unco_cw_count_gray_u;
output [15:0]  out_corr_cw_count_gray_l;
output [15:0]  out_corr_cw_count_gray_u;
output [(4*16)-1:0]  symbol_err_count_gray_l;
output [(4*16)-1:0]  symbol_err_count_gray_u;
output					RX_MD_HI_SER;

output	[`LANENUMBER-1:0]	out_block_lock;
output	[`LANENUMBER-1:0]	out_tx_block_lock;
output  [15:0]  out_dissync_counter;
output	[`LANENUMBER*4-1:0]	out_lane_id;
//tx
input [`UNITWIDTH*`LANENUMBER-1:0]	llp_phy_data;
input	 llp_phy_data_valid;
output		phy_llp_phy_idle;
output	phy_llp_ready;
//rx
output	[`UNITWIDTH*`LANENUMBER-1:0] phy_llp_data;
output	phy_llp_data_valid;
output	phy_llp_data_error;

input	clkpma_tx;
input	clkpma_rx0_div2;
input	clkpma_tx_div2;

	//tx 0
output [`UNITWIDTH_PMA-1:0]	txdata0;
	//rx 0
input	clkpma_rx0;
input [`UNITWIDTH_PMA-1:0]	rxdata0;

	//tx 1
output [`UNITWIDTH_PMA-1:0]	txdata1;
	//rx 1
input	clkpma_rx1;
input [`UNITWIDTH_PMA-1:0]	rxdata1;

	//tx 2
output [`UNITWIDTH_PMA-1:0]	txdata2;
	//rx 2
input	clkpma_rx2;
input [`UNITWIDTH_PMA-1:0]	rxdata2;

	//tx 3
output [`UNITWIDTH_PMA-1:0]	txdata3;
	//rx 3
input	clkpma_rx3;
input [`UNITWIDTH_PMA-1:0]	rxdata3;

wire [`UNITWIDTH_PMA-1:0]	rxdata0w;
wire [`UNITWIDTH_PMA-1:0]	rxdata1w;
wire [`UNITWIDTH_PMA-1:0]	rxdata2w;
wire [`UNITWIDTH_PMA-1:0]	rxdata3w;

`ifdef FPGA_IMPLEMENTATION
wire in_USE_PCS25G=1'b1;
`else
`ifdef FOURTYG
wire in_USE_PCS25G=1'b0;
`else
input in_USE_PCS25G;
`endif
`endif
input in_csr_reset_n;

output	[15:0]	out_counterDIV1M_rx0;
output	[15:0]	out_counterDIV1M_rx1;
output	[15:0]	out_counterDIV1M_rx2;
output	[15:0]	out_counterDIV1M_rx3;
output	[15:0]	out_counterDIV1M_tx ;
output	[15:0]	out_counterDIV1M_core;

wire reset_n_tmp=reset_n_core & in_csr_reset_n;

//adding a stage here  to cut the path
wire		phy_llp_phy_idle_staged;
wire	 llp_phy_data_valid_staged;
wire [`UNITWIDTH*`LANENUMBER-1:0]	llp_phy_data_staged;
tx_fifo_stage_idle #(`UNITWIDTH*`LANENUMBER) inst_stage_idle(
	.in_enable(1'b1),
	.clock(clkcore),
	.reset_n(reset_n_tmp),
	
	//fifo interface
	.in_en(llp_phy_data_valid),
	.in_data(llp_phy_data),
	.out_idle(phy_llp_phy_idle),

	//escaper interface
	.out_en(llp_phy_data_valid_staged),
	.out_data(llp_phy_data_staged),
	.in_idle(phy_llp_phy_idle_staged)
);



wire phy_llp_ready_pcs25g;
wire phy_llp_phy_idle_pcs25g;
wire	[`UNITWIDTH*`LANENUMBER-1:0] phy_llp_data_pcs25g;
wire	phy_llp_data_valid_pcs25g;
wire [`UNITWIDTH_PMA-1:0]	txdata0_pcs25g;
wire [`UNITWIDTH_PMA-1:0]	txdata1_pcs25g;
wire [`UNITWIDTH_PMA-1:0]	txdata2_pcs25g;
wire [`UNITWIDTH_PMA-1:0]	txdata3_pcs25g;
wire [`LANENUMBER-1:0] block_lock_tmp;
wire	[`LANENUMBER*4-1:0]	out_lane_id_pcs25g;
wire	[7:0]	out_detectedpolar_pcs25g;
wire  [15:0]  dissync_counter_pcs25g;
pcs4x_nocsr inst_pcs4x_nocsr(
	.reset_n_core(reset_n_tmp),
	.clkcore(clkcore),
	.in_enable(in_USE_PCS25G),
	
	.dissync_enable(in_dissync_enable),
	.INFER_POLAR(in_INFER_POLAR),
	.GIVEN_POLAR(in_GIVEN_POLAR),
	.INFER_BLOCKLOCK(in_INFER_BLOCKLOCK),
	.GIVEN_BLOCKLOCK(in_GIVEN_BLOCKLOCK),
	.out_detectedpolar(out_detectedpolar_pcs25g),
	
	.block_lock(block_lock_tmp),
	.tx_block_lock(out_tx_block_lock),//this is used for tx
	.dissync_counter(dissync_counter_pcs25g),
	.out_lane_id(out_lane_id_pcs25g),
	//tx
	.llp_phy_data(llp_phy_data_staged),
	.llp_phy_data_valid(llp_phy_data_valid_staged&in_USE_PCS25G),
	.phy_llp_phy_idle(phy_llp_phy_idle_pcs25g),
	//rx
	.phy_llp_data(phy_llp_data_pcs25g),
	.phy_llp_data_valid(phy_llp_data_valid_pcs25g),
	.phy_llp_ready(phy_llp_ready_pcs25g),
	
	
	.clkpma_tx(clkpma_tx),
	//tx 0
	.txdata0(txdata0_pcs25g),
	//rx 0
	.clkpma_rx0(clkpma_rx0),
	.rxdata0(rxdata0w),
	//tx 1
	.txdata1(txdata1_pcs25g),
	//rx 1
	.clkpma_rx1(clkpma_rx1),
	.rxdata1(rxdata1w),
	//tx 2
	.txdata2(txdata2_pcs25g),
	//rx 2
	.clkpma_rx2(clkpma_rx2),
	.rxdata2(rxdata2w),
	//tx 3
	.txdata3(txdata3_pcs25g),
	//rx 3
	.clkpma_rx3(clkpma_rx3),
	.rxdata3(rxdata3w)
);
assign	phy_llp_ready=phy_llp_ready_pcs25g;
assign	phy_llp_phy_idle_staged=phy_llp_phy_idle_pcs25g;
assign	phy_llp_data=phy_llp_data_pcs25g;
assign	phy_llp_data_valid=phy_llp_data_valid_pcs25g;
assign	phy_llp_data_error=1'b0;
assign	txdata0=txdata0_pcs25g;
assign	txdata1=txdata1_pcs25g;
assign	txdata2=txdata2_pcs25g;
assign	txdata3=txdata3_pcs25g;
assign	out_block_lock=block_lock_tmp;
assign	out_lane_id=out_lane_id_pcs25g;
assign	out_detectedpolar=out_detectedpolar_pcs25g;
assign	RX_MD_HI_SER=1'b0;
assign out_dissync_counter=dissync_counter_pcs25g;


/*clock_counter inst_clock_counter_rx0(.clk(clkpma_rx0),.reset_n(reset_n_tmp),.out_counterDIV1M(out_counterDIV1M_rx0));
clock_counter inst_clock_counter_rx1(.clk(clkpma_rx1),.reset_n(reset_n_tmp),.out_counterDIV1M(out_counterDIV1M_rx1));
clock_counter inst_clock_counter_rx2(.clk(clkpma_rx2),.reset_n(reset_n_tmp),.out_counterDIV1M(out_counterDIV1M_rx2));
clock_counter inst_clock_counter_rx3(.clk(clkpma_rx3),.reset_n(reset_n_tmp),.out_counterDIV1M(out_counterDIV1M_rx3));
clock_counter inst_clock_counter_tx (.clk(clkpma_tx ),.reset_n(reset_n_tmp),.out_counterDIV1M(out_counterDIV1M_tx ));
clock_counter inst_clock_counter_core (.clk(clkcore ),.reset_n(reset_n_tmp),.out_counterDIV1M(out_counterDIV1M_core));
*/
assign	out_counterDIV1M_rx0          =16'b0;
assign	out_counterDIV1M_rx1          =16'b0;
assign	out_counterDIV1M_rx2          =16'b0;
assign	out_counterDIV1M_rx3          =16'b0;
assign	out_counterDIV1M_tx           =16'b0;
assign	out_counterDIV1M_core          =16'b0;


//injecting errors into input frames
errorInjecting inst_errorInjecting_0 (
	.clk(clkpma_rx0),
	.reset_n(reset_n_tmp),
	.in_errorInjectionMode(in_errorInjectionMode),
	.ind(rxdata0),
	.outd(rxdata0w)
);

errorInjecting inst_errorInjecting_1 (
	.clk(clkpma_rx1),
	.reset_n(reset_n_tmp),
	.in_errorInjectionMode(in_errorInjectionMode),
	.ind(rxdata1),
	.outd(rxdata1w)
);

errorInjecting inst_errorInjecting_2 (
	.clk(clkpma_rx2),
	.reset_n(reset_n_tmp),
	.in_errorInjectionMode(in_errorInjectionMode),
	.ind(rxdata2),
	.outd(rxdata2w)
);

errorInjecting inst_errorInjecting_3 (
	.clk(clkpma_rx3),
	.reset_n(reset_n_tmp),
	.in_errorInjectionMode(in_errorInjectionMode),
	.ind(rxdata3),
	.outd(rxdata3w)
);

endmodule
