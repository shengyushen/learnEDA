module gearbox_192_256 (
	in_enable,
	clk,
	reset_n,
	//interface to upper
	out_idle,
	in_data,
	in_datavalid,
	//interface to downside
	out_data,
	out_datavalid,
	in_idle
);
input	in_enable;
input	clk, reset_n;
	//interface to upper
output	out_idle;
input [191:0]	in_data;
input in_datavalid;
	//interface to downside
output [255:0]	out_data;
output out_datavalid;
input in_idle;

wire in_idle_tmp;
wire [255:0] out_data_tmp;
wire [3:0] odv_tmp;

wire [3:0] oidl;
assign	out_idle=oidl[0];
wire [3:0] es;
wire	empty_save=es[0];
wire	out_datavalid_tmp=odv_tmp[0];


gearbox_48_64 inst0(
	.in_enable(in_enable),
	.clk(clk),
	.reset_n(reset_n),
	//interface to upper
	.out_idle(oidl[0]),
	.in_data(in_data[47:0]),
	.in_datavalid(in_datavalid),
	.empty_save(es[0]),
	//interface to downside
	.out_data(out_data_tmp[63:0]),
	.out_datavalid(odv_tmp[0]),
	.in_idle(in_idle_tmp)
);

gearbox_48_64 inst1(
	.in_enable(in_enable),
	.clk(clk),
	.reset_n(reset_n),
	//interface to upper
	.out_idle(oidl[1]),
	.in_data(in_data[47+48*1:0+48*1]),
	.in_datavalid(in_datavalid),
	.empty_save(es[1]),
	//interface to downside
	.out_data(out_data_tmp[63+64*1:0+64*1]),
	.out_datavalid(odv_tmp[1]),
	.in_idle(in_idle_tmp)
);

gearbox_48_64 inst2(
	.in_enable(in_enable),
	.clk(clk),
	.reset_n(reset_n),
	//interface to upper
	.out_idle(oidl[2]),
	.in_data(in_data[47+48*2:0+48*2]),
	.in_datavalid(in_datavalid),
	.empty_save(es[2]),
	//interface to downside
	.out_data(out_data_tmp[63+64*2:0+64*2]),
	.out_datavalid(odv_tmp[2]),
	.in_idle(in_idle_tmp)
);

gearbox_48_64 inst3(
	.in_enable(in_enable),
	.clk(clk),
	.reset_n(reset_n),
	//interface to upper
	.out_idle(oidl[3]),
	.in_data(in_data[47+48*3:0+48*3]),
	.in_datavalid(in_datavalid),
	.empty_save(es[3]),
	//interface to downside
	.out_data(out_data_tmp[63+64*3:0+64*3]),
	.out_datavalid(odv_tmp[3]),
	.in_idle(in_idle_tmp)
);


gb_border inst_gb_border256 (
	.in_enable(in_enable),
	.clk(clk),
	.reset_n(reset_n),
	//interface to up
	.out_idle(in_idle_tmp),
	.in_data(out_data_tmp),
	.in_datavalid(out_datavalid_tmp),
	.empty_save(empty_save),
	//interface to down
	.out_data(out_data),
	.out_datavalid(out_datavalid),
	.in_idle(in_idle)
);

`ifdef PCS_SIM
assert_always #(`OVL_FATAL) inst_assert_0(clk,reset_n,(!in_datavalid|out_idle));
assert_always #(`OVL_FATAL) inst_assert_1(clk,reset_n,(!out_datavalid|in_idle));
assert_always #(`OVL_FATAL) inst_assert_2(clk,reset_n,(oidl==4'b0000||oidl==4'b1111));
assert_always #(`OVL_FATAL) inst_assert_3(clk,reset_n,(odv_tmp==4'b0000||odv_tmp==4'b1111));
assert_always #(`OVL_FATAL) inst_assert_4(clk,reset_n,(es==4'b0000||es==4'b1111));
`endif

endmodule
