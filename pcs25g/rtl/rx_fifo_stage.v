module rx_fifo_stage (
	in_enable,
	clock,
	reset_n,

	canpop_fifo,
	pop_fifo,
	data_fifo,
	data_valid_fifo,

	canpop_collector,
	pop_collector,
	data_collector,
	data_valid_collector,
	issync_collector,
	
	out_blocklock_remote,
	out_blocklock_remote_en
);
parameter WR_WIDTH=48;
input in_enable;
input	clock;
input	reset_n;

input	canpop_fifo;
output	pop_fifo;
wire	pop_fifo;
input [WR_WIDTH-1:0]	data_fifo;
input	data_valid_fifo;

output	canpop_collector;
wire	canpop_collector;
output	issync_collector;
wire	issync_collector;
input	pop_collector;
output [WR_WIDTH-2:0]	data_collector;
output	data_valid_collector;

reg [WR_WIDTH-1:0]	data_reg;
reg	data_valid_reg;
reg [WR_WIDTH-1:0]	data_nxt;
reg	data_valid_nxt;

output [3:0]	out_blocklock_remote;
output	out_blocklock_remote_en;
reg [3:0]	out_blocklock_remote;
reg	out_blocklock_remote_en;

always  @(posedge clock) begin
	if(!reset_n) begin
		data_reg <= 0;
		data_valid_reg <= 1'b0;
	end
	else if(in_enable) begin
		data_reg <= data_nxt;
		data_valid_reg <= data_valid_nxt;
	end
end
assign	pop_fifo=(pop_collector|(!data_valid_reg)) & canpop_fifo;

always @(*) begin
	//we can receive data even if there is no pop_fifo
	//this is for forced pop in dissync
	if(data_valid_fifo) begin
		data_nxt=data_fifo;
		data_valid_nxt=data_valid_fifo;
	end
	else if(pop_collector) begin
		data_nxt=data_reg;
		data_valid_nxt=1'b0;
	end
	else begin
		data_nxt=data_reg;
		data_valid_nxt=data_valid_reg;
	end
end
assign	canpop_collector=data_valid_reg;
assign	issync_collector=data_reg[WR_WIDTH-1] & data_valid_reg;
assign	data_collector=data_reg[WR_WIDTH-2:0];
assign	data_valid_collector=data_valid_reg & pop_collector;

always  @(posedge clock) begin
	if(!reset_n) begin
		out_blocklock_remote<=4'b1111;
		out_blocklock_remote_en<=1'b0;
	end
	else if(in_enable) begin
		out_blocklock_remote<=data_reg[3:0];
		out_blocklock_remote_en<=issync_collector;
	end
end


`ifdef PCS_SIM
//assertion for pop_collector -> data_valid_collector
//assert_always #(`OVL_FATAL) inst_assert_0(clock,reset_n,!pop_collector | data_valid_collector);
//assertion for  data_valid_collector ->  pop_collector
//assert_always #(`OVL_FATAL) inst_assert_1(clock,reset_n,!data_valid_collector | pop_collector);
//assertion for  pop_collector ->  canpop_collector
//assert_always #(`OVL_FATAL) inst_assert_2(clock,reset_n,!pop_collector | canpop_collector);

//assertion for pop_fifo -> data_valid_fifo
//assert_always #(`OVL_FATAL) inst_assert_3(clock,reset_n,!pop_fifo | data_valid_fifo);
//assertion for  data_valid_fifo ->  pop_collector
//assert_always #(`OVL_FATAL) inst_assert_4(clock,reset_n,!data_valid_fifo | pop_fifo);
//assertion for  pop_fifo ->  canpop_fifo
//assert_always #(`OVL_FATAL) inst_assert_5(clock,reset_n,!pop_fifo | canpop_fifo);
`endif
endmodule
