module pcs1x_empty (
	in_enable,
  reset_n_core,
  clkcore,
  dissync_enable,
	INFER_POLAR,
	GIVEN_POLAR,
	INFER_BLOCKLOCK,
	GIVEN_BLOCKLOCK,
	out_detectedpolar,

  //tx
  clkpma_tx,
  reset_n_tx,
  //tx link interface
  in_txdata_en,
  in_txdata,
  in_txsync,
  out_ideal,
  in_softreset,
  //tx hss interface
  out_txdata,
  
  //rx
  clkpma_rx,
  reset_n_rx,
  //rx link interface
  out_canpop,
  out_issync,
  in_pop,
  out_rxdata,
  out_rxdata_valid,
  out_dissync,
  //rx hss interface
  in_rxdata,
  out_block_lock_core,

  in_blocklock_swizzled_local,
  out_blocklock_remote,
  out_blocklock_remote_en,
  
  out_inserting_idle,
  in_lane_id
);
input in_enable;
input reset_n_core;
input clkcore;
input dissync_enable;
input	INFER_POLAR;
input	GIVEN_POLAR;
input	INFER_BLOCKLOCK;
input	GIVEN_BLOCKLOCK;

output	[1:0] out_detectedpolar;

//tx
input  clkpma_tx;
input  reset_n_tx;
input  in_txdata_en;
input [`UNITWIDTH-1:0]  in_txdata;
input	in_txsync;
//to link
output out_ideal;
input in_softreset;
//to serdes
output [`UNITWIDTH_PMA-1:0]  out_txdata;

  //rx
input  clkpma_rx;
input  reset_n_rx;
output  out_canpop;
output  out_issync;
input  in_pop;
output [`UNITWIDTH-1:0]  out_rxdata;
output  out_rxdata_valid;
output  out_dissync;
//to serdes
input [`UNITWIDTH_PMA-1:0]  in_rxdata;

output  out_block_lock_core;
//reg    out_block_lock_core;

input	[3:0] in_blocklock_swizzled_local;
output [3:0]  out_blocklock_remote;
output  out_blocklock_remote_en;

output	out_inserting_idle;
input	[2:0] in_lane_id;


assign	out_detectedpolar=2'b00;
assign	out_ideal=1'b1;
assign	out_txdata={`UNITWIDTH_PMA{1'b0}};
assign	out_canpop=1'b0;
assign	out_issync=1'b0;
assign 	out_rxdata={`UNITWIDTH{1'b0}};
assign	out_rxdata_valid=1'b0;
assign	out_dissync=1'b0;
assign	out_block_lock_core=1'b0;
assign	out_blocklock_remote=4'b0;
assign	out_blocklock_remote_en=1'b0;
assign	out_inserting_idle=1'b0;

endmodule
