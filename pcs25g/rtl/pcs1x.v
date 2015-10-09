module pcs1x (
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
//=================tx====================


//from clkcore to clkpma_tx
wire  sync_postfifo;
wire [`UNITWIDTH-1:0] data_postfifo;
wire tx_en_postfifo;
wire ideal_postfifo;
tx_fifo_2x  #(`UNITWIDTH-1+2) inst_tx_fifo(
	.in_enable(in_enable),
   .clk_wr(clkcore),
  .clk_rd(clkpma_tx),
  .reset_n_wr(reset_n_core),
  .reset_n_rd(reset_n_tx),

  .en_wr(in_txdata_en),
  .data_wr({in_txsync,in_txdata}),
  .idle_wr(out_ideal),

  .en_rd(tx_en_postfifo),
  .data_rd({sync_postfifo,data_postfifo}),
  .idle_rd(ideal_postfifo)
);

wire  sync_post_tx_fifo_stage;
wire [`UNITWIDTH-1:0] data_post_tx_fifo_stage;
wire tx_en_post_tx_fifo_stage;
wire ideal_post_tx_fifo_stage;

tx_fifo_stage #(`UNITWIDTH-1+2) inst_tx_fifo_stage(
	.in_enable(in_enable),
	.clock(clkpma_tx),
	.reset_n(reset_n_tx),
	
	//fifo interface
	.en_fifo(tx_en_postfifo),
	.data_fifo({sync_postfifo,data_postfifo}),
	.idle_fifo(ideal_postfifo),

	//escaper interface
	.en_escaper(tx_en_post_tx_fifo_stage),
	.data_escaper({sync_post_tx_fifo_stage,data_post_tx_fifo_stage}),
	.idle_escaper(ideal_post_tx_fifo_stage)
);

wire txdata_en_post_esc;
wire [`UNITWIDTH-1:0] txdata_post_esc;
wire ideal_tx_gearbox;
tx_escaper inst_tx_escaper (
	.in_enable(in_enable),
  .clk(clkpma_tx),
  .reset_n(reset_n_tx),
  
  .in_blocklock_swizzled_local(in_blocklock_swizzled_local),

  //upper interface
  .in_txdata_en(tx_en_post_tx_fifo_stage),
  .in_txdata(data_post_tx_fifo_stage),
  .in_txsync(sync_post_tx_fifo_stage),
  .out_ideal(ideal_post_tx_fifo_stage),

  //lower interface
  .out_txdata_en(txdata_en_post_esc),
  .out_txdata(txdata_post_esc),
  .in_ideal(ideal_tx_gearbox),
  
  .out_inserting_idle(out_inserting_idle),
  .in_lane_id(in_lane_id)
);


wire pop_postscrambler;
wire [2:0] state_postscrambler;
wire [`UNITWIDTH-1:0] data_postscrambler;
scrambler_48 inst_tx_scrambler_48(
	.in_enable(in_enable),
	.clk(clkpma_tx),
	.reset_n(reset_n_tx),

	.in_pop(txdata_en_post_esc),
	.in_data(txdata_post_esc),
	
	.scrambled_result(data_postscrambler),
	.out_pop(pop_postscrambler)
);

tx_gearbox inst_tx_gearbox (
	.in_enable(in_enable),
	.clk(clkpma_tx),
	.reset_n(reset_n_tx),
	
	.in_data(data_postscrambler),
	.in_pop(pop_postscrambler),
	.out_ideal(ideal_tx_gearbox),
	
	.out_data(out_txdata),
	.correct()
);

//=================rx====================
reg [1:0] out_detectedpolar;
wire [65:0] rx_data_66b_pos;
wire data_valid_66b_pos;
wire block_lock_pma_pos;
wire [`UNITWIDTH-1:0] rx_data_48b_pos;
wire data_valid_48b_pos;
rx_block_sync block_sync_pos(
	.in_enable(in_enable),
                        .clk             (clkpma_rx             ),
                        .reset_n        (reset_n_rx        ),

                        .rx_data_in             (in_rxdata             ),
                        .pma_rx_ready_flop      (1'b1      ),//todo : this should be change latter to use serdes's ready signal

                        .block_lock             (block_lock_pma_pos         ),
                        .rx_data_66b            (rx_data_66b_pos            ),
                        .data_valid_66b             (data_valid_66b_pos             ),
                        .rx_data_48b            (rx_data_48b_pos            ),
                        .data_valid_48b             (data_valid_48b_pos             )
                );


wire [65:0] rx_data_66b_neg;
wire data_valid_66b_neg;
wire block_lock_pma_neg;
wire [`UNITWIDTH-1:0] rx_data_48b_neg;
wire data_valid_48b_neg;
rx_block_sync block_sync_neg(
	.in_enable(in_enable),
                        .clk             (clkpma_rx             ),
                        .reset_n        (reset_n_rx        ),

                        .rx_data_in             (~in_rxdata             ),
                        .pma_rx_ready_flop      (1'b1      ),//todo : this should be change latter to use serdes's ready signal

                        .block_lock             (block_lock_pma_neg         ),
                        .rx_data_66b            (rx_data_66b_neg            ),
                        .data_valid_66b             (data_valid_66b_neg             ),
                        .rx_data_48b            (rx_data_48b_neg            ),
                        .data_valid_48b             (data_valid_48b_neg             )
                );

reg block_lock_pma;
reg [`UNITWIDTH-1:0] rx_data_48b;
reg data_valid_48b;

always @(*) begin
	if(INFER_POLAR) begin
		//inferring polar by myself
		if(block_lock_pma_pos && !block_lock_pma_neg) begin
			block_lock_pma=1'b1;
			rx_data_48b=rx_data_48b_pos;
			data_valid_48b=data_valid_48b_pos;
			out_detectedpolar=2'b01;
		end
		else if(block_lock_pma_neg && !block_lock_pma_pos) begin
			block_lock_pma=1'b1;
			rx_data_48b=rx_data_48b_neg;
			data_valid_48b=data_valid_48b_neg;
			out_detectedpolar=2'b00;
		end
		else begin
			block_lock_pma=1'b0;
			rx_data_48b=rx_data_48b_pos;
			data_valid_48b=data_valid_48b_pos;
			out_detectedpolar=2'b11;
		end
	end
	else begin
		//use given polar
		if(GIVEN_POLAR) begin
			//given polar is positive
			block_lock_pma=block_lock_pma_pos;
			rx_data_48b=rx_data_48b_pos;
			data_valid_48b=data_valid_48b_pos;
			out_detectedpolar=2'b01;
		end
		else begin
			//given polar is negative
			block_lock_pma=block_lock_pma_neg;
			rx_data_48b=rx_data_48b_neg;
			data_valid_48b=data_valid_48b_neg;
			out_detectedpolar=2'b00;
		end
	end
end

//inferring block means using block_lock_pma
//or else when GIVEN_BLOCKLOCK is 0, this lane is ignored
wire real_blocklock=INFER_BLOCKLOCK?block_lock_pma:(GIVEN_BLOCKLOCK & block_lock_pma);
sync_2xdff #(1) inst_out_block_lock_core(
	.dout(out_block_lock_core),
	.clk(clkcore), 
	.rst_n(1'b1), 
	.din(real_blocklock)
);

`ifdef PCS_SIM
inplace_dec6466 dec_pos(
                        .clk                    (clkpma_rx       ),
                        .reset_n                  (reset_n_rx        ),

                        .in_data       		(rx_data_66b_pos     ),
                        .in_valid               (data_valid_66b_pos      )
                );
inplace_dec6466 dec_neg(
                        .clk                    (clkpma_rx       ),
                        .reset_n                  (reset_n_rx        ),

                        .in_data       		(rx_data_66b_neg     ),
                        .in_valid               (data_valid_66b_neg      )
                );
`endif

wire [`UNITWIDTH-1:0] rx_data_48b_descramble;
wire 	data_valid_48b_descramble;

descrambler_48 inst_rx_descrambler_48(
	.in_enable(in_enable),
	.clk(clkpma_rx),
	.reset_n(reset_n_rx),

	.in_pop(data_valid_48b & real_blocklock),
	.in_data(rx_data_48b),
	
	.scrambled_result(rx_data_48b_descramble),
	.out_pop(data_valid_48b_descramble)
);

wire [`UNITWIDTH-1:0] rx_data_48b_deescaper;
wire 	data_valid_48b_deescaper;
wire 	sync_deescaper;
rx_deescaper inst_rx_deescaper (
	.in_enable(in_enable),
	.clk(clkpma_rx),
	.reset_n(reset_n_rx),

	.in_pop(data_valid_48b_descramble),
	.in_data(rx_data_48b_descramble),
	
	.out_data(rx_data_48b_deescaper),
	.out_pop(data_valid_48b_deescaper),
	.out_sync(sync_deescaper)
);


`ifdef PCS_SIM
chk_dec inst_chk_dec(
                        .clk                    (clkpma_rx       ),
                        .reset_n                  (reset_n_rx        ),
			
                        .in_data       		(rx_data_48b_deescaper     ),
                        .in_valid               (data_valid_48b_deescaper  ),
			.in_sync		(sync_deescaper),
			.correct		()
			
);
`endif

wire [`LANENUMBER-1:0]	out_blocklock_remote_new;
wire	out_blocklock_remote_en_new;

wire canpop_fifo;
wire pop_fifo;
wire [`UNITWIDTH:0] data_fifo;
wire data_valid_fifo;


wire softreset_core;
sync_2xdff inst_sync_2xdff_softreset_core(
    // Outputs
    .dout(softreset_core),
    // Inputs
    .clk(clkcore), 
    .rst_n(1'b1), 
    .din(in_softreset)
    );
wire softreset_rx;
sync_2xdff inst_sync_2xdff_softreset_rx(
    // Outputs
    .dout(softreset_rx),
    // Inputs
    .clk(clkpma_rx), 
    .rst_n(1'b1), 
    .din(in_softreset)
    );


rx_fifo_2x_32 #(`UNITWIDTH-1+2) inst_rx_fifo(
	.in_enable(in_enable),
	.clk_wr(clkpma_rx),
	.clk_rd(clkcore),
	.reset_n_wr(reset_n_rx&!softreset_rx),
	.reset_n_rd(reset_n_core&!softreset_core),
	.dissync_enable(dissync_enable),
	
	.en_wr(data_valid_48b_deescaper),
	.data_wr({sync_deescaper,rx_data_48b_deescaper}),

	.canpop(canpop_fifo),
	.pop_rd(pop_fifo),
	.data_rd(data_fifo),
	.data_valid(data_valid_fifo),
	.dissync(out_dissync)

);

rx_fifo_stage #(`UNITWIDTH-1+2) inst_rx_fifo_stage(
	.in_enable(in_enable),
	.clock(clkcore),
	.reset_n(reset_n_core&!softreset_core),

	.canpop_fifo(canpop_fifo),
	.pop_fifo(pop_fifo),
	.data_fifo(data_fifo),
	.data_valid_fifo(data_valid_fifo),

	.canpop_collector(out_canpop),
	.pop_collector(in_pop),
	.data_collector(out_rxdata),
	.data_valid_collector(out_rxdata_valid),
	.issync_collector(out_issync),
	
	.out_blocklock_remote(out_blocklock_remote_new),
	.out_blocklock_remote_en(out_blocklock_remote_en_new)
);

assign	out_blocklock_remote=out_blocklock_remote_new;
assign	out_blocklock_remote_en=out_blocklock_remote_en_new;
`ifdef PCS_SIM
chk_rx_fifo inst_chk_rx_fifo(
	.clk(clkcore),
	.reset_n(reset_n_core),

	.in_data(out_rxdata),
	.in_valid(out_rxdata_valid),
	.in_sync(out_issync),	

	.correct()		
);
`endif

endmodule



