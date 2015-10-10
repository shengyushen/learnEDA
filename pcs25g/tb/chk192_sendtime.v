module chk192_sendtime (clk,reset_n,rcvtime,data,pop,error,correct) ;
input [191:0] data;
input pop;
input error;
input clk;
input reset_n;
input rcvtime;

output correct;


reg [11:0] data4;

always @(posedge clk) begin
	if(!reset_n) begin
		data4<=0;
	end
	else begin
		if(pop) data4<=data[191:180];
	end
end

reg poped;
integer delta_time;
integer delta_time_max;
integer new_delta_time;
integer time_send;

always @(posedge clk) begin
	if(!reset_n) begin
		poped<=1'b0;
		delta_time<=100;
		new_delta_time<=100;
		delta_time_max<=0;
	end
	else begin
		if(pop & correct & rcvtime) begin
			poped<=1'b1;
			time_send=data[31:0];
			new_delta_time=$time-time_send; 
			if(new_delta_time<delta_time && new_delta_time>0) begin
				$display("smaller time %t at %t\n",new_delta_time,$time);
				delta_time=new_delta_time;
			end
			if(new_delta_time>delta_time_max && new_delta_time<50) begin
				$display("larger time %t %d at %t\n",new_delta_time,new_delta_time,$time);
				delta_time_max=new_delta_time;
			end
		end
	end
end


integer cnt;
integer deltatime_bandwidth;
//for the direction from fast to slow
//it is always with 8 lanes without skew and external latency
//so we send time on the fast and rcvtime on the slow
//we can test delay and bandwith on this direction
always @(posedge clk) begin
	if(!reset_n) begin
		deltatime_bandwidth<=$time;
		cnt<=0;
	end
	else if(pop & correct & rcvtime) begin
		if(cnt==1000) begin//start counting time
			deltatime_bandwidth<=$time;
			cnt<=cnt+1;
		end
		else if(cnt==2000) begin
			$display("bandwidth is %d GB\n",1000*191/($time-deltatime_bandwidth),$time);
			cnt<=0;
		end
		else begin
			cnt<=cnt+1;
		end
	end
end


wire [11:0] data4_0=data4+1;
wire [11:0] data4_1=data4+2;
wire [11:0] data4_2=data4+3;
wire [11:0] data4_3=data4+4;
wire [11:0] data4_4=data4+5;
wire [11:0] data4_5=data4+6;
wire [11:0] data4_6=data4+7;
wire [11:0] data4_7=data4+8;

wire [11:0] data4_8 =data4+9 ;
wire [11:0] data4_9 =data4+10;
wire [11:0] data4_10=data4+11;
wire [11:0] data4_11=data4+12;
wire [11:0] data4_12=data4+13;
wire [11:0] data4_13=data4+14;
wire [11:0] data4_14=data4+15;
wire [11:0] data4_15=data4+16;


assign correct=(pop==1'b0) || /*(error==1'b1) ||*/ (
data[95+96:84+96]==data4_15 &&
data[83+96:72+96]==data4_14 &&
data[71+96:60+96]==data4_13 &&
data[59+96:48+96]==data4_12 &&
data[47+96:36+96]==data4_11 &&
data[35+96:24+96]==data4_10 &&
data[23+96:12+96]==data4_9 &&
data[11+96: 0+96]==data4_8 &&
data[95:84]==data4_7 &&
data[83:72]==data4_6 &&
data[71:60]==data4_5 &&
data[59:48]==data4_4 &&
data[47:36]==data4_3  &&
(rcvtime?1'b1:(data[35:24]==data4_2 &&
data[23:12]==data4_1 &&
data[11: 0]==data4_0 )) &&
data4_0[3:0]==4'b0000
);


//psl inst_assert_0 : assert always (reset_n -> (correct|error)) @ (posedge clk) severity warning;

endmodule
