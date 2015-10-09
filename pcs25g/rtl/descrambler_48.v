module descrambler_48(
	in_enable,
	clk,
	reset_n,

	in_pop,
	in_data,
	
	scrambled_result,
	out_pop
);

input in_enable;
input	clk;
input	reset_n;

input	in_pop;
input	[`UNITWIDTH-1:0]	in_data;

output	[`UNITWIDTH-1:0] scrambled_result;
output	out_pop;

assign	out_pop=in_pop;

reg	[`UNITWIDTH+57:0]	data_prev;
wire  [`UNITWIDTH+57:0]  data_merge;
always @(posedge clk) begin
//not reseting data contenet may boost speed
	if(!reset_n) begin
		data_prev<=0;
	end
	else if(in_enable) begin
		if(in_pop) data_prev<=data_merge;
	end
end

assign  data_merge={in_data,data_prev[`UNITWIDTH+57:`UNITWIDTH]};

assign  scrambled_result=data_merge[`UNITWIDTH+57:1+57] ^ data_merge[`UNITWIDTH+57-39:1+57-39] ^ data_merge[`UNITWIDTH+57-58:1+57-58];


endmodule
