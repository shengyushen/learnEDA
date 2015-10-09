module gearbox_64_48 (
	in_enable,
	clk,
	reset_n,
	//interface to upper
	out_idle,
	in_data,
	in_datavalid,
	in_dataerror,
	//interface to downside
	out_data,
	out_datavalid,
	out_dataerror,
	in_idle
);
parameter WORDSIZE					=16;
parameter SAVEDATAADDRSIZE	=9;
parameter	SAVEDATASIZE			=640;
parameter	SAVEWORDNUMBER		=SAVEDATASIZE/WORDSIZE;
input	in_enable;
input	clk, reset_n;
	//interface to upper
output	out_idle;
input [63:0]	in_data;
input in_datavalid;
input in_dataerror;
	//interface to downside
output [47:0]	out_data;
output out_datavalid;
output out_dataerror;
input in_idle;


reg	out_idle;
reg [WORDSIZE*3-1:0]	out_data;
reg [SAVEDATASIZE-1:0] save_data;
reg [SAVEDATASIZE-1:0] save_data_nxt;
reg [SAVEWORDNUMBER-1:0] save_error;
reg [SAVEWORDNUMBER-1:0] save_error_nxt;
//intentional double the pointer 
reg	[SAVEDATAADDRSIZE:0] pointer;
reg	[SAVEDATAADDRSIZE:0] pointer_nxt;

always @(posedge clk ) begin
	if(!reset_n) begin
		pointer <= SAVEDATASIZE;
		save_data <= {SAVEDATASIZE{1'b0}};
		save_error <= {SAVEWORDNUMBER{1'b0}};
	end
	else begin
		pointer <= pointer_nxt;
		save_data <= save_data_nxt;
		save_error <= save_error_nxt;
	end
end
reg [2:0] error;
always @(*) begin
	out_data=save_data[WORDSIZE*3-1:0];
	error=save_error[2+0:0];
	case(pointer)
	WORDSIZE*0 :		  begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*0 :WORDSIZE*0 ];      error=save_error[2+0 :0 ]; end
	WORDSIZE*1 : 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*1 :WORDSIZE*1 ];      error=save_error[2+1 :1 ]; end
	WORDSIZE*2 : 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*2 :WORDSIZE*2 ];      error=save_error[2+2 :2 ]; end
	WORDSIZE*3 : 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*3 :WORDSIZE*3 ];      error=save_error[2+3 :3 ]; end
	WORDSIZE*4 : 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*4 :WORDSIZE*4 ];      error=save_error[2+4 :4 ]; end
	WORDSIZE*5 : 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*5 :WORDSIZE*5 ];      error=save_error[2+5 :5 ]; end
	WORDSIZE*6 : 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*6 :WORDSIZE*6 ];      error=save_error[2+6 :6 ]; end
	WORDSIZE*7 : 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*7 :WORDSIZE*7 ];      error=save_error[2+7 :7 ]; end
	WORDSIZE*8 : 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*8 :WORDSIZE*8 ];      error=save_error[2+8 :8 ]; end
	WORDSIZE*9 : 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*9 :WORDSIZE*9 ];      error=save_error[2+9 :9 ]; end
	WORDSIZE*10:		  begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*10:WORDSIZE*10];      error=save_error[2+10:10]; end
	WORDSIZE*11: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*11:WORDSIZE*11];      error=save_error[2+11:11]; end
	WORDSIZE*12: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*12:WORDSIZE*12];      error=save_error[2+12:12]; end
	WORDSIZE*13: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*13:WORDSIZE*13];      error=save_error[2+13:13]; end
	WORDSIZE*14: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*14:WORDSIZE*14];      error=save_error[2+14:14]; end
	WORDSIZE*15: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*15:WORDSIZE*15];      error=save_error[2+15:15]; end
	WORDSIZE*16: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*16:WORDSIZE*16];      error=save_error[2+16:16]; end
	WORDSIZE*17: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*17:WORDSIZE*17];      error=save_error[2+17:17]; end
	WORDSIZE*18: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*18:WORDSIZE*18];      error=save_error[2+18:18]; end
	WORDSIZE*19: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*19:WORDSIZE*19];      error=save_error[2+19:19]; end
	WORDSIZE*20:			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*20:WORDSIZE*20];      error=save_error[2+20:20]; end
	WORDSIZE*21: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*21:WORDSIZE*21];      error=save_error[2+21:21]; end
	WORDSIZE*22: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*22:WORDSIZE*22];      error=save_error[2+22:22]; end
	WORDSIZE*23: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*23:WORDSIZE*23];      error=save_error[2+23:23]; end
	WORDSIZE*24: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*24:WORDSIZE*24];      error=save_error[2+24:24]; end
	WORDSIZE*25: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*25:WORDSIZE*25];      error=save_error[2+25:25]; end
	WORDSIZE*26: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*26:WORDSIZE*26];      error=save_error[2+26:26]; end
	WORDSIZE*27: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*27:WORDSIZE*27];      error=save_error[2+27:27]; end
	WORDSIZE*28: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*28:WORDSIZE*28];      error=save_error[2+28:28]; end
	WORDSIZE*29: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*29:WORDSIZE*29];      error=save_error[2+29:29]; end
	WORDSIZE*30:			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*30:WORDSIZE*30];      error=save_error[2+30:30]; end
	WORDSIZE*31: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*31:WORDSIZE*31];      error=save_error[2+31:31]; end
	WORDSIZE*32: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*32:WORDSIZE*32];      error=save_error[2+32:32]; end
	WORDSIZE*33: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*33:WORDSIZE*33];      error=save_error[2+33:33]; end
	WORDSIZE*34: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*34:WORDSIZE*34];      error=save_error[2+34:34]; end
	WORDSIZE*35: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*35:WORDSIZE*35];      error=save_error[2+35:35]; end
	WORDSIZE*36: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*36:WORDSIZE*36];      error=save_error[2+36:36]; end
	WORDSIZE*37: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*37:WORDSIZE*37];      error=save_error[2+37:37]; end
