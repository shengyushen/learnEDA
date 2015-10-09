module amdetector(
	fullclk,
	in_data,
	out_isam,
	am_field,
	fecFrameStart,
	corruptAM
);
input	fullclk;
input in_data;
output out_isam;
output [2:0] am_field;
output	fecFrameStart;
output	corruptAM;

parameter AM3  = 48'h846AB27B954D;
parameter AM2  = 48'h17B4A6E84B59;
parameter AM1  = 48'h718E628E719D;
parameter AM0  = 48'hDE973E2168C1;

reg [63:0] regdata;

always @(posedge fullclk)  begin
	regdata <= {in_data,regdata[63:1]};
end
 wire [11:0] non_match_AM0 = {(AM0[47:44] != regdata[55:52]),
                         (AM0[43:40] != regdata[51:48]),
                         (AM0[39:36] != regdata[47:44]),
                         (AM0[35:32] != regdata[43:40]),
                         (AM0[31:28] != regdata[39:36]),
                         (AM0[27:24] != regdata[35:32]),
//shengyu shen's question : missing 8 bits are BIPs used to check BER rate
                         (AM0[23:20] != regdata[23:20]),
                         (AM0[19:16] != regdata[19:16]),
                         (AM0[15:12] != regdata[15:12]),
                         (AM0[11: 8] != regdata[11: 8]),
                         (AM0[ 7: 4] != regdata[ 7: 4]),
                         (AM0[ 3: 0] != regdata[ 3: 0])};

 // Does block fail to match AM1?
 wire [11:0] non_match_AM1 = {(AM1[47:44] != regdata[55:52]),
                         (AM1[43:40] != regdata[51:48]),
                         (AM1[39:36] != regdata[47:44]),
                         (AM1[35:32] != regdata[43:40]),
                         (AM1[31:28] != regdata[39:36]),
                         (AM1[27:24] != regdata[35:32]),
                         (AM1[23:20] != regdata[23:20]),
                         (AM1[19:16] != regdata[19:16]),
                         (AM1[15:12] != regdata[15:12]),
                         (AM1[11: 8] != regdata[11: 8]),
                         (AM1[ 7: 4] != regdata[ 7: 4]),
                         (AM1[ 3: 0] != regdata[ 3: 0])};

 // Does block fail to match AM2?
 wire [11:0] non_match_AM2 = {(AM2[47:44] != regdata[55:52]),
                         (AM2[43:40] != regdata[51:48]),
                         (AM2[39:36] != regdata[47:44]),
                         (AM2[35:32] != regdata[43:40]),
                         (AM2[31:28] != regdata[39:36]),
                         (AM2[27:24] != regdata[35:32]),
                         (AM2[23:20] != regdata[23:20]),
                         (AM2[19:16] != regdata[19:16]),
                         (AM2[15:12] != regdata[15:12]),
                         (AM2[11: 8] != regdata[11: 8]),
                         (AM2[ 7: 4] != regdata[ 7: 4]),
                         (AM2[ 3: 0] != regdata[ 3: 0])};

 // Does block fail to match AM3?
 wire [11:0] non_match_AM3 = {(AM3[47:44] != regdata[55:52]),
                         (AM3[43:40] != regdata[51:48]),
                         (AM3[39:36] != regdata[47:44]),
                         (AM3[35:32] != regdata[43:40]),
                         (AM3[31:28] != regdata[39:36]),
                         (AM3[27:24] != regdata[35:32]),
                         (AM3[23:20] != regdata[23:20]),
                         (AM3[19:16] != regdata[19:16]),
                         (AM3[15:12] != regdata[15:12]),
                         (AM3[11: 8] != regdata[11: 8]),
                         (AM3[ 7: 4] != regdata[ 7: 4]),
                         (AM3[ 3: 0] != regdata[ 3: 0])};

