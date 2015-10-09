module rx_stage(
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
	out_allsync
);

input	in_enable;
input	clk;
input reset_n;

input [`UNITWIDTH*`LANENUMBER-1:0]	in_rxdata;
input in_rxdata_valid;
input	[`LANENUMBER-1:0]	in_blocklock;
input	in_allsync;

output [`UNITWIDTH*`LANENUMBER-1:0]	out_rxdata;
output out_rxdata_valid;
output	[`LANENUMBER-1:0]	out_blocklock;
output	out_allsync;

reg [`UNITWIDTH*`LANENUMBER-1:0]	out_rxdata;
reg out_rxdata_valid;
reg	[`LANENUMBER-1:0]	out_blocklock;
reg	out_allsync;

always @(posedge clk) begin
	if(!reset_n) begin
		out_rxdata<=0;
		out_rxdata_valid<=1'b0;
		out_blocklock<=0;
		out_allsync<=1'b0;
	end
	else if(in_enable) begin
		out_rxdata<=in_rxdata;
		out_rxdata_valid<=in_rxdata_valid;
		out_blocklock<=in_blocklock;
		out_allsync<=in_allsync;
	end
end

endmodule
