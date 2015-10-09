module rx_lane_sorter(
	in_enable,
	clk,
	reset_n,
	
	in_rxdata,
	in_rxdata_valid,
	in_blocklock,
	in_allsync,

	out_rxdata,
	out_rxdata_valid,
	out_blocklock,
	out_allsync,
	
	out_lane_id
);

input	in_enable;
input	clk;
input	reset_n;

input [`UNITWIDTH*`LANENUMBER-1:0]	in_rxdata;
input	in_rxdata_valid;
input	[`LANENUMBER-1:0]	in_blocklock;
input	in_allsync;

output [`UNITWIDTH*`LANENUMBER-1:0]	out_rxdata;
output	out_rxdata_valid;
output	[`LANENUMBER-1:0]	out_blocklock;
output	out_allsync;

output	[`LANENUMBER*4-1:0] out_lane_id;

wire	[2:0]	lane_id_0=in_rxdata[ 0*`UNITWIDTH + 10 : 0*`UNITWIDTH + 8];
wire	[2:0]	lane_id_1=in_rxdata[ 1*`UNITWIDTH + 10 : 1*`UNITWIDTH + 8];
wire	[2:0]	lane_id_2=in_rxdata[ 2*`UNITWIDTH + 10 : 2*`UNITWIDTH + 8];
wire	[2:0]	lane_id_3=in_rxdata[ 3*`UNITWIDTH + 10 : 3*`UNITWIDTH + 8];



reg [2:0]	lane_id_0_reg;
reg [2:0]	lane_id_1_reg;
reg [2:0]	lane_id_2_reg;
reg [2:0]	lane_id_3_reg;
assign	out_lane_id= {
   1'b0,lane_id_3_reg,
   1'b0,lane_id_2_reg,
   1'b0,lane_id_1_reg,
   1'b0,lane_id_0_reg
};

always @(posedge clk) begin
	if(!reset_n) begin
		lane_id_0_reg<=0;
		lane_id_1_reg<=0;
		lane_id_2_reg<=0;
		lane_id_3_reg<=0;
	end
	else if (in_enable && in_allsync) begin
		lane_id_0_reg<=lane_id_0;
		lane_id_1_reg<=lane_id_1;
		lane_id_2_reg<=lane_id_2;
		lane_id_3_reg<=lane_id_3;
	end
end


//sort lanes according to their lane_id_reg
//lane 0 
wire lane_0_is_0 = (lane_id_0_reg==3'h0) & in_blocklock[0];
wire lane_1_is_0 = (lane_id_1_reg==3'h0) & in_blocklock[1];
wire lane_2_is_0 = (lane_id_2_reg==3'h0) & in_blocklock[2];
wire lane_3_is_0 = (lane_id_3_reg==3'h0) & in_blocklock[3];
                                   
wire lane_0_is_1 = (lane_id_0_reg==3'h1) & in_blocklock[0];
wire lane_1_is_1 = (lane_id_1_reg==3'h1) & in_blocklock[1];
wire lane_2_is_1 = (lane_id_2_reg==3'h1) & in_blocklock[2];
wire lane_3_is_1 = (lane_id_3_reg==3'h1) & in_blocklock[3];
                                   
wire lane_0_is_2 = (lane_id_0_reg==3'h2) & in_blocklock[0];
wire lane_1_is_2 = (lane_id_1_reg==3'h2) & in_blocklock[1];
wire lane_2_is_2 = (lane_id_2_reg==3'h2) & in_blocklock[2];
wire lane_3_is_2 = (lane_id_3_reg==3'h2) & in_blocklock[3];
                                   
wire lane_0_is_3 = (lane_id_0_reg==3'h3) & in_blocklock[0];
wire lane_1_is_3 = (lane_id_1_reg==3'h3) & in_blocklock[1];
wire lane_2_is_3 = (lane_id_2_reg==3'h3) & in_blocklock[2];
wire lane_3_is_3 = (lane_id_3_reg==3'h3) & in_blocklock[3];
                                   
assign {out_rxdata[ 0*`UNITWIDTH + `UNITWIDTH-1 : 0*`UNITWIDTH + 0],out_blocklock[0]} = lane_0_is_0?{in_rxdata[ 0*`UNITWIDTH + `UNITWIDTH-1 : 0*`UNITWIDTH + 0],in_blocklock[0]}:
                                                              lane_1_is_0?{in_rxdata[ 1*`UNITWIDTH + `UNITWIDTH-1 : 1*`UNITWIDTH + 0],in_blocklock[1]}:
                                                              lane_2_is_0?{in_rxdata[ 2*`UNITWIDTH + `UNITWIDTH-1 : 2*`UNITWIDTH + 0],in_blocklock[2]}:
                                                                          {in_rxdata[ 3*`UNITWIDTH + `UNITWIDTH-1 : 3*`UNITWIDTH + 0],in_blocklock[3] & lane_3_is_0 };

