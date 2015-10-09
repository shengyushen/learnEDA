module rx_deescaper (
	in_enable,
  clk,
  reset_n,

  in_pop,
  in_data,

  out_data,
  out_pop,
  out_sync
);
input in_enable;
input  clk;
input  reset_n;

input  in_pop;
input  [`UNITWIDTH-1:0] in_data;

output [`UNITWIDTH-1:0]  out_data;
output  out_pop;
reg  out_pop;
output  out_sync;
reg  out_sync;

reg	last_is_esc;

always @(posedge clk) begin
	if(!reset_n) begin
		last_is_esc<=1'b0;
	end
	else if(in_enable) begin
		if(in_pop) begin
			if(in_data==`ESC_CHAR) begin
				last_is_esc<=!last_is_esc;
			end
			else begin
				last_is_esc<=1'b0;
			end
		end
	end
end

always @(*) begin
	out_pop=in_pop;
	out_sync=1'b0;
	if(in_pop) begin
	  if(in_data==`ESC_CHAR) begin
		if(last_is_esc) begin //this is the second esc that should be outputed
			out_pop=1'b1;
		end
		else begin
			out_pop=1'b0;
		end
	  end
	  else if(in_data==`IDLE_CHAR && last_is_esc) begin
		out_pop=1'b0;
	  end
	  else if(in_data[`UNITWIDTH-1:11]==`SYNC_CHAR && last_is_esc) begin
		out_pop=1'b1;
		out_sync=1'b1;
	  end
	end
end

assign	out_data=in_data;
endmodule
