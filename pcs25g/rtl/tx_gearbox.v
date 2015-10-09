module tx_gearbox (
	in_enable,
	clk,
	reset_n,
	
	in_data,
	in_pop,
	out_ideal,
	
	out_data,
	correct
);

parameter STATE_765432=3'b000;
parameter STATE_107654=3'b001;
parameter STATE_321076=3'b010;
parameter STATE_543210=3'b011;


parameter MAXIDX=100;
parameter INITIDX=60;
parameter IDLIDX=80;
input in_enable;
input	clk;
input	reset_n;
	
input	[`UNITWIDTH-1:0]	in_data;
input	in_pop;
output	out_ideal;

output	[`UNITWIDTH_PMA-1:0]	out_data;
output	correct;
reg	correct;

reg	[7:0]	pos;
reg	[7:0]	pos_nxt;
reg [MAXIDX-1:0] data_reg;
reg [MAXIDX-1:0] data_reg_nxt;
reg	[2:0]	state;

always @(posedge clk) begin
	if(!reset_n) begin
		state<=STATE_765432;
	end
	else if(in_enable) begin
		if(in_pop) begin
			case(state)
			STATE_765432 : state<=STATE_107654;
			STATE_107654 : state<=STATE_321076;
			STATE_321076 : state<=STATE_543210;
			STATE_543210 : state<=STATE_765432;
			endcase
		end
	end
end

always @(posedge clk) begin
	if(!reset_n) begin
		pos<=INITIDX;
		data_reg<=0;
	end
	else if(in_enable) begin
		pos<=pos_nxt;
		data_reg<=data_reg_nxt;
	end
end

