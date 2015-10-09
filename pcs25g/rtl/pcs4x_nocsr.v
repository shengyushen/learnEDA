module pcs4x_nocsr(
	in_enable,
	reset_n_core,
	clkcore,
	
	dissync_enable,
	INFER_POLAR,
	GIVEN_POLAR,
	INFER_BLOCKLOCK,
	GIVEN_BLOCKLOCK,
	out_detectedpolar,
	
	block_lock,
	tx_block_lock,//this is used for tx
	dissync_counter,
	out_lane_id,
	//tx
	llp_phy_data,
	llp_phy_data_valid,
	phy_llp_phy_idle,
	//rx
	phy_llp_data,
	phy_llp_data_valid,
	phy_llp_ready,
	
	
	clkpma_tx,
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
	rxdata3
);
input in_enable;
input reset_n_core;
input clkcore;
input   dissync_enable;
input	INFER_POLAR;
input	[3:0] GIVEN_POLAR;
input	INFER_BLOCKLOCK;
input	[3:0] GIVEN_BLOCKLOCK;
output	[7:0] out_detectedpolar;

output	[`LANENUMBER-1:0]	block_lock;
output	[`LANENUMBER-1:0]	tx_block_lock;
output  [15:0]  dissync_counter;
output	[`LANENUMBER*4-1:0]	out_lane_id;
//tx
input [`UNITWIDTH*`LANENUMBER-1:0]	llp_phy_data;
input	 llp_phy_data_valid;
output		phy_llp_phy_idle;
output	phy_llp_ready;
//rx
output	[`UNITWIDTH*`LANENUMBER-1:0] phy_llp_data;
output	phy_llp_data_valid;

input	clkpma_tx;
wire	reset_n_tx;
	//tx 0
output [`UNITWIDTH_PMA-1:0]	txdata0;
	//rx 0
input	clkpma_rx0;
wire	reset_n_rx0;
input [`UNITWIDTH_PMA-1:0]	rxdata0;

	//tx 1
output [`UNITWIDTH_PMA-1:0]	txdata1;
	//rx 1
input	clkpma_rx1;
wire	reset_n_rx1;
input [`UNITWIDTH_PMA-1:0]	rxdata1;

	//tx 2
output [`UNITWIDTH_PMA-1:0]	txdata2;
	//rx 2
input	clkpma_rx2;
wire	reset_n_rx2;
input [`UNITWIDTH_PMA-1:0]	rxdata2;

	//tx 3
output [`UNITWIDTH_PMA-1:0]	txdata3;
	//rx 3
input	clkpma_rx3;
wire	reset_n_rx3;
input [`UNITWIDTH_PMA-1:0]	rxdata3;


wire in_txdata_en0;
wire [`UNITWIDTH-1:0] in_txdata0;
wire out_ideal0;

wire in_txdata_en1;
wire [`UNITWIDTH-1:0] in_txdata1;
wire out_ideal1;

wire in_txdata_en2;
wire [`UNITWIDTH-1:0] in_txdata2;
wire out_ideal2;

wire in_txdata_en3;
wire [`UNITWIDTH-1:0] in_txdata3;
wire out_ideal3;


wire in_txdataK0;
wire in_txdataK1;
wire in_txdataK2;
wire in_txdataK3;

wire	empty_tx_swizzler;
wire	out_syncing_pre;

wire	[`LANENUMBER-1:0]	out_blocklock_remote;
wire	out_blocklock_remote_en;

