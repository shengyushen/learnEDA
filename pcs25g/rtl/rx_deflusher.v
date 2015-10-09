module rx_deflusher (
	in_enable,
	clk,
	reset_n,

	in_rxdata,
	in_rxdata_valid,
	in_rxdata_error,

	out_rxdata,
	out_rxdata_valid,
	out_rxdata_error
);
input	in_enable;
input	clk;
input	reset_n;

input	[`UNITWIDTH*`LANENUMBER-1:0]	in_rxdata;
input	in_rxdata_valid;
input	in_rxdata_error;

output	[`UNITWIDTH*`LANENUMBER-1:0]	out_rxdata;
output	out_rxdata_valid;
output	out_rxdata_error;
reg	[`UNITWIDTH*`LANENUMBER-1:0]	out_rxdata;
reg	out_rxdata_valid;
wire	out_rxdata_error;

wire is_ESC_PACK = ( in_rxdata == `ESC_PACK );
wire is_FLUSH_PACK = ( in_rxdata == `FLUSH_PACK );


reg	last_is_ESC_PACK;
reg	last_is_ESC_PACK_nxt;

always @(posedge clk) begin
	if(!reset_n) begin
		last_is_ESC_PACK <= 1'b0;
	end
	else if(in_enable) begin
		last_is_ESC_PACK <= last_is_ESC_PACK_nxt;
	end
end
assign out_rxdata_error=in_rxdata_error;
always @(*) begin
	if(in_rxdata_valid && is_ESC_PACK ) begin
		//current is ESC_PACK
		if(!last_is_ESC_PACK) begin
			//this is the first ESC_PACK, just delete it
			out_rxdata_valid=1'b0;
			out_rxdata=in_rxdata;
			last_is_ESC_PACK_nxt=1'b1;
		end
		else begin
			//this is the second ESC_PACK, output it
			out_rxdata_valid=1'b1;
			out_rxdata=in_rxdata;
			last_is_ESC_PACK_nxt=1'b0;
		end
	end
	else if (in_rxdata_valid && is_FLUSH_PACK) begin
		if(!last_is_ESC_PACK) begin
			//this is the FLUSH_PACK without esc, just output it
			out_rxdata_valid=1'b1;
			out_rxdata=in_rxdata;
			last_is_ESC_PACK_nxt=1'b0;
		end
		else begin
			//this is the FLUSH_PACK with esc, dont output
			out_rxdata_valid=1'b0;
			out_rxdata=in_rxdata;
			last_is_ESC_PACK_nxt=1'b0;
		end

	end
	else begin
		//output waht ever
		out_rxdata_valid=in_rxdata_valid;
		out_rxdata=in_rxdata;
		//if we found a valid input data, then the last_is_ESC_PACK_nxt will be clear
		if(in_rxdata_valid) begin
			last_is_ESC_PACK_nxt=1'b0;
		end
		else begin
			last_is_ESC_PACK_nxt=last_is_ESC_PACK;
		end
	end
end

endmodule
