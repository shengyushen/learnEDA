module gearbox_256_192 (
	in_enable,
	clk,
	reset_n,
	//interface to upper
	out_idle,
	in_data,
	in_datavalid,
	in_dataerror,
	//interface to downside
	out_data,
	out_datavalid,
	out_dataerror,
	out_gblocked,
	in_idle
);
input	in_enable;
input	clk, reset_n;
	//interface to upper
output	out_idle;
reg	out_idle;
wire	out_idle_pre;
input [255:0]	in_data;
input in_datavalid;
input	in_dataerror;
	//interface to downside
output [191:0]	out_data;
output out_datavalid;
output	out_dataerror;
output out_gblocked;
input in_idle;

wire	bderror;
wire [3:0] oidl;
wire out_idle_tmp=oidl[0];
wire [3:0] odv;
assign	out_datavalid=odv[0];
wire [255:0] in_data_tmp;

wire in_datavalid_tmp;
wire reset_n_gb;

wire [255:0] in_data_post;
wire in_datavalid_post;
reg [255:0] reg_data,reg_data_nxt;
reg reg_datavalid,reg_datavalid_nxt;
reg reg_dataerror,reg_dataerror_nxt;

always @(posedge clk) begin
	if(!reset_n) begin
		reg_data <= 256'b0;
		reg_datavalid <=1'b0;
		reg_dataerror <=1'b0;
	end
	else begin
		reg_data <= reg_data_nxt;
		reg_datavalid <=reg_datavalid_nxt;
		reg_dataerror <=reg_dataerror_nxt;
	end
end

always @(*) begin
	if(out_idle_pre) begin
		reg_data_nxt = in_data;
		reg_datavalid_nxt = in_datavalid;
		reg_dataerror_nxt = in_dataerror;
		out_idle =1'b1;
	end
	else begin
		if(!reg_datavalid) begin
			reg_data_nxt = in_data;
			reg_datavalid_nxt = in_datavalid;
			reg_dataerror_nxt = in_dataerror;
			out_idle =1'b1;
		end
		else begin
			reg_data_nxt = reg_data;
			reg_datavalid_nxt = reg_datavalid;
			reg_dataerror_nxt = reg_dataerror;
			out_idle =1'b0;
		end
	end
end

assign in_data_post=reg_data;
assign in_datavalid_post=out_idle_pre?reg_datavalid:1'b0;
gb_deborder inst_gb_deborder(
	.in_enable(in_enable),
	.clk(clk),
	.reset_n(reset_n),
	//upper interface
	.in_data(in_data_post),
	.in_datavalid(in_datavalid_post),
	.out_idle(out_idle_pre),
	//down interface
	.out_data(in_data_tmp),
	.out_datavalid(in_datavalid_tmp),
	.out_reset_n(reset_n_gb),
	.out_gblocked(out_gblocked),
	.out_bderror(bderror),
	.in_idle(out_idle_tmp)
);

wire real_reset_n=reset_n & reset_n_gb;
wire	[3:0] out_dataerror_tmp;
gearbox_64_48 inst0(
	.in_enable(in_enable),
	.clk(clk),
	.reset_n(real_reset_n),
	//interface to upper
	.out_idle(oidl[0]),
	.in_data(in_data_tmp[63+64*0:0+64*0]),
	.in_datavalid(in_datavalid_tmp),
	.in_dataerror(reg_dataerror),
	//interface to downside
	.out_data(out_data[47+48*0:0+48*0]),
	.out_datavalid(odv[0]),
	.out_dataerror(out_dataerror_tmp[0]),
	.in_idle(in_idle)
);

gearbox_64_48 inst1(
	.in_enable(in_enable),
	.clk(clk),
	.reset_n(real_reset_n),
	//interface to upper
	.out_idle(oidl[1]),
	.in_data(in_data_tmp[63+64*1:0+64*1]),
	.in_datavalid(in_datavalid_tmp),
	.in_dataerror(reg_dataerror),
	//interface to downside
	.out_data(out_data[47+48*1:0+48*1]),
	.out_datavalid(odv[1]),
	.out_dataerror(out_dataerror_tmp[1]),
	.in_idle(in_idle)
);

gearbox_64_48 inst2(
	.in_enable(in_enable),
	.clk(clk),
	.reset_n(real_reset_n),
	//interface to upper
	.out_idle(oidl[2]),
	.in_data(in_data_tmp[63+64*2:0+64*2]),
	.in_datavalid(in_datavalid_tmp),
	.in_dataerror(reg_dataerror),
	//interface to downside
	.out_data(out_data[47+48*2:0+48*2]),
	.out_datavalid(odv[2]),
	.out_dataerror(out_dataerror_tmp[2]),
	.in_idle(in_idle)
);

gearbox_64_48 inst3(
	.in_enable(in_enable),
	.clk(clk),
	.reset_n(real_reset_n),
	//interface to upper
	.out_idle(oidl[3]),
	.in_data(in_data_tmp[63+64*3:0+64*3]),
	.in_datavalid(in_datavalid_tmp),
	.in_dataerror(reg_dataerror),
	//interface to downside
	.out_data(out_data[47+48*3:0+48*3]),
	.out_datavalid(odv[3]),
	.out_dataerror(out_dataerror_tmp[3]),
	.in_idle(in_idle)
);
assign	out_dataerror=out_dataerror_tmp[0]|bderror;

endmodule
