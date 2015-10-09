//generating flushing flow to :
//1 maintain steady data flow to seperate the sync characters in rx fifo
//2 prevent the data remained in tx_swizzler when not all lanes are available for tx and rx
module tx_flusher (
	in_enable,
	clk,
	reset_n,

	//interface to upper
	in_txdata,
	in_txdata_valid,
	out_idle,

	//interface to lower
	out_txdata,
	out_txdata_valid,
	in_idle
);
input	in_enable;
input	clk;
input	reset_n;

	//interface to upper
input	[191:0] in_txdata;
input	in_txdata_valid;
output	out_idle;
reg	out_idle;

	//interface to lower
output	[191:0] out_txdata;
output	out_txdata_valid;
reg	[191:0] out_txdata;
reg	out_txdata_valid;
input	in_idle;

parameter	STATE_NORMAL=2'b00;
parameter	STATE_SENDESC=2'b01;//wait until the swizzler have finished sending a data frame
parameter	STATE_SENDFLUSH=2'b10;


reg	[3:0]	idle_cnt;
reg	[3:0]	idle_cnt_nxt;
reg	[1:0]	state;
reg	[1:0]	state_nxt;

always @(posedge clk) begin
	if(!reset_n) begin
		idle_cnt <= 0;
		state <= STATE_NORMAL;
	end
	else if(in_enable) begin
		idle_cnt <= idle_cnt_nxt;
		state <= state_nxt;
	end
end

wire sending_ESC_PACK = ( in_txdata == `ESC_PACK );
always @(*) begin
	state_nxt=state;
	idle_cnt_nxt=idle_cnt;
	out_txdata=in_txdata;
	out_txdata_valid=in_txdata_valid;
	out_idle=in_idle;
	case(state)
	STATE_NORMAL : begin
		if(in_idle && !in_txdata_valid) begin
			//can send but no data to send
			if(idle_cnt==4'h7) begin
				//too long ideal, I will send an ESC_PACK now,
				// and then send a FLUSH_PACK next cycle
				idle_cnt_nxt = 4'h0;
				state_nxt=STATE_SENDFLUSH;
				out_txdata=`ESC_PACK;
				out_txdata_valid=1'b1;
			end
			else begin
				idle_cnt_nxt = idle_cnt+1;
			end
		end
		else if(in_idle && in_txdata_valid && sending_ESC_PACK) begin
			//the sending data happen to be the ESC_PACK
			// so we need to send another ESC_PACK
			idle_cnt_nxt = 4'h0;
			state_nxt=STATE_SENDESC;
			out_txdata=`ESC_PACK;
			out_txdata_valid=1'b1;
		end
		else begin
			idle_cnt_nxt=4'h0;
		end
	end
	STATE_SENDESC : begin
		out_txdata=`ESC_PACK;
		out_idle=1'b0;
		idle_cnt_nxt = 4'h0;
		if(in_idle) begin
			out_txdata_valid=1'b1;
			state_nxt=STATE_NORMAL;
		end
		else begin
			out_txdata_valid=1'b0;
			state_nxt=state;
		end
	end
	STATE_SENDFLUSH : begin
		out_txdata=`FLUSH_PACK;
		out_idle=1'b0;
		idle_cnt_nxt=4'h0;
		if(in_idle) begin
			out_txdata_valid=1'b1;
			state_nxt=STATE_NORMAL;
		end
		else begin
			out_txdata_valid=1'b0;
			state_nxt=state;
		end
	end
	endcase
end

`ifdef PCS_SIM
assert_always #(`OVL_FATAL) inst_assert_0(clk,reset_n,!out_txdata_valid | in_idle);
`endif


endmodule
