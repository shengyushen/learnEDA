`timescale 1ns/1fs
module lane_shower (in_data,out_isam,am_field,fecFrameStart,corruptAM);
input in_data;
output out_isam;
output [2:0] am_field;
output fecFrameStart;
output corruptAM;

wire fullclk;
ssycdr inst_ssycdr(
	.in_data(in_data),
	.fullclk(fullclk)
);

amdetector inst_amdetector(
	.fullclk(fullclk),
	.in_data(in_data),
	.out_isam(out_isam),
	.am_field(am_field),
	.fecFrameStart(fecFrameStart),
	.corruptAM(corruptAM)
);

endmodule
