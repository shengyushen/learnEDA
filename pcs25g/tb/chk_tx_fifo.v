module chk_tx_fifo(
	clk,
	reset_n,
	en_rd,
	data_rd,
	pop,
	correct
);
parameter IDLE    = 12'h555;
parameter	SYNC			=12'hAAA;
parameter LANEOK_HEAD=4'hB;

input	clk;
input	reset_n;
input [1:0]	en_rd;
input [23:0]	data_rd;
input pop;
output correct;
reg correct;

reg [11:0] data4;

always @(posedge clk) begin
	if(!reset_n) begin
		data4<=0;
	end
	else if(pop) begin
		case(en_rd)
			2'b01: data4<=data_rd[11:0];
			2'b10: data4<=data_rd[23:12];
			2'b11: data4<=data_rd[23:12];
		endcase
	end
end

wire [11:0] newdata=data4+8;
wire [11:0] data_rd110=data_rd[11:0]+8;
always @(*) begin
	if(pop) begin
		case(en_rd)
			2'b00: correct=(data_rd[23:12]==IDLE || data_rd[23:12]==SYNC || data_rd[23:20]==LANEOK_HEAD) & (data_rd[11:0]==IDLE || data_rd[11:0]==SYNC || data_rd[11:8]==LANEOK_HEAD);
			2'b01: correct=(data_rd[23:12]==IDLE || data_rd[23:12]==SYNC || data_rd[23:20]==LANEOK_HEAD) & (newdata==data_rd[11:0]);
			2'b10: correct=(newdata==data_rd[23:12]) & (data_rd[11:0]==IDLE || data_rd[11:0]==SYNC || data_rd[11:8]==LANEOK_HEAD);
			2'b11: correct=(newdata==data_rd[11:0] && data_rd[23:12]==data_rd110);
		endcase
	end
	else correct=1'b1;
end

endmodule 
