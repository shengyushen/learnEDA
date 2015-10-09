`ifndef PCS8X_DEFINE_H
`define PCS8X_DEFINE_H

//per lane control character
`define ESC_CHAR  48'hAAAA_AAAA_AAAA
`define IDLE_CHAR 48'hBBBB_BBBB_BBBB
`define SYNC_CHAR 37'h1C_CCCC_CCCC

//per port control package
`define FLUSH_PACK 192'hf9f_f9e_f9d_f9c_f9b_f9a_f99_f98_f97_f96_f95_f94_f93_f92_f91_f90
`define ESC_PACK  192'hf8f_f8e_f8d_f8c_f8b_f8a_f89_f88_f87_f86_f85_f84_f83_f82_f81_f80

//defining the bit width
`define UNITWIDTH 48
`ifdef FOURTYG
`define UNITWIDTH_PMA 64
`else
`define UNITWIDTH_PMA 32
`endif
`define LANENUMBER 4
`endif
