`timescale 1ns/1fs
module ssycdr (in_data,fullclk);
input in_data;
output fullclk;

reg clk;
initial begin
	clk=1'b0;
	forever begin
		#(0.001) clk=!clk;
	end
end

reg rst;
initial begin
	rst=1'b0;
	#100 rst=1'b1;
	#100 rst=1'b0;
end

reg [15:0] cnt;
reg last_data;


reg [15:0] cntsaved[49:0];
integer j;
always @(posedge clk) begin
	if(rst) begin
		for(j=0;j<=49;j=j+1) begin
			cntsaved[j]<=1000;
		end
		cnt<=0;
		last_data<=1'b0;
	end
	else if(in_data!=last_data) begin
		cntsaved[0]<=cnt;
		for(j=1;j<=49;j=j+1) begin
			cntsaved[j]<=cntsaved[j-1];
		end
		cnt<=0;
		last_data=in_data;
	end 
	else begin
		cnt<=cnt+1;
	end
end
reg [15:0] mincnt[50:0];
integer i;
always @(clk) begin
	mincnt[0]=10000;
	for(i=0;i<=49;i=i+1) begin
		if(mincnt[i]>cntsaved[i]) mincnt[i+1]=cntsaved[i];
		else mincnt[i+1]=mincnt[i];
	end
end

wire [15:0] period=mincnt[50];
wire [15:0] position={1'b0,period[15:1]};

reg [15:0] clkcnt;
reg [15:0] period_saved;
reg fullclk;
always @(posedge clk) begin
	if(rst) begin
		clkcnt<=0;
		period_saved<=0;
		fullclk<=1'b0;
	end
	else if(period!=period_saved) begin
		clkcnt<=0;
		period_saved<=period;
		fullclk<=1'b0;
	end
	else if(clkcnt==period)begin
		clkcnt<=0;
	end
	else begin
		clkcnt<=clkcnt+1;
		if(clkcnt==0) begin
			fullclk<=1'b1;
		end
		else if(clkcnt==position) begin
			fullclk<=1'b0;
		end
	end
end

endmodule
