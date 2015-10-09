module clock_div16(clk,reset_n,out_clkdiv16);
input clk,reset_n;
output out_clkdiv16;

reg [3:0] cnt16;

always @(posedge clk) begin
	if(!reset_n) cnt16<=4'b0;
	else cnt16<=cnt16+1;
end

assign	out_clkdiv16=cnt16[3];

endmodule
