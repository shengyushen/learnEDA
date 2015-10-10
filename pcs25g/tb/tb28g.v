`timescale 1ns/1ps
module tb28g(
	//selecting pcs25g or fec
	USE_PCS25G,
	//common setting for pcs25g and fec
	NO_DISSYNC,
	INFER_POLAR,
	GIVEN_POLAR,
	//fec config
	MD_BYPASS_CORR_ENABLE,
	MD_BYPASS_IND_ENABLE,
	//pcs25g config
	INFER_BLOCKLOCK,
	GIVEN_BLOCKLOCK,
	//simulation config
	LANESKEW,
	POLAR_INVERSION,
	MISCONN,
	ERRORTYPE,
	in_errorInjectionMode
);
input [1:0] in_errorInjectionMode;
	//selecting pcs25g or fec
input USE_PCS25G;
	//common setting for pcs25g and fec
input	NO_DISSYNC;
input	INFER_POLAR;
input	[3:0] GIVEN_POLAR;
//fec config
input MD_BYPASS_CORR_ENABLE;
input MD_BYPASS_IND_ENABLE;
//pcs25g config
input	INFER_BLOCKLOCK;
input	[3:0] GIVEN_BLOCKLOCK;

	//simulation config
input LANESKEW;
input	POLAR_INVERSION;
input	MISCONN;
input [2:0] ERRORTYPE;

parameter CYCLE_FAST=2.000;
parameter CYCLE_SLOW=2.002;

`ifdef FOURTYG
parameter CYCLE800_FAST=1.000;
parameter CYCLE800_SLOW=1.002;
`else
parameter CYCLE800_FAST=1.428/2;//test for the half rate mode by rising the core clock freq
parameter CYCLE800_SLOW=1.430/2;
//parameter CYCLE800_FAST=1.250;
//parameter CYCLE800_SLOW=1.252;
`endif

reg clk500m_fast;
initial 
begin
	clk500m_fast=1;
	forever 
		#(CYCLE_FAST/2) clk500m_fast=!clk500m_fast;
end

reg clk800m_fast;
initial 
begin
	clk800m_fast=1;
	forever 
		#(CYCLE800_FAST/2) clk800m_fast=!clk800m_fast;
end
    reg[10:0]     hss_HSSPRTADDR_fast ; 
    reg           hss_HSSPRTAEN_fast ;   
    reg[15:0]     hss_HSSPRTDATAIN_fast ;
    reg           hss_HSSPRTWRITE_fast ; 

reg	hssreset_fast;
initial 
begin
	hssreset_fast=1;
	#(200) hssreset_fast=1;
	#(200) hssreset_fast=0;
/*	#(2000) //wait for prtready
	hss_HSSPRTAEN_fast=1'b1;*/
	/*broadcast to all tx*/
/*	hss_HSSPRTADDR_fast=11'b10001_000000;
	hss_HSSPRTDATAIN_fast=16'b1010_0010_0100_1000;
	hss_HSSPRTWRITE_fast=1'b0;
	#50
	hss_HSSPRTWRITE_fast=1'b1;
	#50
	hss_HSSPRTWRITE_fast=1'b0;
	#300*/
	/*broadcast to all rx*/
//	hss_HSSPRTADDR_fast=11'b10010_000000;
//	hss_HSSPRTDATAIN_fast=16'b1010_0010_0111_1000;
//above dfe setting may cause clock drift in simulation
/*	hss_HSSPRTDATAIN_fast=16'b1010_0010_0100_1000;
	#50
	hss_HSSPRTWRITE_fast=1'b1;
	#50
	hss_HSSPRTWRITE_fast=1'b0;*/

end
/*setting 32 bit interface*/
wire HSSPRTREADYB_fast;
always @(HSSPRTREADYB_fast) begin
  if(HSSPRTREADYB_fast) begin
  #(2000) //wait for prtready
  force hss_HSSPRTAEN_fast=1'b1;
  /*broadcast to all tx*/
  force hss_HSSPRTADDR_fast=11'b10001_000000;
  force hss_HSSPRTDATAIN_fast=16'b1010_0010_0100_1000;
  force hss_HSSPRTWRITE_fast=1'b0;
  #50
  force hss_HSSPRTWRITE_fast=1'b1;
  #50
  force hss_HSSPRTWRITE_fast=1'b0;
  #300
  /*broadcast to all rx*/
  force hss_HSSPRTADDR_fast=11'b10010_000000;
  force hss_HSSPRTDATAIN_fast=16'b1010_0010_0100_1000;
  #50
  force hss_HSSPRTWRITE_fast=1'b1;
  #50
  force hss_HSSPRTWRITE_fast=1'b0;

  end
