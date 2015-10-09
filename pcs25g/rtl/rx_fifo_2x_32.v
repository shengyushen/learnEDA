
module rx_fifo_2x_32 (
	in_enable,
	clk_wr,
	clk_rd,
	reset_n_wr,
	reset_n_rd,
	dissync_enable,
	
	en_wr,
	data_wr,

	canpop,
	pop_rd,
	data_rd,
	data_valid,
	dissync
);
parameter WR_WIDTH=48;

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

parameter G16=5'b11000;
parameter G17=5'b11001;
parameter G18=5'b11011;
parameter G19=5'b11010;
parameter G20=5'b11110;
parameter G21=5'b11111;
parameter G22=5'b11101;
parameter G23=5'b11100;

parameter G24=5'b10100;
parameter G25=5'b10101;
parameter G26=5'b10111;
parameter G27=5'b10110;
parameter G28=5'b10010;
parameter G29=5'b10011;
parameter G30=5'b10001;
parameter G31=5'b10000;

input	in_enable;
input clk_wr;
input clk_rd;
input reset_n_wr;
input reset_n_rd;
input dissync_enable;

input en_wr;
input [WR_WIDTH-1:0]  data_wr;

output	canpop;
input pop_rd;
output  [WR_WIDTH-1:0] data_rd;
output	data_valid;
output	dissync;
reg	dissync;


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

reg	[WR_WIDTH-1:0] datareg16;
reg	[WR_WIDTH-1:0] datareg17;
reg	[WR_WIDTH-1:0] datareg18;
reg	[WR_WIDTH-1:0] datareg19;
reg	[WR_WIDTH-1:0] datareg20;
reg	[WR_WIDTH-1:0] datareg21;
reg	[WR_WIDTH-1:0] datareg22;
reg	[WR_WIDTH-1:0] datareg23;

reg	[WR_WIDTH-1:0] datareg24;
reg	[WR_WIDTH-1:0] datareg25;
reg	[WR_WIDTH-1:0] datareg26;
reg	[WR_WIDTH-1:0] datareg27;
reg	[WR_WIDTH-1:0] datareg28;
reg	[WR_WIDTH-1:0] datareg29;
reg	[WR_WIDTH-1:0] datareg30;
reg	[WR_WIDTH-1:0] datareg31;

reg	[4:0]	wrpointer;
wire	[4:0]	wrpointer_full=wrpointer;

