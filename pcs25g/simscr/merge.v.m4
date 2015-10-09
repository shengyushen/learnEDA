include(`../scr/forloop.m4')
module merge(
input [5139:0] inputData,
input [527:0] error,
input [5279:0] errorData

);

wire [139:0] parity;


encoderFlatInput inst_encoderFlatInput (
.inputData(inputData),
.parity(parity)
);

//collecting the encoded data
wire [5279:0] encodedData;


assign encodedData = {parity,inputData};


//insert errors
wire [5279:0] encodedData1;

forloop(`instcnt', `0', `527', `
gfmux_mod inst_gfmux`'instcnt`'(.Z(encodedData1[10*`'instcnt`' +:10]),.S(error[`'instcnt`']),.A(errorData [10*`'instcnt`' +:10]),.B(encodedData [10*`'instcnt`' +:10]));')





forloop(`instcnt', `0', `64', `
wire [279:0] decoderDataInput_inst_`'instcnt`';')

assign decoderDataInput_inst_1 [ 239:   0] = encodedData1 [ 240*1-1      :          0] ;
assign decoderDataInput_inst_2 [ 279:   0] = encodedData1 [ 240*1+280*1-1:240*1      ] ;
assign decoderDataInput_inst_3 [ 239:   0] = encodedData1 [ 240*2+280*1-1:240*1+280*1] ;
assign decoderDataInput_inst_4 [ 279:   0] = encodedData1 [ 240*2+280*2-1:240*2+280*1] ;
assign decoderDataInput_inst_5 [ 279:   0] = encodedData1 [ 240*2+280*3-1:240*2+280*2] ;
assign decoderDataInput_inst_6 [ 239:   0] = encodedData1 [ 240*1-1      +1320:          0+1320] ;
assign decoderDataInput_inst_7 [ 279:   0] = encodedData1 [ 240*1+280*1-1+1320:240*1      +1320] ;
//miss 8
assign decoderDataInput_inst_9 [ 239:   0] = encodedData1 [ 240*2+280*1-1+1320:240*1+280*1+1320] ;
assign decoderDataInput_inst_10[ 279:   0] = encodedData1 [ 240*2+280*2-1+1320:240*2+280*1+1320] ;
assign decoderDataInput_inst_11[ 279:   0] = encodedData1 [ 240*2+280*3-1+1320:240*2+280*2+1320] ;

assign decoderDataInput_inst_12[ 239:   0] = encodedData1 [ 240*1-1      +1320*2:          0+1320*2] ;
assign decoderDataInput_inst_13[ 279:   0] = encodedData1 [ 240*1+280*1-1+1320*2:240*1      +1320*2] ;
assign decoderDataInput_inst_14[ 239:   0] = encodedData1 [ 240*2+280*1-1+1320*2:240*1+280*1+1320*2] ;
assign decoderDataInput_inst_15[ 279:   0] = encodedData1 [ 240*2+280*2-1+1320*2:240*2+280*1+1320*2] ;
assign decoderDataInput_inst_16[ 279:   0] = encodedData1 [ 240*2+280*3-1+1320*2:240*2+280*2+1320*2] ;

assign decoderDataInput_inst_17[ 239:   0] = encodedData1 [ 240*1-1      +1320*3:          0+1320*3] ;
assign decoderDataInput_inst_18[ 279:   0] = encodedData1 [ 240*1+280*1-1+1320*3:240*1      +1320*3] ;
assign decoderDataInput_inst_19[ 239:   0] = encodedData1 [ 240*2+280*1-1+1320*3:240*1+280*1+1320*3] ;
assign decoderDataInput_inst_20[ 279:   0] = encodedData1 [ 240*2+280*2-1+1320*3:240*2+280*1+1320*3] ;
assign decoderDataInput_inst_21[ 279:   0] = encodedData1 [ 240*2+280*3-1+1320*3:240*2+280*2+1320*3] ;

forloop(`instcnt', `0', `64', `
wire [279:0] decodedData_inst_`'instcnt`';
wire decodedDataValid_inst_`'instcnt`';
wire decodedDataAM_inst_`'instcnt`';
wire decodedData280_inst_`'instcnt`';
wire fail_inst_`'instcnt`';
wire test_inst_`'instcnt`';
wire iscount14_inst_`'instcnt`';
wire isNotZ_inst_`'instcnt`';
wire kGE0_inst_`'instcnt`';
wire out_ribm_init_inst_`'instcnt`';
wire out_valid_inst_`'instcnt`';
wire [139:0] out_synd_inst_`'instcnt`';
wire out_chien_init_inst_`'instcnt`';
wire [149:0] out_delta_inst_`'instcnt`';
wire [2:0] out_degree_inst_`'instcnt`';
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
	.fail_inst_`'instcnt`'(fail_inst_`'instcnt`'),
	.test_inst_`'instcnt`'(test_inst_`'instcnt`'),
	.iscount14_inst_`'instcnt`'(iscount14_inst_`'instcnt`'),
	.isNotZ_inst_`'instcnt`'(isNotZ_inst_`'instcnt`'),
	.kGE0_inst_`'instcnt`'(kGE0_inst_`'instcnt`'),
	.out_ribm_init_inst_`'instcnt`'(out_ribm_init_inst_`'instcnt`'),
	.out_valid_inst_`'instcnt`'(out_valid_inst_`'instcnt`'),
	.out_synd_inst_`'instcnt`'(out_synd_inst_`'instcnt`'),
	.out_chien_init_inst_`'instcnt`'(out_chien_init_inst_`'instcnt`'),
	.out_delta_inst_`'instcnt`'(out_delta_inst_`'instcnt`'),
	.out_degree_inst_`'instcnt`'(out_degree_inst_`'instcnt`'),
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

wire correct3 = ( decodedData == encodedData);

endmodule