end

reg	corereset;
initial 
begin
	corereset=1;
	#(900) corereset=1;//wait for rxdclk ready
	#(200) corereset=0;
end

reg	c32reset;
reg div2reset;
initial 
begin
	c32reset=1;
	div2reset=1;
	#(800) c32reset=1;//wait for rxdclk ready
	#(200) c32reset=0;
	#(400) div2reset=1;
	#(200) div2reset=0;
end



//800M core clock a little slower
reg clk500m_slow;
initial 
begin
	clk500m_slow=1;
	forever 
		#(CYCLE_SLOW/2) clk500m_slow=!clk500m_slow;
end

reg clk800m_slow;
initial 
begin
	clk800m_slow=1;
	forever 
		#(CYCLE800_SLOW/2) clk800m_slow=!clk800m_slow;
end

reg clk_ref;
initial 
begin
	clk_ref=1;
	forever 
		#(5) clk_ref=!clk_ref;
end

reg rst_ref_n;
initial 
begin
	rst_ref_n=1'b0;
	#100 rst_ref_n=1'b0;
	#100 rst_ref_n=1'b1;
end

    reg[10:0]     hss_HSSPRTADDR_slow ; 
    reg           hss_HSSPRTAEN_slow ;   
    reg[15:0]     hss_HSSPRTDATAIN_slow ;
    reg           hss_HSSPRTWRITE_slow ; 

reg	hssreset_slow;
initial 
begin
	hssreset_slow=1;
	#(200) hssreset_slow=1;
	#(200) hssreset_slow=0;
/*	#(2000)//we must wait for the prtready  
	hss_HSSPRTAEN_slow=1'b1;*/
	/*broadcast to all tx*/
/*	hss_HSSPRTADDR_slow=11'b10001_000000;
	hss_HSSPRTDATAIN_slow=16'b1010_0010_0100_1000;
	hss_HSSPRTWRITE_slow=1'b0;
	#50
	hss_HSSPRTWRITE_slow=1'b1;
	#50
	hss_HSSPRTWRITE_slow=1'b0;
	#300*/
	/*broadcast to all rx*/
//	hss_HSSPRTADDR_slow=11'b10010_000000;
//	hss_HSSPRTDATAIN_slow=16'b1010_0010_0111_1000;
//above dfe setting may cause clock drift in simulation
/*	hss_HSSPRTDATAIN_slow=16'b1010_0010_0100_1000;
	#50
	hss_HSSPRTWRITE_slow=1'b1;
	#50
	hss_HSSPRTWRITE_slow=1'b0;*/
end

/*setting 32 bit interface*/
wire HSSPRTREADYB_slow;
always @(HSSPRTREADYB_slow) begin
  if(HSSPRTREADYB_slow) begin
  #(2000) //wait for prtready
  force hss_HSSPRTAEN_slow=1'b1;
  /*broadcast to all tx*/
  force hss_HSSPRTADDR_slow=11'b10001_000000;
  force hss_HSSPRTDATAIN_slow=16'b1010_0010_0100_1000;
  force hss_HSSPRTWRITE_slow=1'b0;
  #50
  force hss_HSSPRTWRITE_slow=1'b1;
  #50
  force hss_HSSPRTWRITE_slow=1'b0;
  #300
  /*broadcast to all rx*/
  force hss_HSSPRTADDR_slow=11'b10010_000000;
  force hss_HSSPRTDATAIN_slow=16'b1010_0010_0100_1000;
  #50
  force hss_HSSPRTWRITE_slow=1'b1;
  #50
  force hss_HSSPRTWRITE_slow=1'b0;

  end
end

reg sendtime;
initial 
begin
	sendtime=1'b1;
	#(20000) sendtime=1'b0;
end

//from fast to slow
wire	F2S_A_N;
wire	F2S_A_P;
wire	F2S_B_N;
wire	F2S_B_P;
wire	F2S_C_N;
wire	F2S_C_P;
wire	F2S_D_N;
wire	F2S_D_P;

reg	F2S_A_N_err;
reg	F2S_A_P_err;
reg	F2S_B_N_err;
reg	F2S_B_P_err;
reg	F2S_C_N_err;
reg	F2S_C_P_err;
reg	F2S_D_N_err;
reg	F2S_D_P_err;

