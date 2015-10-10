module tx_swizzler(
	in_enable,
	clk,
	reset_n,
	in_blocklock_remote,
	in_blocklock_remote_en,

	in_txdata,
	in_txdata_valid,
	out_idle,
	
	out_txdata,
	out_txdata_valid,
	out_empty,
	in_idle,
	in_syncing_pre,
	
	saved_blocklock_remote_pre
);
input	in_enable;
input	clk;
input	reset_n;
input	[3:0]	in_blocklock_remote;
input	in_blocklock_remote_en;

input	[`UNITWIDTH*`LANENUMBER-1:0] in_txdata;
input	in_txdata_valid;
input			in_syncing_pre;
output	out_idle;
reg	out_idle;
output	out_empty;
reg	out_empty;

output	[`UNITWIDTH*`LANENUMBER-1:0] out_txdata;
output	out_txdata_valid;
reg	[`UNITWIDTH*`LANENUMBER-1:0] out_txdata;
reg	out_txdata_valid;
input	in_idle;
output	[`LANENUMBER-1:0]	saved_blocklock_remote_pre;



reg	[`LANENUMBER-1:0]	saved_blocklock_remote_pre;
reg	[`LANENUMBER-1:0]	saved_blocklock_remote;
//store the in_blocklock_remote
always @(posedge clk) begin
	if(!reset_n) begin
		saved_blocklock_remote_pre<={`LANENUMBER{1'b1}};
	end
	else if(in_enable && in_blocklock_remote_en && in_blocklock_remote!=0) begin 
		//shengyu shen comment 2013/10/18 : adding in_blocklock_remote!=0 to prevent dead lock
		// the scenario of deadlock is :
		// fast  <-> slow
		//                slow send SYNC char with block_lock==0 to fast
		// fast's distributor need to send a SYNC char, it need to wait for an empty signal from tx swizzler
		// but tx_block_lock==0 make the swizzler stop there without sending out empty
		// no SYNC sent to slow
		//                slow's rx_lan_sorter do NOT know which rx lane corresponds to which tx lane, so all it can not map its block_lock to fast view point, it can only send out all as its swizzled block_lock to fast
		//fast continue to use 0 as tx_block_lock

		saved_blocklock_remote_pre<=in_blocklock_remote;
	end
end

reg	all1;

always @(posedge clk) begin
	if(!reset_n) begin
		saved_blocklock_remote<=0;
		all1<=0;
	end
	else if(in_enable) begin
		saved_blocklock_remote<=saved_blocklock_remote_pre;
		all1 <= (saved_blocklock_remote_pre=={`LANENUMBER{1'b1}});
	end
end


//store the temporal data
reg	[`UNITWIDTH*`LANENUMBER*2-1:0]	tempdata;
reg	[`UNITWIDTH*`LANENUMBER*3-1:0]	tempdata_nxt1;
reg	[`UNITWIDTH*`LANENUMBER*2-1:0]	tempdata_nxt2;


//depend on the `LANENUMBER
//++++++++++++++++++++++++++++++
wire [3:0] numberOfdata0=saved_blocklock_remote_pre[0]?4'b0001:4'b0000;
wire [3:0] numberOfdata1=saved_blocklock_remote_pre[1]?(numberOfdata0+1):numberOfdata0;
wire [3:0] numberOfdata2=saved_blocklock_remote_pre[2]?(numberOfdata1+1):numberOfdata1;
wire [3:0] numberOfdata3=saved_blocklock_remote_pre[3]?(numberOfdata2+1):numberOfdata2;

reg	[3:0] numberOfdata;
reg	[4:0] numberOfdata4;
always @(posedge clk) begin
	if(!reset_n) begin
		numberOfdata<=0;
		numberOfdata4<=0;
	end
	else if(in_enable) begin
		numberOfdata<=numberOfdata3;
		numberOfdata4<=`LANENUMBER+{1'b0,numberOfdata};
	end
end
//++++++++++++++++++++++++++++++

reg	[4:0]	pos; //0 to 7
reg	[5:0]	pos_nxt1;
reg	[4:0]	pos_nxt2;
reg		pos_gt_numberOfdata;
reg		pos_equal_numberofdata;
reg		pos_lt_numberofdata;
reg		eight_sub_pos_sub_numberOfdata_ge4;
reg		pos_le_4;
reg	reg_idle;
reg	clear_buffer;
reg	pos_ne_0;
always @(posedge clk) begin
	if(!reset_n) begin
		tempdata<=0;
		pos<=0;
		pos_gt_numberOfdata<=1'b0;
		pos_equal_numberofdata<=1'b0;
		pos_lt_numberofdata<=1'b0;
		reg_idle<=1'b0;
		eight_sub_pos_sub_numberOfdata_ge4<=1'b0;
		pos_le_4<=1'b0;
		clear_buffer<=0;
		pos_ne_0<=1'b0;
	end
	else if(in_enable) begin
		tempdata<=tempdata_nxt2;
		pos<=pos_nxt2;
		pos_gt_numberOfdata<=(pos_nxt2>={1'b0,numberOfdata});
		pos_equal_numberofdata<=(pos_nxt2=={1'b0,numberOfdata});
		pos_lt_numberofdata<=(pos_nxt2<{1'b0,numberOfdata});
		reg_idle<=in_idle;
		//eight_sub_pos_sub_numberOfdata_ge4<=(`LANENUMBER*2-(pos_nxt2-numberOfdata)>=LANENUMBER);
		eight_sub_pos_sub_numberOfdata_ge4<=(numberOfdata4>=pos_nxt2);
		pos_le_4<=(pos_nxt2<=`LANENUMBER);
		clear_buffer<=in_blocklock_remote_en && (in_blocklock_remote!=saved_blocklock_remote_pre);
		pos_ne_0<=(pos_nxt2!=0);
	end
end

wire	[`UNITWIDTH*`LANENUMBER-1:0]	txdata0=saved_blocklock_remote_pre[0]?tempdata[`UNITWIDTH*`LANENUMBER-1:0]:{tempdata[`UNITWIDTH*`LANENUMBER-1-`UNITWIDTH:`UNITWIDTH*0],tempdata[`UNITWIDTH*1-1:0]};
wire	[`UNITWIDTH*`LANENUMBER-1:0]	txdata1=saved_blocklock_remote_pre[1]? txdata0[`UNITWIDTH*`LANENUMBER-1:0]:{ txdata0[`UNITWIDTH*`LANENUMBER-1-`UNITWIDTH:`UNITWIDTH*1], txdata0[`UNITWIDTH*2-1:0]};
wire	[`UNITWIDTH*`LANENUMBER-1:0]	txdata2=saved_blocklock_remote_pre[2]? txdata1[`UNITWIDTH*`LANENUMBER-1:0]:{ txdata1[`UNITWIDTH*`LANENUMBER-1-`UNITWIDTH:`UNITWIDTH*2], txdata1[`UNITWIDTH*3-1:0]};
wire	[`UNITWIDTH*`LANENUMBER-1:0]	txdata3=txdata2;

wire	can_go=pos_gt_numberOfdata & in_idle;
always @(*) begin
	tempdata_nxt1={{`UNITWIDTH*`LANENUMBER{1'b0}},tempdata};
	pos_nxt1={1'b0,pos};

	tempdata_nxt2=tempdata_nxt1[`UNITWIDTH*`LANENUMBER*2-1:0];
	pos_nxt2=pos_nxt1[4:0];

	out_idle=1'b0;
	out_txdata_valid=1'b0;
	out_txdata=txdata3;

	out_empty=(pos==0);
	if(all1) begin//this is the short path for all lane ok case
		out_empty=1'b1;
		out_idle=in_idle;
		out_txdata_valid=in_txdata_valid;
		out_txdata=in_txdata;
	end
	else if(in_syncing_pre && pos_lt_numberofdata) begin //if there are too much data, then we need to send them in else
		if(pos_ne_0) begin
			//not enough data to send
			//fill in trash data
			out_idle=1'b0;
			out_txdata_valid=1'b0;

			pos_nxt2={1'b0,numberOfdata};
		end
		else begin//in the case of no data, we need to wait for the idle of lower layer
			out_idle=in_idle;
		end
	end
	else if( in_syncing_pre && pos_equal_numberofdata) begin //with filled in data to be send before sync
		if(in_idle) begin
			out_idle=1'b0;
			out_txdata_valid=1'b1;
			pos_nxt2=0;
		end
	end
	else if(clear_buffer) begin//new remote block lock will cause us to clear the buffer
		pos_nxt2=0;
		out_idle=1'b0;
		out_txdata_valid=1'b0;
	end
	else begin
		//dealing with sending data
		//prevent new data coming when in_syncing_pre
		out_idle=(in_syncing_pre==1'b0) && (can_go?eight_sub_pos_sub_numberOfdata_ge4:pos_le_4);
		out_txdata_valid=can_go ;
		out_txdata=txdata3;
		
		//dealing with input
		if(in_txdata_valid) begin
			case(pos)
			0: begin tempdata_nxt1 [(3+0)*48+47:0*48]=in_txdata; pos_nxt1=6'd4+       6'd0; end
			1: begin tempdata_nxt1 [(3+1)*48+47:1*48]=in_txdata; pos_nxt1=6'd4+       6'd1; end
			2: begin tempdata_nxt1 [(3+2)*48+47:2*48]=in_txdata; pos_nxt1=6'd4+       6'd2; end
			3: begin tempdata_nxt1 [(3+3)*48+47:3*48]=in_txdata; pos_nxt1=6'd4+       6'd3; end
			4: begin tempdata_nxt1 [(3+4)*48+47:4*48]=in_txdata; pos_nxt1=6'd4+       6'd4; end
			5: begin tempdata_nxt1 [(3+5)*48+47:5*48]=in_txdata; pos_nxt1=6'd4+       6'd5; end
			6: begin tempdata_nxt1 [(3+6)*48+47:6*48]=in_txdata; pos_nxt1=6'd4+       6'd6; end
			7: begin tempdata_nxt1 [(3+7)*48+47:7*48]=in_txdata; pos_nxt1=6'd4+       6'd7; end
			//other case dont have idel, so no data come in 
			//just stay the same
			endcase
		end
		
		//dealing with output
		if(can_go) begin
			case(numberOfdata)
		//0 can not be consider because there are no lane to send
			1: begin tempdata_nxt2=tempdata_nxt1[`UNITWIDTH*`LANENUMBER*2-1+ 1*`UNITWIDTH:0+ 1*`UNITWIDTH]; pos_nxt2=pos_nxt1-                   1; end
			2: begin tempdata_nxt2=tempdata_nxt1[`UNITWIDTH*`LANENUMBER*2-1+ 2*`UNITWIDTH:0+ 2*`UNITWIDTH]; pos_nxt2=pos_nxt1-                   2; end
			3: begin tempdata_nxt2=tempdata_nxt1[`UNITWIDTH*`LANENUMBER*2-1+ 3*`UNITWIDTH:0+ 3*`UNITWIDTH]; pos_nxt2=pos_nxt1-                   3; end
			4: begin tempdata_nxt2=tempdata_nxt1[`UNITWIDTH*`LANENUMBER*2-1+ 4*`UNITWIDTH:0+ 4*`UNITWIDTH]; pos_nxt2=pos_nxt1-                   4; end
			endcase
		end
		else begin
			tempdata_nxt2=tempdata_nxt1[`UNITWIDTH*`LANENUMBER*2-1:0];
			pos_nxt2=pos_nxt1[4:0];
		end
	end
end



endmodule