wire	[`LANENUMBER-1:0]	out_blocklock_swizzled_local;

wire [`UNITWIDTH*`LANENUMBER-1:0]	txdata_post_txsw;
wire	 txdata_en_txsw;
wire	ideal_txsw;

sync_2xdff inst_sync_2xdff_reset_n_tx(
    // Outputs
    .dout(reset_n_tx),
    // Inputs
    .clk(clkpma_tx), 
    .rst_n(1'b1), 
    .din(reset_n_core)
    );

sync_2xdff inst_sync_2xdff_reset_n_rx0(
    // Outputs
    .dout(reset_n_rx0),
    // Inputs
    .clk(clkpma_rx0), 
    .rst_n(1'b1), 
    .din(reset_n_core)
    );

sync_2xdff inst_sync_2xdff_reset_n_rx1(
    // Outputs
    .dout(reset_n_rx1),
    // Inputs
    .clk(clkpma_rx1), 
    .rst_n(1'b1), 
    .din(reset_n_core)
    );

sync_2xdff inst_sync_2xdff_reset_n_rx2(
    // Outputs
    .dout(reset_n_rx2),
    // Inputs
    .clk(clkpma_rx2), 
    .rst_n(1'b1), 
    .din(reset_n_core)
    );

sync_2xdff inst_sync_2xdff_reset_n_rx3(
    // Outputs
    .dout(reset_n_rx3),
    // Inputs
    .clk(clkpma_rx3), 
    .rst_n(1'b1), 
    .din(reset_n_core)
    );



wire ideal_tx_flusher;
wire [`UNITWIDTH*`LANENUMBER-1:0] out_txdata_tx_flusher;
wire	out_txdata_valid_tx_flusher;
tx_flusher inst_tx_flusher (
	.in_enable(in_enable),
	.clk(clkcore),
	.reset_n(reset_n_core),

	//interface to upper
	.in_txdata(llp_phy_data),
	.in_txdata_valid(llp_phy_data_valid),
	.out_idle(phy_llp_phy_idle),

	//interface to lower
	.out_txdata(out_txdata_tx_flusher),
	.out_txdata_valid(out_txdata_valid_tx_flusher),
	.in_idle(ideal_tx_flusher)
);

tx_swizzler	inst_tx_swizzler(
	.in_enable(in_enable),
	.clk(clkcore),
	.reset_n(reset_n_core),
	.in_blocklock_remote(out_blocklock_remote),
	.in_blocklock_remote_en(out_blocklock_remote_en),
	
	.in_txdata(out_txdata_tx_flusher),
	.in_txdata_valid(out_txdata_valid_tx_flusher),
	.out_idle(ideal_tx_flusher),
	
	.out_txdata(txdata_post_txsw),
	.out_txdata_valid(txdata_en_txsw),
	.out_empty(empty_tx_swizzler),
	.in_idle(ideal_txsw),
	.in_syncing_pre(out_syncing_pre),
	
	.saved_blocklock_remote_pre(tx_block_lock)
);



wire	txsync0;
wire	txsync1;
wire	txsync2;
wire	txsync3;

distributor inst_distributor(
	.in_enable(in_enable),
	.clk(clkcore),
	.reset_n(reset_n_core),
	//tx
	.in_txdata(txdata_post_txsw),
	.in_txdata_en(txdata_en_txsw),
	.out_ideal(ideal_txsw),
	.out_syncing_pre(out_syncing_pre),
	.in_empty(empty_tx_swizzler),
	
	//distributing
	.out_txdata0(in_txdata0),
	.out_txdata_en0(in_txdata_en0),
	.out_txsync0(txsync0),
	.in_ideal0(out_ideal0),

	.out_txdata1(in_txdata1),
	.out_txdata_en1(in_txdata_en1),
	.out_txsync1(txsync1),
	.in_ideal1(out_ideal1),

	.out_txdata2(in_txdata2),
	.out_txdata_en2(in_txdata_en2),
	.out_txsync2(txsync2),
	.in_ideal2(out_ideal2),

	.out_txdata3(in_txdata3),
	.out_txdata_en3(in_txdata_en3),
	.out_txsync3(txsync3),
	.in_ideal3(out_ideal3)
);

wire inserting_idle_lane0;
wire inserting_idle_lane1;
wire inserting_idle_lane2;
wire inserting_idle_lane3;

wire softreset;
wire	out_canpop0;
wire	out_issync0;
wire	in_pop0;
wire	[`UNITWIDTH-1:0]	out_rxdata0;
wire	out_rxdata_valid0;
wire	out_dissync0;
wire [`LANENUMBER-1:0]	out_blocklock_remote_0;
wire	out_blocklock_remote_en_0;
pcs1x inst_lane0(
	.in_enable(in_enable),
	.reset_n_core(reset_n_core),
	.clkcore(clkcore),
	.dissync_enable(dissync_enable),
	.INFER_POLAR(INFER_POLAR),
	.GIVEN_POLAR(GIVEN_POLAR[0]),
	.INFER_BLOCKLOCK(INFER_BLOCKLOCK),
	.GIVEN_BLOCKLOCK(GIVEN_BLOCKLOCK[0]),
	.out_detectedpolar(out_detectedpolar[1:0]),

	//tx
	.clkpma_tx(clkpma_tx),
	.reset_n_tx(reset_n_tx),
	//tx link interface
	.in_txdata_en(in_txdata_en0),
	.in_txdata(in_txdata0),
	.in_txsync(txsync0),
	.out_ideal(out_ideal0),
	.in_softreset(softreset),
	//tx hss interface
	.out_txdata(txdata0),
	
	//rx
	.clkpma_rx(clkpma_rx0),
	.reset_n_rx(reset_n_rx0),
	//rx link interface
	.out_canpop(out_canpop0),
	.out_issync(out_issync0),
	.in_pop(in_pop0),
	.out_rxdata(out_rxdata0),
	.out_rxdata_valid(out_rxdata_valid0),
	.out_dissync(out_dissync0),
	//rx hss interface
	.in_rxdata(rxdata0),
	.out_block_lock_core(block_lock[0]),
	
	.in_blocklock_swizzled_local(out_blocklock_swizzled_local),
	.out_blocklock_remote(out_blocklock_remote_0),
	.out_blocklock_remote_en(out_blocklock_remote_en_0),
	
	.out_inserting_idle(inserting_idle_lane0),
	.in_lane_id(3'h0)
);

wire	out_canpop1;
wire	out_issync1;
wire	in_pop1;
wire	[`UNITWIDTH-1:0]	out_rxdata1;
wire	out_rxdata_valid1;
wire	out_dissync1;
wire [`LANENUMBER-1:0]	out_blocklock_remote_1;
wire	out_blocklock_remote_en_1;
`ifdef NOTUSE_LANE1
pcs1x_empty inst_lane1(
`else
pcs1x inst_lane1(
`endif
	.in_enable(in_enable),
	.reset_n_core(reset_n_core),
	.clkcore(clkcore),
	.dissync_enable(dissync_enable),
	.INFER_POLAR(INFER_POLAR),
	.GIVEN_POLAR(GIVEN_POLAR[1]),
	.INFER_BLOCKLOCK(INFER_BLOCKLOCK),
	.GIVEN_BLOCKLOCK(GIVEN_BLOCKLOCK[1]),
	.out_detectedpolar(out_detectedpolar[3:2]),

	//tx
	.clkpma_tx(clkpma_tx),
	.reset_n_tx(reset_n_tx),
	//tx link interface
	.in_txdata_en(in_txdata_en1),
	.in_txdata(in_txdata1),
	.in_txsync(txsync1),
	.out_ideal(out_ideal1),
	.in_softreset(softreset),
	//tx hss interface
	.out_txdata(txdata1),
	
	//rx
	.clkpma_rx(clkpma_rx1),
	.reset_n_rx(reset_n_rx1),
	//rx link interface
	.out_canpop(out_canpop1),
	.out_issync(out_issync1),
	.in_pop(in_pop1),
	.out_rxdata(out_rxdata1),
	.out_rxdata_valid(out_rxdata_valid1),
	.out_dissync(out_dissync1),
	//rx hss interface
	.in_rxdata(rxdata1),
	.out_block_lock_core(block_lock[1]),

	.in_blocklock_swizzled_local(out_blocklock_swizzled_local),
	.out_blocklock_remote(out_blocklock_remote_1),
	.out_blocklock_remote_en(out_blocklock_remote_en_1),
	
	.out_inserting_idle(inserting_idle_lane1),
	.in_lane_id(3'h1)
);

wire	out_canpop2;
wire	out_issync2;
wire	in_pop2;
wire	[`UNITWIDTH-1:0]	out_rxdata2;
wire	out_rxdata_valid2;
wire	out_dissync2;
wire [`LANENUMBER-1:0]	out_blocklock_remote_2;
wire	out_blocklock_remote_en_2;
`ifdef NOTUSE_LANE2
pcs1x_empty inst_lane2(
`else
pcs1x inst_lane2(
`endif
	.in_enable(in_enable),
	.reset_n_core(reset_n_core),
	.clkcore(clkcore),
	.dissync_enable(dissync_enable),
	.INFER_POLAR(INFER_POLAR),
	.GIVEN_POLAR(GIVEN_POLAR[2]),
	.INFER_BLOCKLOCK(INFER_BLOCKLOCK),
	.GIVEN_BLOCKLOCK(GIVEN_BLOCKLOCK[2]),
	.out_detectedpolar(out_detectedpolar[5:4]),

	//tx
	.clkpma_tx(clkpma_tx),
	.reset_n_tx(reset_n_tx),
	//tx link interface
	.in_txdata_en(in_txdata_en2),
	.in_txdata(in_txdata2),
	.in_txsync(txsync2),
	.out_ideal(out_ideal2),
	.in_softreset(softreset),
	//tx hss interface
	.out_txdata(txdata2),
	
	//rx
	.clkpma_rx(clkpma_rx2),
	.reset_n_rx(reset_n_rx2),
	//rx link interface
	.out_canpop(out_canpop2),
	.out_issync(out_issync2),
	.in_pop(in_pop2),
	.out_rxdata(out_rxdata2),
	.out_rxdata_valid(out_rxdata_valid2),
	.out_dissync(out_dissync2),
	//rx hss interface
	.in_rxdata(rxdata2),
	.out_block_lock_core(block_lock[2]),

	.in_blocklock_swizzled_local(out_blocklock_swizzled_local),
	.out_blocklock_remote(out_blocklock_remote_2),
	.out_blocklock_remote_en(out_blocklock_remote_en_2),
	
	.out_inserting_idle(inserting_idle_lane2),
	.in_lane_id(3'h2)
);

wire	out_canpop3;
wire	out_issync3;
wire	in_pop3;
wire	[`UNITWIDTH-1:0]	out_rxdata3;
wire	out_rxdata_valid3;
wire	out_dissync3;
wire [`LANENUMBER-1:0]	out_blocklock_remote_3;
wire	out_blocklock_remote_en_3;
`ifdef NOTUSE_LANE3
pcs1x_empty inst_lane3(
`else
pcs1x inst_lane3(
`endif
	.in_enable(in_enable),
	.reset_n_core(reset_n_core),
	.clkcore(clkcore),
	.dissync_enable(dissync_enable),
	.INFER_POLAR(INFER_POLAR),
	.GIVEN_POLAR(GIVEN_POLAR[3]),
	.INFER_BLOCKLOCK(INFER_BLOCKLOCK),
	.GIVEN_BLOCKLOCK(GIVEN_BLOCKLOCK[3]),
	.out_detectedpolar(out_detectedpolar[7:6]),

	//tx
	.clkpma_tx(clkpma_tx),
	.reset_n_tx(reset_n_tx),
	//tx link interface
	.in_txdata_en(in_txdata_en3),
	.in_txdata(in_txdata3),
	.in_txsync(txsync3),
	.out_ideal(out_ideal3),
	.in_softreset(softreset),
	//tx hss interface
	.out_txdata(txdata3),
	
	//rx
	.clkpma_rx(clkpma_rx3),
	.reset_n_rx(reset_n_rx3),
	//rx link interface
	.out_canpop(out_canpop3),
	.out_issync(out_issync3),
	.in_pop(in_pop3),
	.out_rxdata(out_rxdata3),
	.out_rxdata_valid(out_rxdata_valid3),
	.out_dissync(out_dissync3),
	//rx hss interface
	.in_rxdata(rxdata3),
	.out_block_lock_core(block_lock[3]),

	.in_blocklock_swizzled_local(out_blocklock_swizzled_local),
	.out_blocklock_remote(out_blocklock_remote_3),
	.out_blocklock_remote_en(out_blocklock_remote_en_3),
	
	.out_inserting_idle(inserting_idle_lane3),
	.in_lane_id(3'h3)
);

wire [`UNITWIDTH*`LANENUMBER-1:0]	out_rxdata_post_collector;
wire out_rxdata_valid_post_collector;
wire	[`LANENUMBER-1:0]	out_blocklock_post_collector;
wire	out_allsync;
collector inst_collector (
	.in_enable(in_enable),
	.reset_n(reset_n_core),
	.clk(clkcore),

	//rx link interface
	.out_rxdata(out_rxdata_post_collector),
	.out_rxdata_valid(out_rxdata_valid_post_collector),
	.out_blocklock(out_blocklock_post_collector),
	.out_allsync(out_allsync),
	.lanes_locked(phy_llp_ready),
	.dissync_counter(dissync_counter),
	
	//rx pcs interface
	.in_block_lock_core(block_lock),
	
	.in_canpop0(out_canpop0),
	.in_issync0(out_issync0),
	.out_pop0(in_pop0),
	.in_rxdata0(out_rxdata0),
	.in_rxdata_valid0(out_rxdata_valid0),
	.in_dissync0(out_dissync0),
	.in_blocklock_remote_0(out_blocklock_remote_0),
	.in_blocklock_remote_en_0(out_blocklock_remote_en_0),

	.in_canpop1(out_canpop1),
	.in_issync1(out_issync1),
	.out_pop1(in_pop1),
	.in_rxdata1(out_rxdata1),
	.in_rxdata_valid1(out_rxdata_valid1),
	.in_dissync1(out_dissync1),
	.in_blocklock_remote_1(out_blocklock_remote_1),
	.in_blocklock_remote_en_1(out_blocklock_remote_en_1),

	.in_canpop2(out_canpop2),
	.in_issync2(out_issync2),
	.out_pop2(in_pop2),
	.in_rxdata2(out_rxdata2),
	.in_rxdata_valid2(out_rxdata_valid2),
	.in_dissync2(out_dissync2),
	.in_blocklock_remote_2(out_blocklock_remote_2),
	.in_blocklock_remote_en_2(out_blocklock_remote_en_2),

	.in_canpop3(out_canpop3),
	.in_issync3(out_issync3),
	.out_pop3(in_pop3),
	.in_rxdata3(out_rxdata3),
	.in_rxdata_valid3(out_rxdata_valid3),
	.in_dissync3(out_dissync3),
	.in_blocklock_remote_3(out_blocklock_remote_3),
	.in_blocklock_remote_en_3(out_blocklock_remote_en_3),

	.out_blocklock_remote(out_blocklock_remote),
	.out_blocklock_remote_en(out_blocklock_remote_en),
	
	.softreset(softreset)
);

wire [`UNITWIDTH*`LANENUMBER-1:0]	out_rxdata_post_rx_stage;
wire out_rxdata_valid_post_rx_stage;
wire	[`LANENUMBER-1:0]	out_blocklock_post_rx_stage;
wire	out_allsync_post_rx_stage;

//just store for a cycle
rx_stage inst_rx_stage (
	.in_enable(in_enable),
	.clk(clkcore),
	.reset_n(reset_n_core),
	
	.in_rxdata(out_rxdata_post_collector),
	.in_rxdata_valid(out_rxdata_valid_post_collector),
	.in_blocklock(out_blocklock_post_collector),
	.in_allsync(out_allsync),
	
	.out_rxdata(out_rxdata_post_rx_stage),
	.out_rxdata_valid(out_rxdata_valid_post_rx_stage),
	.out_blocklock(out_blocklock_post_rx_stage),
	.out_allsync(out_allsync_post_rx_stage)
);
wire [`UNITWIDTH*`LANENUMBER-1:0]	out_rxdata_post_rx_lane_sorter;
wire		out_rxdata_valid_post_rx_lane_sorter;
wire	[`LANENUMBER-1:0]	out_blocklock_post_rx_lane_sorter;
wire    out_allsync_post_rx_lane_sorter;
rx_lane_sorter inst_rx_lane_sorter (
	.in_enable(in_enable),
	.clk(clkcore),
	.reset_n(reset_n_core),
	
	.in_rxdata(out_rxdata_post_rx_stage),
	.in_rxdata_valid(out_rxdata_valid_post_rx_stage),
	.in_blocklock(out_blocklock_post_rx_stage),
	.in_allsync(out_allsync_post_rx_stage),

	//to distributor
	.out_rxdata(out_rxdata_post_rx_lane_sorter),
	.out_rxdata_valid(out_rxdata_valid_post_rx_lane_sorter),
	.out_blocklock(out_blocklock_post_rx_lane_sorter),
	.out_allsync(out_allsync_post_rx_lane_sorter),
	
	.out_lane_id(out_lane_id)
);
wire [`UNITWIDTH*`LANENUMBER-1:0]	out_rxdata_post_rx_stage2;
wire out_rxdata_valid_post_rx_stage2;
wire	[`LANENUMBER-1:0]	out_blocklock_post_rx_stage2;
wire	out_allsync_post_rx_stage2;

//just store for a cycle
rx_stage inst_rx_stage2 (
	.in_enable(in_enable),
	.clk(clkcore),
	.reset_n(reset_n_core),
	
	.in_rxdata(out_rxdata_post_rx_lane_sorter),
	.in_rxdata_valid(out_rxdata_valid_post_rx_lane_sorter),
	.in_blocklock(out_blocklock_post_rx_lane_sorter),
	.in_allsync(out_allsync_post_rx_lane_sorter),
	
	.out_rxdata(out_rxdata_post_rx_stage2),
	.out_rxdata_valid(out_rxdata_valid_post_rx_stage2),
	.out_blocklock(out_blocklock_post_rx_stage2),
	.out_allsync(out_allsync_post_rx_stage2)
);
assign out_blocklock_swizzled_local=out_blocklock_post_rx_stage2;
wire [`UNITWIDTH*`LANENUMBER-1:0] out_rxdata_rxsw;
wire   out_rxdata_valid_rxsw;
rx_swizzler	inst_rx_swizzler(
	.in_enable(in_enable),
	.clk(clkcore),
	.reset_n(reset_n_core),
	
	.in_rxdata(out_rxdata_post_rx_stage2),
	.in_rxdata_valid(out_rxdata_valid_post_rx_stage2),
	.in_blocklock(out_blocklock_post_rx_stage2),
	.in_allsync(out_allsync_post_rx_stage2),

	.out_rxdata(out_rxdata_rxsw),
	.out_rxdata_valid(out_rxdata_valid_rxsw)
);

rx_deflusher  inst_rx_deflusher(
	.in_enable(in_enable),
	.clk(clkcore),
	.reset_n(reset_n_core),

	.in_rxdata(out_rxdata_rxsw),
	.in_rxdata_valid(out_rxdata_valid_rxsw),
	.in_rxdata_error(1'b0),

	.out_rxdata(phy_llp_data),
	.out_rxdata_valid(phy_llp_data_valid),
	.out_rxdata_error()//error is not used
);

`ifdef PCS_SIM
wire exist_inserting_idle=
 inserting_idle_lane0 | 
 inserting_idle_lane1 | 
 inserting_idle_lane2 | 
 inserting_idle_lane3 ;
wire all_inserting_idle=
 inserting_idle_lane0 & 
 inserting_idle_lane1 & 
 inserting_idle_lane2 & 
 inserting_idle_lane3 ;
 //inserting idle must be at the same time
//assert_always #(`OVL_FATAL) inst_assert_0(clkpma_tx,reset_n_tx,(!exist_inserting_idle | all_inserting_idle));
//this may not hold when one lane is sending a ESC_CHAR
`endif

endmodule