reg	F2S_A_N_delay;
reg	F2S_A_P_delay;
reg	F2S_B_N_delay;
reg	F2S_B_P_delay;
reg	F2S_C_N_delay;
reg	F2S_C_P_delay;
reg	F2S_D_N_delay;
reg	F2S_D_P_delay;


random_error inst_random_error0 (ERRORTYPE,err0);
random_error inst_random_error1 (ERRORTYPE,err1);
random_error inst_random_error2 (ERRORTYPE,err2);
random_error inst_random_error3 (ERRORTYPE,err3);

wire isam0;
wire isam1;
wire isam2;
wire isam3;
wire fecFrameStart0;
wire fecFrameStart1;
wire fecFrameStart2;
wire fecFrameStart3;
wire [2:0] am_field0;
wire [2:0] am_field1;
wire [2:0] am_field2;
wire [2:0] am_field3;
wire corruptAM0;
lane_shower inst_lane_shower0(.in_data(F2S_A_P_delay),.out_isam(isam0),.am_field(am_field0),.fecFrameStart(fecFrameStart0),.corruptAM(corruptAM0));
lane_shower inst_lane_shower1(.in_data(F2S_B_P_delay),.out_isam(isam1),.am_field(am_field1),.fecFrameStart(fecFrameStart1),.corruptAM());
lane_shower inst_lane_shower2(.in_data(F2S_C_P_delay),.out_isam(isam2),.am_field(am_field2),.fecFrameStart(fecFrameStart2),.corruptAM());
lane_shower inst_lane_shower3(.in_data(F2S_D_P_delay),.out_isam(isam3),.am_field(am_field3),.fecFrameStart(fecFrameStart3),.corruptAM());

wire isam0_err;
wire isam1_err;
wire isam2_err;
wire isam3_err;
wire fecFrameStart0_err;
wire fecFrameStart1_err;
wire fecFrameStart2_err;
wire fecFrameStart3_err;
wire [2:0] am_field0_err;
wire [2:0] am_field1_err;
wire [2:0] am_field2_err;
wire [2:0] am_field3_err;
lane_shower inst_lane_shower0_err(.in_data(F2S_A_P_err),.out_isam(isam0_err),.am_field(am_field0_err),.fecFrameStart(fecFrameStart0_err),.corruptAM());
lane_shower inst_lane_shower1_err(.in_data(F2S_B_P_err),.out_isam(isam1_err),.am_field(am_field1_err),.fecFrameStart(fecFrameStart1_err),.corruptAM());
lane_shower inst_lane_shower2_err(.in_data(F2S_C_P_err),.out_isam(isam2_err),.am_field(am_field2_err),.fecFrameStart(fecFrameStart2_err),.corruptAM());
lane_shower inst_lane_shower3_err(.in_data(F2S_D_P_err),.out_isam(isam3_err),.am_field(am_field3_err),.fecFrameStart(fecFrameStart3_err),.corruptAM());

wire amlost0=(am_field0!=am_field0_err);
wire amlost1=(am_field1!=am_field1_err);
wire amlost2=(am_field2!=am_field2_err);
wire amlost3=(am_field3!=am_field3_err);


always @(F2S_A_N_delay or err0 or corruptAM0) begin  F2S_A_N_err<=  F2S_A_N_delay&(!err0)&(!corruptAM0) ; end
always @(F2S_A_P_delay or err0 or corruptAM0) begin  F2S_A_P_err<=  F2S_A_P_delay&(!err0)&(!corruptAM0) ; end
always @(F2S_B_N_delay or err1) begin  F2S_B_N_err<=  F2S_B_N_delay&(!err1) ; end
always @(F2S_B_P_delay or err1) begin  F2S_B_P_err<=  F2S_B_P_delay&(!err1) ; end
always @(F2S_C_N_delay or err2) begin  F2S_C_N_err<=  F2S_C_N_delay&(!err2) ; end
always @(F2S_C_P_delay or err2) begin  F2S_C_P_err<=  F2S_C_P_delay&(!err2) ; end
always @(F2S_D_N_delay or err3) begin  F2S_D_N_err<=  F2S_D_N_delay&(!err3) ; end
always @(F2S_D_P_delay or err3) begin  F2S_D_P_err<=  F2S_D_P_delay&(!err3) ; end

