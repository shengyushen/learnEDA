//-----------------------------------------------------------------
//  (C) Copyright Lab 604, 2012.  All Rights Reserved.
//-----------------------------------------------------------------
//
// Author      : xiao canwen,NC Group
// Created On  : 2014-2-20 15:45:41
// shengyu shen port to 28g at 2013-11-30
// Description :
//
//---------------------------------------------------------------------
//{{{ History :
//
//}}}


//todo :
//1	csr
//2	twg
//3	aec aet
//4 calibration related pin not connected yet
//     HSSCALCOMP(),
//    HSSCALENAB(),
//     HSSCALSSTN(),
//     HSSCALSSTP(),
//calibrating imp
//     HSSCALCOMPOUT,
//     HSSCALSSTOUTN,
//     HSSCALSSTOUTP,
//5 asst
module hss(/*AUTOARG*/
  // Outputs
	hss_rxdata0,
	hss_rxdata1,
	hss_rxdata2,
	hss_rxdata3,

	hss_rxdclk0,
	hss_rxdclk1,
	hss_rxdclk2,
	hss_rxdclk3,


    HSS_TXP, 
	HSS_TXN, 
	
	HSSPLLLOCKB,
	HSSPRTREADYB,
	
	HSSPRTDATAOUT,         
	
	HSSCALCOMPOUT,
	HSSCALSSTOUTN,
	HSSCALSSTOUTP,
	clksel_half,
	HSSCLK32B,
	RXXPKTCLK_pre,

  // Inputs
    IF_PLL_OUTAC, //500Mhz ref clk
	IF_PLL_OUTAT, 
	hss_reset,
	rst_soft_hss,
	change_hss_rst, 
	change_HSSDIVSELB,
	change_VCOSELB,
	change_PLLDIV2B,
	hss_curr_rate,
	rst_c32_change,

    twg_rst_for_c20,
    hss_txdata0, 
	hss_txdata1,
    hss_txdata2, 
	hss_txdata3, 

	HSSPRTADDR,
	HSSPRTAEN,
	HSSPRTDATAIN,
	HSSPRTWRITE,

	HSS_RXP, 
	HSS_RXN,      
	
	
	HSSCALCOMP,
	HSSCALENAB,
	HSSCALSSTN,
	HSSCALSSTP,
	
	
	

//above are functional IO
//below are configuration IO
	
	//input
	//28G using PLLB according to
	// Table1-1.Data Rates and Receiver Modes Supported by the HS28GB Cores 
       config_hss_HSSDIVSELA, 
       config_hss_HSSDIVSELB, 
       config_hss_REFCLKVALIDA,  
       config_hss_REFCLKVALIDB,  
       config_hss_PDWNPLLA,      
       config_hss_PDWNPLLB,      
       config_hss_VCOSELA,       
       config_hss_VCOSELB,       
       config_hss_PLLDIV2A ,
       config_hss_PLLDIV2B ,
       config_hss_REFDIVA,     
       config_hss_REFDIVB,     
       config_hss_PLLCONFIGA ,
       config_hss_PLLCONFIGB ,   
       config_hss_ph0,config_hss_ph1,config_hss_ph2,config_hss_ph3 , config_hss_TXOE ,
      
       
       TXAAESTAT , TXBAESTAT , TXCAESTAT , TXDAESTAT ,
       RXXPKTDATA , RXXPKTFRAME , RXXSIGDET,
       RXXBLOCKDPC, RXXPKTSTART,TXAAECMD , TXAAECMDVAL ,
       TXBAECMD , TXBAECMDVAL ,TXCAECMD , TXCAECMDVAL ,
       TXDAECMD , TXDAECMDVAL ,
       
       
			 
			 hssRxAsstClk,
       clk_ref,
       rst_ref_n,
       EEPROM_PRESENT ,
       hss_load_done    , clk_twg, clk400M4asst,
			 txdclk
        
 

    );

  
  //outputs 
  output [3:0]    RXXPKTDATA ;
  output [3:0]    RXXPKTFRAME ;
  output [3:0]    RXXSIGDET ;
  output [7:0]    TXAAESTAT , TXBAESTAT , TXCAESTAT , TXDAESTAT ;      
  
  output           HSSCALCOMPOUT ;      
  output [5:0]     HSSCALSSTOUTN ;       
  output [5:0]     HSSCALSSTOUTP ;  
	output clksel_half;
  
  input            HSSCALCOMP ;        
  input            HSSCALENAB ;         
  input  [5:0]     HSSCALSSTN ;         
  input  [5:0]     HSSCALSSTP ;         
   
  input  [3:0]    RXXBLOCKDPC ;
  input  [3:0]    RXXPKTSTART ;
  input  [13:0]   TXAAECMD  ;
  input           TXAAECMDVAL ;
  input  [13:0]   TXBAECMD  ;
  input           TXBAECMDVAL ;
  input  [13:0]   TXCAECMD  ;
  input           TXCAECMDVAL ;
  input  [13:0]   TXDAECMD  ;
  input           TXDAECMDVAL ;
  
  input          change_hss_rst  ;     //change the parameter of hspll 
  input[8:0]     change_HSSDIVSELB ;
  input          change_VCOSELB ;
  input          change_PLLDIV2B ;
  input[2:0]     hss_curr_rate ;
  input          rst_c32_change ;
  input          twg_rst_for_c20 ;
  
