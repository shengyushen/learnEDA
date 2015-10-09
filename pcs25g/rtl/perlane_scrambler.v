module perlane_scrambler (
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
input	clk,reset_n;

	//interface to upper
input [255:0]	in_txdata;
input 	in_txdata_valid;
output	out_idle;

	//interface to lower
output [255:0]	out_txdata;
output	out_txdata_valid;
wire [3:0]	out_txdata_valid_tmp;
input	in_idle;
assign	out_txdata_valid=out_txdata_valid_tmp[0];

scrambler_64 inst0 (
	.in_enable(in_enable),
	.clk(clk),
	.reset_n(reset_n),

	.in_pop(in_txdata_valid),
	.in_data(in_txdata[63:0]),

	.scrambled_result(out_txdata[63:0]),
	.out_pop(out_txdata_valid_tmp[0])
);

scrambler_64 inst1 (
	.in_enable(in_enable),
	.clk(clk),
	.reset_n(reset_n),

	.in_pop(in_txdata_valid),
	.in_data(in_txdata[127:64]),

	.scrambled_result(out_txdata[127:64]),
	.out_pop(out_txdata_valid_tmp[1])
);

scrambler_64 inst2 (
	.in_enable(in_enable),
	.clk(clk),
	.reset_n(reset_n),

	.in_pop(in_txdata_valid),
	.in_data(in_txdata[191:128]),

	.scrambled_result(out_txdata[191:128]),
	.out_pop(out_txdata_valid_tmp[2])
);

scrambler_64 inst3 (
	.in_enable(in_enable),
	.clk(clk),
	.reset_n(reset_n),

	.in_pop(in_txdata_valid),
	.in_data(in_txdata[255:192]),

	.scrambled_result(out_txdata[255:192]),
	.out_pop(out_txdata_valid_tmp[3])
);

assign	out_idle=in_idle;

`ifdef PCS_SIM
assert_always #(`OVL_FATAL) inst_assert_0(clk,reset_n,(!in_txdata_valid|out_idle));
assert_always #(`OVL_FATAL) inst_assert_1(clk,reset_n,(out_txdata_valid_tmp==4'b0000||out_txdata_valid_tmp==4'b1111));
`endif

endmodule 