always @(F2S_A_N) begin if(LANESKEW) begin F2S_A_N_delay<= #2  F2S_A_N ;end else begin F2S_A_N_delay<=  F2S_A_N ; end end
always @(F2S_A_P) begin if(LANESKEW) begin F2S_A_P_delay<= #2  F2S_A_P ;end else begin F2S_A_P_delay<=  F2S_A_P ; end end
always @(F2S_B_N) begin if(LANESKEW) begin F2S_B_N_delay<= #7  F2S_B_N ;end else begin F2S_B_N_delay<=  F2S_B_N ; end end
always @(F2S_B_P) begin if(LANESKEW) begin F2S_B_P_delay<= #7  F2S_B_P ;end else begin F2S_B_P_delay<=  F2S_B_P ; end end
always @(F2S_C_N) begin if(LANESKEW) begin F2S_C_N_delay<= #0  F2S_C_N ;end else begin F2S_C_N_delay<=  F2S_C_N ; end end
always @(F2S_C_P) begin if(LANESKEW) begin F2S_C_P_delay<= #0  F2S_C_P ;end else begin F2S_C_P_delay<=  F2S_C_P ; end end
always @(F2S_D_N) begin if(LANESKEW) begin F2S_D_N_delay<= #4  F2S_D_N ;end else begin F2S_D_N_delay<=  F2S_D_N ; end end
always @(F2S_D_P) begin if(LANESKEW) begin F2S_D_P_delay<= #4  F2S_D_P ;end else begin F2S_D_P_delay<=  F2S_D_P ; end end

initial begin
	#200000 force F2S_A_N_delay=0;  force F2S_A_P_delay=0;
	#100000 force F2S_C_N_delay=0;  force F2S_C_P_delay=0;
	#100000 force F2S_B_N_delay=0;  force F2S_B_P_delay=0;
	#100000 force F2S_D_N_delay=0;  force F2S_D_P_delay=0;

	#100000 release F2S_C_N_delay;  release F2S_C_P_delay;
	#100000 release F2S_A_N_delay;  release F2S_A_P_delay;
	#100000 release F2S_D_N_delay;  release F2S_D_P_delay;
	#100000 release F2S_B_N_delay;  release F2S_B_P_delay;

end

//from slow  to fast
wire	S2F_A_N;
wire	S2F_A_P;
wire	S2F_B_N;
wire	S2F_B_P;
wire	S2F_C_N;
wire	S2F_C_P;
wire	S2F_D_N;
wire	S2F_D_P;

reg	S2F_A_N_delay;
reg	S2F_A_P_delay;
reg	S2F_B_N_delay;
reg	S2F_B_P_delay;
reg	S2F_C_N_delay;
reg	S2F_C_P_delay;
reg	S2F_D_N_delay;
reg	S2F_D_P_delay;

always @(S2F_C_N or S2F_B_N or S2F_A_N) begin if(LANESKEW) begin S2F_A_N_delay<= #7 (MISCONN?S2F_B_N:S2F_A_N) ;end else begin S2F_A_N_delay<=  (MISCONN?S2F_B_N:S2F_A_N) ; end end
always @(S2F_C_P or S2F_B_P or S2F_A_P) begin if(LANESKEW) begin S2F_A_P_delay<= #7 (MISCONN?S2F_B_P:S2F_A_P) ;end else begin S2F_A_P_delay<=  (MISCONN?S2F_B_P:S2F_A_P) ; end end
always @(S2F_B_N) begin if(LANESKEW) begin S2F_D_N_delay<= #3 S2F_B_N ;end else begin S2F_D_N_delay<=  S2F_B_N ; end end
always @(S2F_B_P) begin if(LANESKEW) begin S2F_D_P_delay<= #3 S2F_B_P ;end else begin S2F_D_P_delay<=  S2F_B_P ; end end
always @(S2F_D_N) begin if(LANESKEW) begin S2F_C_N_delay<= #1 S2F_D_N ;end else begin S2F_C_N_delay<=  S2F_D_N ; end end
always @(S2F_D_P) begin if(LANESKEW) begin S2F_C_P_delay<= #1 S2F_D_P ;end else begin S2F_C_P_delay<=  S2F_D_P ; end end
always @(S2F_C_N) begin if(LANESKEW) begin S2F_B_N_delay<= #0 S2F_C_N ;end else begin S2F_B_N_delay<=  S2F_C_N ; end end
always @(S2F_C_P) begin if(LANESKEW) begin S2F_B_P_delay<= #0 S2F_C_P ;end else begin S2F_B_P_delay<=  S2F_C_P ; end end

