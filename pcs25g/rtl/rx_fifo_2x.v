
module rx_fifo_2x (
	clk_wr,
	clk_rd,
	reset_n_wr,
	reset_n_rd,

	en_wr,
	date_wr,

	canpop,
	issync,
	pop_rd,
	data_rd,
	data_valid,
	dissync,
	
	out_blocklock_remote,
	out_blocklock_remote_en
);
parameter WR_WIDTH=25;

parameter G0 =5'b00000;
parameter G1 =5'b00001;
parameter G2 =5'b00011;
parameter G3 =5'b00010;
parameter G4 =5'b00110;
parameter G5 =5'b00111;
parameter G6 =5'b00101;
parameter G7 =5'b00100;

parameter G8 =5'b01100;
parameter G9 =5'b01101;
parameter G10=5'b01111;
parameter G11=5'b01110;
parameter G12=5'b01010;
parameter G13=5'b01011;
parameter G14=5'b01001;
parameter G15=5'b01000;

input clk_wr;
input clk_rd;
input reset_n_wr;
input reset_n_rd;

input en_wr;
input [WR_WIDTH-1:0]  date_wr;

output	canpop;
output	issync;
wire	issync;
input pop_rd;
output  [WR_WIDTH-2:0] data_rd;
output	data_valid;
output	dissync;
reg	dissync;

output [7:0]	out_blocklock_remote;
output	out_blocklock_remote_en;
reg [7:0]	out_blocklock_remote;
reg	out_blocklock_remote_en;

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
reg	[WR_WIDTH-1:0] datareg12;
reg	[WR_WIDTH-1:0] datareg13;
reg	[WR_WIDTH-1:0] datareg14;
reg	[WR_WIDTH-1:0] datareg15;

reg	[4:0]	wrpointer;
wire	[4:0]	wrpointer_full=wrpointer;

always @(posedge clk_wr)  begin
	if(!reset_n_wr) begin
		wrpointer<=0;
	end
	else begin
		if(en_wr) begin
			if(wrpointer==5'd15) begin
				wrpointer <= 5'd0;
			end
			else begin
				wrpointer <= wrpointer +1 ;
			end
			
			case(wrpointer)
			0 : datareg0 <=date_wr;
			1 : datareg1 <=date_wr;
			2 : datareg2 <=date_wr;
			3 : datareg3 <=date_wr;
			4 : datareg4 <=date_wr;
			5 : datareg5 <=date_wr;
			6 : datareg6 <=date_wr;
			7 : datareg7 <=date_wr;
			8 : datareg8 <=date_wr;
			9 : datareg9 <=date_wr;
			10: datareg10<=date_wr;
			11: datareg11<=date_wr;
			12: datareg12<=date_wr;
			13: datareg13<=date_wr;
			14: datareg14<=date_wr;
			15: datareg15<=date_wr;
			endcase
		end
	end
end


wire	[4:0]	wrpointer_gray;
graycounter_16_long inst_grayencoder_wr (
	.clk(clk_wr),
	.reset_n(reset_n_wr),
	.inp(wrpointer),
	.enable(en_wr),
	.outp(wrpointer_gray)
);

wire	[4:0]	wrpointer_gray_sync1;
wire	[4:0]	wrpointer_gray_sync2;
//we dont need reset here
//this will reduce the delay
/*always  @(posedge clk_rd) begin
	wrpointer_gray_sync1<=wrpointer_gray;
	wrpointer_gray_sync2<=wrpointer_gray_sync1;
end*/
sync_2xdff #(5) inst_wrpointer_gray_sync1(
	.dout(wrpointer_gray_sync2),
	.clk(clk_rd), 
//	.rst_n(reset_n_rd), 
	.din(wrpointer_gray)
);

/*sync_2xdff #(5) inst_wrpointer_gray_sync2(
	.dout(wrpointer_gray_sync2),
	.clk(clk_rd), 
	.rst_n(reset_n_rd), 
	.din(wrpointer_gray_sync1)
);*/

wire [4:0] wrpointer_gray_sync2_dec;

graydecoder_16_long inst_graydecoder_wr (
	.clk(clk_rd),
	.reset_n(reset_n_rd),
	.inp(wrpointer_gray_sync2),
	.outp(wrpointer_gray_sync2_dec)
);

wire [4:0] wrpointer_gray_sync2_full=wrpointer_gray_sync2_dec;


reg	[4:0]	rdpointerG;
reg	[4:0]	rdpointer;
reg	[4:0]	rdpointerG_nxt;
reg	[4:0]	rdpointer_nxt;
wire	[4:0]	rdpointer_full=rdpointer;

wire	almost_full_approximation                   =(rdpointer_full>wrpointer_gray_sync2_full)?
	((rdpointer_full-wrpointer_gray_sync2_full)<=8):
	((wrpointer_gray_sync2_full-rdpointer_full)>=(16-8));

always @(*) begin
	rdpointer_nxt=rdpointer;
	rdpointerG_nxt=rdpointerG;
	if(pop_rd | almost_full_approximation) begin
