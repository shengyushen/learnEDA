module gearbox_48_64 (
	in_enable,
	clk,
	reset_n,
	//interface to upper
	out_idle,
	in_data,
	in_datavalid,
	empty_save,
	//interface to downside
	out_data,
	out_datavalid,
	in_idle
);
input	in_enable;
input	clk, reset_n;
	//interface to upper
output	out_idle;
input [47:0]	in_data;
input in_datavalid;
output  empty_save;
	//interface to downside
output [63:0]	out_data;
output out_datavalid;
input in_idle;


//state means the position to be filled
//so 0 is nothing in
reg [5:0] state;
reg [5:0] state_nxt;
reg [9*16-1:0] save_data;
reg [9*16-1:0] save_data_nxt;

assign out_idle=(state<=6);
//at border of 48 bit
assign	empty_save=(state==0||state==3||state==6||state==9);

always @(posedge clk) begin
	if(!reset_n) begin
		state <= 6'b0;
		save_data <= 0;
	end
	else if(in_enable)  begin
		state <= state_nxt;
		save_data <= save_data_nxt;
	end
end
reg [63:0]	out_data;
reg out_datavalid;
always @(*) begin
	out_data=save_data[63:0];
	out_datavalid=1'b0;
	state_nxt=state;
	save_data_nxt =save_data ;
	//data can run through
	case(state)
	0: begin
		/*no data to output*/
		if(in_datavalid) begin
			state_nxt=state+3;
			save_data_nxt[3*16-1:0*16]=in_data;
		end
	end
	1: begin
		/*no data to output*/
		if(in_datavalid) begin
			state_nxt=state+3;
			save_data_nxt[4*16-1:1*16]=in_data;
		end
	end
	2: begin
		/*no data to output*/
		if(in_datavalid) begin
			state_nxt=state+3;
			save_data_nxt[5*16-1:2*16]=in_data;
		end
	end
	3: begin
		/*no data to output*/
		if(in_datavalid) begin
			state_nxt=state+3;
			save_data_nxt[6*16-1:3*16]=in_data;
		end
	end
	4: begin
		/*data to output*/
		out_datavalid=in_idle;
		if(in_idle) begin
			if(in_datavalid) begin
				state_nxt=state-4+3;
				save_data_nxt[3*16-1:0*16]=in_data;
			end
			else begin
				state_nxt=state-4;
			end
		end
		else begin
			if(in_datavalid) begin
				state_nxt=state+3;
				save_data_nxt[7*16-1:4*16]=in_data;
			end
		end
	end
	5: begin
		/*data to output*/
		out_datavalid=in_idle;
		if(in_idle) begin
			save_data_nxt[1*16-1:0*16]=save_data[5*16-1:4*16];
			if(in_datavalid) begin
				state_nxt=state-4+3;
				save_data_nxt[4*16-1:1*16]=in_data;
			end
			else begin
				state_nxt=state-4;
			end
		end
		else begin
			if(in_datavalid) begin
				state_nxt=state+3;
				save_data_nxt[8*16-1:5*16]=in_data;
			end
		end
	end
	6: begin
		/*data to output*/
		out_datavalid=in_idle;
		if(in_idle) begin
			save_data_nxt[2*16-1:0*16]=save_data[6*16-1:4*16];
			if(in_datavalid) begin
				state_nxt=state-4+3;
				save_data_nxt[5*16-1:2*16]=in_data;
			end
			else begin
				state_nxt=state-4;
			end
		end
		else begin
			if(in_datavalid) begin
				state_nxt=state+3;
				save_data_nxt[9*16-1:6*16]=in_data;
			end
		end
	end
	7: begin
		/*data to output*/
		out_datavalid=in_idle;
		if(in_idle) begin
			save_data_nxt[3*16-1:0*16]=save_data[7*16-1:4*16];
			//no data incoming
			state_nxt=state-4;
		end
	end
	8: begin
		/*data to output*/
		out_datavalid=in_idle;
		if(in_idle) begin
			save_data_nxt[4*16-1:0*16]=save_data[8*16-1:4*16];
			//no data incoming
				state_nxt=state-4;
		end
	end
	9: begin
		/*data to output*/
		out_datavalid=in_idle;
		if(in_idle) begin
			save_data_nxt[5*16-1:0*16]=save_data[9*16-1:4*16];
			//no data incoming
				state_nxt=state-4;
		end
	end
	endcase
end

`ifdef PCS_SIM
assert_always #(`OVL_FATAL) inst_assert_0(clk,reset_n,(!in_datavalid|out_idle));
assert_always #(`OVL_FATAL) inst_assert_1(clk,reset_n,(!out_datavalid|in_idle));
`endif

endmodule