initial begin
	#200000 force S2F_A_N_delay=0;  force S2F_A_P_delay=0;
	#100000 force S2F_C_N_delay=0;  force S2F_C_P_delay=0;
	#100000 force S2F_B_N_delay=0;  force S2F_B_P_delay=0;
	#100000 force S2F_D_N_delay=0;  force S2F_D_P_delay=0;

	#100000 release S2F_C_N_delay;  release S2F_C_P_delay;
	#100000 release S2F_A_N_delay;  release S2F_A_P_delay;
	#100000 release S2F_D_N_delay;  release S2F_D_P_delay;
	#100000 release S2F_B_N_delay;  release S2F_B_P_delay;

end
`ifdef FOURTYG
wire	[63:0]	out_txdata0_fast;
wire	[63:0]	out_txdata1_fast;
wire	[63:0]	out_txdata2_fast;
wire	[63:0]	out_txdata3_fast;

wire	[63:0]	out_rxdata0_fast;
wire	[63:0]	out_rxdata1_fast;
wire	[63:0]	out_rxdata2_fast;
wire	[63:0]	out_rxdata3_fast;
`else
wire	[31:0]	out_txdata0_fast;
wire	[31:0]	out_txdata1_fast;
wire	[31:0]	out_txdata2_fast;
wire	[31:0]	out_txdata3_fast;

