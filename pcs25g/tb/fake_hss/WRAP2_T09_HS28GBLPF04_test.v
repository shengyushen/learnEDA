

`timescale 1ns/10ps

module WRAP2_T09_HS28GBLPF04 (HSSCALCOMP, HSSCALENAB, HSSCALSSTN, HSSCALSSTP,
    HSSDIVSELA, HSSDIVSELB, HSSPDWNPLLA, HSSPDWNPLLB, HSSPLLBYPA, HSSPLLBYPB,
    HSSPLLCONFIGA, HSSPLLCONFIGB, HSSPLLDIV2A, HSSPLLDIV2B, HSSPRTADDR, HSSPRTAEN,
    HSSPRTDATAIN, HSSPRTWRITE, HSSRECCALA, HSSRECCALB, HSSREFCLKAN, HSSREFCLKAP,
    HSSREFCLKBN, HSSREFCLKBP, HSSREFCLKVALIDA, HSSREFCLKVALIDB, HSSREFDIVA,
    HSSREFDIVB, HSSRESET, HSSRESYNCA, HSSRESYNCB, HSSRXACMODE, HSSVCOSELA,
    HSSVCOSELB, RXAASSTCLK, RXABLOCKDPC, RXACONFIGSEL, RXADATASYNC, RXAEARLYIN,
    RXAIN, RXAIP, RXALATEIN, RXAPHSDNIN, RXAPHSLOCK, RXAPHSUPIN, RXAPKTSTART,
    RXAPRBSRST, RXAQUIET, RXAREFRESH, RXBASSTCLK, RXBBLOCKDPC, RXBCONFIGSEL,
    RXBDATASYNC, RXBEARLYIN, RXBIN, RXBIP, RXBLATEIN, RXBPHSDNIN, RXBPHSLOCK,
    RXBPHSUPIN, RXBPKTSTART, RXBPRBSRST, RXBQUIET, RXBREFRESH, RXCASSTCLK,
    RXCBLOCKDPC, RXCCONFIGSEL, RXCDATASYNC, RXCEARLYIN, RXCIN, RXCIP, RXCLATEIN,
    RXCPHSDNIN, RXCPHSLOCK, RXCPHSUPIN, RXCPKTSTART, RXCPRBSRST, RXCQUIET,
    RXCREFRESH, RXDASSTCLK, RXDBLOCKDPC, RXDCONFIGSEL, RXDDATASYNC, RXDEARLYIN,
    RXDIN, RXDIP, RXDLATEIN, RXDPHSDNIN, RXDPHSLOCK, RXDPHSUPIN, RXDPKTSTART,
    RXDPRBSRST, RXDQUIET, RXDREFRESH, TXAAECMD, TXAAECMD10, TXAAECMD11, TXAAECMD12,
    TXAAECMD13, TXAAECMDVAL, TXACONFIGSEL, TXAD, TXADCLK, TXAOBS, TXAOE,
    TXAQUIET, TXAREFRESH, TXBAECMD, TXBAECMD10, TXBAECMD11, TXBAECMD12, TXBAECMD13,
    TXBAECMDVAL, TXBCONFIGSEL, TXBD, TXBDCLK, TXBOBS, TXBOE, TXBQUIET, TXBREFRESH,
    TXCAECMD, TXCAECMD10, TXCAECMD11, TXCAECMD12, TXCAECMD13, TXCAECMDVAL,
    TXCCONFIGSEL, TXCD, TXCDCLK, TXCOBS, TXCOE, TXCQUIET, TXCREFRESH, TXDAECMD,
    TXDAECMD10, TXDAECMD11, TXDAECMD12, TXDAECMD13, TXDAECMDVAL, TXDCONFIGSEL,
    TXDD, TXDDCLK, TXDOBS, TXDOE, TXDQUIET, TXDREFRESH, RCM_JTGCLOCKDR_JTAG_SYSCLK,
    RCM_DCLK_TXLINK_SYSCLK, RCM_REFCLK_TXLINK_SYSCLK, RCM_REFCLK_RXLINK_SYSCLK,
    RCM_REFCLK_RCLKSEL_SYSCLK, RCM_REFCLK_PLLCNTL_SYSCLK, RCM_REFCLK_PLLCCAL_SYSCLK,
    RCM_FBCLK_PLLCCAL_SYSCLK, RCM_CLK64_RXLINK_SYSCLK, RCM_CLK64D_TXLINK_SYSCLK,
    RCM_CLK64D_RCLKSEL_SYSCLK, RCM_CLK16_TXLINK_SYSCLK, RCM_CLK16_RXCDR_SYSCLK,
    RCM_JTGCLOCKDR_JTAG_USER, RCM_DCLK_TXLINK_USER, RCM_REFCLK_TXLINK_USER,
    RCM_REFCLK_RXLINK_USER, RCM_REFCLK_RCLKSEL_USER, RCM_REFCLK_PLLCNTL_USER,
    RCM_REFCLK_PLLCCAL_USER, RCM_FBCLK_PLLCCAL_USER, RCM_CLK64_RXLINK_USER,
    RCM_CLK64D_TXLINK_USER, RCM_CLK64D_RCLKSEL_USER, RCM_CLK16_TXLINK_USER,
    RCM_CLK16_RXCDR_USER, RCM_JTGCLOCKDR_JTAG_USER_CE0_LOAD, RCM_DCLK_TXLINK_USER_CE0_LOAD,
    RCM_REFCLK_TXLINK_USER_CE0_LOAD, RCM_REFCLK_RXLINK_USER_CE0_LOAD, RCM_REFCLK_RCLKSEL_USER_CE0_LOAD,
    RCM_REFCLK_PLLCNTL_USER_CE0_LOAD, RCM_REFCLK_PLLCCAL_USER_CE0_LOAD, RCM_FBCLK_PLLCCAL_USER_CE0_LOAD,
    RCM_CLK64_RXLINK_USER_CE0_LOAD, RCM_CLK64D_TXLINK_USER_CE0_LOAD, RCM_CLK64D_RCLKSEL_USER_CE0_LOAD,
    RCM_CLK16_TXLINK_USER_CE0_LOAD, RCM_CLK16_RXCDR_USER_CE0_LOAD, HSSCALCOMPOUT,
    HSSCALSSTOUTN, HSSCALSSTOUTP, HSSCLK32A, HSSCLK32B, HSSCLK40A, HSSCLK40B,
    HSSEYEQUALITY, HSSPLLLOCKA, HSSPLLLOCKB, HSSPRTDATAOUT, HSSPRTREADYA,
    HSSPRTREADYB, RXAD, RXADCLK, RXAERROFLOW, RXAPKTCLK, RXAPKTDATA, RXAPKTFRAME,
    RXAPRBSERR, RXAPRBSSYNC, RXASIGDET, RXBD, RXBDCLK, RXBERROFLOW, RXBPKTCLK,
    RXBPKTDATA, RXBPKTFRAME, RXBPRBSERR, RXBPRBSSYNC, RXBSIGDET, RXCD, RXCDCLK,
    RXCERROFLOW, RXCPKTCLK, RXCPKTDATA, RXCPKTFRAME, RXCPRBSERR, RXCPRBSSYNC,
    RXCSIGDET, RXDD, RXDDCLK, RXDERROFLOW, RXDPKTCLK, RXDPKTDATA, RXDPKTFRAME,
    RXDPRBSERR, RXDPRBSSYNC, RXDSIGDET, TXAAESTAT, TXAON, TXAOP, TXBAESTAT,
    TXBON, TXBOP, TXCAESTAT, TXCON, TXCOP, TXDAESTAT, TXDON, TXDOP);


// synopsys dc_script_begin
// set_dont_touch current_design
// synopsys dc_script_end

// ambit synthesis off
// synopsys translate_off

   parameter BYPASS_CAL = 0;
   parameter BYPASS_PWR = 0;
   parameter MESSAGES = 1;


// synopsys translate_on
// ambit synthesis on

   input  HSSCALCOMP;
   input  HSSCALENAB;
   input [5:0] HSSCALSSTN;
   input [5:0] HSSCALSSTP;
   input [8:0] HSSDIVSELA;
   input [8:0] HSSDIVSELB;
   input  HSSPDWNPLLA;
   input  HSSPDWNPLLB;
   input  HSSPLLBYPA;
   input  HSSPLLBYPB;
   input [7:0] HSSPLLCONFIGA;
   input [7:0] HSSPLLCONFIGB;
   input  HSSPLLDIV2A;
   input  HSSPLLDIV2B;
   input [10:0] HSSPRTADDR;
   input  HSSPRTAEN;
   input [15:0] HSSPRTDATAIN;
   input  HSSPRTWRITE;
   input  HSSRECCALA;
   input  HSSRECCALB;
   input  HSSREFCLKAN;
   input  HSSREFCLKAP;
   input  HSSREFCLKBN;
   input  HSSREFCLKBP;
   input  HSSREFCLKVALIDA;
   input  HSSREFCLKVALIDB;
   input [3:0] HSSREFDIVA;
   input [3:0] HSSREFDIVB;
   input  HSSRESET;
   input  HSSRESYNCA;
   input  HSSRESYNCB;
   input  HSSRXACMODE;
   input  HSSVCOSELA;
   input  HSSVCOSELB;
   input  RXAASSTCLK;
   input  RXABLOCKDPC;
   input [1:0] RXACONFIGSEL;
   input  RXADATASYNC;
   input  RXAEARLYIN;
   input  RXAIN;
   input  RXAIP;
   input  RXALATEIN;
   input  RXAPHSDNIN;
   input  RXAPHSLOCK;
   input  RXAPHSUPIN;
   input  RXAPKTSTART;
   input  RXAPRBSRST;
   input  RXAQUIET;
   input  RXAREFRESH;
   input  RXBASSTCLK;
   input  RXBBLOCKDPC;
   input [1:0] RXBCONFIGSEL;
   input  RXBDATASYNC;
   input  RXBEARLYIN;
   input  RXBIN;
   input  RXBIP;
   input  RXBLATEIN;
   input  RXBPHSDNIN;
   input  RXBPHSLOCK;
   input  RXBPHSUPIN;
   input  RXBPKTSTART;
   input  RXBPRBSRST;
   input  RXBQUIET;
   input  RXBREFRESH;
   input  RXCASSTCLK;
   input  RXCBLOCKDPC;
   input [1:0] RXCCONFIGSEL;
   input  RXCDATASYNC;
   input  RXCEARLYIN;
   input  RXCIN;
   input  RXCIP;
   input  RXCLATEIN;
   input  RXCPHSDNIN;
   input  RXCPHSLOCK;
   input  RXCPHSUPIN;
   input  RXCPKTSTART;
   input  RXCPRBSRST;
   input  RXCQUIET;
   input  RXCREFRESH;
   input  RXDASSTCLK;
   input  RXDBLOCKDPC;
   input [1:0] RXDCONFIGSEL;
   input  RXDDATASYNC;
   input  RXDEARLYIN;
   input  RXDIN;
   input  RXDIP;
   input  RXDLATEIN;
   input  RXDPHSDNIN;
   input  RXDPHSLOCK;
   input  RXDPHSUPIN;
   input  RXDPKTSTART;
   input  RXDPRBSRST;
   input  RXDQUIET;
   input  RXDREFRESH;
   input [7:0] TXAAECMD;
   input  TXAAECMD10;
   input  TXAAECMD11;
   input  TXAAECMD12;
   input  TXAAECMD13;
   input  TXAAECMDVAL;
   input [1:0] TXACONFIGSEL;
   input [39:0] TXAD;
   input  TXADCLK;
   input  TXAOBS;
   input  TXAOE;
   input  TXAQUIET;
   input  TXAREFRESH;
   input [7:0] TXBAECMD;
   input  TXBAECMD10;
   input  TXBAECMD11;
   input  TXBAECMD12;
   input  TXBAECMD13;
   input  TXBAECMDVAL;
   input [1:0] TXBCONFIGSEL;
   input [39:0] TXBD;
   input  TXBDCLK;
   input  TXBOBS;
   input  TXBOE;
   input  TXBQUIET;
   input  TXBREFRESH;
   input [7:0] TXCAECMD;
   input  TXCAECMD10;
   input  TXCAECMD11;
   input  TXCAECMD12;
   input  TXCAECMD13;
   input  TXCAECMDVAL;
   input [1:0] TXCCONFIGSEL;
   input [39:0] TXCD;
   input  TXCDCLK;
   input  TXCOBS;
   input  TXCOE;
   input  TXCQUIET;
   input  TXCREFRESH;
   input [7:0] TXDAECMD;
   input  TXDAECMD10;
   input  TXDAECMD11;
   input  TXDAECMD12;
   input  TXDAECMD13;
   input  TXDAECMDVAL;
   input [1:0] TXDCONFIGSEL;
   input [39:0] TXDD;
   input  TXDDCLK;
   input  TXDOBS;
   input  TXDOE;
   input  TXDQUIET;
   input  TXDREFRESH;
   input  RCM_JTGCLOCKDR_JTAG_SYSCLK;
   input  RCM_DCLK_TXLINK_SYSCLK;
   input  RCM_REFCLK_TXLINK_SYSCLK;
   input  RCM_REFCLK_RXLINK_SYSCLK;
   input  RCM_REFCLK_RCLKSEL_SYSCLK;
   input  RCM_REFCLK_PLLCNTL_SYSCLK;
   input  RCM_REFCLK_PLLCCAL_SYSCLK;
   input  RCM_FBCLK_PLLCCAL_SYSCLK;
   input  RCM_CLK64_RXLINK_SYSCLK;
   input  RCM_CLK64D_TXLINK_SYSCLK;
   input  RCM_CLK64D_RCLKSEL_SYSCLK;
   input  RCM_CLK16_TXLINK_SYSCLK;
   input  RCM_CLK16_RXCDR_SYSCLK;
   input [4:0] RCM_JTGCLOCKDR_JTAG_USER;
   input [4:0] RCM_DCLK_TXLINK_USER;
   input [4:0] RCM_REFCLK_TXLINK_USER;
   input [4:0] RCM_REFCLK_RXLINK_USER;
   input [4:0] RCM_REFCLK_RCLKSEL_USER;
   input [4:0] RCM_REFCLK_PLLCNTL_USER;
   input [4:0] RCM_REFCLK_PLLCCAL_USER;
   input [4:0] RCM_FBCLK_PLLCCAL_USER;
   input [4:0] RCM_CLK64_RXLINK_USER;
   input [4:0] RCM_CLK64D_TXLINK_USER;
   input [4:0] RCM_CLK64D_RCLKSEL_USER;
   input [4:0] RCM_CLK16_TXLINK_USER;
   input [4:0] RCM_CLK16_RXCDR_USER;
   input  RCM_JTGCLOCKDR_JTAG_USER_CE0_LOAD;
   input  RCM_DCLK_TXLINK_USER_CE0_LOAD;
   input  RCM_REFCLK_TXLINK_USER_CE0_LOAD;
   input  RCM_REFCLK_RXLINK_USER_CE0_LOAD;
   input  RCM_REFCLK_RCLKSEL_USER_CE0_LOAD;
   input  RCM_REFCLK_PLLCNTL_USER_CE0_LOAD;
   input  RCM_REFCLK_PLLCCAL_USER_CE0_LOAD;
   input  RCM_FBCLK_PLLCCAL_USER_CE0_LOAD;
   input  RCM_CLK64_RXLINK_USER_CE0_LOAD;
   input  RCM_CLK64D_TXLINK_USER_CE0_LOAD;
   input  RCM_CLK64D_RCLKSEL_USER_CE0_LOAD;
   input  RCM_CLK16_TXLINK_USER_CE0_LOAD;
   input  RCM_CLK16_RXCDR_USER_CE0_LOAD;
   output  HSSCALCOMPOUT;
   output [5:0] HSSCALSSTOUTN;
   output [5:0] HSSCALSSTOUTP;
   output  HSSCLK32A;
   output  HSSCLK32B;
   output  HSSCLK40A;
   output  HSSCLK40B;
   output  HSSEYEQUALITY;
   output  HSSPLLLOCKA;
   output  HSSPLLLOCKB;
   output [15:0] HSSPRTDATAOUT;
   output  HSSPRTREADYA;
   output  HSSPRTREADYB;
   output [39:0] RXAD;
   output  RXADCLK;
   output  RXAERROFLOW;
   output  RXAPKTCLK;
   output  RXAPKTDATA;
   output  RXAPKTFRAME;
   output  RXAPRBSERR;
   output  RXAPRBSSYNC;
   output  RXASIGDET;
   output [39:0] RXBD;
   output  RXBDCLK;
   output  RXBERROFLOW;
   output  RXBPKTCLK;
   output  RXBPKTDATA;
   output  RXBPKTFRAME;
   output  RXBPRBSERR;
   output  RXBPRBSSYNC;
   output  RXBSIGDET;
   output [39:0] RXCD;
   output  RXCDCLK;
   output  RXCERROFLOW;
   output  RXCPKTCLK;
   output  RXCPKTDATA;
   output  RXCPKTFRAME;
   output  RXCPRBSERR;
   output  RXCPRBSSYNC;
   output  RXCSIGDET;
   output [39:0] RXDD;
   output  RXDDCLK;
   output  RXDERROFLOW;
   output  RXDPKTCLK;
   output  RXDPKTDATA;
   output  RXDPKTFRAME;
   output  RXDPRBSERR;
   output  RXDPRBSSYNC;
   output  RXDSIGDET;
   output [7:0] TXAAESTAT;
   output  TXAON;
   output  TXAOP;
   output [7:0] TXBAESTAT;
   output  TXBON;
   output  TXBOP;
   output [7:0] TXCAESTAT;
   output  TXCON;
   output  TXCOP;
   output [7:0] TXDAESTAT;
   output  TXDON;
   output  TXDOP;
   

   
gen_rdy_lock gen_rdy_lock_inst(
.HSSREFCLKAC(HSSREFCLKBN),
 .HSSRESET(HSSRESET),
 .HSSPLLLOCKA(HSSPLLLOCKA),
 .HSSPRTREADYA(HSSPRTREADYA),
 .HSSPLLLOCKB(HSSPLLLOCKB),
 .HSSPRTREADYB(HSSPRTREADYB));

/* HSSLane AUTO_TEMPLATE "\([A-Z]+\>\)"(
                         // Outputs
                         .TXDCLK                (TX@DCLK),
                         .RXD                   (RX@D[`DATAWIDTH_PCS-1:0]),
                         .RXDCLK                (RX@DCLK),
                         .PhyOutP               (TX@OP),
                         .PhyOutN               (TX@ON),
                         // Inputs
                         .Rst                   (HSSRESET),
                         .TXD                   (TX@D[`DATAWIDTH_PCS-1:0]),
                         .PhyInP                (RX@IP),
                         .PhyInN                (RX@IN));  */
                         

    HSSLane HSSLane_A( /*autoinst*/
                      // Outputs
                      .TXDCLK           (TXADCLK),               // Templated
                      .RXD              (RXAD[`DATAWIDTH_PCS-1:0]), // Templated
                      .RXDCLK           (RXADCLK),               // Templated
                      .PhyOutP          (TXAOP),                 // Templated
                      .PhyOutN          (TXAON),                 // Templated
                      // Inputs
                      .Rst              (HSSRESET),              // Templated
                      .TXD              (TXAD[`DATAWIDTH_PCS-1:0]), // Templated
                      .PhyInP           (RXAIP),                 // Templated
                      .PhyInN           (RXAIN));                // Templated

    HSSLane HSSLane_B(/*autoinst*/
                      // Outputs
                      .TXDCLK           (TXBDCLK),               // Templated
                      .RXD              (RXBD[`DATAWIDTH_PCS-1:0]), // Templated
                      .RXDCLK           (RXBDCLK),               // Templated
                      .PhyOutP          (TXBOP),                 // Templated
                      .PhyOutN          (TXBON),                 // Templated
                      // Inputs
                      .Rst              (HSSRESET),              // Templated
                      .TXD              (TXBD[`DATAWIDTH_PCS-1:0]), // Templated
                      .PhyInP           (RXBIP),                 // Templated
                      .PhyInN           (RXBIN));                // Templated

    
    HSSLane HSSLane_C(/*autoinst*/
                      // Outputs
                      .TXDCLK           (TXCDCLK),               // Templated
                      .RXD              (RXCD[`DATAWIDTH_PCS-1:0]), // Templated
                      .RXDCLK           (RXCDCLK),               // Templated
                      .PhyOutP          (TXCOP),                 // Templated
                      .PhyOutN          (TXCON),                 // Templated
                      // Inputs
                      .Rst              (HSSRESET),              // Templated
                      .TXD              (TXCD[`DATAWIDTH_PCS-1:0]), // Templated
                      .PhyInP           (RXCIP),                 // Templated
                      .PhyInN           (RXCIN));                // Templated
    HSSLane HSSLane_D(/*autoinst*/
                      // Outputs
                      .TXDCLK           (TXDDCLK),               // Templated
                      .RXD              (RXDD[`DATAWIDTH_PCS-1:0]), // Templated
                      .RXDCLK           (RXDDCLK),               // Templated
                      .PhyOutP          (TXDOP),                 // Templated
                      .PhyOutN          (TXDON),                 // Templated
                      // Inputs
                      .Rst              (HSSRESET),              // Templated
                      .TXD              (TXDD[`DATAWIDTH_PCS-1:0]), // Templated
                      .PhyInP           (RXDIP),                 // Templated
                      .PhyInN           (RXDIN));                // Templated
endmodule
