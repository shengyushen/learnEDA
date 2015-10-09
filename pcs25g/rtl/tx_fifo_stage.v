module tx_fifo_stage (
	in_enable,
	clock,
	reset_n,
	
	//fifo interface
	en_fifo,
	data_fifo,
	idle_fifo,

	//escaper interface
	en_escaper,
	data_escaper,
	idle_escaper
);
parameter WR_WIDTH=12;
input in_enable;
input	clock;
input	reset_n;
	
	//fifo interface
input	en_fifo;
input [WR_WIDTH-1:0]	data_fifo;
output	idle_fifo;
reg	idle_fifo;

	//escaper interface
output	en_escaper;
output [WR_WIDTH-1:0]	data_escaper;
input	idle_escaper;

reg en_escaper_reg;
reg [WR_WIDTH-1:0]	data_escaper_reg;

reg en_escaper_nxt;
reg [WR_WIDTH-1:0]	data_escaper_nxt;

always @(posedge clock)  begin
	if(!reset_n) begin
		en_escaper_reg <= 1'b0;
		data_escaper_reg <= 0;
	end
	else if(in_enable) begin
		en_escaper_reg <= en_escaper_nxt;
		data_escaper_reg <= data_escaper_nxt;
	end
end

assign	en_escaper=en_escaper_reg & idle_escaper;
assign	data_escaper=data_escaper_reg;

always @(*) begin
	if(idle_escaper) begin
		//we have input idle, current data can go, so we can read the tx fifo unconditionally
		idle_fifo=1'b1;
		en_escaper_nxt = en_fifo;
		data_escaper_nxt = data_fifo;
	end
	else begin
		//we dont have input idle
		if(!en_escaper_reg) begin
			//but we have space in stage, so we can read the tx fifo unconditionally
			idle_fifo=1'b1;
			en_escaper_nxt = en_fifo;
			data_escaper_nxt = data_fifo;
		end
		else begin
			//we also dont have space in stage, so we can not read the tx fifo
			idle_fifo=1'b0;
			en_escaper_nxt = en_escaper_reg;
			data_escaper_nxt = data_escaper_reg;
		end
	end
end
endmodule