wire	[31:0]	out_rxdata0_fast;
wire	[31:0]	out_rxdata1_fast;
wire	[31:0]	out_rxdata2_fast;
wire	[31:0]	out_rxdata3_fast;
`endif
wire	out_rxclk0_fast;
wire	out_rxclk1_fast;
wire	out_rxclk2_fast;
wire	out_rxclk3_fast;
wire HSSC32B_fast;
reg HSSC32B_fast_div2;
always @(posedge HSSC32B_fast) begin
	if(div2reset) begin
		HSSC32B_fast_div2<=1'b0;
	end
	else begin
		HSSC32B_fast_div2<=!HSSC32B_fast_div2;
	end
end
reg out_rxclk0_fast_div2;
always @(posedge out_rxclk0_fast) begin
	if(div2reset) begin
	out_rxclk0_fast_div2	<=1'b0;
	end
	else begin
	out_rxclk0_fast_div2	<=!out_rxclk0_fast_div2;
	end
end


chip inst_chip_fast(
	.reset_n(!corereset),
	.clkcore(clk800m_fast),
	.rx_reversed(1'b0),
	.sendtime(1'b1),
	.rcvtime(1'b0),

	.clkpma_tx(HSSC32B_fast),
	.clkpma_tx_div2(HSSC32B_fast_div2),
	.clkpma_rx0_div2(out_rxclk0_fast_div2),
	//tx 0
	.txdata0(out_txdata0_fast),
	//rx 0
	.clkpma_rx0(out_rxclk0_fast),
	.rxdata0(out_rxdata0_fast),
	//tx 1
	.txdata1(out_txdata1_fast),
	//rx 1
//lane B will be no clock
	.clkpma_rx1(MISCONN?1'b0:out_rxclk1_fast),
	.rxdata1(out_rxdata1_fast),
	//tx 2
	.txdata2(out_txdata2_fast),
	//rx 2
//lane C will have very slow clock
	.clkpma_rx2(MISCONN?clk500m_fast:out_rxclk2_fast),
	.rxdata2(out_rxdata2_fast),
	//tx 3
	.txdata3(out_txdata3_fast),
	//rx 3
	.clkpma_rx3(out_rxclk3_fast),
	.rxdata3(out_rxdata3_fast),
	//selecting pcs25g or cgfec
	.USE_PCS25G(USE_PCS25G),
	//common setting for pcs25g and fec
	.NO_DISSYNC(NO_DISSYNC),
	.INFER_POLAR(INFER_POLAR),
	.GIVEN_POLAR(GIVEN_POLAR),
	//config for cgfec
	.MD_BYPASS_CORR_ENABLE(MD_BYPASS_CORR_ENABLE),
	.MD_BYPASS_IND_ENABLE(MD_BYPASS_IND_ENABLE),
	//config for pcs25g
	.INFER_BLOCKLOCK(INFER_BLOCKLOCK),
	.GIVEN_BLOCKLOCK(GIVEN_BLOCKLOCK),
	.in_errorInjectionMode(in_errorInjectionMode)
	) ;


hss   inst_fast(
    // Outputs
     .hss_rxdata0(out_rxdata0_fast), 
     .hss_rxdata1(out_rxdata1_fast),
     .hss_rxdata2(out_rxdata2_fast), 
     .hss_rxdata3(out_rxdata3_fast),

     .hss_rxdclk0(out_rxclk0_fast), 
     .hss_rxdclk1(out_rxclk1_fast),
     .hss_rxdclk2(out_rxclk2_fast),
     .hss_rxdclk3(out_rxclk3_fast) , 

		.HSSCLK32B(HSSC32B_fast),
	.clk400M4asst(1'b0),

    .HSS_TXP({F2S_D_P,F2S_C_P,F2S_B_P,F2S_A_P}), 
    .HSS_TXN({F2S_D_N,F2S_C_N,F2S_B_N,F2S_A_N}), 

	.HSSPLLLOCKB(),
	.HSSPRTREADYB(HSSPRTREADYB_fast),
	.HSSPRTDATAOUT(),
	.clksel_half(),
	.RXXPKTCLK_pre(),

    // Inputs
    .txdclk(HSSC32B_fast),
		.clk_twg(1'b0),
		.hssRxAsstClk(1'b0),
    .IF_PLL_OUTAC(clk500m_fast), 
    .IF_PLL_OUTAT(!clk500m_fast), 
    .hss_reset(hssreset_fast),
    .rst_soft_hss(1'b0),

    .hss_txdata0(out_txdata0_fast), 
    .hss_txdata1(out_txdata1_fast),
    .hss_txdata2(out_txdata2_fast), 
    .hss_txdata3(out_txdata3_fast), 

    .HSSPRTADDR(hss_HSSPRTADDR_fast),
    .HSSPRTAEN(hss_HSSPRTAEN_fast), 
    .HSSPRTDATAIN(hss_HSSPRTDATAIN_fast),
    .HSSPRTWRITE(hss_HSSPRTWRITE_fast), 
		//lane inversion CD
    .HSS_RXP(POLAR_INVERSION?{S2F_D_N_delay,S2F_C_N_delay,S2F_B_P_delay,S2F_A_P_delay}:{S2F_D_P_delay,S2F_C_P_delay,S2F_B_P_delay,S2F_A_P_delay}), 
    .HSS_RXN(POLAR_INVERSION?{S2F_D_P_delay,S2F_C_P_delay,S2F_B_N_delay,S2F_A_N_delay}:{S2F_D_N_delay,S2F_C_N_delay,S2F_B_N_delay,S2F_A_N_delay}),
//above are functional IO
//below are configuration IO
       .config_hss_HSSDIVSELA(9'b0), 
       .config_hss_HSSDIVSELB(9'b0), 
       .config_hss_REFCLKVALIDA(1'b0),  
       .config_hss_REFCLKVALIDB(1'b0),  
       .config_hss_PDWNPLLA(1'b0),      
       .config_hss_PDWNPLLB(1'b0),      
       .config_hss_VCOSELA(1'b0),       
       .config_hss_VCOSELB(1'b0),       
       .config_hss_PLLDIV2A (1'b0),
       .config_hss_PLLDIV2B (1'b0),
       .config_hss_REFDIVA(4'b0),     
       .config_hss_REFDIVB(4'b0),     
       .config_hss_PLLCONFIGA (8'b0),
       .config_hss_PLLCONFIGB (8'b0),   
       .config_hss_ph0(5'b0),
			 .config_hss_ph1(5'b0),
			 .config_hss_ph2(5'b0),
			 .config_hss_ph3(5'b0),
	.config_hss_TXOE(4'b1111),
      
       .clk_ref(clk_ref),
       .rst_ref_n(rst_ref_n),
       .EEPROM_PRESENT (1'b0),
       .hss_load_done(1'b1),

			 .TXAAESTAT(),
			 .TXBAESTAT(),
			 .TXCAESTAT(),
			 .TXDAESTAT(),
			 .RXXPKTDATA(),
			 .RXXPKTFRAME(),
			 .RXXSIGDET(),
				.RXXBLOCKDPC(),
				.RXXPKTSTART(),
				.TXAAECMD(),
				.TXAAECMDVAL(),
				.TXBAECMD(),
				.TXBAECMDVAL(),
				.TXCAECMD(),
				.TXCAECMDVAL(),
				.TXDAECMD(),
				.TXDAECMDVAL(),
				.HSSCALCOMPOUT(),
				.HSSCALSSTOUTN(),
				.HSSCALSSTOUTP(),
       .change_hss_rst(1'b0),  
       .change_HSSDIVSELB(9'b0), 
       .change_VCOSELB(1'b0), 
       .change_PLLDIV2B(1'b0),
       .hss_curr_rate(3'b0),
       .rst_c32_change(c32reset),
       .twg_rst_for_c20(1'b0),
     .HSSCALCOMP(1'b0),
     .HSSCALENAB(1'b0),
     .HSSCALSSTN(6'b0),
     .HSSCALSSTP(6'b0)
    );


////////////////////slow////////////////////
`ifdef FOURTYG
wire	[63:0]	out_txdata0_slow;
wire	[63:0]	out_txdata1_slow;
wire	[63:0]	out_txdata2_slow;
wire	[63:0]	out_txdata3_slow;

