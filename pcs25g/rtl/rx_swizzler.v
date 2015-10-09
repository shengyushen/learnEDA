module rx_swizzler(
	in_enable,
	clk,
	reset_n,
	
	in_rxdata,
	in_rxdata_valid,
	in_blocklock,
	in_allsync,

	out_rxdata,
	out_rxdata_valid
);
input	in_enable;
input	clk;
input	reset_n;

input [`UNITWIDTH*`LANENUMBER-1:0]	in_rxdata;
input	in_rxdata_valid;
input	[`LANENUMBER-1:0]	in_blocklock;
input	in_allsync;

output [`UNITWIDTH*`LANENUMBER-1:0]	out_rxdata;
output	out_rxdata_valid;
reg	out_rxdata_valid1;

wire	[`UNITWIDTH*`LANENUMBER-1:0] rxdata_swizzled;
assign	rxdata_swizzled=in_rxdata;


wire	[`LANENUMBER-1:0]	blocklock_swizzled;
assign	blocklock_swizzled=in_blocklock;


/*dealing with blocklock_swizzled first*/
wire	[`LANENUMBER-1:0]	blocklock_2=blocklock_swizzled[2]?blocklock_swizzled:{1'b0,blocklock_swizzled[3             ],blocklock_swizzled[1:0]};
wire	[`LANENUMBER-1:0]	blocklock_1=blocklock_swizzled[1]?blocklock_2       :{1'b0,blocklock_2       [`LANENUMBER-1:2],blocklock_2       [  0]};
wire	[`LANENUMBER-1:0]	blocklock_0=blocklock_swizzled[0]?blocklock_1       :{1'b0,blocklock_1       [`LANENUMBER-1:1]                        };

