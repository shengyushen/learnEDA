include(`../scr/forloop.m4')
module encoderFlatInput (
input [5139:0] inputData,
output [139:0] parity
);

forloop(`instcnt', `0', `24', `
wire init_top_inst_`'instcnt`';')

assign init_top_inst_0=1'b1;
assign init_top_inst_1=1'b0;
assign init_top_inst_2=1'b0;
assign init_top_inst_3=1'b0;
assign init_top_inst_4=1'b0;
assign init_top_inst_5=1'b0;
assign init_top_inst_6=1'b0;
assign init_top_inst_7=1'b0;
assign init_top_inst_8=1'b0;
assign init_top_inst_9=1'b0;
assign init_top_inst_10=1'b0;
assign init_top_inst_11=1'b0;
assign init_top_inst_12=1'b0;
assign init_top_inst_13=1'b0;
assign init_top_inst_14=1'b0;
assign init_top_inst_15=1'b0;
assign init_top_inst_16=1'b0;
assign init_top_inst_17=1'b0;
assign init_top_inst_18=1'b0;
assign init_top_inst_19=1'b0;
assign init_top_inst_20=1'b1;
assign init_top_inst_21=1'b0;
assign init_top_inst_22=1'b0;
assign init_top_inst_23=1'b0;
assign init_top_inst_24=1'b0;


forloop(`instcnt', `0', `24', `
wire maxdata_top_inst_`'instcnt`';')



assign maxdata_top_inst_0=1'b0;
assign maxdata_top_inst_1=1'b1;
assign maxdata_top_inst_2=1'b1;
assign maxdata_top_inst_3=1'b0;
assign maxdata_top_inst_4=1'b1;
assign maxdata_top_inst_5=1'b1;
assign maxdata_top_inst_6=1'b0;
assign maxdata_top_inst_7=1'b1;
assign maxdata_top_inst_8=1'b1;
assign maxdata_top_inst_9=1'b1;
assign maxdata_top_inst_10=1'b0;
assign maxdata_top_inst_11=1'b1;
assign maxdata_top_inst_12=1'b1;
assign maxdata_top_inst_13=1'b0;
assign maxdata_top_inst_14=1'b1;
assign maxdata_top_inst_15=1'b1;
assign maxdata_top_inst_16=1'b0;
assign maxdata_top_inst_17=1'b1;
assign maxdata_top_inst_18=1'b1;
assign maxdata_top_inst_19=1'b1;
assign maxdata_top_inst_20=1'b0;
assign maxdata_top_inst_21=1'b1;
assign maxdata_top_inst_22=1'b1;
assign maxdata_top_inst_23=1'b0;
assign maxdata_top_inst_24=1'b1;

forloop(`instcnt', `0', `24', `
wire [259:0] gb_data_out_top_inst_`'instcnt`';
wire [139:0] parity_inst_`'instcnt`';
')
assign	gb_data_out_top_inst_0[ 249 : 0 ] = inputData[ 249          :   0          ];
assign	gb_data_out_top_inst_1[ 259 : 0 ] = inputData[ 509          : 250          ];
assign	gb_data_out_top_inst_2[ 259 : 0 ] = inputData[ 769          : 510          ];
assign	gb_data_out_top_inst_3[ 249 : 0 ] = inputData[ 249+770      :   0+770      ];
assign	gb_data_out_top_inst_4[ 259 : 0 ] = inputData[ 509+770      : 250+770      ];
assign	gb_data_out_top_inst_5[ 259 : 0 ] = inputData[ 769+770      : 510+770      ];
assign	gb_data_out_top_inst_6[ 249 : 0 ] = inputData[ 249+770*2    :   0+770*2    ];
assign	gb_data_out_top_inst_7[ 259 : 0 ] = inputData[ 509+770*2    : 250+770*2    ];
assign	gb_data_out_top_inst_8[ 259 : 0 ] = inputData[ 769+770*2    : 510+770*2    ];
assign	gb_data_out_top_inst_9[ 259 : 0 ] = inputData[ 769+770*2+260: 510+770*2+260];

assign	gb_data_out_top_inst_10[ 249 : 0 ] = inputData[ 249          +2570:   0          +2570];
assign	gb_data_out_top_inst_11[ 259 : 0 ] = inputData[ 509          +2570: 250          +2570];
assign	gb_data_out_top_inst_12[ 259 : 0 ] = inputData[ 769          +2570: 510          +2570];
assign	gb_data_out_top_inst_13[ 249 : 0 ] = inputData[ 249+770      +2570:   0+770      +2570];
assign	gb_data_out_top_inst_14[ 259 : 0 ] = inputData[ 509+770      +2570: 250+770      +2570];
assign	gb_data_out_top_inst_15[ 259 : 0 ] = inputData[ 769+770      +2570: 510+770      +2570];
assign	gb_data_out_top_inst_16[ 249 : 0 ] = inputData[ 249+770*2    +2570:   0+770*2    +2570];
assign	gb_data_out_top_inst_17[ 259 : 0 ] = inputData[ 509+770*2    +2570: 250+770*2    +2570];
assign	gb_data_out_top_inst_18[ 259 : 0 ] = inputData[ 769+770*2    +2570: 510+770*2    +2570];
assign	gb_data_out_top_inst_19[ 259 : 0 ] = inputData[ 769+770*2+260+2570: 510+770*2+260+2570];



//the encoder
CGFEC_TX_ENCODER_wrap_noundriven inst_propconst (
forloop(`instcnt', `0', `24', `
	.gb_data_out_inst_`'instcnt`'(gb_data_out_top_inst_`'instcnt`'),
	.pma_tx_clk_div2_inst_`'instcnt`'(1_SSYSYMBOL_b0),
	.reset_inst_`'instcnt`'(1_SSYSYMBOL_b0),
	.init_inst_`'instcnt`'(init_top_inst_`'instcnt`'),
	.maxdata_inst_`'instcnt`'(maxdata_top_inst_`'instcnt`'),
	.gfdata_valid_inst_`'instcnt`'(1_SSYSYMBOL_b1),
	.parity_inst_`'instcnt`'(parity_inst_`'instcnt`'),
')
.xx()	
);


assign parity = parity_inst_20;
endmodule
