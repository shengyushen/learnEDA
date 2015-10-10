module tx_fifo_2x (
	in_enable,
	clk_wr,
	clk_rd,
	reset_n_wr,
	reset_n_rd,

	en_wr,
	data_wr,
	idle_wr,

	en_rd,
	data_rd,
	idle_rd
);
parameter WR_WIDTH=12;
input in_enable;
input clk_wr;
input clk_rd;
input reset_n_wr;
input reset_n_rd;

input en_wr;
input [WR_WIDTH-1:0] data_wr;
output idle_wr;
reg idle_wr;

output  en_rd;
output [WR_WIDTH-1:0] data_rd;
input idle_rd;

//an extra bit is used to record the valid bit
reg	[WR_WIDTH-1:0] datareg0 ;
reg	[WR_WIDTH-1:0] datareg1 ;
reg	[WR_WIDTH-1:0] datareg2 ;
reg	[WR_WIDTH-1:0] datareg3 ;
reg	[WR_WIDTH-1:0] datareg4 ;
reg	[WR_WIDTH-1:0] datareg5 ;
reg	[WR_WIDTH-1:0] datareg6 ;
reg	[WR_WIDTH-1:0] datareg7 ;
reg	[WR_WIDTH-1:0] datareg8 ;
reg	[WR_WIDTH-1:0] datareg9 ;
reg	[WR_WIDTH-1:0] datareg10;
reg	[WR_WIDTH-1:0] datareg11;

reg	[3:0]	wrpointer;

//wire	[3:0]	wrpointer_add1_mod=(wrpointer==(12-1))?0:(wrpointer+1);
//simpilied version
wire	[3:0]	wrpointer_add1_mod=(wrpointer==4'd11)?0:(wrpointer+1);

always @(posedge clk_wr)  begin
	if(!reset_n_wr) begin
		wrpointer<=0;
	end
	else if(in_enable) begin
		if(en_wr) begin
			wrpointer<=wrpointer_add1_mod;
			case(wrpointer)
			0 : datareg0 <=data_wr;
			1 : datareg1 <=data_wr;
			2 : datareg2 <=data_wr;
			3 : datareg3 <=data_wr;
			4 : datareg4 <=data_wr;
			5 : datareg5 <=data_wr;
			6 : datareg6 <=data_wr;
			7 : datareg7 <=data_wr;
			8 : datareg8 <=data_wr;
			9 : datareg9 <=data_wr;
			10: datareg10<=data_wr;
			11: datareg11<=data_wr;
			endcase
			
		end
	end
end


wire	[3:0]	wrpointer_gray;

graycounter_12 inst_grayencoder_0 (
	.clk(clk_wr),
	.reset_n(reset_n_wr),
	.inp(wrpointer),
	.enable(en_wr),
	.outp(wrpointer_gray)
);

wire	[3:0]	wrpointer_gray_sync1;
wire	[3:0]	wrpointer_gray_sync2;
sync_2xdff #(4) inst_wrpointer_gray_sync1(
	.dout(wrpointer_gray_sync2),
	.clk(clk_rd), 
	.rst_n(1'b1), 
	.din(wrpointer_gray)
);


wire [3:0] wrpointer_gray_sync2_dec;

graydecoder_12 inst_graydecoder_0 (
	.clk(clk_rd),
	.reset_n(reset_n_rd),
	.inp(wrpointer_gray_sync2),
	.outp(wrpointer_gray_sync2_dec)
);

wire [3:0] wrpointer_gray_sync2_full=wrpointer_gray_sync2_dec;










wire pop_rd;

reg	[3:0]	rdpointer;
wire	[3:0]	rdpointer_full=rdpointer;

always @(posedge clk_rd)  begin
	if(!reset_n_rd) begin
		rdpointer<=0;
	end
	else if(in_enable) begin
		if(pop_rd) begin
			if(rdpointer==4'd11) 
				rdpointer<=0;
			else
				rdpointer<=rdpointer+1;
		end
	end
end

wire	[3:0]	rdpointer_gray;

graycounter_12 inst_grayencoder_12_rd (
	.clk(clk_rd),
	.reset_n(reset_n_rd),
	.inp(rdpointer),
	.enable(pop_rd),
	.outp(rdpointer_gray)
);

wire	[3:0]	rdpointer_gray_sync1;
wire	[3:0]	rdpointer_gray_sync2;

sync_2xdff #(4) inst_rdpointer_gray_sync1(
	.dout(rdpointer_gray_sync2),
	.clk(clk_wr), 
	.rst_n(1'b1), 
	.din(rdpointer_gray)
);



wire [3:0] rdpointer_gray_sync2_dec;

graydecoder_12 inst_graydecoder_12_rd (
	.clk(clk_wr),
	.reset_n(reset_n_wr),
	.inp(rdpointer_gray_sync2),
	.outp(rdpointer_gray_sync2_dec)
);

wire [3:0] rdpointer_gray_sync2_full=rdpointer_gray_sync2_dec;

//eqaul means empty
//I change it to more relax
//such that we can reg it at upper layer
wire	idle_wr_tmp               =(wrpointer>=rdpointer_gray_sync2_full)?
//	((wrpointer-rdpointer_gray_sync2_full)<=(12-4)):
	((wrpointer-rdpointer_gray_sync2_full)<=4'd8):
	((rdpointer_gray_sync2_full-wrpointer)>=4'd4);

always @(posedge clk_wr)  begin
	if(!reset_n_wr) begin
		idle_wr<=0;
	end
	else if(in_enable) begin
		idle_wr<=idle_wr_tmp;
	end
end

//this is the old version that make the timing too bad
wire	idle_wr_tight               =(wrpointer>=rdpointer_gray_sync2_full)?
	((wrpointer-rdpointer_gray_sync2_full)<=(12-3)):
	((rdpointer_gray_sync2_full-wrpointer)>=3);

//eqaul means empty
//canpop means there is a data in fifo
wire	canpop                   =(rdpointer_full!=wrpointer_gray_sync2_full);

//pop_rd means we actaully read the fifo
assign	pop_rd=idle_rd & canpop;


reg en_rd;
reg [WR_WIDTH-1:0] data_rd;
always @(*) begin
	en_rd=pop_rd;
	data_rd=datareg0;
	case(rdpointer[3:0])
	0 :  data_rd=datareg0 ;
	1 :  data_rd=datareg1 ;
	2 :  data_rd=datareg2 ;
	3 :  data_rd=datareg3 ;
	4 :  data_rd=datareg4 ;
	5 :  data_rd=datareg5 ;
	6 :  data_rd=datareg6 ;
	7 :  data_rd=datareg7 ;
	8 :  data_rd=datareg8 ;
	9 :  data_rd=datareg9 ;
	10:  data_rd=datareg10;
	11:  data_rd=datareg11;
	endcase
end


endmodule
