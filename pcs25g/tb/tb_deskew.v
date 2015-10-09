module tb_deskew ();


reg clk_core;
reg reset_core;

initial begin
	clk_core = 1'b0;
	forever #0.625 clk_core = !clk_core;
end

initial begin
	reset_core = 1'b0;
	#100 reset_core = 1'b1;
	#200 reset_core = 1'b0;
end

wire [11:0] am_field;
wire [3:0] rx_data_am_valid;
wire [4*66-1:0]  rx_data_am;

integer		reg_random0;
integer		reg_random1;
integer		reg_random2;
integer		reg_random3;
always @(posedge clk_core) begin
	reg_random0<=$random%10240;//we generate the random number that 
	reg_random1<=$random%10240;//we generate the random number that 
	reg_random2<=$random%10240;//we generate the random number that 
	reg_random3<=$random%10240;//we generate the random number that 
end
wire err0=reg_random0==0 && rx_data_am_valid[0];
wire err1=reg_random1==0 && rx_data_am_valid[1];
wire err2=reg_random2==0 && rx_data_am_valid[2];
wire err3=reg_random3==0 && rx_data_am_valid[3];

reg [10:0] cnt0;
reg [10:0] cnt1;
reg [10:0] cnt2;
reg [10:0] cnt3;
always @(posedge clk_core) begin
	if(reset_core) begin
		cnt0 <=7;
		cnt1 <=0;
		cnt2 <=10;
		cnt3 <=5;
	end
	else begin
		cnt0 <= cnt0+1;
		cnt1 <= cnt1+1;
		cnt2 <= cnt2+1;
		cnt3 <= cnt3+1;
	end
end

assign rx_data_am_valid[0]=cnt0[0];
assign rx_data_am_valid[1]=cnt1[0];
assign rx_data_am_valid[2]=cnt2[0];
assign rx_data_am_valid[3]=cnt3[0];

assign rx_data_am={{6{cnt3}},{6{cnt2}},{6{cnt1}},{6{cnt0}}};
assign	am_field[11:9]=(cnt3==11'd1||err3)?3'd3:3'h7;
assign	am_field[ 8:6]=(cnt2==11'd1||err2)?3'd2:3'h7;
assign	am_field[ 5:3]=(cnt1==11'd1||err1)?3'd1:3'h7;
assign	am_field[ 2:0]=(cnt0==11'd1||err0)?3'd0:3'h7;

wire fec_align_status;
wire am_deskew;
wire deskewed_data_valid;
wire [263:0] deskewed_data;
CGFEC_RX_DESKEW inst_deskew
(
 .in_enable(1'b1),
 .in_dissync_enable(1'b1),
 .pma_rx_clk({clk_core,clk_core,clk_core,clk_core}),
 .reset_pma_rx({reset_core,reset_core,reset_core,reset_core}),
 .am_field(am_field),
 .am_is_ram(4'b0000),
 .amps_lock(4'b1111),
// all_locked(),
 .rx_data_am_valid(rx_data_am_valid),
 .rx_data_am(rx_data_am),
 .test_cw_set(1'b0),
 .cw_bad(1'b0),

 .clk_core(clk_core),
 .reset_core(reset_core),

 .fec_align_status(fec_align_status),
 .restart_lock(),
 .am_deskew(am_deskew),//deskewed_data is an AM
 .deskewed_data_valid(deskewed_data_valid),
 .deskewed_data(deskewed_data),
 .fec_pma_mapping(),
 .fec_lane_mapping()
);

wire [65:0] deskewed_data0=deskewed_data[0*66+:66];
wire [65:0] deskewed_data1=deskewed_data[1*66+:66];
wire [65:0] deskewed_data2=deskewed_data[2*66+:66];
wire [65:0] deskewed_data3=deskewed_data[3*66+:66];

wire [10:0] deskewed_data00=deskewed_data0[0*11+:11];
wire [10:0] deskewed_data01=deskewed_data0[1*11+:11];
wire [10:0] deskewed_data02=deskewed_data0[2*11+:11];
wire [10:0] deskewed_data03=deskewed_data0[3*11+:11];
wire [10:0] deskewed_data04=deskewed_data0[4*11+:11];
wire [10:0] deskewed_data05=deskewed_data0[5*11+:11];

reg [10:0] deskewed_data00_prev;
always @(posedge clk_core) begin
	if(deskewed_data_valid)
		deskewed_data00_prev <= deskewed_data00;
end

wire [10:0] xx=deskewed_data00_prev+2;
assign correct=!deskewed_data_valid|
		(
		deskewed_data0==deskewed_data1 && 
		deskewed_data0==deskewed_data2 && 
		deskewed_data0==deskewed_data3 &&
		deskewed_data01==deskewed_data00 &&
		deskewed_data02==deskewed_data00 &&
		deskewed_data03==deskewed_data00 &&
		deskewed_data04==deskewed_data00 &&
		deskewed_data05==deskewed_data00 &&
		deskewed_data00==xx
		);


endmodule