wire [3:0]  non_match_AM0_sum;
wire [3:0]  non_match_AM1_sum;
wire [3:0]  non_match_AM2_sum;
wire [3:0]  non_match_AM3_sum;

 assign non_match_AM0_sum = {3'd0,non_match_AM0[11]} + {3'd0,non_match_AM0[10]} + {3'd0,non_match_AM0[9]} + {3'd0,non_match_AM0[8]} +
                            {3'd0,non_match_AM0[7]}  + {3'd0,non_match_AM0[6]}  + {3'd0,non_match_AM0[5]} + {3'd0,non_match_AM0[4]} +
                            {3'd0,non_match_AM0[3]}  + {3'd0,non_match_AM0[2]}  + {3'd0,non_match_AM0[1]} + {3'd0,non_match_AM0[0]};
 assign non_match_AM1_sum = {3'd0,non_match_AM1[11]} + {3'd0,non_match_AM1[10]} + {3'd0,non_match_AM1[9]} + {3'd0,non_match_AM1[8]} +
                            {3'd0,non_match_AM1[7]}  + {3'd0,non_match_AM1[6]}  + {3'd0,non_match_AM1[5]} + {3'd0,non_match_AM1[4]} +
                            {3'd0,non_match_AM1[3]}  + {3'd0,non_match_AM1[2]}  + {3'd0,non_match_AM1[1]} + {3'd0,non_match_AM1[0]};
 assign non_match_AM2_sum = {3'd0,non_match_AM2[11]} + {3'd0,non_match_AM2[10]} + {3'd0,non_match_AM2[9]} + {3'd0,non_match_AM2[8]} +
                            {3'd0,non_match_AM2[7]}  + {3'd0,non_match_AM2[6]}  + {3'd0,non_match_AM2[5]} + {3'd0,non_match_AM2[4]} +
                            {3'd0,non_match_AM2[3]}  + {3'd0,non_match_AM2[2]}  + {3'd0,non_match_AM2[1]} + {3'd0,non_match_AM2[0]};
 assign non_match_AM3_sum = {3'd0,non_match_AM3[11]} + {3'd0,non_match_AM3[10]} + {3'd0,non_match_AM3[9]} + {3'd0,non_match_AM3[8]} +
                            {3'd0,non_match_AM3[7]}  + {3'd0,non_match_AM3[6]}  + {3'd0,non_match_AM3[5]} + {3'd0,non_match_AM3[4]} +
                            {3'd0,non_match_AM3[3]}  + {3'd0,non_match_AM3[2]}  + {3'd0,non_match_AM3[1]} + {3'd0,non_match_AM3[0]};

 assign {out_isam,am_field} = (non_match_AM0_sum  < 4) ? {1'b1,3'd0} :
                              (non_match_AM1_sum  < 4) ? {1'b1,3'd1} :
                              (non_match_AM2_sum  < 4) ? {1'b1,3'd2} :
                              (non_match_AM3_sum  < 4) ? {1'b1,3'd3} :
							{1'b0,3'b111};
reg [15:0] fecFrameCounter;
reg [19:0] amCounter;
always @(posedge fullclk) begin
	if(out_isam) begin
		fecFrameCounter <=0;
		amCounter <= 0;
	end
	else begin
		amCounter <= amCounter +1;
		if(fecFrameCounter==1319)
			fecFrameCounter <= 0;
		else
			fecFrameCounter <= fecFrameCounter+1;
	end
end 

assign fecFrameStart=out_isam | fecFrameCounter==1319;
wire	corruptAMtmp=amCounter >= 39500 || amCounter <=100;
integer reg_random;
always @(posedge fullclk) begin
	reg_random = $random%50;
end
wire err=(reg_random==0);

reg seenerr;
reg lastcorruptAMtmp;
always @(posedge fullclk) begin
	lastcorruptAMtmp <=corruptAMtmp;
	if(corruptAMtmp==1 && lastcorruptAMtmp==0) begin
		if(err) seenerr<=1;
		else seenerr<=0;
	end
	else if (corruptAMtmp==0 && lastcorruptAMtmp==1) seenerr <=1'b0;
end

assign	corruptAM=corruptAMtmp & seenerr;
endmodule