//		if(rdpointer==(16-1))
		if(rdpointer==5'd15)
			rdpointer_nxt=0;
		else 
			rdpointer_nxt=(rdpointer+1);

		case(rdpointer)
		0 :  rdpointerG_nxt=G0 ;
		1 :  rdpointerG_nxt=G1 ;
		2 :  rdpointerG_nxt=G1 ;
		3 :  rdpointerG_nxt=G2 ;
		4 :  rdpointerG_nxt=G2 ;
		5 :  rdpointerG_nxt=G3 ;
		6 :  rdpointerG_nxt=G3 ;
		7 :  rdpointerG_nxt=G4 ;
		8 :  rdpointerG_nxt=G4 ;
		9 :  rdpointerG_nxt=G5;
		10 : rdpointerG_nxt=G5;
		11 : rdpointerG_nxt=G6;
		12 : rdpointerG_nxt=G6;
		13 : rdpointerG_nxt=G7;
		14 : rdpointerG_nxt=G7;
		15 : rdpointerG_nxt=G0 ;
		endcase
	end
end



always @(posedge clk_rd)  begin
	if(!reset_n_rd) begin
		rdpointer<=0;
		rdpointerG<=G0;
		dissync<=1'b0;
	end
	else begin
		rdpointer<=rdpointer_nxt;
		rdpointerG<=rdpointerG_nxt;
		dissync<=almost_full_approximation & (!pop_rd);
	end
end

wire	[4:0]	rdpointer_gray;


graycounter_16_long inst_grayencoder_rd (
	.clk(clk_rd),
	.reset_n(reset_n_rd),
	.inp(rdpointer),
	.enable(pop_rd | almost_full_approximation),
	.outp(rdpointer_gray)
);

wire	[4:0]	rdpointer_gray_sync1;
wire	[4:0]	rdpointer_gray_sync2;
//we dont need reset here
//this will reduce the delay
/*always  @(posedge clk_wr) begin
	rdpointer_gray_sync1<=rdpointer_gray;
	rdpointer_gray_sync2<=rdpointer_gray_sync1;
end*/
sync_2xdff #(5) inst_rdpointer_gray_sync1(
	.dout(rdpointer_gray_sync2),
	.clk(clk_wr), 
//	.rst_n(reset_n_wr), 
	.din(rdpointer_gray)
);

/*sync_2xdff #(5) inst_rdpointer_gray_sync2(
	.dout(rdpointer_gray_sync2),
	.clk(clk_wr), 
	.rst_n(reset_n_wr), 
	.din(rdpointer_gray_sync1)
);*/

wire [4:0] rdpointer_gray_sync2_dec;

graydecoder_16_long inst_graydecoder_rd (
	.clk(clk_wr),
	.reset_n(reset_n_wr),
	.inp(rdpointer_gray_sync2),
	.outp(rdpointer_gray_sync2_dec)
);

wire [4:0] rdpointer_gray_sync2_full=rdpointer_gray_sync2_dec;

//eqaul means empty
wire	idle_wr               =(wrpointer_full>=rdpointer_gray_sync2_full)?
//	((wrpointer_full-rdpointer_gray_sync2_full)<=(16-3)):
	((wrpointer_full-rdpointer_gray_sync2_full)<=5'd13):
	((rdpointer_gray_sync2_full-wrpointer_full)>=5'd3);
wire	approximated_empty               =(wrpointer_full>=rdpointer_gray_sync2_full)?
	((wrpointer_full-rdpointer_gray_sync2_full)<=5'd3):
	((rdpointer_gray_sync2_full-wrpointer_full)>=5'd13);

//eqaul means empty
//canpop means there is a data in fifo
/*assign	canpop                   =(rdpointer_full>wrpointer_gray_sync2_full)?
	((rdpointer_full-wrpointer_gray_sync2_full)<=(16-1)):
	((wrpointer_gray_sync2_full-rdpointer_full)>=1);*/
//faster version
assign	canpop                   =(wrpointer_gray_sync2_full!=rdpointer_full);
reg [WR_WIDTH-1:0] data_rd1;
assign issync=data_rd1[WR_WIDTH-1] & canpop;
assign data_rd=data_rd1[WR_WIDTH-2:0];
assign data_valid=canpop;
always @(*) begin
	data_rd1=datareg0;
	case(rdpointer)
	0 : data_rd1=datareg0 ;
	1 : data_rd1=datareg1 ;
	2 : data_rd1=datareg2 ;
	3 : data_rd1=datareg3 ;
	4 : data_rd1=datareg4 ;
	5 : data_rd1=datareg5 ;
	6 : data_rd1=datareg6 ;
	7 : data_rd1=datareg7 ;
	8 : data_rd1=datareg8 ;
	9 : data_rd1=datareg9 ;
	10: data_rd1=datareg10;
	11: data_rd1=datareg11;
	12: data_rd1=datareg12;
	13: data_rd1=datareg13;
	14: data_rd1=datareg14;
	15: data_rd1=datareg15;
	endcase
end


wire correct=idle_wr | !en_wr;


always  @(posedge clk_rd) begin
	if(!reset_n_rd) begin
		out_blocklock_remote<=8'b1111_1111;
		out_blocklock_remote_en<=1'b0;
	end
	else begin
		out_blocklock_remote<=data_rd[7:0];
		out_blocklock_remote_en<=issync;
	end
end

`ifdef PCS_SIM
//eqaul means empty
//canpop means there is a data in fifo
wire	almost_full                   =(rdpointer_full>wrpointer_gray_sync2_full)?
	((rdpointer_full-wrpointer_gray_sync2_full)<=3):
	((wrpointer_gray_sync2_full-rdpointer_full)>=(16-3));
reg		almost_full_last;
always @(posedge clk_rd or negedge reset_n_rd) begin
	if(!reset_n_rd) begin
		almost_full_last<=0;
	end
	else begin
		almost_full_last<=almost_full;
	end
end

wire	almost_empty                   =(rdpointer_full>wrpointer_gray_sync2_full)?
	((rdpointer_full-wrpointer_gray_sync2_full)>=(16-3)):
	((wrpointer_gray_sync2_full-rdpointer_full)<=3);

wire	overflow=almost_full_last&& almost_empty;

assert_always #(`OVL_FATAL) inst_assert_0(clk_wr,reset_n_wr,!overflow);

wire	not_expected_draw=almost_full_approximation & !pop_rd;

`endif

endmodule