input clk_twg, clk400M4asst;
  
  // Outputs
output [31:0]	hss_rxdata0;
output [31:0]	hss_rxdata1;
output [31:0]	hss_rxdata2;
output [31:0]	hss_rxdata3;

output	hss_rxdclk0;
output	hss_rxdclk1;
output	hss_rxdclk2;
output	hss_rxdclk3;


output  [3:0] HSS_TXP;
output	[3:0] HSS_TXN; 
output	HSSPLLLOCKB;
output	HSSPRTREADYB;
output	[15:0] HSSPRTDATAOUT;

  // Inputs
input IF_PLL_OUTAC;
input IF_PLL_OUTAT;
input	hss_reset;
input   rst_soft_hss ;
input [31:0] hss_txdata0;
input [31:0] hss_txdata1;
input [31:0] hss_txdata2;
input [31:0] hss_txdata3;

input	[3:0] HSS_RXP;
input	[3:0] HSS_RXN;

input [10:0]	HSSPRTADDR;
input	        HSSPRTAEN;
input [15:0]	HSSPRTDATAIN;
input	        HSSPRTWRITE;

output    [3:0]    RXXPKTCLK_pre ;
//above are functional IO
//below are configuration IO
	
//input
//28G using PLLB according to
// Table1-1.Data Rates and Receiver Modes Supported by the HS28GB Cores 
    input [8:0]     config_hss_HSSDIVSELA; 
    input [8:0]     config_hss_HSSDIVSELB; 
    input           config_hss_REFCLKVALIDA;  
    input           config_hss_REFCLKVALIDB;  
    input           config_hss_PDWNPLLA;      
    input           config_hss_PDWNPLLB;      
    input           config_hss_VCOSELA;       
    input           config_hss_VCOSELB;       
    input           config_hss_PLLDIV2A ;
    input           config_hss_PLLDIV2B ;
    input [3:0]     config_hss_REFDIVA;     
    input [3:0]     config_hss_REFDIVB;     
    input [7:0]     config_hss_PLLCONFIGA ;
    input [7:0]     config_hss_PLLCONFIGB ;   
    input [4:0]     config_hss_ph0;
    input [4:0]     config_hss_ph1 ;
    input [4:0]     config_hss_ph2 ;
    input [4:0]     config_hss_ph3 ;   
    input [3:0]     config_hss_TXOE  ;
   
    input           hss_load_done ;   
    input           clk_ref ;
	input           hssRxAsstClk ;
	
    input           rst_ref_n ;
    input           EEPROM_PRESENT ;
		input						txdclk;



output HSSCLK32B;
wire HSSCLK32B_div2;
wire HSSCLK32B_div4;
wire HSSCLK32B_1ordiv2;
wire HSSCLK32B_2ordiv4;
wire [7:0] x0,x1,x2,x3;