//	WORDSIZE*38: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*38:WORDSIZE*38];      error=save_error[2+38:38]; end
//	WORDSIZE*39: 			begin out_data=save_data[WORDSIZE*3-1+WORDSIZE*39:WORDSIZE*39];      error=save_error[2+39:39]; end
	endcase
end
assign	out_datavalid=(pointer<=(WORDSIZE*37)) & in_idle;
assign	out_dataerror=|error;

always @(*) begin
	if(in_idle) begin
		out_idle=(pointer>=WORDSIZE);
		if(in_datavalid) begin
			save_data_nxt={in_data,save_data[SAVEDATASIZE-1:64]};
			save_error_nxt={{4{in_dataerror}},save_error[SAVEWORDNUMBER-1:4]};
			pointer_nxt=out_datavalid?(pointer-16):(pointer-64);
		end
		else begin
			save_data_nxt=save_data;
			save_error_nxt=save_error;
			pointer_nxt=out_datavalid?(pointer+48):pointer;
		end
	end
	else begin
		out_idle=(pointer>=64);
		if(in_datavalid) begin
			save_data_nxt={in_data,save_data[SAVEDATASIZE-1:64]};
			save_error_nxt={{4{in_dataerror}},save_error[SAVEWORDNUMBER-1:4]};
			pointer_nxt=pointer-64;
		end
		else begin
			save_data_nxt=save_data;
			save_error_nxt=save_error;
			pointer_nxt=pointer;
		end
	end
end

`ifdef PCS_SIM
assert_always #(`OVL_FATAL) inst_assert_0(clk,reset_n,(!in_datavalid|out_idle));
assert_always #(`OVL_FATAL) inst_assert_1(clk,reset_n,(!out_datavalid|in_idle));
`endif

endmodule
