module chip_sendESC (
	reset_n,
	clkcore,
	rx_reversed,
	sendtime,
	rcvtime,

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
	rxdata3,
	//tx 4
	txdata4,
	//rx 4
	clkpma_rx4,
	rxdata4,
	//tx 5
	txdata5,
	//rx 5
	clkpma_rx5,
	rxdata5,
	//tx 6
	txdata6,
	//rx 6
	clkpma_rx6,
	rxdata6,
	//tx 7
	txdata7,
	//rx 7
	clkpma_rx7,
	rxdata7,
	NO_DISSYNC
	) ;
input NO_DISSYNC;
input 	reset_n;
input 	clkcore;
input		rx_reversed;
input  	sendtime;
input  	rcvtime;

input	clkpma_tx;
	//tx 0
output [19:0]	txdata0;
	//rx 0
input	clkpma_rx0;
input [19:0]	rxdata0;

	//tx 1
output [19:0]	txdata1;
	//rx 1
input	clkpma_rx1;
input [19:0]	rxdata1;

	//tx 2
output [19:0]	txdata2;
	//rx 2
input	clkpma_rx2;
input [19:0]	rxdata2;

	//tx 3
output [19:0]	txdata3;
	//rx 3
input	clkpma_rx3;
input [19:0]	rxdata3;

	//tx 4
output [19:0]	txdata4;
	//rx 4
input	clkpma_rx4;
input [19:0]	rxdata4;

	//tx 5
output [19:0]	txdata5;
	//rx 5
input	clkpma_rx5;
input [19:0]	rxdata5;

	//tx 6
output [19:0]	txdata6;
	//rx 6
input	clkpma_rx6;
input [19:0]	rxdata6;

	//tx 7
output [19:0]	txdata7;
	//rx 7
input	clkpma_rx7;
input [19:0]	rxdata7;

wire [191:0]  txdata;
wire  txpop;

wire out_ideal;
gen192_sendtime_sendESC inst_gen(
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
pcs8x_nocsr inst_pcs8x(
	.reset_n_core(reset_n_core),
	.clkcore(clkcore),
	.dissync_enable(NO_DISSYNC),
	.block_lock(),
	.tx_block_lock(),
	.dissync_counter(),
	//tx
	.llp_phy_data(txdata),
	.llp_phy_data_valid(txpop),
	.phy_llp_phy_idle(out_ideal),
	//rx
	.phy_llp_data(rxdata),
	.phy_llp_data_valid(rxpop),
	.phy_llp_ready(),

	.clkpma_tx(clkpma_tx),
	//tx 0
	.txdata0(txdata0),
	//rx 0
	.clkpma_rx0(clkpma_rx0),
	.rxdata0(rxdata0),
	//tx 1
	.txdata1(txdata1),
	//rx 1
	.clkpma_rx1(clkpma_rx1),
	.rxdata1(rxdata1),
	//tx 2
	.txdata2(txdata2),
	//rx 2
	.clkpma_rx2(clkpma_rx2),
	.rxdata2(rxdata2),
	//tx 3
	.txdata3(txdata3),
	//rx 3
	.clkpma_rx3(clkpma_rx3),
	.rxdata3(rxdata3),
	//tx 4
	.txdata4(txdata4),
	//rx 4
	.clkpma_rx4(clkpma_rx4),
	.rxdata4(rxdata4),
	//tx 5
	.txdata5(txdata5),
	//rx 5
	.clkpma_rx5(clkpma_rx5),
	.rxdata5(rxdata5),
	//tx 6
	.txdata6(txdata6),
	//rx 6
	.clkpma_rx6(clkpma_rx6),
	.rxdata6(rxdata6),
	//tx 7
	.txdata7(txdata7),
	//rx 7
	.clkpma_rx7(clkpma_rx7),
	.rxdata7(rxdata7)

);

wire correct;
chk192_sendtime_sendESC inst_chk(
	.clk(clkcore),
	.reset_n(reset_n),
	.rcvtime(rcvtime),
	.data(rxdata),
	.pop(rxpop),
	.correct(correct)
);


endmodule
