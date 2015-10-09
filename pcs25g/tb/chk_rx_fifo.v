module chk_rx_fifo(
	clk,
	reset_n,

	in_data,
	in_valid,
	in_sync,		
	
	correct		
);
parameter IDLE=12'h555;
parameter SYNC=12'hAAA;
parameter LANEOK_HEAD=4'hB;
input	clk;
input	reset_n;

input [47:0]	in_data;
input 	in_valid;
	
input	in_sync;
output	correct;
reg	correct;

reg [11:0] data4;
reg [11:0] data4_nxt;
always @(posedge clk) begin
	if(!reset_n) data4<=0;
	else data4<=data4_nxt;
end

wire [11:0] data4_16=data4+16;
wire [11:0] data4_17=data4+17;

always @(*) begin
	data4_nxt =data4;
	correct=1'b1;
	if(in_valid)  begin
		data4_nxt=in_data[11:0];
		correct=in_sync || (data4_16==in_data[11:0] && data4_17==in_data[23:12]);
	end
end


endmodule
