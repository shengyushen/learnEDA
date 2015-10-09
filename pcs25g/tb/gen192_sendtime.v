module gen192_sendtime (clk,reset_n,sendtime,data,out_txen,ideal,) ;
output [191:0] data;
output  out_txen;
input ideal;
input clk,reset_n;
input sendtime;
wire pop;

assign	out_txen=pop;

reg [11:0] data4;
always @(posedge clk) begin
	if(!reset_n) data4<=0;
	else if(pop) data4<=data4+16;
	else data4<=data4;
end

wire [11:0] data4_0=data4;
wire [11:0] data4_1 =data4+1 ;
wire [11:0] data4_2 =data4+2 ;
wire [11:0] data4_3 =data4+3 ;
wire [11:0] data4_4 =data4+4 ;
wire [11:0] data4_5 =data4+5 ;
wire [11:0] data4_6 =data4+6 ;
wire [11:0] data4_7 =data4+7 ;
wire [11:0] data4_8 =data4+8 ;
wire [11:0] data4_9 =data4+9 ;
wire [11:0] data4_10=data4+10;
wire [11:0] data4_11=data4+11;
wire [11:0] data4_12=data4+12;
wire [11:0] data4_13=data4+13;
wire [11:0] data4_14=data4+14;
wire [11:0] data4_15=data4+15;

integer cnt;
always @(posedge clk) begin
	if(!reset_n) cnt<=0;
	else if(cnt>=40000) begin
		cnt<=0;
	end
	else if(pop) cnt<=cnt+1;
end

integer time_now;
always @(posedge clk) begin
	time_now<=$time;
end



integer		reg_random;
always @(posedge clk) begin
	reg_random<=$random%1024;//we generate the random number that 
end

//for the direction from fast to slow
//it is always with 8 lanes without skew and external latency
//so we send time on the fast and rcvtime on the slow
//we can test delay and bandwith on this direction
assign pop=sendtime?ideal:
	(cnt>200000)? ((reg_random>-102 && reg_random<102)?ideal:1'b0) :
	(reg_random>-1020 && reg_random<1020)?ideal : 
	1'b0;

wire [191:0] data_pre;
assign data_pre={
data4_15,
data4_14,
data4_13,
data4_12,
data4_11,
data4_10,
data4_9,
data4_8,
data4_7,
data4_6,
data4_5,
data4_4,
data4_3,
sendtime?{4'b0000,time_now}:{data4_2,data4_1,data4_0}
};

assign data=pop?data_pre:192'b0;

endmodule