wire	[63:0]	out_rxdata0_slow;
wire	[63:0]	out_rxdata1_slow;
wire	[63:0]	out_rxdata2_slow;
wire	[63:0]	out_rxdata3_slow;
`else
wire	[31:0]	out_txdata0_slow;
wire	[31:0]	out_txdata1_slow;
wire	[31:0]	out_txdata2_slow;
wire	[31:0]	out_txdata3_slow;

wire	[31:0]	out_rxdata0_slow;
wire	[31:0]	out_rxdata1_slow;
wire	[31:0]	out_rxdata2_slow;
wire	[31:0]	out_rxdata3_slow;
`endif
wire	out_rxclk0_slow;
wire	out_rxclk1_slow;
wire	out_rxclk2_slow;
wire	out_rxclk3_slow;
wire HSSC32B_slow;
reg HSSC32B_slow_div2;
always @(posedge HSSC32B_slow) begin
	if(div2reset) begin
		HSSC32B_slow_div2<=1'b0;
	end
	else begin
		HSSC32B_slow_div2<=!HSSC32B_slow_div2;
	end
end
reg out_rxclk0_slow_div2;
always @(posedge out_rxclk0_slow) begin
	if(div2reset) begin
	out_rxclk0_slow_div2	<=1'b0;
	end
	else begin
	out_rxclk0_slow_div2	<=!out_rxclk0_slow_div2;
	end
end