assign {out_rxdata[ 1*`UNITWIDTH + `UNITWIDTH-1 : 1*`UNITWIDTH + 0],out_blocklock[1]} = lane_0_is_1?{in_rxdata[ 0*`UNITWIDTH + `UNITWIDTH-1 : 0*`UNITWIDTH + 0],in_blocklock[0]}:
                                                              lane_1_is_1?{in_rxdata[ 1*`UNITWIDTH + `UNITWIDTH-1 : 1*`UNITWIDTH + 0],in_blocklock[1]}:
                                                              lane_2_is_1?{in_rxdata[ 2*`UNITWIDTH + `UNITWIDTH-1 : 2*`UNITWIDTH + 0],in_blocklock[2]}:
                                                                          {in_rxdata[ 3*`UNITWIDTH + `UNITWIDTH-1 : 3*`UNITWIDTH + 0],in_blocklock[3] & lane_3_is_1 };

assign {out_rxdata[ 2*`UNITWIDTH + `UNITWIDTH-1 : 2*`UNITWIDTH + 0],out_blocklock[2]} = lane_0_is_2?{in_rxdata[ 0*`UNITWIDTH + `UNITWIDTH-1 : 0*`UNITWIDTH + 0],in_blocklock[0]}:
                                                              lane_1_is_2?{in_rxdata[ 1*`UNITWIDTH + `UNITWIDTH-1 : 1*`UNITWIDTH + 0],in_blocklock[1]}:
                                                              lane_2_is_2?{in_rxdata[ 2*`UNITWIDTH + `UNITWIDTH-1 : 2*`UNITWIDTH + 0],in_blocklock[2]}:
                                                                          {in_rxdata[ 3*`UNITWIDTH + `UNITWIDTH-1 : 3*`UNITWIDTH + 0],in_blocklock[3] & lane_3_is_2 };

assign {out_rxdata[ 3*`UNITWIDTH + `UNITWIDTH-1 : 3*`UNITWIDTH + 0],out_blocklock[3]} = lane_0_is_3?{in_rxdata[ 0*`UNITWIDTH + `UNITWIDTH-1 : 0*`UNITWIDTH + 0],in_blocklock[0]}:
                                                              lane_1_is_3?{in_rxdata[ 1*`UNITWIDTH + `UNITWIDTH-1 : 1*`UNITWIDTH + 0],in_blocklock[1]}:
                                                              lane_2_is_3?{in_rxdata[ 2*`UNITWIDTH + `UNITWIDTH-1 : 2*`UNITWIDTH + 0],in_blocklock[2]}:
                                                                          {in_rxdata[ 3*`UNITWIDTH + `UNITWIDTH-1 : 3*`UNITWIDTH + 0],in_blocklock[3] & lane_3_is_3 };


assign out_rxdata_valid=in_rxdata_valid;
assign	out_allsync=in_allsync;
endmodule
