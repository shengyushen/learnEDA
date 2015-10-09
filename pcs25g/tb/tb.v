`timescale 1ns/1ps
module tb;
tb28g inst_tb28g_fec_corrected( 
	.USE_PCS25G(1'b0),
	.NO_DISSYNC(1'b0),
	.INFER_POLAR(1'b1),.GIVEN_POLAR(4'b0000),
	//fec config
	.MD_BYPASS_CORR_ENABLE(1'b0),.MD_BYPASS_IND_ENABLE(1'b0),
	//pcs25g config
	.INFER_BLOCKLOCK(1'b1),.GIVEN_BLOCKLOCK(4'b0000),
	//sim config
	//trying
	.LANESKEW(1'b1),.POLAR_INVERSION(1'b0),.MISCONN(1'b0),.ERRORTYPE(3'b011),
	.in_errorInjectionMode(2'b00));



endmodule