assign	out_ideal=(pos<IDLIDX);
always @(*) begin
	correct=1'b1;
	if(pos>=`UNITWIDTH_PMA) begin
		//there is data
		//the default action is to pop is
		pos_nxt=pos-`UNITWIDTH_PMA;
		data_reg_nxt={data_reg[MAXIDX-1:MAXIDX-`UNITWIDTH_PMA],data_reg[MAXIDX-1:`UNITWIDTH_PMA]};
		if(in_pop) begin
			case(state)
			STATE_765432 : begin //48 bit data
				pos_nxt=pos+(`UNITWIDTH-`UNITWIDTH_PMA);
				case(pos)
				32: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH   ],in_data};
				34: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+ 2],in_data,data_reg[`UNITWIDTH_PMA+ 1:`UNITWIDTH_PMA]};
				36: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+ 4],in_data,data_reg[`UNITWIDTH_PMA+ 3:`UNITWIDTH_PMA]};
				38: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+ 6],in_data,data_reg[`UNITWIDTH_PMA+ 5:`UNITWIDTH_PMA]};
                                                                                               
				40: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+ 8],in_data,data_reg[`UNITWIDTH_PMA+ 7:`UNITWIDTH_PMA]};
				42: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+10],in_data,data_reg[`UNITWIDTH_PMA+ 9:`UNITWIDTH_PMA]};
				44: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+12],in_data,data_reg[`UNITWIDTH_PMA+11:`UNITWIDTH_PMA]};
				46: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+14],in_data,data_reg[`UNITWIDTH_PMA+13:`UNITWIDTH_PMA]};
				48: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+16],in_data,data_reg[`UNITWIDTH_PMA+15:`UNITWIDTH_PMA]};
                                                                                               
				50: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+18],in_data,data_reg[`UNITWIDTH_PMA+17:`UNITWIDTH_PMA]};
				52: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+20],in_data,data_reg[`UNITWIDTH_PMA+19:`UNITWIDTH_PMA]};
				54: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+22],in_data,data_reg[`UNITWIDTH_PMA+21:`UNITWIDTH_PMA]};
				56: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+24],in_data,data_reg[`UNITWIDTH_PMA+23:`UNITWIDTH_PMA]};
				58: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+26],in_data,data_reg[`UNITWIDTH_PMA+25:`UNITWIDTH_PMA]};
                                                                                               
				60: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+28],in_data,data_reg[`UNITWIDTH_PMA+27:`UNITWIDTH_PMA]};
				62: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+30],in_data,data_reg[`UNITWIDTH_PMA+29:`UNITWIDTH_PMA]};
				64: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+32],in_data,data_reg[`UNITWIDTH_PMA+31:`UNITWIDTH_PMA]};
				66: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+34],in_data,data_reg[`UNITWIDTH_PMA+33:`UNITWIDTH_PMA]};
				68: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+36],in_data,data_reg[`UNITWIDTH_PMA+35:`UNITWIDTH_PMA]};
                                                                                             
				70: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+38],in_data,data_reg[`UNITWIDTH_PMA+37:`UNITWIDTH_PMA]};
				72: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+40],in_data,data_reg[`UNITWIDTH_PMA+39:`UNITWIDTH_PMA]};
				74: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+42],in_data,data_reg[`UNITWIDTH_PMA+41:`UNITWIDTH_PMA]};
				76: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+44],in_data,data_reg[`UNITWIDTH_PMA+43:`UNITWIDTH_PMA]};
				78: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+46],in_data,data_reg[`UNITWIDTH_PMA+45:`UNITWIDTH_PMA]};
                                                                                           
				80: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+48],in_data,data_reg[`UNITWIDTH_PMA+47:`UNITWIDTH_PMA]};
				82: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+50],in_data,data_reg[`UNITWIDTH_PMA+49:`UNITWIDTH_PMA]};
				84: data_reg_nxt={                                 in_data,data_reg[`UNITWIDTH_PMA+51:`UNITWIDTH_PMA]};
				default : correct=1'b0;
				endcase
			end
			STATE_107654 : begin  //48 bit data with 10 between 0 and 76
				pos_nxt=pos+(`UNITWIDTH-`UNITWIDTH_PMA)+2;
				case(pos)
				32: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+ 2],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0]};
				34: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+ 4],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+ 1:`UNITWIDTH_PMA]};
				36: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+ 6],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+ 3:`UNITWIDTH_PMA]};
				38: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+ 8],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+ 5:`UNITWIDTH_PMA]};

				40: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+10],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+ 7:`UNITWIDTH_PMA]};
				42: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+12],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+ 9:`UNITWIDTH_PMA]};
				44: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+14],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+11:`UNITWIDTH_PMA]};
				46: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+16],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+13:`UNITWIDTH_PMA]};
				48: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+18],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+15:`UNITWIDTH_PMA]};

				50: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+20],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+17:`UNITWIDTH_PMA]};
				52: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+22],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+19:`UNITWIDTH_PMA]};
				54: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+24],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+21:`UNITWIDTH_PMA]};
				56: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+26],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+23:`UNITWIDTH_PMA]};
				58: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+28],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+25:`UNITWIDTH_PMA]};

				60: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+30],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+27:`UNITWIDTH_PMA]};
				62: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+32],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+29:`UNITWIDTH_PMA]};
				64: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+34],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+31:`UNITWIDTH_PMA]};
				66: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+36],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+33:`UNITWIDTH_PMA]};
				68: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+38],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+35:`UNITWIDTH_PMA]};
                                                        
				70: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+40],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+37:`UNITWIDTH_PMA]};
				72: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+42],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+39:`UNITWIDTH_PMA]};
				74: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+44],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+41:`UNITWIDTH_PMA]};
				76: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+46],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+43:`UNITWIDTH_PMA]};
				78: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+48],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+45:`UNITWIDTH_PMA]};

				80: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+50],in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+47:`UNITWIDTH_PMA]};
				82: data_reg_nxt={                                 in_data[`UNITWIDTH-1:16],2'b10,in_data[15:0],data_reg[`UNITWIDTH_PMA+49:`UNITWIDTH_PMA]};
				default : correct=1'b0;
				endcase
			end
			STATE_321076 : begin  //48 bit data with 10 between 0 and 76
				pos_nxt=pos+(`UNITWIDTH-`UNITWIDTH_PMA)+2;
				case(pos)
				32: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+ 2],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0]};
				34: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+ 4],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+ 1:`UNITWIDTH_PMA]};
				36: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+ 6],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+ 3:`UNITWIDTH_PMA]};
				38: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+ 8],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+ 5:`UNITWIDTH_PMA]};
                                                           
				40: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+10],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+ 7:`UNITWIDTH_PMA]};
				42: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+12],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+ 9:`UNITWIDTH_PMA]};
				44: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+14],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+11:`UNITWIDTH_PMA]};
				46: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+16],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+13:`UNITWIDTH_PMA]};
				48: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+18],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+15:`UNITWIDTH_PMA]};

				50: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+20],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+17:`UNITWIDTH_PMA]};
				52: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+22],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+19:`UNITWIDTH_PMA]};
				54: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+24],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+21:`UNITWIDTH_PMA]};
				56: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+26],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+23:`UNITWIDTH_PMA]};
				58: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+28],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+25:`UNITWIDTH_PMA]};

				60: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+30],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+27:`UNITWIDTH_PMA]};
				62: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+32],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+29:`UNITWIDTH_PMA]};
				64: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+34],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+31:`UNITWIDTH_PMA]};
				66: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+36],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+33:`UNITWIDTH_PMA]};
				68: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+38],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+35:`UNITWIDTH_PMA]};

				70: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+40],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+37:`UNITWIDTH_PMA]};
				72: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+42],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+39:`UNITWIDTH_PMA]};
				74: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+44],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+41:`UNITWIDTH_PMA]};
				76: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+46],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+43:`UNITWIDTH_PMA]};
				78: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+48],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+45:`UNITWIDTH_PMA]};

				80: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+50],in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+47:`UNITWIDTH_PMA]};
				82: data_reg_nxt={                                 in_data[`UNITWIDTH-1:32],2'b10,in_data[31:0],data_reg[`UNITWIDTH_PMA+49:`UNITWIDTH_PMA]};
				default : correct=1'b0;
				endcase
			end
			STATE_543210 : begin  //48 bit data with 01 at tail
				pos_nxt=pos+(`UNITWIDTH-`UNITWIDTH_PMA)+2;
				case(pos)
				32: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+ 2],2'b01,in_data};
				34: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+ 4],2'b01,in_data,data_reg[`UNITWIDTH_PMA+ 1:`UNITWIDTH_PMA]};
				36: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+ 6],2'b01,in_data,data_reg[`UNITWIDTH_PMA+ 3:`UNITWIDTH_PMA]};
				38: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+ 8],2'b01,in_data,data_reg[`UNITWIDTH_PMA+ 5:`UNITWIDTH_PMA]};
                                                          
				40: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+10],2'b01,in_data,data_reg[`UNITWIDTH_PMA+ 7:`UNITWIDTH_PMA]};
				42: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+12],2'b01,in_data,data_reg[`UNITWIDTH_PMA+ 9:`UNITWIDTH_PMA]};
				44: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+14],2'b01,in_data,data_reg[`UNITWIDTH_PMA+11:`UNITWIDTH_PMA]};
				46: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+16],2'b01,in_data,data_reg[`UNITWIDTH_PMA+13:`UNITWIDTH_PMA]};
				48: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+18],2'b01,in_data,data_reg[`UNITWIDTH_PMA+15:`UNITWIDTH_PMA]};
                                                         
				50: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+20],2'b01,in_data,data_reg[`UNITWIDTH_PMA+17:`UNITWIDTH_PMA]};
				52: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+22],2'b01,in_data,data_reg[`UNITWIDTH_PMA+19:`UNITWIDTH_PMA]};
				54: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+24],2'b01,in_data,data_reg[`UNITWIDTH_PMA+21:`UNITWIDTH_PMA]};
				56: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+26],2'b01,in_data,data_reg[`UNITWIDTH_PMA+23:`UNITWIDTH_PMA]};
				58: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+28],2'b01,in_data,data_reg[`UNITWIDTH_PMA+25:`UNITWIDTH_PMA]};
                                                        
				60: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+30],2'b01,in_data,data_reg[`UNITWIDTH_PMA+27:`UNITWIDTH_PMA]};
				62: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+32],2'b01,in_data,data_reg[`UNITWIDTH_PMA+29:`UNITWIDTH_PMA]};
				64: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+34],2'b01,in_data,data_reg[`UNITWIDTH_PMA+31:`UNITWIDTH_PMA]};
				66: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+36],2'b01,in_data,data_reg[`UNITWIDTH_PMA+33:`UNITWIDTH_PMA]};
				68: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+38],2'b01,in_data,data_reg[`UNITWIDTH_PMA+35:`UNITWIDTH_PMA]};
                                                       
				70: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+40],2'b01,in_data,data_reg[`UNITWIDTH_PMA+37:`UNITWIDTH_PMA]};
				72: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+42],2'b01,in_data,data_reg[`UNITWIDTH_PMA+39:`UNITWIDTH_PMA]};
				74: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+44],2'b01,in_data,data_reg[`UNITWIDTH_PMA+41:`UNITWIDTH_PMA]};
				76: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+46],2'b01,in_data,data_reg[`UNITWIDTH_PMA+43:`UNITWIDTH_PMA]};
				78: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+48],2'b01,in_data,data_reg[`UNITWIDTH_PMA+45:`UNITWIDTH_PMA]};

				80: data_reg_nxt={data_reg[MAXIDX-1:`UNITWIDTH+50],2'b01,in_data,data_reg[`UNITWIDTH_PMA+47:`UNITWIDTH_PMA]};
				82: data_reg_nxt={                                 2'b01,in_data,data_reg[`UNITWIDTH_PMA+49:`UNITWIDTH_PMA]};
				default : correct=1'b0;
				endcase
			end
			endcase
		end
	end
	else begin
		pos_nxt=INITIDX;
		data_reg_nxt=data_reg;
		correct=1'b0;
	end

end

assign	out_data=data_reg[`UNITWIDTH_PMA-1:0];

`ifdef PCS_SIM
// data enable  ->  ideal
assert_always #(`OVL_FATAL) inst_assert_inp_enable_ideal(clk,reset_n,!in_pop || out_ideal);
//the pos is alway correct
assert_always #(`OVL_FATAL) inst_assert_inp_position_correct(clk,reset_n,correct);
`endif

endmodule
