module tx_fifo_stage_idle (
	in_enable,
	clock,
	reset_n,
	
	//fifo interface
	in_en,
	in_data,
	out_idle,

	//escaper interface
	out_en,
	out_data,
	in_idle
);
parameter WR_WIDTH=12;
input in_enable;
input	clock;
input	reset_n;
	
	//fifo interface
input	in_en;
input [WR_WIDTH-1:0]	in_data;
output	out_idle;

	//escaper interface
output	out_en;
output [WR_WIDTH-1:0]	out_data;
input	in_idle;

reg [2*WR_WIDTH-1:0]	out_data_reg;
reg [2*WR_WIDTH-1:0]	out_data_nxt;

reg [1:0] datanum;
reg [1:0] datanum_nxt;
always @(posedge clock)  begin
	if(!reset_n) begin
		out_data_reg <= 0;
		datanum <= 2'b00;
	end
	else if(in_enable) begin
		out_data_reg <= out_data_nxt;
		datanum <= datanum_nxt;
	end
end
assign	out_idle = datanum==2'b00||datanum==2'b01;
assign	out_en = (datanum==2'b01||datanum==2'b10)&&in_idle;
assign	out_data=out_data_reg[2*WR_WIDTH-1:WR_WIDTH];

always @(*) begin
	out_data_nxt = out_data_reg;
	datanum_nxt  = datanum;
	case(datanum)
	2'b00: begin
		if(in_en) begin
			out_data_nxt = {in_data,out_data_reg[WR_WIDTH-1:0]};
			datanum_nxt = 2'b01;
		end
	end
	2'b01:begin
		if(in_en) begin
			if(in_idle) begin
				out_data_nxt = {in_data,out_data_reg[WR_WIDTH-1:0]};
			end
			else begin
				out_data_nxt = {out_data_reg[2*WR_WIDTH-1:WR_WIDTH],in_data};
				datanum_nxt = 2'b10;
			end
		end
		else begin
			if(in_idle) begin
				datanum_nxt = 2'b00;
			end
		end
	end
	2'b10:begin
		if(in_idle) begin
			out_data_nxt = {out_data_reg[WR_WIDTH-1:0],out_data_reg[WR_WIDTH-1:0]};
			datanum_nxt = 2'b01;
		end
	end
	endcase
end
endmodule

