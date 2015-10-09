module scrambler_64(
	in_enable,
	clk,
	reset_n,

	in_pop,
	in_data,
	
	scrambled_result,
	out_pop
);
input	in_enable;
input	clk;
input	reset_n;

input	in_pop;
input	[64-1:0]	in_data;

output	[64-1:0] scrambled_result;
output	out_pop;

assign	out_pop=in_pop;

reg	[64+57:0]	data_prev;
wire	[64+57:0]	data_prev_nxt;
always @(posedge clk) begin
//not reseting data contenet may boost speed
	if(!reset_n) begin
		data_prev<=0;
	end
	else if(in_enable) begin
		if(in_pop) data_prev<=data_prev_nxt;
	end
end

wire  [64+57:0]  data_merge={in_data,data_prev[64+57:64]};
/*this model assume that UNITWIDTH<39, such that the 39th element is in data_prev*/
/*but now 48>39 so there is error in this model*/
/*assign  scrambled_result=data_merge[64+57:1+57] ^ data_merge[64+57-39:1+57-39] ^ data_merge[64+57-58:1+57-58];*/
assign  scrambled_result[38:0]=data_merge[38+1+57:1+57] ^ data_merge[38+1+57-39:1+57-39] ^ data_merge[38+1+57-58:1+57-58];
wire [64+57:0] data_merge2={in_data[63:39],scrambled_result[38:0],data_prev[64+57:64]};
assign	scrambled_result[63:39]=data_merge2[64+57:39+1+57] ^ data_merge2[64+57-39:39+1+57-39] ^ data_merge2[64+57-58:39+1+57-58] ;

assign  data_prev_nxt={scrambled_result,data_prev[64+57:64]};

endmodule
