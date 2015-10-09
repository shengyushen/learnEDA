module collector(
	in_enable,
	reset_n,
	clk,

	//rx link interface
	out_rxdata,
	out_rxdata_valid,
	out_blocklock,
	out_allsync,
	lanes_locked,
	dissync_counter,
	
	//rx pcs interface
	in_block_lock_core,
	
	in_canpop0,
	in_issync0,
	out_pop0,
	in_rxdata0,
	in_rxdata_valid0,
	in_dissync0,
	in_blocklock_remote_0,
	in_blocklock_remote_en_0,

	in_canpop1,
	in_issync1,
	out_pop1,
	in_rxdata1,
	in_rxdata_valid1,
	in_dissync1,
	in_blocklock_remote_1,
	in_blocklock_remote_en_1,

	in_canpop2,
	in_issync2,
	out_pop2,
	in_rxdata2,
	in_rxdata_valid2,
	in_dissync2,
	in_blocklock_remote_2,
	in_blocklock_remote_en_2,

	in_canpop3,
	in_issync3,
	out_pop3,
	in_rxdata3,
	in_rxdata_valid3,
	in_dissync3,
	in_blocklock_remote_3,
	in_blocklock_remote_en_3,

	out_blocklock_remote,
	out_blocklock_remote_en,
	
	softreset
);
input	in_enable;
input	reset_n;
input	clk;

	//rx link interface
output [`UNITWIDTH*`LANENUMBER-1:0]	out_rxdata;
output	out_rxdata_valid;
reg	out_rxdata_valid_in;
output	[`LANENUMBER-1:0]	out_blocklock;
output	out_allsync;
output	lanes_locked;
reg	lanes_locked;
reg	lanes_locked_nxt;
output	[15:0] dissync_counter;
reg	[15:0] dissync_counter;

	//rx pcs interface
input	[`LANENUMBER-1:0]	in_block_lock_core;

input	in_canpop0;
input	in_issync0;
output	out_pop0;
reg	out_pop0;
input	[`UNITWIDTH-1:0]	in_rxdata0;
input	in_rxdata_valid0;
input	[`LANENUMBER-1:0]	in_blocklock_remote_0;
input	in_blocklock_remote_en_0;
input	in_dissync0;

input	in_canpop1;
input	in_issync1;
output	out_pop1;
reg	out_pop1;
input	[`UNITWIDTH-1:0]	in_rxdata1;
input	in_rxdata_valid1;
input	[`LANENUMBER-1:0]	in_blocklock_remote_1;
input	in_blocklock_remote_en_1;
input	in_dissync1;

input	in_canpop2;
input	in_issync2;
output	out_pop2;
reg	out_pop2;
input	[`UNITWIDTH-1:0]	in_rxdata2;
input	in_rxdata_valid2;
input	[`LANENUMBER-1:0]	in_blocklock_remote_2;
input	in_blocklock_remote_en_2;
input	in_dissync2;

input	in_canpop3;
input	in_issync3;
output	out_pop3;
reg	out_pop3;
input	[`UNITWIDTH-1:0]	in_rxdata3;
input	in_rxdata_valid3;
input	[`LANENUMBER-1:0]	in_blocklock_remote_3;
input	in_blocklock_remote_en_3;
input	in_dissync3;

output	[`LANENUMBER-1:0]		out_blocklock_remote;
output	out_blocklock_remote_en;
reg	[`LANENUMBER-1:0]		out_blocklock_remote;
reg	out_blocklock_remote_en;

output softreset;
reg	softreset;
/*dealing with the change of block lock status*/
reg	[`LANENUMBER-1:0]	reg_block_lock_core_stg1;
reg	[`LANENUMBER-1:0]	reg_block_lock_core_stg2;

