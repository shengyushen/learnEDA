module tb();

include(`/usr/share/doc/m4/examples/forloop.m4')


forloop(`instcnt', `0', `24', `
//wire [259:0] gb_data_out_top_inst_`'instcnt`';
reg [259:0] gb_data_out_top_inst_`'instcnt`';
')

forloop(`instcnt', `0', `24', `
wire [139:0] parity_top_inst_`'instcnt`';')

forloop(`instcnt', `0', `24', `
wire pma_tx_clk_div2_top_inst_`'instcnt`';')

forloop(`instcnt', `0', `24', `
wire reset_top_inst_`'instcnt`';')

forloop(`instcnt', `0', `24', `
wire init_top_inst_`'instcnt`';')

forloop(`instcnt', `0', `24', `
wire maxdata_top_inst_`'instcnt`';')

forloop(`instcnt', `0', `24', `
wire gfdata_valid_top_inst_`'instcnt`';')




expandmod inst_expandmod (
forloop(`instcnt', `0', `24', ` forloop(`bitcnt', `0', `259', `
.\gb_data_out[`'bitcnt`']_port_inst_`'instcnt`' (gb_data_out_top_inst_`'instcnt`'[`'bitcnt`']), ') ')


forloop(`instcnt', `0', `24', ` forloop(`bitcnt', `0', `139', `
.\parity[`'bitcnt`']_port_inst_`'instcnt`' (parity_top_inst_`'instcnt`'[`'bitcnt`']), ') ')


forloop(`instcnt', `0', `24', `
.pma_tx_clk_div2_port_inst_`'instcnt`' (pma_tx_clk_div2_top_inst_`'instcnt`'),')

forloop(`instcnt', `0', `24', `
.reset_port_inst_`'instcnt`' (reset_top_inst_`'instcnt`'),')

forloop(`instcnt', `0', `24', `
.init_port_inst_`'instcnt`' (init_top_inst_`'instcnt`'),')

forloop(`instcnt', `0', `24', `
.maxdata_port_inst_`'instcnt`' (maxdata_top_inst_`'instcnt`'),')

forloop(`instcnt', `0', `23', `
.gfdata_valid_port_inst_`'instcnt`'(gfdata_valid_top_inst_`'instcnt`'),')
.gfdata_valid_port_inst_24(gfdata_valid_top_inst_24)


);


forloop(`instcnt', `0', `24', `
wire [139:0] parity_inst_propconst_`'instcnt`';')


CGFEC_TX_ENCODER_wrap_noundriven inst_propconst (
forloop(`instcnt', `0', `24', `
	.gb_data_out_inst_`'instcnt`'(gb_data_out_top_inst_`'instcnt`'),
	.parity_inst_`'instcnt`'(parity_inst_propconst_`'instcnt`'),
	.pma_tx_clk_div2_inst_`'instcnt`'(pma_tx_clk_div2_top_inst_`'instcnt`'),
	.reset_inst_`'instcnt`'(reset_top_inst_`'instcnt`'),
	.init_inst_`'instcnt`'(init_top_inst_`'instcnt`'),
	.maxdata_inst_`'instcnt`'(maxdata_top_inst_`'instcnt`'),
	.gfdata_valid_inst_`'instcnt`'(gfdata_valid_top_inst_`'instcnt`'),
')
.xx()	
);



wire correct2 = ( parity_top_inst_20 == parity_inst_propconst_20 ) ;




forloop(`instcnt', `0', `24', `
assign reset_top_inst_`'instcnt`'=0;')



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
assign gfdata_valid_top_inst_`'instcnt`'=1;')


/*
assign gb_data_out_top_inst_0  =260'b1111000010001010010111011110101010011010010011011110111001101000010011101011100000101110001101111000111010110011001000111010110000001100111011101011101001010000101100111011000001110101111000001110110101000010100011000101101110001111100011000111100111011000011;
assign gb_data_out_top_inst_1  =260'b1000100101111110000101000110111110111100011000001010001001010000011100000011110110101100110110010000000101101010111111001111110101111011111110010110010100000010110001100111010000011111001111000101110110001011111101000001111110111010000011100001000001001100001;
assign gb_data_out_top_inst_2  =260'b10011110001100101010010100100111010000100011000111000101011000100011100111011110111010110110110001111111111001011111100001111101110100011110101000111001101100010011100110011001101111110100001111001001001111110111000011111100001110011010010100001000110001010;
assign gb_data_out_top_inst_3  =260'b10000010101011111110100100100011000011010000110011110010111011110011101010110011010011010010111001011110010101100111110001001011111100101001011010100001001110011010101110111001111011111010010110011000101101011111100111100100111011011110101110110001110100001;
assign gb_data_out_top_inst_4  =260'b111001111011100101010111000101001000111000001111111100010100111010110011000101111000011000011010011010011101011011010101111010000100111011100100111101010000100101000001101111011011100010010100111100110011100011101001000100000100101011010111001010110101000001;
assign gb_data_out_top_inst_5  =260'b10001101101010000110001010000010000011011100011110001010010111010100101100111101111010001101000001111110101100000011010001000011000000001000001101110110001001101110101100101000111101100110000101101100101010110101010101001110001101111100110111101010010011001011;
assign gb_data_out_top_inst_6  =260'b11110001100100100101101000000111101001001110001100100101110110111000100111101100011011011111111011100110100000100001101100100001100000010110111000110101111101010010000000100001010110000010111110000000110001001010111110100100011011011010111010101001001100100100;
assign gb_data_out_top_inst_7  =260'b1100011010110111100111101011001111000000110010000010000101011010000110100100001000111111011010011111001010110010011110111100101101111111010111001101110100000111101001000011110010010100101101001011011101000000100110010001011111111001011010001001001011111000110;
assign gb_data_out_top_inst_8  =260'b10001000000100001110001011100111011111000010101010001000011100000001011011101110110111000000101111101101001010110001101000110010101101011110110010011111001111100101111000101001101011001111110010000110110000000101110110000010010011010111010011011011010001010101;
assign gb_data_out_top_inst_9  =260'b11011101111110110000010000010101010011000111101111100111100011110101100010100111011110010101001111010001110100001100100110001011110101110100001111111110100110000111011100101101101110111000011111001001101111011010011011010110101011010010001101010100000111111001;
assign gb_data_out_top_inst_10  =260'b11000101010001011111100101010100010011001000100111100101011111101001111000000111111000000000001000111010000010001110010000000000010100111100000111001011111110001010000110001011111001111000001100100110000110101011100001110101001010010000101011111100110000000001;
assign gb_data_out_top_inst_11 =260'b1100000010001100001011100010100001010011000101000000110000110001001100100001111110010110110110001000010100111011001110101000001100100101101010110101111111001001111111110100101001100001010001100100101000001010001000101101111100110011001010001100000101010010101;
assign gb_data_out_top_inst_12 =260'b10101111001011110110000011110100011100111110101000001101101110010111011100111101111001010001010111010011010000101100000111111011000111110000101001101011001101110011001010111011100101010011111001010011111111010010001011011010111001111001110110110000011011010000;
assign gb_data_out_top_inst_13 =260'b10101000101111110001101000011101101111001111000010111001111101011110110101010110101111010100001111001101000110001011001010001001111000110110110001010100101000010101111100100000101011110000110110001111110110000100100000100011111001101010110111100011011101010000;
assign gb_data_out_top_inst_14 =260'b11110000110010100101010001001111000110101111110000100011011101011011000011011000110110111000000110010000011110111010000111100100011100001110111101001011110100100000111111110011001001100111011011101101001111000011001110110111000100110110100100011000010010100010;
assign gb_data_out_top_inst_15 =260'b1011111011000010001101110001110100000110011101001110000100011101101000000011101101111100001000100110000010111111000100101010101010000011001100001010000101100011110010111110001100000110000100100111110100101110100110110111000010000100101001010110011000011010;
assign gb_data_out_top_inst_16 =260'b1000100101111101111000010001111011011000101010010100011110100000101010011101001100101110010101000101011011101101101110010110000111001000001000000111111110001011110001000010000010111010001000110110111110011001101111110010101110011001011001010111110010111011011;
assign gb_data_out_top_inst_17 =260'b11101001110101111010010110000110001111111011111111100011111100101000111110100111111011101100100101101001000100100101110011001011001001010011011100110011000110001001001011100100100111011110000110111001001110000111001011010101001101001011010101000010111100010010;
assign gb_data_out_top_inst_18 =260'b1010011001001000110111001100111101010001101101101101100011100010010111001000110010100010011010001001000011101101000111001111111101010011110000000010000110000000110100110000000101010000110011111001101111000000111101110100010111110010001110011000100111110100101;
assign gb_data_out_top_inst_19 =260'b1111000111100101100010110011110110110010110111100000101000101001000100000011111110100110010001010100110111111001010001011011011100110010010100011101000111001100010011001001000010010101000101010010010011111001110000010101111110101110100101100110100010010011011;
assign gb_data_out_top_inst_20 =260'b1100011010110010110010011101110000110111111010101110101010100001010010000111000000111001110101001000011000110110101011101001100101011011001101110010100111001101010101000101001001100010110100010001011110101010001111011011001011101101110101110110100010000010001;
assign gb_data_out_top_inst_21 =260'b101100001001001011111011010001100000110110110010110111100110001100111000001111011010110000000100101100101101011110010111010111111010000111001100010101011100001101110011011110000100110001111011000001101111101001110001000111101010100110001001010010011110001101;
assign gb_data_out_top_inst_22 =260'b11101100010011101101010011000100000100110111000111000110111110100101110001100011100100001000100011011001000110110111111101011000100011000001010001011100010111011000011110100100101101011011110101100001000110100001101001001001100000000101110011110101010001100010;
assign gb_data_out_top_inst_23 =260'b11001100101010001011001001000011000100011001111111000011110111010001010101011000011001011101101000100101001011111011001001011101011111110100100100011101011100010111100011111111001000001101110111110010111000100101101001011011001110001111111110111101101011110001;
*/

//use random data
integer i;
initial begin
	forever begin
	  #1
		for(i=0;i<=259;i=i+1) begin
forloop(`instcnt', `0', `23', `
			gb_data_out_top_inst_`'instcnt`'[i] = $random %2;
')
		end
	end
end
wire [5279:0] encodedData;

assign	encodedData[ 249          :   0          ] = gb_data_out_top_inst_0[ 249 : 0 ];
assign	encodedData[ 509          : 250          ] = gb_data_out_top_inst_1[ 259 : 0 ];
assign	encodedData[ 769          : 510          ] = gb_data_out_top_inst_2[ 259 : 0 ];
assign	encodedData[ 249+770      :   0+770      ] = gb_data_out_top_inst_3[ 249 : 0 ];
assign	encodedData[ 509+770      : 250+770      ] = gb_data_out_top_inst_4[ 259 : 0 ];
assign	encodedData[ 769+770      : 510+770      ] = gb_data_out_top_inst_5[ 259 : 0 ];
assign	encodedData[ 249+770*2    :   0+770*2    ] = gb_data_out_top_inst_6[ 249 : 0 ];
assign	encodedData[ 509+770*2    : 250+770*2    ] = gb_data_out_top_inst_7[ 259 : 0 ];
assign	encodedData[ 769+770*2    : 510+770*2    ] = gb_data_out_top_inst_8[ 259 : 0 ];
assign	encodedData[ 769+770*2+260: 510+770*2+260] = gb_data_out_top_inst_9[ 259 : 0 ];

assign	encodedData[ 249          +2570:   0          +2570] = gb_data_out_top_inst_10[ 249 : 0 ];
assign	encodedData[ 509          +2570: 250          +2570] = gb_data_out_top_inst_11[ 259 : 0 ];
assign	encodedData[ 769          +2570: 510          +2570] = gb_data_out_top_inst_12[ 259 : 0 ];
assign	encodedData[ 249+770      +2570:   0+770      +2570] = gb_data_out_top_inst_13[ 249 : 0 ];
assign	encodedData[ 509+770      +2570: 250+770      +2570] = gb_data_out_top_inst_14[ 259 : 0 ];
assign	encodedData[ 769+770      +2570: 510+770      +2570] = gb_data_out_top_inst_15[ 259 : 0 ];
assign	encodedData[ 249+770*2    +2570:   0+770*2    +2570] = gb_data_out_top_inst_16[ 249 : 0 ];
assign	encodedData[ 509+770*2    +2570: 250+770*2    +2570] = gb_data_out_top_inst_17[ 259 : 0 ];
assign	encodedData[ 769+770*2    +2570: 510+770*2    +2570] = gb_data_out_top_inst_18[ 259 : 0 ];
assign	encodedData[ 769+770*2+260+2570: 510+770*2+260+2570] = gb_data_out_top_inst_19[ 259 : 0 ];


assign encodedData [5279:5140]= parity_inst_propconst_20 ;



forloop(`instcnt', `0', `64', `
wire [279:0] decoderDataInput_inst_`'instcnt`';')

//assign decoderDataInput_inst_1 [ 239:   0] = encodedData [ 240*1-1      :          0] ;
assign decoderDataInput_inst_1 [ 239:   0] = {10'b0,encodedData [ 240*1-1-10      :          0]} ;
//assign decoderDataInput_inst_2 [ 279:   0] = encodedData [ 240*1+280*1-1:240*1      ] ;
assign decoderDataInput_inst_2 [ 279:   0] = {10'b0,encodedData [ 240*1+280*1-1-10:240*1      ]} ;
assign decoderDataInput_inst_3 [ 239:   0] = encodedData [ 240*2+280*1-1:240*1+280*1] ;
assign decoderDataInput_inst_4 [ 279:   0] = encodedData [ 240*2+280*2-1:240*2+280*1] ;
//assign decoderDataInput_inst_5 [ 279:   0] = encodedData [ 240*2+280*3-1:240*2+280*2] ;
assign decoderDataInput_inst_5 [ 279:   0] = {10'b0,encodedData [ 240*2+280*3-1-10:240*2+280*2]} ;

//assign decoderDataInput_inst_6 [ 239:   0] = encodedData [ 240*1-1      +1320:          0+1320] ;
assign decoderDataInput_inst_6 [ 239:   0] = {10'b0,encodedData [ 240*1-1      +1320-10:          0+1320]} ;
assign decoderDataInput_inst_7 [ 279:   0] = encodedData [ 240*1+280*1-1+1320:240*1      +1320] ;
//miss 8
assign decoderDataInput_inst_9 [ 239:   0] = encodedData [ 240*2+280*1-1+1320:240*1+280*1+1320] ;
assign decoderDataInput_inst_10[ 279:   0] = encodedData [ 240*2+280*2-1+1320:240*2+280*1+1320] ;
assign decoderDataInput_inst_11[ 279:   0] = encodedData [ 240*2+280*3-1+1320:240*2+280*2+1320] ;

assign decoderDataInput_inst_12[ 239:   0] = encodedData [ 240*1-1      +1320*2:          0+1320*2] ;
assign decoderDataInput_inst_13[ 279:   0] = encodedData [ 240*1+280*1-1+1320*2:240*1      +1320*2] ;
assign decoderDataInput_inst_14[ 239:   0] = encodedData [ 240*2+280*1-1+1320*2:240*1+280*1+1320*2] ;
assign decoderDataInput_inst_15[ 279:   0] = encodedData [ 240*2+280*2-1+1320*2:240*2+280*1+1320*2] ;
assign decoderDataInput_inst_16[ 279:   0] = encodedData [ 240*2+280*3-1+1320*2:240*2+280*2+1320*2] ;

assign decoderDataInput_inst_17[ 239:   0] = encodedData [ 240*1-1      +1320*3:          0+1320*3] ;
assign decoderDataInput_inst_18[ 279:   0] = encodedData [ 240*1+280*1-1+1320*3:240*1      +1320*3] ;
assign decoderDataInput_inst_19[ 239:   0] = encodedData [ 240*2+280*1-1+1320*3:240*1+280*1+1320*3] ;
assign decoderDataInput_inst_20[ 279:   0] = encodedData [ 240*2+280*2-1+1320*3:240*2+280*1+1320*3] ;
assign decoderDataInput_inst_21[ 279:   0] = encodedData [ 240*2+280*3-1+1320*3:240*2+280*2+1320*3] ;

forloop(`instcnt', `0', `64', `
wire [279:0] decodedData_inst_`'instcnt`';
wire decodedDataValid_inst_`'instcnt`';
wire decodedDataAM_inst_`'instcnt`';
wire decodedData280_inst_`'instcnt`';
')

CGFEC_RX_DECODER_wrap_noundriven inst_dec (
forloop(`instcnt', `0', `64', `
  .gb_data_out_inst_`'instcnt`'(decoderDataInput_inst_`'instcnt`'),
	.SYMBOL_ERR_COUNT_RESET_inst_`'instcnt`'(4_SSYSYMBOL_b0000),
	.FEC_PMA_MAPPING_inst_`'instcnt`'(8_SSYSYMBOL_b11100100),
	.CORR_CW_COUNT_RESET_inst_`'instcnt`'(1_SSYSYMBOL_b0),
	.UNCO_CW_COUNT_RESET_inst_`'instcnt`'(1_SSYSYMBOL_b0),
	.RESET_inst_`'instcnt`'(1_SSYSYMBOL_b0),
  .DEC_DATA_IN_IS_280B_inst_`'instcnt`'(1_SSYSYMBOL_b ifelse(instcnt,`1',0,instcnt,`3',0,instcnt,`6',0,instcnt,`9',0,instcnt,`12',0,instcnt,`14',0,instcnt,`17',0,instcnt,`19',0,instcnt,`22',0,instcnt,`24',0,instcnt,`27',0,instcnt,`29',0,instcnt,`32',0,instcnt,`34',0,instcnt,`37',0,instcnt,`39',0,instcnt,`43',0,instcnt,`45',0,instcnt,`48',0,instcnt,`50',0,instcnt,`53',0,instcnt,`55',0,instcnt,`58',0,instcnt,`60',0,instcnt,`63',0,1)),
	.DEC_DATA_IN_IS_AM_inst_`'instcnt`'(1_SSYSYMBOL_b0),
  .DEC_DATA_IN_VAL_inst_`'instcnt`'(1_SSYSYMBOL_b ifelse(instcnt,`8',0,instcnt,`41',0,1)),
  .DECODER_INIT_inst_`'instcnt`'(1_SSYSYMBOL_b ifelse(instcnt,`1',1,instcnt,`22',1,instcnt,`43',1,instcnt,`63',1,0)),
	.DEC_DATA_OUT_inst_`'instcnt`'(decodedData_inst_`'instcnt`'),
	.DEC_DATA_OUT_IS_280B_inst_`'instcnt`'(decodedData280_inst_`'instcnt`'),
	.DEC_DATA_OUT_IS_AM_inst_`'instcnt`'(decodedDataAM_inst_`'instcnt`'),
	.DEC_DATA_OUT_VAL_inst_`'instcnt`'(decodedDataValid_inst_`'instcnt`'),
	')
	.am_seen_l_reg_Q_inst_0(1'b1)
);


wire [5279:0] decodedData;

assign decodedData [239:0] = decodedData_inst_38[239:0];
assign decodedData [279+240:240] = decodedData_inst_39[279:0];
assign decodedData [239+280+240:280+240] = decodedData_inst_40 [239:0];
assign decodedData [279+280+240*2:280+240*2] = decodedData_inst_41 [279:0];
assign decodedData [279+280*2+240*2:280*2+240*2] = decodedData_inst_43 [279:0];
assign decodedData [239+280*3+240*2:280*3+240*2] = decodedData_inst_44 [239:0];
assign decodedData [279+280*3+240*3:280*3+240*3] = decodedData_inst_45 [279:0];
assign decodedData [239+280*4+240*3:280*4+240*3] = decodedData_inst_46 [239:0];
assign decodedData [279+280*4+240*4:280*4+240*4] = decodedData_inst_47 [279:0];
assign decodedData [279+280*5+240*4:280*5+240*4] = decodedData_inst_48 [279:0];
assign decodedData [239+280*6+240*4:280*6+240*4] = decodedData_inst_49 [239:0];
assign decodedData [279+280*6+240*5:280*6+240*5] = decodedData_inst_50 [279:0];
assign decodedData [239+280*7+240*5:280*7+240*5] = decodedData_inst_51 [239:0];
assign decodedData [279+280*7+240*6:280*7+240*6] = decodedData_inst_52 [279:0];
assign decodedData [279+280*8+240*6:280*8+240*6] = decodedData_inst_53 [279:0];
assign decodedData [239+280*9+240*6:280*9+240*6] = decodedData_inst_54 [239:0];
assign decodedData [279+280*9+240*7:280*9+240*7] = decodedData_inst_55 [279:0];
assign decodedData [239+280*10+240*7:280*10+240*7] = decodedData_inst_56 [239:0];
assign decodedData [279+280*10+240*8:280*10+240*8] = decodedData_inst_57 [279:0];
assign decodedData [279+280*11+240*8:280*11+240*8] = decodedData_inst_58 [279:0];

assign correct3 = ( decodedData == encodedData);

endmodule