reg	[4:0] numberOfData;
reg	[`LANENUMBER-1:0]	blocklock_7;
always @(posedge clk) begin
	if(!reset_n) begin
		blocklock_7<={`LANENUMBER{1'b1}};
		numberOfData<=`LANENUMBER;
	end
	else if(in_enable) begin
		blocklock_7<=blocklock_0;
		case(blocklock_0)
		4'b0000 :	numberOfData<=0;
		4'b0001 :	numberOfData<=1;
		4'b0011 :	numberOfData<=2;
		4'b0111 :	numberOfData<=3;
		default :	numberOfData<=`LANENUMBER;
		endcase
	end
end
wire	[`UNITWIDTH*`LANENUMBER-1:0]	rxdata_2=blocklock_swizzled[2]?rxdata_swizzled:{{`UNITWIDTH{1'b0}}, rxdata_swizzled[`UNITWIDTH*`LANENUMBER-1:`UNITWIDTH*3],rxdata_swizzled[`UNITWIDTH*2-1:0]};
wire	[`UNITWIDTH*`LANENUMBER-1:0]	rxdata_1=blocklock_swizzled[1]?rxdata_2		    :{{`UNITWIDTH{1'b0}},rxdata_2 	     [`UNITWIDTH*`LANENUMBER-1:`UNITWIDTH*2],rxdata_2       [`UNITWIDTH*1-1:0]};
wire	[`UNITWIDTH*`LANENUMBER-1:0]	rxdata_0=blocklock_swizzled[0]?rxdata_1		    :{{`UNITWIDTH{1'b0}},rxdata_1 	     [`UNITWIDTH*`LANENUMBER-1:`UNITWIDTH*1]};
wire	[`UNITWIDTH*`LANENUMBER-1:0]	rxdata_7=rxdata_0;




reg	[`UNITWIDTH*`LANENUMBER*2-1:0]	rxdata_store;
reg	[`UNITWIDTH*`LANENUMBER*2-1:0]	rxdata_store_nxt;
reg	[3:0]	pos;
reg	[3:0]	pos_nxt;
reg	rxdata_valid_nxt;
reg	all1;
always @(posedge clk) begin
	if(!reset_n) begin
		rxdata_store<=0;
		pos<=0;
		out_rxdata_valid1<=1'b0;
		all1<=1'b0;
	end
	else if(in_enable) begin
		rxdata_store<=rxdata_store_nxt;
		pos<=pos_nxt;
		out_rxdata_valid1<=rxdata_valid_nxt;
		all1<=(in_blocklock=={`LANENUMBER{1'b1}});
	end
end

always @(*) begin
	rxdata_store_nxt=rxdata_store;
	pos_nxt=pos;
	rxdata_valid_nxt=1'b0;
	if(in_allsync) begin
		pos_nxt=0;
	end
	else if (in_rxdata_valid) begin
		case(pos)
		0,4 : begin
			case(numberOfData)
			0       : begin rxdata_store_nxt=rxdata_store;                               pos_nxt=0; rxdata_valid_nxt=1'b0; end
			1       : begin rxdata_store_nxt[`UNITWIDTH*1-1:0]=rxdata_7[`UNITWIDTH*1-1:0]; pos_nxt=1; rxdata_valid_nxt=1'b0; end
			2       : begin rxdata_store_nxt[`UNITWIDTH*2-1:0]=rxdata_7[`UNITWIDTH*2-1:0]; pos_nxt=2; rxdata_valid_nxt=1'b0; end
			3       : begin rxdata_store_nxt[`UNITWIDTH*3-1:0]=rxdata_7[`UNITWIDTH*3-1:0]; pos_nxt=3; rxdata_valid_nxt=1'b0; end
			default : begin rxdata_store_nxt[`UNITWIDTH*4-1:0]=rxdata_7[`UNITWIDTH*4-1:0]; pos_nxt=4; rxdata_valid_nxt=1'b1; end
			endcase
		end
		1,5 : begin
			case(numberOfData)
			0       : begin rxdata_store_nxt=rxdata_store;                                       pos_nxt=1; rxdata_valid_nxt=1'b0; end
			1       : begin rxdata_store_nxt[`UNITWIDTH*2-1:`UNITWIDTH]=rxdata_7[`UNITWIDTH*1-1:0]; pos_nxt=2; rxdata_valid_nxt=1'b0; end
			2       : begin rxdata_store_nxt[`UNITWIDTH*3-1:`UNITWIDTH]=rxdata_7[`UNITWIDTH*2-1:0]; pos_nxt=3; rxdata_valid_nxt=1'b0; end
			3       : begin rxdata_store_nxt[`UNITWIDTH*4-1:`UNITWIDTH]=rxdata_7[`UNITWIDTH*3-1:0]; pos_nxt=4; rxdata_valid_nxt=1'b1; end
			default : begin rxdata_store_nxt[`UNITWIDTH*5-1:`UNITWIDTH]=rxdata_7[`UNITWIDTH*4-1:0]; pos_nxt=5; rxdata_valid_nxt=1'b1; end
			endcase

			if(pos[2]) begin//bigger than or equal to 4 
				rxdata_store_nxt[`UNITWIDTH-1:0]=rxdata_store[`UNITWIDTH*5-1:`UNITWIDTH*4];
			end
		end
		2,6 : begin
			case(numberOfData)
			0       : begin rxdata_store_nxt=rxdata_store;                                         pos_nxt=2; rxdata_valid_nxt=1'b0; end
			1       : begin rxdata_store_nxt[`UNITWIDTH*3-1:`UNITWIDTH*2]=rxdata_7[`UNITWIDTH*1-1:0]; pos_nxt=3; rxdata_valid_nxt=1'b0; end
			2       : begin rxdata_store_nxt[`UNITWIDTH*4-1:`UNITWIDTH*2]=rxdata_7[`UNITWIDTH*2-1:0]; pos_nxt=4; rxdata_valid_nxt=1'b1; end
			3       : begin rxdata_store_nxt[`UNITWIDTH*5-1:`UNITWIDTH*2]=rxdata_7[`UNITWIDTH*3-1:0]; pos_nxt=5; rxdata_valid_nxt=1'b1; end
			default : begin rxdata_store_nxt[`UNITWIDTH*6-1:`UNITWIDTH*2]=rxdata_7[`UNITWIDTH*4-1:0]; pos_nxt=6; rxdata_valid_nxt=1'b1; end
			endcase

			if(pos[2]) begin//bigger than or equal to 4
				rxdata_store_nxt[`UNITWIDTH*2-1:0]=rxdata_store[`UNITWIDTH*6-1:`UNITWIDTH*4];
			end
		end
		3,7 : begin
			case(numberOfData)
			0       : begin rxdata_store_nxt=rxdata_store;                                         pos_nxt=3; rxdata_valid_nxt=1'b0; end
			1       : begin rxdata_store_nxt[`UNITWIDTH*4-1:`UNITWIDTH*3]=rxdata_7[`UNITWIDTH*1-1:0]; pos_nxt=4; rxdata_valid_nxt=1'b1; end
			2       : begin rxdata_store_nxt[`UNITWIDTH*5-1:`UNITWIDTH*3]=rxdata_7[`UNITWIDTH*2-1:0]; pos_nxt=5; rxdata_valid_nxt=1'b1; end
			3       : begin rxdata_store_nxt[`UNITWIDTH*6-1:`UNITWIDTH*3]=rxdata_7[`UNITWIDTH*3-1:0]; pos_nxt=6; rxdata_valid_nxt=1'b1; end
			default : begin rxdata_store_nxt[`UNITWIDTH*7-1:`UNITWIDTH*3]=rxdata_7[`UNITWIDTH*4-1:0]; pos_nxt=7; rxdata_valid_nxt=1'b1; end
			endcase

			if(pos[3]) begin//bigger than or equal to 8
				rxdata_store_nxt[71:0]=rxdata_store[263:192];
			end
		end
		endcase
	end
end

assign	out_rxdata=all1?rxdata_swizzled:rxdata_store[`UNITWIDTH*`LANENUMBER-1:0];
assign	out_rxdata_valid=all1?in_rxdata_valid:out_rxdata_valid1;



`ifdef PCS_SIM
reg	correct;
always @(*) begin
	correct=1'b0;
			case(blocklock_7)
			4'b0000 :	correct=1'b1;
			4'b0001 :	correct=1'b1;
			4'b0011 :	correct=1'b1;
			4'b0111 :	correct=1'b1;
			4'b1111 :	correct=1'b1;
			endcase
end
`endif

endmodule