reg [8:0]      HSSDIVSELA;       
reg [8:0]      HSSDIVSELB;       
reg            REFCLKVALIDA;     
reg            REFCLKVALIDB;     
reg            PDWNPLLA;         
reg            PDWNPLLB;         
reg            VCOSELA;          
reg            VCOSELB;          
reg            PLLDIV2A ;        
reg            PLLDIV2B ;        
reg [3:0]      REFDIVA;          
reg [3:0]      REFDIVB;          
reg [7:0]      PLLCONFIGA ;      
reg [7:0]      PLLCONFIGB ;      
reg [4:0]      ph0;              
reg [4:0]      ph1 ;             
reg [4:0]      ph2 ;             
reg [4:0]      ph3 ;             
reg [3:0]      TXOE ;

wire half_rate3;
sync_2xdff inst_sync_2xdff_half_rate(
  .dout(half_rate3),
  .clk(HSSCLK32B),
  .rst_n(1'b1),
  .din(hss_curr_rate[0])
);
wire  [4:0]  w_div ;

assign w_div = (half_rate3) ?  5'b00011 : 5'b00001  ;



  wire w_present ;
   sync_2xdff sync_pr(      
                           
.dout(w_present),              
.clk(clk_ref),             
.rst_n(1'b1),              
.din(EEPROM_PRESENT) 
); 
  
//----------------------------------------------------------------------------------------  
    reg         reg0_s, reg1_s ,reg2_s , reg6_s ;
    reg         reg3_s, reg4_s ,reg5_s , reg7_s ;
    wire        w1_s , w2_s ;  
  
  
    always @(posedge clk_ref)
    if (~rst_ref_n) 
    begin
        reg0_s<=1 ;
        reg1_s<=1 ;
        reg2_s<=1 ;
    end
    else begin
         reg0_s<= hss_load_done ;
        reg1_s<=reg0_s ;
        reg2_s<=reg1_s ;
    end
   assign w1_s=~reg2_s&reg1_s ;
   
   always @(posedge clk_ref)
    if (~rst_ref_n) 
    begin
        reg3_s<=0 ;
        reg4_s<=0 ;
        reg5_s<=0;
        reg6_s<=0 ;
        reg7_s<=0 ;
      
    end
    else begin
        reg3_s<= change_hss_rst ;
        reg4_s<=reg3_s ;
        reg5_s<=reg4_s ;
        reg6_s<=reg5_s ;
        reg7_s<=reg6_s ;
       
    end
   assign w2_s=~reg4_s&reg3_s ;
   
    always @(posedge clk_ref) 
    if (~rst_ref_n) begin
         HSSDIVSELA  <=  9'b001001100 ; //ratio=30 for 30x500M=15G    page 37
         HSSDIVSELB  <=  9'b000111010 ; //ratio=50 for 50x500M=25G    page 37
         REFCLKVALIDA  <=   1'b0  ;
         REFCLKVALIDB  <=   1'b1  ;
         PDWNPLLA  <=       1'b1  ;
         PDWNPLLB  <=       1'b0   ;
         VCOSELA  <=        1'b0  ;
         VCOSELB  <=        1'b1  ;
         PLLDIV2A   <=      1'b0  ;
         PLLDIV2B   <=      1'b0  ;
         REFDIVA  <=        4'b1100 ; //refclk=500M
         REFDIVB  <=        4'b1100 ; //refclk=500M       
         PLLCONFIGA   <=    8'b0001_1010 ;  //value=0x1a provided by ibm 
         PLLCONFIGB   <=    8'b0001_1010 ;  //value=0x1a provided by ibm
         ph0  <=            5'b0 ;
         ph1   <=           5'b0 ;
         ph2   <=           5'b0 ;
         ph3   <=           5'b0 ;
         TXOE  <=           4'b1111 ;
        
    end
    else begin
      
       if (w_present&w1_s) begin
           HSSDIVSELA    <=           config_hss_HSSDIVSELA;   
           HSSDIVSELB    <=           config_hss_HSSDIVSELB;   
           REFCLKVALIDA    <=         config_hss_REFCLKVALIDA; 
           REFCLKVALIDB    <=         config_hss_REFCLKVALIDB; 
           PDWNPLLA    <=             config_hss_PDWNPLLA;     
           PDWNPLLB    <=             config_hss_PDWNPLLB;     
           VCOSELA    <=              config_hss_VCOSELA;      
           VCOSELB    <=              config_hss_VCOSELB;      
           PLLDIV2A     <=            config_hss_PLLDIV2A ;    
           PLLDIV2B     <=            config_hss_PLLDIV2B ;    
           REFDIVA    <=              config_hss_REFDIVA;      
           REFDIVB    <=              config_hss_REFDIVB;      
           PLLCONFIGA     <=          config_hss_PLLCONFIGA ;  
           PLLCONFIGB     <=          config_hss_PLLCONFIGB ;  
           ph0    <=                  config_hss_ph0;          
           ph1     <=                 config_hss_ph1 ;         
           ph2     <=                 config_hss_ph2 ;         
           ph3     <=                 config_hss_ph3 ;         
           TXOE    <=                 config_hss_TXOE ;
      
      
      
        end
         else if (w2_s) begin
            HSSDIVSELB<= change_HSSDIVSELB;
               VCOSELB<= change_VCOSELB ;
               PLLDIV2B<=change_PLLDIV2B ;
                     end
        
       end



//TODO by xcw: generating clksel_half with the following semantics
//selecting 28G or 14G
//0 -> full rate
//1 -> half rate
assign clksel_half=half_rate3;



    // synopsys translate_off
defparam inst_hss.BYPASS_CAL = 1;
defparam inst_hss.BYPASS_PWR = 1;


    // synopsys translate_on
//WRAP2 dont expose jtag interface, which will be connected in FEP
WRAP2_T09_HS28GBLPF04 inst_hss(
	//input
		//28G  not using PLLA
     .HSSVCOSELA(VCOSELA),
     .HSSPLLDIV2A(PLLDIV2A),
     .HSSREFCLKVALIDA(REFCLKVALIDA),
     .HSSREFCLKAN(IF_PLL_OUTAC),
     .HSSREFCLKAP(IF_PLL_OUTAT),
	 .HSSDIVSELA(HSSDIVSELA), 
     .HSSPDWNPLLA(PDWNPLLA),
     .HSSPLLBYPA(1'b0),
     .HSSPLLCONFIGA(PLLCONFIGA),
     .HSSRECCALA(1'b0),
     .HSSREFDIVA(REFDIVA), 
     .HSSRESYNCA(1'b0),
		//28G using PLLB according to
		// Table1-1.Data Rates and Receiver Modes Supported by the HS28GB Cores 
     .HSSVCOSELB(VCOSELB),
     .HSSPLLDIV2B(PLLDIV2B),//may be used to run half rate
     .HSSREFCLKVALIDB(REFCLKVALIDB),
     .HSSREFCLKBN(IF_PLL_OUTAC),
     .HSSREFCLKBP(IF_PLL_OUTAT), 
		 .HSSDIVSELB(HSSDIVSELB),
     .HSSPDWNPLLB(PDWNPLLB),
     .HSSPLLBYPB(1'b0),
     .HSSPLLCONFIGB(PLLCONFIGB),
     .HSSRECCALB(1'b0),
     .HSSREFDIVB(REFDIVB), //based on ref clk freq
     .HSSRESYNCB(1'b0),

     .HSSRXACMODE(1'b1),
     .HSSRESET(hss_reset|reg7_s|rst_soft_hss),

		//reg accessing ports
     .HSSPRTADDR(HSSPRTADDR),
     .HSSPRTAEN(HSSPRTAEN),
     .HSSPRTDATAIN(HSSPRTDATAIN),
     .HSSPRTWRITE(HSSPRTWRITE),

		//calibration related pin not connected yet
     .HSSCALCOMP(HSSCALCOMP),
     .HSSCALENAB(HSSCALENAB),
     .HSSCALSSTN(HSSCALSSTN),
     .HSSCALSSTP(HSSCALSSTP),

     .TXAAECMD(TXAAECMD[7:0]),
     .TXAAECMD10(TXAAECMD[10]),
     .TXAAECMD11(TXAAECMD[11]),
     .TXAAECMD12(TXAAECMD[12]),
     .TXAAECMD13(TXAAECMD[13]),
     .TXAAECMDVAL(TXAAECMDVAL),
     .TXACONFIGSEL(2'b00),
     .TXAD({8'b0,hss_txdata0}),
     .TXADCLK(txdclk),
     .TXAOBS(1'b0),
     .TXAOE(TXOE[0]),
     .TXAQUIET(1'b0),
     .TXAREFRESH(1'b0),

     .TXBAECMD(TXBAECMD[7:0]),
     .TXBAECMD10(TXBAECMD[10]),
     .TXBAECMD11(TXBAECMD[11]),
     .TXBAECMD12(TXBAECMD[12]),
     .TXBAECMD13(TXBAECMD[13]),
     .TXBAECMDVAL(TXBAECMDVAL),
     .TXBCONFIGSEL(2'b00),
     .TXBD({8'b0,hss_txdata1}),
     .TXBDCLK(txdclk),
     .TXBOBS(1'b0),
     .TXBOE(TXOE[1]),
     .TXBQUIET(1'b0),
     .TXBREFRESH(1'b0),

     .TXCAECMD(TXCAECMD[7:0]),
     .TXCAECMD10(TXCAECMD[10]),
     .TXCAECMD11(TXCAECMD[11]),
     .TXCAECMD12(TXCAECMD[12]),
     .TXCAECMD13(TXCAECMD[13]),
     .TXCAECMDVAL(TXCAECMDVAL),
     .TXCCONFIGSEL(2'b00),
     .TXCD({8'b0,hss_txdata2}),
     .TXCDCLK(txdclk),
     .TXCOBS(1'b0),
     .TXCOE(TXOE[2]),
     .TXCQUIET(1'b0),
     .TXCREFRESH(1'b0),

     .TXDAECMD(TXDAECMD[7:0]),
     .TXDAECMD10(TXDAECMD[10]),
     .TXDAECMD11(TXDAECMD[11]),
     .TXDAECMD12(TXDAECMD[12]),
     .TXDAECMD13(TXDAECMD[13]),
     .TXDAECMDVAL(TXDAECMDVAL),
     .TXDCONFIGSEL(2'b00),
     .TXDD({8'b0,hss_txdata3}),
     .TXDDCLK(txdclk),
     .TXDOBS(1'b0),
     .TXDOE(TXOE[3]),
     .TXDQUIET(1'b0),
     .TXDREFRESH(1'b0),

     .RXAASSTCLK(hssRxAsstClk),
     .RXABLOCKDPC(RXXBLOCKDPC[0]),
     .RXACONFIGSEL(2'b00),
     .RXADATASYNC(1'b0),
     .RXAEARLYIN(ph0[0]),
     .RXAIN(HSS_RXN[0]),
     .RXAIP(HSS_RXP[0]),
     .RXALATEIN(ph0[1]),
     .RXAPHSDNIN(ph0[2]),
     .RXAPHSLOCK(ph0[3]),
     .RXAPHSUPIN(ph0[4]),
     .RXAPKTSTART(RXXPKTSTART[0]),
     .RXAPRBSRST(1'b0),
     .RXAQUIET(1'b0),
     .RXAREFRESH(1'b0),

     .RXBASSTCLK(hssRxAsstClk),
     .RXBBLOCKDPC(RXXBLOCKDPC[1]),
     .RXBCONFIGSEL(2'b00),
     .RXBDATASYNC(1'b0),
     .RXBEARLYIN(ph1[0]),
     .RXBIN(HSS_RXN[1]),
     .RXBIP(HSS_RXP[1]),
     .RXBLATEIN(ph1[1]),
     .RXBPHSDNIN(ph1[2]),
     .RXBPHSLOCK(ph1[3]),
     .RXBPHSUPIN(ph1[4]),
     .RXBPKTSTART(RXXPKTSTART[1]),
     .RXBPRBSRST(1'b0),
     .RXBQUIET(1'b0),
     .RXBREFRESH(1'b0),

     .RXCASSTCLK(hssRxAsstClk),
     .RXCBLOCKDPC(RXXBLOCKDPC[2]),
     .RXCCONFIGSEL(2'b00),
     .RXCDATASYNC(1'b0),
     .RXCEARLYIN(ph2[0]),
     .RXCIN(HSS_RXN[2]),
     .RXCIP(HSS_RXP[2]),
     .RXCLATEIN(ph2[1]),
     .RXCPHSDNIN(ph2[2]),
     .RXCPHSLOCK(ph2[3]),
     .RXCPHSUPIN(ph2[4]),
     .RXCPKTSTART(RXXPKTSTART[2]),
     .RXCPRBSRST(1'b0),
     .RXCQUIET(1'b0),
     .RXCREFRESH(1'b0),

     .RXDASSTCLK(hssRxAsstClk),
     .RXDBLOCKDPC(RXXBLOCKDPC[3]),
     .RXDCONFIGSEL(2'b00),
     .RXDDATASYNC(1'b0),
     .RXDEARLYIN(ph3[0]),
     .RXDIN(HSS_RXN[3]),
     .RXDIP(HSS_RXP[3]),
     .RXDLATEIN(ph3[1]),
     .RXDPHSDNIN(ph3[2]),
     .RXDPHSLOCK(ph3[3]),
     .RXDPHSUPIN(ph3[4]),
     .RXDPKTSTART(RXXPKTSTART[3]),
     .RXDPRBSRST(1'b0),
     .RXDQUIET(1'b0),
     .RXDREFRESH(1'b0),

     .RCM_JTGCLOCKDR_JTAG_SYSCLK(1'b0),
     .RCM_DCLK_TXLINK_SYSCLK(1'b0),
     .RCM_REFCLK_TXLINK_SYSCLK(1'b0),
     .RCM_REFCLK_RXLINK_SYSCLK(1'b0),
     .RCM_REFCLK_RCLKSEL_SYSCLK(1'b0),
     .RCM_REFCLK_PLLCNTL_SYSCLK(1'b0),
     .RCM_REFCLK_PLLCCAL_SYSCLK(1'b0),
     .RCM_FBCLK_PLLCCAL_SYSCLK(1'b0),
     .RCM_CLK64_RXLINK_SYSCLK(1'b0),
     .RCM_CLK64D_TXLINK_SYSCLK(1'b0),
     .RCM_CLK64D_RCLKSEL_SYSCLK(1'b0),
     .RCM_CLK16_TXLINK_SYSCLK(1'b0),
     .RCM_CLK16_RXCDR_SYSCLK(1'b0),
     .RCM_JTGCLOCKDR_JTAG_USER(5'b0),
     .RCM_DCLK_TXLINK_USER(5'b0),
     .RCM_REFCLK_TXLINK_USER(5'b0),
     .RCM_REFCLK_RXLINK_USER(5'b0),
     .RCM_REFCLK_RCLKSEL_USER(5'b0),
     .RCM_REFCLK_PLLCNTL_USER(5'b0),
     .RCM_REFCLK_PLLCCAL_USER(5'b0),
     .RCM_FBCLK_PLLCCAL_USER(5'b0),
     .RCM_CLK64_RXLINK_USER(5'b0),
     .RCM_CLK64D_TXLINK_USER(5'b0),
     .RCM_CLK64D_RCLKSEL_USER(5'b0),
     .RCM_CLK16_TXLINK_USER(5'b0),
     .RCM_CLK16_RXCDR_USER(5'b0),
     .RCM_JTGCLOCKDR_JTAG_USER_CE0_LOAD(1'b0),
     .RCM_DCLK_TXLINK_USER_CE0_LOAD(1'b0),
     .RCM_REFCLK_TXLINK_USER_CE0_LOAD(1'b0),
     .RCM_REFCLK_RXLINK_USER_CE0_LOAD(1'b0),
     .RCM_REFCLK_RCLKSEL_USER_CE0_LOAD(1'b0),
     .RCM_REFCLK_PLLCNTL_USER_CE0_LOAD(1'b0),
     .RCM_REFCLK_PLLCCAL_USER_CE0_LOAD(1'b0),
     .RCM_FBCLK_PLLCCAL_USER_CE0_LOAD(1'b0),
     .RCM_CLK64_RXLINK_USER_CE0_LOAD(1'b0),
     .RCM_CLK64D_TXLINK_USER_CE0_LOAD(1'b0),
     .RCM_CLK64D_RCLKSEL_USER_CE0_LOAD(1'b0),
     .RCM_CLK16_TXLINK_USER_CE0_LOAD(1'b0),
     .RCM_CLK16_RXCDR_USER_CE0_LOAD(1'b0),

		 //output
     .HSSPLLLOCKA(),
     .HSSPLLLOCKB(HSSPLLLOCKB),
     .HSSPRTREADYA(),
     .HSSPRTREADYB(HSSPRTREADYB),

		//only use PLLB and 32 bit interface
     .HSSCLK32A(),
     .HSSCLK32B(HSSCLK32B),
     .HSSCLK40A(),
     .HSSCLK40B(),

	 .HSSCALCOMPOUT(HSSCALCOMPOUT),
     .HSSCALSSTOUTN(HSSCALSSTOUTN),
     .HSSCALSSTOUTP(HSSCALSSTOUTP),
		
     .HSSEYEQUALITY(),
     .HSSPRTDATAOUT(HSSPRTDATAOUT),

     .RXAD({x0,hss_rxdata0}),
     .RXADCLK(hss_rxdclk0),
     .RXAERROFLOW(),
     .RXAPKTCLK(RXXPKTCLK_pre[0]),
     .RXAPKTDATA(RXXPKTDATA[0]),
     .RXAPKTFRAME(RXXPKTFRAME[0]),
     .RXAPRBSERR(),
     .RXAPRBSSYNC(),
     .RXASIGDET(RXXSIGDET[0]),

     .RXBD({x1,hss_rxdata1}),
     .RXBDCLK(hss_rxdclk1),
     .RXBERROFLOW(),
     .RXBPKTCLK(RXXPKTCLK_pre[1]),
     .RXBPKTDATA(RXXPKTDATA[1]),
     .RXBPKTFRAME(RXXPKTFRAME[1]),
     .RXBPRBSERR(),
     .RXBPRBSSYNC(),
     .RXBSIGDET(RXXSIGDET[1]),

     .RXCD({x2,hss_rxdata2}),
     .RXCDCLK(hss_rxdclk2),
     .RXCERROFLOW(),
     .RXCPKTCLK(RXXPKTCLK_pre[2]),
     .RXCPKTDATA(RXXPKTDATA[2]),
     .RXCPKTFRAME(RXXPKTFRAME[2]),
     .RXCPRBSERR(),
     .RXCPRBSSYNC(),
     .RXCSIGDET(RXXSIGDET[2]),

     .RXDD({x3,hss_rxdata3}),
     .RXDDCLK(hss_rxdclk3),
     .RXDERROFLOW(),
     .RXDPKTCLK(RXXPKTCLK_pre[3]),
     .RXDPKTDATA(RXXPKTDATA[3]),
     .RXDPKTFRAME(RXXPKTFRAME[3]),
     .RXDPRBSERR(),
     .RXDPRBSSYNC(),
     .RXDSIGDET(RXXSIGDET[3]),

     .TXAAESTAT(TXAAESTAT),
     .TXBAESTAT(TXBAESTAT),
     .TXCAESTAT(TXCAESTAT),
     .TXDAESTAT(TXDAESTAT),
     .TXAON(HSS_TXN[0]),
     .TXAOP(HSS_TXP[0]),
     .TXBON(HSS_TXN[1]),
     .TXBOP(HSS_TXP[1]),
     .TXCON(HSS_TXN[2]),
     .TXCOP(HSS_TXP[2]),
     .TXDON(HSS_TXN[3]),
     .TXDOP(HSS_TXP[3])

		 );


endmodule

