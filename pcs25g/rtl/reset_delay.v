module reset_delay (clk,reset_async_n,reset_out_n);

input clk;
input reset_async_n;
output reset_out_n;
reg [11:0] reset_cnt;


always @(posedge clk) begin
	if(!reset_async_n) begin
		reset_cnt <=12'b0;
	end
	else begin
		if(reset_cnt>=1024) reset_cnt<=reset_cnt;
		else reset_cnt<=reset_cnt+1;
	end
end

assign reset_out_n=(reset_cnt>=1024);


endmodule