always @(posedge clk) begin
	if(!reset_n) begin
		reg_block_lock_core_stg1<={`LANENUMBER{1'b0}};
		reg_block_lock_core_stg2<={`LANENUMBER{1'b0}};
	end
	else if(in_enable) begin
		reg_block_lock_core_stg1<=in_block_lock_core;
		reg_block_lock_core_stg2<=reg_block_lock_core_stg1;
	end
end
assign	out_blocklock=reg_block_lock_core_stg2;

parameter	STATE_NORMAL=3'b000;
parameter	STATE_WAIT4ALLSYNC=3'b001;

reg [2:0]	state;
reg [2:0]	state_nxt;
reg	[3:0] timeout_cnt;
reg	[3:0] timeout_cnt_nxt;
wire exist_dissync=in_dissync0 | in_dissync1 | in_dissync2 | in_dissync3 ;
reg [4:0] softreset_cnt;
always @(posedge clk) begin
	if(!reset_n) begin
		softreset_cnt<=0;
	end
	else if(in_enable) begin
		if(exist_dissync|softreset_cnt!=0) begin
			if(softreset_cnt[4]==1'b1) begin
				softreset_cnt<=0;
			end
			else begin
				softreset_cnt<=softreset_cnt+1;
			end
		end
	end
end

always @(posedge clk) begin
	if(!reset_n) begin
		softreset<=1'b0;
	end
	else if(in_enable) begin
		softreset<=(softreset_cnt!=0);
	end
end

always @(posedge clk) begin
	if(!reset_n) begin
		state<=STATE_NORMAL;
		lanes_locked<=1'b0;
		timeout_cnt<=0;
		dissync_counter<=0;
	end
	else if(in_enable) begin
		state<=state_nxt;
		if(exist_dissync) begin
			lanes_locked<=1'b0;
			dissync_counter<=dissync_counter+1;
		end
		else begin
			lanes_locked<=lanes_locked_nxt;
			if(lanes_locked_nxt==1'b0) begin
				dissync_counter<=dissync_counter+1;
			end
		end
		timeout_cnt<=timeout_cnt_nxt;
	end
end



wire exist_sync=
	(reg_block_lock_core_stg2[0] ? in_issync0 : 1'b0 ) |
	(reg_block_lock_core_stg2[1] ? in_issync1 : 1'b0 ) |
	(reg_block_lock_core_stg2[2] ? in_issync2 : 1'b0 ) |
	(reg_block_lock_core_stg2[3] ? in_issync3 : 1'b0 ) ;

wire all_sync=
	(reg_block_lock_core_stg2[0] ? in_issync0 : 1'b1 ) &
	(reg_block_lock_core_stg2[1] ? in_issync1 : 1'b1 ) &
	(reg_block_lock_core_stg2[2] ? in_issync2 : 1'b1 ) &
	(reg_block_lock_core_stg2[3] ? in_issync3 : 1'b1 ) ;

wire all_canpop=
	(reg_block_lock_core_stg2[0] ? in_canpop0 : 1'b1 ) &
	(reg_block_lock_core_stg2[1] ? in_canpop1 : 1'b1 ) &
	(reg_block_lock_core_stg2[2] ? in_canpop2 : 1'b1 ) &
	(reg_block_lock_core_stg2[3] ? in_canpop3 : 1'b1 ) ;

assign	out_allsync=all_sync;
always @(*) begin
	state_nxt=state;
	out_pop0=1'b0;
	out_pop1=1'b0;
	out_pop2=1'b0;
	out_pop3=1'b0;
	out_rxdata_valid_in=1'b0;
	lanes_locked_nxt=lanes_locked;
	timeout_cnt_nxt=0;
	case(state)
	STATE_NORMAL : begin
		if(exist_sync) begin
			if(all_sync) begin //already aligned
				if(all_canpop) begin
					state_nxt=STATE_NORMAL;
					out_pop0=reg_block_lock_core_stg2[0];
					out_pop1=reg_block_lock_core_stg2[1];
					out_pop2=reg_block_lock_core_stg2[2];
					out_pop3=reg_block_lock_core_stg2[3];
					lanes_locked_nxt=1'b1;
				end
			end
			else begin
				state_nxt=STATE_WAIT4ALLSYNC;
				//read those lane without sync
				out_pop0=in_canpop0 & !in_issync0 & reg_block_lock_core_stg2[0];
				out_pop1=in_canpop1 & !in_issync1 & reg_block_lock_core_stg2[1];
				out_pop2=in_canpop2 & !in_issync2 & reg_block_lock_core_stg2[2];
				out_pop3=in_canpop3 & !in_issync3 & reg_block_lock_core_stg2[3];
			end
		end
		else begin
			//normal case
			if(all_canpop) begin
				out_rxdata_valid_in=1'b1;
				out_pop0= reg_block_lock_core_stg2[0];
				out_pop1= reg_block_lock_core_stg2[1];
				out_pop2= reg_block_lock_core_stg2[2];
				out_pop3= reg_block_lock_core_stg2[3];
			end
		end
	end
	STATE_WAIT4ALLSYNC : begin
		if(all_sync) begin
			if(all_canpop) begin
				state_nxt=STATE_NORMAL;
				out_pop0= reg_block_lock_core_stg2[0];
				out_pop1= reg_block_lock_core_stg2[1];
				out_pop2= reg_block_lock_core_stg2[2];
				out_pop3= reg_block_lock_core_stg2[3];
				lanes_locked_nxt=1'b1;
			end
		end
		else begin
			if(timeout_cnt==15) begin
				lanes_locked_nxt=1'b0;
				timeout_cnt_nxt=0;
			end
			else  begin
				timeout_cnt_nxt=timeout_cnt+1;
			end
			//read those lane without sync
			out_pop0=in_canpop0 & !in_issync0 & reg_block_lock_core_stg2[0];
			out_pop1=in_canpop1 & !in_issync1 & reg_block_lock_core_stg2[1];
			out_pop2=in_canpop2 & !in_issync2 & reg_block_lock_core_stg2[2];
			out_pop3=in_canpop3 & !in_issync3 & reg_block_lock_core_stg2[3];
		end
	end
	endcase
end

assign	out_rxdata_valid=out_rxdata_valid_in & lanes_locked;

assign	out_rxdata={
	in_rxdata3,
	in_rxdata2,
	in_rxdata1,
	in_rxdata0
};

always @(posedge clk) begin
	if(!reset_n) begin
		out_blocklock_remote<=0;
		out_blocklock_remote_en<=0;
	end
	else if(in_enable) begin
		out_blocklock_remote<=
		in_blocklock_remote_en_0?in_blocklock_remote_0:
		in_blocklock_remote_en_1?in_blocklock_remote_1:
		in_blocklock_remote_en_2?in_blocklock_remote_2:
		in_blocklock_remote_3
		;
		out_blocklock_remote_en<=
		in_blocklock_remote_en_0 |
		in_blocklock_remote_en_1 |
		in_blocklock_remote_en_2 |
		in_blocklock_remote_en_3 
		;
	end
end
endmodule
