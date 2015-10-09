module distributor(
	in_enable,
	clk,
	reset_n,
	//tx
	in_txdata,
	in_txdata_en,
	out_ideal,
	out_syncing_pre,
	in_empty,
	
	//distributing
	out_txdata0,
	out_txdata_en0,
	out_txsync0,
	in_ideal0,

	out_txdata1,
	out_txdata_en1,
	out_txsync1,
	in_ideal1,

	out_txdata2,
	out_txdata_en2,
	out_txsync2,
	in_ideal2,

	out_txdata3,
	out_txdata_en3,
	out_txsync3,
	in_ideal3
);

input	in_enable;
input	clk;
input	reset_n;
	//tx
input	[`UNITWIDTH*`LANENUMBER-1:0]	in_txdata;
input	 in_txdata_en;
output	out_ideal;
reg	out_ideal;

output	out_syncing_pre;
reg	out_syncing_pre;
input	in_empty;

	//distributing
output	[`UNITWIDTH-1:0]	out_txdata0;
output	out_txdata_en0;
output  out_txsync0;
input	in_ideal0;

output	[`UNITWIDTH-1:0]	out_txdata1;
output	out_txdata_en1;
output  out_txsync1;
input	in_ideal1;

output	[`UNITWIDTH-1:0]	out_txdata2;
output	out_txdata_en2;
output  out_txsync2;
input	in_ideal2;

output	[`UNITWIDTH-1:0]	out_txdata3;
output	out_txdata_en3;
output  out_txsync3;
input	in_ideal3;

wire allidle=
	in_ideal0 & 
	in_ideal1 &
	in_ideal2 &
	in_ideal3 ;

parameter	STATE_NORMAL=2'b00;
parameter	STATE_WAIT4CLEAN=2'b01;//wait until the swizzler have finished sending a data frame
parameter	STATE_WAIT4IDLE=2'b10;
parameter	STATE_SENDING_SYNC=2'b11;

reg	[1:0] state;
reg	[1:0] state_nxt;
reg	[9:0]	cnt;
reg	[9:0]	cnt_nxt;
always @(posedge clk) begin
	if(!reset_n) begin
		state<=STATE_NORMAL;
		cnt<=0;
	end
	else if(in_enable) begin
		state<=state_nxt;
		cnt<=cnt_nxt;
	end
end

reg	[`UNITWIDTH-1:0]	out_txdata0;
reg	[`UNITWIDTH-1:0]	out_txdata1;
reg	[`UNITWIDTH-1:0]	out_txdata2;
reg	[`UNITWIDTH-1:0]	out_txdata3;

reg	out_txdata_en0;
reg	out_txdata_en1;
reg	out_txdata_en2;
reg	out_txdata_en3;

reg	out_txsync0;
reg	out_txsync1;
reg	out_txsync2;
reg	out_txsync3;

always @(*) begin
	out_ideal=1'b0;

	out_txdata0	=in_txdata[`UNITWIDTH*1-1:`UNITWIDTH*0];
	out_txdata1	=in_txdata[`UNITWIDTH*2-1:`UNITWIDTH*1];
	out_txdata2	=in_txdata[`UNITWIDTH*3-1:`UNITWIDTH*2];
	out_txdata3	=in_txdata[`UNITWIDTH*4-1:`UNITWIDTH*3];

	out_txdata_en0  =1'b0;
	out_txdata_en1  =1'b0;
	out_txdata_en2  =1'b0;
	out_txdata_en3  =1'b0;

	out_txsync0  =1'b0;
	out_txsync1  =1'b0;
	out_txsync2  =1'b0;
	out_txsync3  =1'b0;
	
	state_nxt=state;
	cnt_nxt=cnt;

	out_syncing_pre=1'b0;
	
	case(state)
	STATE_NORMAL : begin
		out_ideal=allidle;

		out_txdata_en0  =in_txdata_en;
		out_txdata_en1  =in_txdata_en;
		out_txdata_en2  =in_txdata_en;
		out_txdata_en3  =in_txdata_en;
		
		cnt_nxt=cnt+1;
		if(cnt==0) begin
			if(in_empty) begin//already clean in swizeller
				state_nxt=STATE_WAIT4IDLE;
			end
			else begin
				state_nxt=STATE_WAIT4CLEAN;//wait until the swizzler have send all current data
				out_syncing_pre=1'b1;
			end
		end
		else if(cnt==384 || cnt==768) begin
			out_ideal=1'b0;//no sending in this cycle to compensate for frequency difference
			cnt_nxt=cnt+1;
		end
	end
	STATE_WAIT4CLEAN: begin
		if(in_empty) begin
			state_nxt=STATE_WAIT4IDLE;
		end
		else begin
			out_syncing_pre=1'b1;
			out_ideal=allidle;

			out_txdata_en0  =in_txdata_en;
			out_txdata_en1  =in_txdata_en;
			out_txdata_en2  =in_txdata_en;
			out_txdata_en3  =in_txdata_en;
		end
	end
	STATE_WAIT4IDLE : begin
		if(allidle) begin
		out_txdata_en0  =1'b1;
		out_txdata_en1  =1'b1;
		out_txdata_en2  =1'b1;
		out_txdata_en3  =1'b1;

		out_txsync0  =1'b1;
		out_txsync1  =1'b1;
		out_txsync2  =1'b1;
		out_txsync3  =1'b1;
		
		state_nxt=STATE_NORMAL;	
		end
	end
	endcase
end

`ifdef PCS_SIM
assert_always #(`OVL_FATAL) inst_assert_0(clk,reset_n,!(!allidle & out_ideal));
assert_always #(`OVL_FATAL) inst_assert_1(clk,reset_n,!(!in_ideal0 & out_txdata_en0));
assert_always #(`OVL_FATAL) inst_assert_2(clk,reset_n,!(!in_ideal1 & out_txdata_en1));
assert_always #(`OVL_FATAL) inst_assert_3(clk,reset_n,!(!in_ideal2 & out_txdata_en2));
assert_always #(`OVL_FATAL) inst_assert_4(clk,reset_n,!(!in_ideal3 & out_txdata_en3));
`endif

endmodule 
