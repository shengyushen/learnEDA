module perlane_descrambler (
	in_enable,
	clk,
	reset_n,

	//interface to upper
	in_txdata,
	in_txdata_valid,
	in_txdata_error,
	out_idle,

	//interface to lower
	out_txdata,
	out_txdata_valid,
	out_txdata_error,
	in_idle
);
input	in_enable;
input	clk,reset_n;

	//interface to upper
input [255:0]	in_txdata;
input 	in_txdata_valid;
input	in_txdata_error;
output	out_idle;

	//interface to lower
output [255:0]	out_txdata;
output	out_txdata_valid;
output	out_txdata_error;
input	in_idle;
wire [3:0] out_txdata_valid_tmp;
assign out_txdata_valid=out_txdata_valid_tmp[0];
reg last_error;
always @(posedge clk) begin
	if(!reset_n) begin
		last_error<=1'b0;
	end
	else if(in_enable && in_txdata_valid) begin
		last_error<=in_txdata_error;
	end
end

assign out_txdata_error=(last_error|in_txdata_error) && in_txdata_valid;

descrambler_64 inst0 (
	.in_enable(in_enable),
	.clk(clk),
	.reset_n(reset_n),

	.in_pop(in_txdata_valid),
	.in_data(in_txdata[63:0]),

	.scrambled_result(out_txdata[63:0]),
	.out_pop(out_txdata_valid_tmp[0])
);

descrambler_64 inst1 (
	.in_enable(in_enable),
	.clk(clk),
	.reset_n(reset_n),

	.in_pop(in_txdata_valid),
	.in_data(in_txdata[127:64]),

	.scrambled_result(out_txdata[127:64]),
	.out_pop(out_txdata_valid_tmp[1])
);

descrambler_64 inst2 (
	.in_enable(in_enable),
	.clk(clk),
	.reset_n(reset_n),

	.in_pop(in_txdata_valid),
	.in_data(in_txdata[191:128]),

	.scrambled_result(out_txdata[191:128]),
	.out_pop(out_txdata_valid_tmp[2])
);

descrambler_64 inst3 (
	.in_enable(in_enable),
	.clk(clk),
	.reset_n(reset_n),

	.in_pop(in_txdata_valid),
	.in_data(in_txdata[255:192]),

	.scrambled_result(out_txdata[255:192]),
	.out_pop(out_txdata_valid_tmp[3])
);

assign	out_idle=in_idle;


endmodule 