chip inst_chip_slow(
	.reset_n(!corereset),
	.clkcore(clk800m_slow),
	.rx_reversed(1'b1),
	.sendtime(1'b0),
	.rcvtime(1'b1),
	.clkpma_tx(HSSC32B_slow),
	.clkpma_tx_div2(HSSC32B_slow_div2),
	.clkpma_rx0_div2(out_rxclk0_slow_div2),
	//tx 0
	.txdata0(out_txdata0_slow),
	//rx 0
	.clkpma_rx0(out_rxclk0_slow),
	.rxdata0(out_rxdata0_slow),
	//tx 1
	.txdata1(out_txdata1_slow),
	//rx 1
	.clkpma_rx1(out_rxclk1_slow),
	.rxdata1(out_rxdata1_slow),
	//tx 2
	.txdata2(out_txdata2_slow),
	//rx 2
	.clkpma_rx2(out_rxclk2_slow),
	.rxdata2(out_rxdata2_slow),
	//tx 3
	.txdata3(out_txdata3_slow),
	//rx 3
	.clkpma_rx3(out_rxclk3_slow),
	.rxdata3(out_rxdata3_slow),

	//selecting pcs25g or fec
	.USE_PCS25G(USE_PCS25G),
	//common setting for pcs25g and fec
	.NO_DISSYNC(NO_DISSYNC),
	.INFER_POLAR(1'b1),//no polar inversion on slow's hss, so always infer
	.GIVEN_POLAR(GIVEN_POLAR),
//fec config
	.MD_BYPASS_CORR_ENABLE(MD_BYPASS_CORR_ENABLE),
	.MD_BYPASS_IND_ENABLE(MD_BYPASS_IND_ENABLE),
//pcs25g config
	.INFER_BLOCKLOCK(1'b1),
	.GIVEN_BLOCKLOCK(GIVEN_BLOCKLOCK),
	.in_errorInjectionMode(in_errorInjectionMode)
	) ;

hss   inst_slow(
    // Outputs
     .hss_rxdata0(out_rxdata0_slow), 
     .hss_rxdata1(out_rxdata1_slow),
     .hss_rxdata2(out_rxdata2_slow), 
     .hss_rxdata3(out_rxdata3_slow),
     .hss_rxdclk0(out_rxclk0_slow), 
     .hss_rxdclk1(out_rxclk1_slow),
     .hss_rxdclk2(out_rxclk2_slow),
     .hss_rxdclk3(out_rxclk3_slow) , 
		.HSSCLK32B(HSSC32B_slow),
	.clk400M4asst(1'b0),

    .HSS_TXP({S2F_D_P,S2F_C_P,S2F_B_P,S2F_A_P}), 
    .HSS_TXN({S2F_D_N,S2F_C_N,S2F_B_N,S2F_A_N}), 

	.HSSPLLLOCKB(),
	.HSSPRTREADYB(HSSPRTREADYB_slow),
	.HSSPRTDATAOUT(),
	.clksel_half(),
	.RXXPKTCLK_pre(),
    // Inputs
    .txdclk(HSSC32B_slow),
		.clk_twg(1'b0),
		.hssRxAsstClk(1'b0),
    .IF_PLL_OUTAC(clk500m_slow), 
    .IF_PLL_OUTAT(!clk500m_slow), 
    .hss_reset(hssreset_slow),
    .rst_soft_hss(1'b0),

    .hss_txdata0(out_txdata0_slow), 
    .hss_txdata1(out_txdata1_slow),
    .hss_txdata2(out_txdata2_slow), 
    .hss_txdata3(out_txdata3_slow), 

    .HSSPRTADDR(hss_HSSPRTADDR_slow),
    .HSSPRTAEN(hss_HSSPRTAEN_slow), 
    .HSSPRTDATAIN(hss_HSSPRTDATAIN_slow),
    .HSSPRTWRITE(hss_HSSPRTWRITE_slow), 
    .HSS_RXP({F2S_D_P_err,F2S_C_P_err,F2S_B_P_err,F2S_A_P_err}), 
    .HSS_RXN({F2S_D_N_err,F2S_C_N_err,F2S_B_N_err,F2S_A_N_err}),
//above are functional IO
//below are configuration IO
       .config_hss_HSSDIVSELA(9'b0), 
       .config_hss_HSSDIVSELB(9'b0), 
       .config_hss_REFCLKVALIDA(1'b0),  
       .config_hss_REFCLKVALIDB(1'b0),  
       .config_hss_PDWNPLLA(1'b0),      
       .config_hss_PDWNPLLB(1'b0),      
       .config_hss_VCOSELA(1'b0),       
       .config_hss_VCOSELB(1'b0),       
       .config_hss_PLLDIV2A (1'b0),
       .config_hss_PLLDIV2B (1'b0),
       .config_hss_REFDIVA(4'b0),     
       .config_hss_REFDIVB(4'b0),     
       .config_hss_PLLCONFIGA (8'b0),
       .config_hss_PLLCONFIGB (8'b0),   
       .config_hss_ph0(5'b0),
			 .config_hss_ph1(5'b0),
			 .config_hss_ph2(5'b0),
			 .config_hss_ph3(5'b0),
	.config_hss_TXOE(4'b1111),
      
       .clk_ref(clk_ref),
       .rst_ref_n(rst_ref_n),
       .EEPROM_PRESENT (1'b0),
       .hss_load_done(1'b1),

			 .TXAAESTAT(),
			 .TXBAESTAT(),
			 .TXCAESTAT(),
			 .TXDAESTAT(),
			 .RXXPKTDATA(),
			 .RXXPKTFRAME(),
			 .RXXSIGDET(),
				.RXXBLOCKDPC(),
				.RXXPKTSTART(),
				.TXAAECMD(),
				.TXAAECMDVAL(),
				.TXBAECMD(),
				.TXBAECMDVAL(),
				.TXCAECMD(),
				.TXCAECMDVAL(),
				.TXDAECMD(),
				.TXDAECMDVAL(),
				.HSSCALCOMPOUT(),
				.HSSCALSSTOUTN(),
				.HSSCALSSTOUTP(),
       .change_hss_rst(1'b0),  
       .change_HSSDIVSELB(9'b0), 
       .change_VCOSELB(1'b0), 
       .change_PLLDIV2B(1'b0),
       .hss_curr_rate(3'b0),
       .rst_c32_change(c32reset),
       .twg_rst_for_c20(1'b0),
     .HSSCALCOMP(1'b0),
     .HSSCALENAB(1'b0),
     .HSSCALSSTN(6'b0),
     .HSSCALSSTP(6'b0)
    );


endmodule