always @(posedge clk_wr)  begin
	if(!reset_n_wr) begin
		wrpointer<=0;
		datareg0 <=0;
		datareg1 <=0;
		datareg2 <=0;
		datareg3 <=0;
		datareg4 <=0;
		datareg5 <=0;
		datareg6 <=0;
		datareg7 <=0;

		datareg8 <=0;
		datareg9 <=0;
		datareg10<=0;
		datareg11<=0;
		datareg12<=0;
		datareg13<=0;
		datareg14<=0;
		datareg15<=0;

		datareg16<=0;
		datareg17<=0;
		datareg18<=0;
		datareg19<=0;
		datareg20<=0;
		datareg21<=0;
		datareg22<=0;
		datareg23<=0;

		datareg24<=0;
		datareg25<=0;
		datareg26<=0;
		datareg27<=0;
		datareg28<=0;
		datareg29<=0;
		datareg30<=0;
		datareg31<=0;

	end
	else if(in_enable) begin
		if(en_wr) begin
			if(wrpointer==5'd31) begin
				wrpointer <= 5'd0;
			end
			else begin
				wrpointer <= wrpointer +1 ;
			end
			
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
			12: datareg12<=data_wr;
			13: datareg13<=data_wr;
			14: datareg14<=data_wr;
			15: datareg15<=data_wr;

			16: datareg16<=data_wr;
			17: datareg17<=data_wr;
			18: datareg18<=data_wr;
			19: datareg19<=data_wr;
			20: datareg20<=data_wr;
			21: datareg21<=data_wr;
			22: datareg22<=data_wr;
			23: datareg23<=data_wr;
			
			24: datareg24<=data_wr;
			25: datareg25<=data_wr;
			26: datareg26<=data_wr;
			27: datareg27<=data_wr;
			28: datareg28<=data_wr;
			29: datareg29<=data_wr;
			30: datareg30<=data_wr;
			31: datareg31<=data_wr;

			endcase
		end
	end
end


wire	[4:0]	wrpointer_gray;
graycounter_32_long inst_grayencoder_wr (
	.clk(clk_wr),
	.reset_n(reset_n_wr),
	.inp(wrpointer),
	.enable(en_wr && in_enable),
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
	.rst_n(1'b1), 
	.din(wrpointer_gray)
);

/*sync_2xdff #(5) inst_wrpointer_gray_sync2(
	.dout(wrpointer_gray_sync2),
	.clk(clk_rd), 
	.rst_n(reset_n_rd), 
	.din(wrpointer_gray_sync1)
);*/

wire [4:0] wrpointer_gray_sync2_dec;

graydecoder_32_long inst_graydecoder_wr (
	.clk(clk_rd),
	.reset_n(reset_n_rd),
	.inp(wrpointer_gray_sync2),
	.outp(wrpointer_gray_sync2_dec)
);

wire [4:0] wrpointer_gray_sync2_full=wrpointer_gray_sync2_dec;


//reg	[4:0]	rdpointerG;
reg	[4:0]	rdpointer;
//reg	[4:0]	rdpointerG_nxt;
reg	[4:0]	rdpointer_nxt;
wire	[4:0]	rdpointer_full=rdpointer;

reg	almost_full_approximation;
always @(*) begin
	if(dissync_enable==1'b0) begin
		almost_full_approximation = 1'b0;
	end
	else begin
		almost_full_approximation = (rdpointer_full>wrpointer_gray_sync2_full)?
		((rdpointer_full-wrpointer_gray_sync2_full)<=8):
		((wrpointer_gray_sync2_full-rdpointer_full)>=(32-8));
	end
end

wire reading=pop_rd | almost_full_approximation;
wire	not_expected_draw=almost_full_approximation & !pop_rd;

always @(*) begin
	rdpointer_nxt=rdpointer;
//	rdpointerG_nxt=rdpointerG;
	if(reading) begin
//		if(rdpointer==(16-1))
		if(rdpointer==5'd31)
			rdpointer_nxt=0;
		else 
			rdpointer_nxt=(rdpointer+1);

		/*case(rdpointer)
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
		endcase*/
	end
end



always @(posedge clk_rd)  begin
	if(!reset_n_rd) begin
		rdpointer<=0;
//		rdpointerG<=G0;
		dissync<=1'b0;
	end
	else if(in_enable) begin
		rdpointer<=rdpointer_nxt;
//		rdpointerG<=rdpointerG_nxt;
		dissync<=not_expected_draw;
	end
end

wire	[4:0]	rdpointer_gray;


graycounter_32_long inst_grayencoder_rd (
	.clk(clk_rd),
	.reset_n(reset_n_rd),
	.inp(rdpointer),
	.enable(reading && in_enable),
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
	.rst_n(1'b1), 
	.din(rdpointer_gray)
);

/*sync_2xdff #(5) inst_rdpointer_gray_sync2(
	.dout(rdpointer_gray_sync2),
	.clk(clk_wr), 
	.rst_n(reset_n_wr), 
	.din(rdpointer_gray_sync1)
);*/

wire [4:0] rdpointer_gray_sync2_dec;

graydecoder_32_long inst_graydecoder_rd (
	.clk(clk_wr),
	.reset_n(reset_n_wr),
	.inp(rdpointer_gray_sync2),
	.outp(rdpointer_gray_sync2_dec)
);

wire [4:0] rdpointer_gray_sync2_full=rdpointer_gray_sync2_dec;

//eqaul means empty
wire	idle_wr               =(wrpointer_full>=rdpointer_gray_sync2_full)?
//	((wrpointer_full-rdpointer_gray_sync2_full)<=(16-3)):
	((wrpointer_full-rdpointer_gray_sync2_full)<=5'd29):
	((rdpointer_gray_sync2_full-wrpointer_full)>=5'd3);
wire	approximated_empty               =(wrpointer_full>=rdpointer_gray_sync2_full)?
	((wrpointer_full-rdpointer_gray_sync2_full)<=5'd3):
	((rdpointer_gray_sync2_full-wrpointer_full)>=5'd29);

//eqaul means empty
//canpop means there is a data in fifo
/*assign	canpop                   =(rdpointer_full>wrpointer_gray_sync2_full)?
	((rdpointer_full-wrpointer_gray_sync2_full)<=(16-1)):
	((wrpointer_gray_sync2_full-rdpointer_full)>=1);*/
//faster version
assign	canpop                   =(wrpointer_gray_sync2_full!=rdpointer_full);
reg [WR_WIDTH-1:0] data_rd1;
assign data_rd=data_rd1;
assign data_valid=canpop & reading; 
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
	
	16: data_rd1=datareg16;
	17: data_rd1=datareg17;
	18: data_rd1=datareg18;
	19: data_rd1=datareg19;
	20: data_rd1=datareg20;
	21: data_rd1=datareg21;
	22: data_rd1=datareg22;
	23: data_rd1=datareg23;
	
	24: data_rd1=datareg24;
	25: data_rd1=datareg25;
	26: data_rd1=datareg26;
	27: data_rd1=datareg27;
	28: data_rd1=datareg28;
	29: data_rd1=datareg29;
	30: data_rd1=datareg30;
	31: data_rd1=datareg31;
	
	endcase
end


wire correct=idle_wr | !en_wr;



`ifdef PCS_SIM
//eqaul means empty
//canpop means there is a data in fifo
wire	almost_full                   =(rdpointer_full>wrpointer_gray_sync2_full)?
	((rdpointer_full-wrpointer_gray_sync2_full)<=3):
	((wrpointer_gray_sync2_full-rdpointer_full)>=(32-3));
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
	((rdpointer_full-wrpointer_gray_sync2_full)>=(32-3)):
	((wrpointer_gray_sync2_full-rdpointer_full)<=3);

wire	overflow=almost_full_last&& almost_empty;

//when NO_DISSYNC is not defined, the dissync is enabled
// which will discard old data by increase read pointer to prevent overflow
// in this case, we can test this assertion
// otherwise, the fifo is intentionally overflowed to discard old data
assert_always #(`OVL_FATAL) inst_assert_0(clk_wr,reset_n_wr,!overflow);

`endif

endmodule
