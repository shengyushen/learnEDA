module rx_block_sync (
	in_enable,
                        clk,
                        reset_n,

                        pma_rx_ready_flop,
                        rx_data_in,

                        block_lock,
                        rx_data_66b,
                        data_valid_66b,
                        rx_data_48b,
                        data_valid_48b
                );


parameter	STATE_NON=4'b0000;
parameter STATE_765432=4'b0001;
parameter STATE_107654=4'b0010;
parameter STATE_321076=4'b0011;
parameter STATE_543210=4'b0100;

input in_enable;
input                   clk;
input                   reset_n;

input   [`UNITWIDTH_PMA-1:0]          rx_data_in;
input                   pma_rx_ready_flop;

output  [65:0]          rx_data_66b;
output                  data_valid_66b;

output   [`UNITWIDTH-1:0]                     rx_data_48b;
output                        data_valid_48b;
reg   [`UNITWIDTH-1:0]                     rx_data_48b;
reg                        data_valid_48b;
reg   [`UNITWIDTH-1:0]                     rx_data_48b_in;
reg                        data_valid_48b_in;


wire                    data_valid_in;
reg                     data_valid_66b;
reg     [65:0]          rx_data_66b;
wire    [65:0]          rx_data_66b_in;
output                  block_lock;
wire                    block_lock;
wire                    block_lock_pre;
wire                    sh_valid;
wire                    slip;
reg                    slip_done_set;
wire    [6:0]           sh_pointer_in;
reg     [6:0]           sh_pointer;
reg     [`UNITWIDTH_PMA+66-1:0]          data_reg;
wire    [`UNITWIDTH_PMA+66-1:0]          data_reg_in;
wire                    test_sh_set;
wire                    slip_done_set_nxt;
wire                    signal_ok;


assign signal_ok = pma_rx_ready_flop ;


assign sh_pointer_in =  reset_n == 1'b0 ?                       7'h00 :
                       slip_done_set_nxt && ~test_sh_set /*sh_pointer > (`UNITWIDTH_PMA-1)*/ ? sh_pointer - (`UNITWIDTH_PMA-1) :/*slip with old data shift right*/
                       slip_done_set_nxt                    ? sh_pointer + (66-`UNITWIDTH_PMA+1) : /*slip with old data shift right and new 66 bit data removed*/
                                            ~test_sh_set /*sh_pointer > (`UNITWIDTH_PMA-1)*/ ? sh_pointer - `UNITWIDTH_PMA : /*no slip and only shift old data right*/
                                                              sh_pointer + (66-`UNITWIDTH_PMA) ;/*no slip with old data shift right and new 66 bit data removed*/
assign data_valid_in = reset_n && sh_pointer_in<`UNITWIDTH_PMA;

assign test_sh_set = (sh_pointer < `UNITWIDTH_PMA);

assign data_reg_in = {rx_data_in, data_reg[`UNITWIDTH_PMA+66-1:`UNITWIDTH_PMA]};
assign slip_done_set_nxt = slip && ~test_sh_set /*sh_pointer>=`UNITWIDTH_PMA*/ && ~slip_done_set;
reg data_valid1;
reg data_valid2;
always @(posedge clk)
  begin
    data_reg <= data_reg_in;
    data_valid1 <= data_valid_in;
    data_valid_66b <= data_valid1  && block_lock_pre;
    sh_pointer <= sh_pointer_in;
     slip_done_set<= slip_done_set_nxt;
    rx_data_66b <= rx_data_66b_in;

	rx_data_48b <= rx_data_48b_in;
	data_valid_48b <= data_valid2  && block_lock_pre;
  end



assign rx_data_66b_in = (reset_n == 1'b0) ?                    66'h0  :
                        (data_valid1 == 1'b0) ?                 rx_data_66b :
                                     (sh_pointer == 7'h00) ? data_reg[ 65:  0] :
                                     (sh_pointer == 7'h01) ? data_reg[ 66:  1] :
                                     (sh_pointer == 7'h02) ? data_reg[ 67:  2] :
                                     (sh_pointer == 7'h03) ? data_reg[ 68:  3] :
                                     (sh_pointer == 7'h04) ? data_reg[ 69:  4] :
                                     (sh_pointer == 7'h05) ? data_reg[ 70:  5] :
                                     (sh_pointer == 7'h06) ? data_reg[ 71:  6] :
                                     (sh_pointer == 7'h07) ? data_reg[ 72:  7] :
                                     (sh_pointer == 7'h08) ? data_reg[ 73:  8] :
                                     (sh_pointer == 7'h09) ? data_reg[ 74:  9] :
                                     (sh_pointer == 7'h0a) ? data_reg[ 75: 10] :
                                     (sh_pointer == 7'h0b) ? data_reg[ 76: 11] :
                                     (sh_pointer == 7'h0c) ? data_reg[ 77: 12] :
                                     (sh_pointer == 7'h0d) ? data_reg[ 78: 13] :
                                     (sh_pointer == 7'h0e) ? data_reg[ 79: 14] :
                                     (sh_pointer == 7'h0f) ? data_reg[ 80: 15] :
                                     (sh_pointer == 7'h10) ? data_reg[ 81: 16] :
                                     (sh_pointer == 7'h11) ? data_reg[ 82: 17] :
                                     (sh_pointer == 7'h12) ? data_reg[ 83: 18] :
                                     (sh_pointer == 7'h13) ? data_reg[ 84: 19] :
                                     (sh_pointer == 7'h14) ? data_reg[ 85: 20] :
                                     (sh_pointer == 7'h15) ? data_reg[ 86: 21] :
                                     (sh_pointer == 7'h16) ? data_reg[ 87: 22] :
                                     (sh_pointer == 7'h17) ? data_reg[ 88: 23] :
                                     (sh_pointer == 7'h18) ? data_reg[ 89: 24] :
                                     (sh_pointer == 7'h19) ? data_reg[ 90: 25] :
                                     (sh_pointer == 7'h1a) ? data_reg[ 91: 26] :
                                     (sh_pointer == 7'h1b) ? data_reg[ 92: 27] :
                                     (sh_pointer == 7'h1c) ? data_reg[ 93: 28] :
                                     (sh_pointer == 7'h1d) ? data_reg[ 94: 29] :
                                     (sh_pointer == 7'h1e) ? data_reg[ 95: 30] :
                                     (sh_pointer == 7'h1f) ? data_reg[ 96: 31] :
                                                             data_reg[ 97: 32] ;

wire correct1 = (reset_n == 1'b0) ? 1'b1:
								(data_valid1 == 1'b0) ? 1'b1:
								(sh_pointer>=7'h00 && sh_pointer<=7'h28);
assign sh_valid = rx_data_66b[65] ^ rx_data_66b[64];

XFIPCS_LOCK_FSM lock_fsm (
												.in_enable(in_enable),
                        .clk            (clk             ),
                        .reset_n          (reset_n        ),

                        .signal_ok      (signal_ok              ),
                        .sh_valid       (sh_valid               ),
                        .slip_done_set  (slip_done_set          ),
                        .test_sh_set    (test_sh_set            ),

                        .slip           (slip                   ),
                        .block_lock     (block_lock_pre             )
                );

reg	[3:0]	state;
reg	[3:0]	state_nxt;
reg	[6:0]	pos48;
reg	[6:0]	pos48_nxt;
always @(posedge clk) begin
	if(!reset_n) begin
		state<=STATE_NON;
		pos48<=50;
	end
	else if(in_enable) begin
		state<=state_nxt;
		pos48<=pos48_nxt;
	end
end
reg invalid_boarder;
reg correct3;
always @(*) begin
	data_valid2=1'b0;
	state_nxt=state;
	pos48_nxt=pos48;
	correct3=1'b1;
	if(invalid_boarder) begin
		state_nxt=STATE_NON;
		correct3=1'b0;
	end
	else if(state==STATE_NON && data_valid1 && rx_data_66b_in[65]==1'b0 && rx_data_66b_in[64]==1'b1 && block_lock_pre) begin // re-alian the pos48
		pos48_nxt=sh_pointer+(66-`UNITWIDTH_PMA);
		state_nxt=STATE_543210;
	end
	else begin
		if(((pos48<66+`UNITWIDTH_PMA-`UNITWIDTH) && (state==STATE_543210 ) )
		|| ((pos48<66+`UNITWIDTH_PMA-`UNITWIDTH-2) && (state==STATE_107654 || state==STATE_321076 || state==STATE_765432) )
		) begin //we have enough data for 48 bit output
			pos48_nxt=pos48 + `UNITWIDTH-`UNITWIDTH_PMA; 
			data_valid2=1'b1;
			case(state)
			STATE_543210 : state_nxt = STATE_321076;
			STATE_321076 : begin
				state_nxt = STATE_107654;
				pos48_nxt = pos48 + `UNITWIDTH-`UNITWIDTH_PMA+2;
			end
			STATE_107654 : begin
				state_nxt = STATE_765432;
				pos48_nxt = pos48 + `UNITWIDTH-`UNITWIDTH_PMA+2;
			end
			STATE_765432 : begin
				state_nxt = STATE_543210;
				pos48_nxt = pos48 + `UNITWIDTH-`UNITWIDTH_PMA+2; 
			end
			endcase
		end
		else begin
			if(pos48>=`UNITWIDTH_PMA) begin
				pos48_nxt=pos48 - `UNITWIDTH_PMA ; 
			end
			else begin
				pos48_nxt=0 ; 
				correct3=1'b0;
			end
		end
	end
end
reg correct2;

always @(*) begin
	rx_data_48b_in=data_reg[`UNITWIDTH-1+0:0+0];
	invalid_boarder=1'b0;
	/*correct2=1'b1;*/
			case(state)
			STATE_543210: begin
				case(pos48)
                                                     
				0: rx_data_48b_in=data_reg[`UNITWIDTH-1+0:0+0];
				1: rx_data_48b_in=data_reg[`UNITWIDTH-1+1:0+1];
				2: rx_data_48b_in=data_reg[`UNITWIDTH-1+2:0+2];
				3: rx_data_48b_in=data_reg[`UNITWIDTH-1+3:0+3];
				4: rx_data_48b_in=data_reg[`UNITWIDTH-1+4:0+4];
				5: rx_data_48b_in=data_reg[`UNITWIDTH-1+5:0+5];
				6: rx_data_48b_in=data_reg[`UNITWIDTH-1+6:0+6];
				7: rx_data_48b_in=data_reg[`UNITWIDTH-1+7:0+7];
				8: rx_data_48b_in=data_reg[`UNITWIDTH-1+8:0+8];
				9: rx_data_48b_in=data_reg[`UNITWIDTH-1+9:0+9];
                                                     
				10: rx_data_48b_in=data_reg[`UNITWIDTH-1+10:0+10];
				11: rx_data_48b_in=data_reg[`UNITWIDTH-1+11:0+11];
				12: rx_data_48b_in=data_reg[`UNITWIDTH-1+12:0+12];
				13: rx_data_48b_in=data_reg[`UNITWIDTH-1+13:0+13];
				14: rx_data_48b_in=data_reg[`UNITWIDTH-1+14:0+14];
				15: rx_data_48b_in=data_reg[`UNITWIDTH-1+15:0+15];
				16: rx_data_48b_in=data_reg[`UNITWIDTH-1+16:0+16];
				17: rx_data_48b_in=data_reg[`UNITWIDTH-1+17:0+17];
				18: rx_data_48b_in=data_reg[`UNITWIDTH-1+18:0+18];
				19: rx_data_48b_in=data_reg[`UNITWIDTH-1+19:0+19];
                                                     
				20: rx_data_48b_in=data_reg[`UNITWIDTH-1+20:0+20];
				21: rx_data_48b_in=data_reg[`UNITWIDTH-1+21:0+21];
				22: rx_data_48b_in=data_reg[`UNITWIDTH-1+22:0+22];
				23: rx_data_48b_in=data_reg[`UNITWIDTH-1+23:0+23];
				24: rx_data_48b_in=data_reg[`UNITWIDTH-1+24:0+24];
				25: rx_data_48b_in=data_reg[`UNITWIDTH-1+25:0+25];
				26: rx_data_48b_in=data_reg[`UNITWIDTH-1+26:0+26];
				27: rx_data_48b_in=data_reg[`UNITWIDTH-1+27:0+27];
				28: rx_data_48b_in=data_reg[`UNITWIDTH-1+28:0+28];
				29: rx_data_48b_in=data_reg[`UNITWIDTH-1+29:0+29];
                                                     
				30: rx_data_48b_in=data_reg[`UNITWIDTH-1+30:0+30];
				31: rx_data_48b_in=data_reg[`UNITWIDTH-1+31:0+31];
				32: rx_data_48b_in=data_reg[`UNITWIDTH-1+32:0+32];
				33: rx_data_48b_in=data_reg[`UNITWIDTH-1+33:0+33];
				34: rx_data_48b_in=data_reg[`UNITWIDTH-1+34:0+34];
				35: rx_data_48b_in=data_reg[`UNITWIDTH-1+35:0+35];
				36: rx_data_48b_in=data_reg[`UNITWIDTH-1+36:0+36];
				37: rx_data_48b_in=data_reg[`UNITWIDTH-1+37:0+37];
				38: rx_data_48b_in=data_reg[`UNITWIDTH-1+38:0+38];
				39: rx_data_48b_in=data_reg[`UNITWIDTH-1+39:0+39];
                                                     
				40: rx_data_48b_in=data_reg[`UNITWIDTH-1+40:0+40];
				41: rx_data_48b_in=data_reg[`UNITWIDTH-1+41:0+41];
				42: rx_data_48b_in=data_reg[`UNITWIDTH-1+42:0+42];
				43: rx_data_48b_in=data_reg[`UNITWIDTH-1+43:0+43];
				44: rx_data_48b_in=data_reg[`UNITWIDTH-1+44:0+44];
				45: rx_data_48b_in=data_reg[`UNITWIDTH-1+45:0+45];
				46: rx_data_48b_in=data_reg[`UNITWIDTH-1+46:0+46];
				47: rx_data_48b_in=data_reg[`UNITWIDTH-1+47:0+47];
				48: rx_data_48b_in=data_reg[`UNITWIDTH-1+48:0+48];
				49: rx_data_48b_in=data_reg[`UNITWIDTH-1+49:0+49];
                                                     
				50: rx_data_48b_in=data_reg[`UNITWIDTH-1+50:0+50];
				/*51: rx_data_48b_in=data_reg[`UNITWIDTH-1+51:0+51];
				52: rx_data_48b_in=data_reg[`UNITWIDTH-1+52:0+52];
				53: rx_data_48b_in=data_reg[`UNITWIDTH-1+53:0+53];
				54: rx_data_48b_in=data_reg[`UNITWIDTH-1+54:0+54];
				55: rx_data_48b_in=data_reg[`UNITWIDTH-1+55:0+55];
				56: rx_data_48b_in=data_reg[`UNITWIDTH-1+56:0+56];
				57: rx_data_48b_in=data_reg[`UNITWIDTH-1+57:0+57];
				58: rx_data_48b_in=data_reg[`UNITWIDTH-1+58:0+58];
				59: rx_data_48b_in=data_reg[`UNITWIDTH-1+59:0+59];
                                                     
				60: rx_data_48b_in=data_reg[`UNITWIDTH-1+60:0+60];
				61: rx_data_48b_in=data_reg[`UNITWIDTH-1+61:0+61];
				62: rx_data_48b_in=data_reg[`UNITWIDTH-1+62:0+62];
				63: rx_data_48b_in=data_reg[`UNITWIDTH-1+63:0+63];
				64: rx_data_48b_in=data_reg[`UNITWIDTH-1+64:0+64];
				65: rx_data_48b_in=data_reg[`UNITWIDTH-1+65:0+65];
				default : correct2=1'b0;*/
				endcase
			end
			STATE_321076: begin
				case(pos48)
                                                                                                                              
				0: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+ 0:18+ 0],data_reg[15+ 0:0+ 0]};invalid_boarder=(data_reg[17+ 0:16+ 0]!=2'b10); end
				1: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+ 1:18+ 1],data_reg[15+ 1:0+ 1]};invalid_boarder=(data_reg[17+ 1:16+ 1]!=2'b10); end
				2: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+ 2:18+ 2],data_reg[15+ 2:0+ 2]};invalid_boarder=(data_reg[17+ 2:16+ 2]!=2'b10); end
				3: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+ 3:18+ 3],data_reg[15+ 3:0+ 3]};invalid_boarder=(data_reg[17+ 3:16+ 3]!=2'b10); end
				4: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+ 4:18+ 4],data_reg[15+ 4:0+ 4]};invalid_boarder=(data_reg[17+ 4:16+ 4]!=2'b10); end
				5: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+ 5:18+ 5],data_reg[15+ 5:0+ 5]};invalid_boarder=(data_reg[17+ 5:16+ 5]!=2'b10); end
				6: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+ 6:18+ 6],data_reg[15+ 6:0+ 6]};invalid_boarder=(data_reg[17+ 6:16+ 6]!=2'b10); end
				7: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+ 7:18+ 7],data_reg[15+ 7:0+ 7]};invalid_boarder=(data_reg[17+ 7:16+ 7]!=2'b10); end
				8: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+ 8:18+ 8],data_reg[15+ 8:0+ 8]};invalid_boarder=(data_reg[17+ 8:16+ 8]!=2'b10); end
				9: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+ 9:18+ 9],data_reg[15+ 9:0+ 9]};invalid_boarder=(data_reg[17+ 9:16+ 9]!=2'b10); end
                                                                                                                              
				10: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+10:18+10],data_reg[15+10:0+10]};invalid_boarder=(data_reg[17+10:16+10]!=2'b10); end
				11: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+11:18+11],data_reg[15+11:0+11]};invalid_boarder=(data_reg[17+11:16+11]!=2'b10); end
				12: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+12:18+12],data_reg[15+12:0+12]};invalid_boarder=(data_reg[17+12:16+12]!=2'b10); end
				13: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+13:18+13],data_reg[15+13:0+13]};invalid_boarder=(data_reg[17+13:16+13]!=2'b10); end
				14: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+14:18+14],data_reg[15+14:0+14]};invalid_boarder=(data_reg[17+14:16+14]!=2'b10); end
				15: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+15:18+15],data_reg[15+15:0+15]};invalid_boarder=(data_reg[17+15:16+15]!=2'b10); end
				16: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+16:18+16],data_reg[15+16:0+16]};invalid_boarder=(data_reg[17+16:16+16]!=2'b10); end
				17: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+17:18+17],data_reg[15+17:0+17]};invalid_boarder=(data_reg[17+17:16+17]!=2'b10); end
				18: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+18:18+18],data_reg[15+18:0+18]};invalid_boarder=(data_reg[17+18:16+18]!=2'b10); end
				19: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+19:18+19],data_reg[15+19:0+19]};invalid_boarder=(data_reg[17+19:16+19]!=2'b10); end
                                                                                                                              
				20: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+20:18+20],data_reg[15+20:0+20]};invalid_boarder=(data_reg[17+20:16+20]!=2'b10); end
				21: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+21:18+21],data_reg[15+21:0+21]};invalid_boarder=(data_reg[17+21:16+21]!=2'b10); end
				22: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+22:18+22],data_reg[15+22:0+22]};invalid_boarder=(data_reg[17+22:16+22]!=2'b10); end
				23: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+23:18+23],data_reg[15+23:0+23]};invalid_boarder=(data_reg[17+23:16+23]!=2'b10); end
				24: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+24:18+24],data_reg[15+24:0+24]};invalid_boarder=(data_reg[17+24:16+24]!=2'b10); end
				25: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+25:18+25],data_reg[15+25:0+25]};invalid_boarder=(data_reg[17+25:16+25]!=2'b10); end
				26: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+26:18+26],data_reg[15+26:0+26]};invalid_boarder=(data_reg[17+26:16+26]!=2'b10); end
				27: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+27:18+27],data_reg[15+27:0+27]};invalid_boarder=(data_reg[17+27:16+27]!=2'b10); end
				28: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+28:18+28],data_reg[15+28:0+28]};invalid_boarder=(data_reg[17+28:16+28]!=2'b10); end
				29: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+29:18+29],data_reg[15+29:0+29]};invalid_boarder=(data_reg[17+29:16+29]!=2'b10); end
                                                                                                                              
				30: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+30:18+30],data_reg[15+30:0+30]};invalid_boarder=(data_reg[17+30:16+30]!=2'b10); end
				31: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+31:18+31],data_reg[15+31:0+31]};invalid_boarder=(data_reg[17+31:16+31]!=2'b10); end
				32: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+32:18+32],data_reg[15+32:0+32]};invalid_boarder=(data_reg[17+32:16+32]!=2'b10); end
				33: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+33:18+33],data_reg[15+33:0+33]};invalid_boarder=(data_reg[17+33:16+33]!=2'b10); end
				34: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+34:18+34],data_reg[15+34:0+34]};invalid_boarder=(data_reg[17+34:16+34]!=2'b10); end
				35: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+35:18+35],data_reg[15+35:0+35]};invalid_boarder=(data_reg[17+35:16+35]!=2'b10); end
				36: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+36:18+36],data_reg[15+36:0+36]};invalid_boarder=(data_reg[17+36:16+36]!=2'b10); end
				37: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+37:18+37],data_reg[15+37:0+37]};invalid_boarder=(data_reg[17+37:16+37]!=2'b10); end
				38: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+38:18+38],data_reg[15+38:0+38]};invalid_boarder=(data_reg[17+38:16+38]!=2'b10); end
				39: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+39:18+39],data_reg[15+39:0+39]};invalid_boarder=(data_reg[17+39:16+39]!=2'b10); end
                                                                                                                              
				40: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+40:18+40],data_reg[15+40:0+40]};invalid_boarder=(data_reg[17+40:16+40]!=2'b10); end
				41: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+41:18+41],data_reg[15+41:0+41]};invalid_boarder=(data_reg[17+41:16+41]!=2'b10); end
				42: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+42:18+42],data_reg[15+42:0+42]};invalid_boarder=(data_reg[17+42:16+42]!=2'b10); end
				43: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+43:18+43],data_reg[15+43:0+43]};invalid_boarder=(data_reg[17+43:16+43]!=2'b10); end
				44: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+44:18+44],data_reg[15+44:0+44]};invalid_boarder=(data_reg[17+44:16+44]!=2'b10); end
				45: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+45:18+45],data_reg[15+45:0+45]};invalid_boarder=(data_reg[17+45:16+45]!=2'b10); end
				46: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+46:18+46],data_reg[15+46:0+46]};invalid_boarder=(data_reg[17+46:16+46]!=2'b10); end
				47: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+47:18+47],data_reg[15+47:0+47]};invalid_boarder=(data_reg[17+47:16+47]!=2'b10); end
				48: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+48:18+48],data_reg[15+48:0+48]};invalid_boarder=(data_reg[17+48:16+48]!=2'b10); end
				/*49: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+49:18+49],data_reg[15+49:0+49]};invalid_boarder=(data_reg[17+49:16+49]!=2'b10); end
                                                                                                                              
				50: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+50:18+50],data_reg[15+50:0+50]};invalid_boarder=(data_reg[17+50:16+50]!=2'b10); end
				51: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+51:18+51],data_reg[15+51:0+51]};invalid_boarder=(data_reg[17+51:16+51]!=2'b10); end
				52: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+52:18+52],data_reg[15+52:0+52]};invalid_boarder=(data_reg[17+52:16+52]!=2'b10); end
				53: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+53:18+53],data_reg[15+53:0+53]};invalid_boarder=(data_reg[17+53:16+53]!=2'b10); end
				54: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+54:18+54],data_reg[15+54:0+54]};invalid_boarder=(data_reg[17+54:16+54]!=2'b10); end
				55: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+55:18+55],data_reg[15+55:0+55]};invalid_boarder=(data_reg[17+55:16+55]!=2'b10); end
				56: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+56:18+56],data_reg[15+56:0+56]};invalid_boarder=(data_reg[17+56:16+56]!=2'b10); end
				57: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+57:18+57],data_reg[15+57:0+57]};invalid_boarder=(data_reg[17+57:16+57]!=2'b10); end
				58: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+58:18+58],data_reg[15+58:0+58]};invalid_boarder=(data_reg[17+58:16+58]!=2'b10); end
				59: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+59:18+59],data_reg[15+59:0+59]};invalid_boarder=(data_reg[17+59:16+59]!=2'b10); end
                                                                                                                              
				60: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+60:18+60],data_reg[15+60:0+60]};invalid_boarder=(data_reg[17+60:16+60]!=2'b10); end
				61: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+61:18+61],data_reg[15+61:0+61]};invalid_boarder=(data_reg[17+61:16+61]!=2'b10); end
				62: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+62:18+62],data_reg[15+62:0+62]};invalid_boarder=(data_reg[17+62:16+62]!=2'b10); end
				63: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+63:18+63],data_reg[15+63:0+63]};invalid_boarder=(data_reg[17+63:16+63]!=2'b10); end
				64: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+64:18+64],data_reg[15+64:0+64]};invalid_boarder=(data_reg[17+64:16+64]!=2'b10); end
				65: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+65:18+65],data_reg[15+65:0+65]};invalid_boarder=(data_reg[17+65:16+65]!=2'b10); end
				default : correct2=1'b0;*/
				endcase
			end
			STATE_107654: begin
				case(pos48)
                                                                                                                              
				 0: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+ 0:34+ 0],data_reg[31+ 0:0+ 0]};invalid_boarder=(data_reg[33+ 0:32+ 0]!=2'b10); end
				 1: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+ 1:34+ 1],data_reg[31+ 1:0+ 1]};invalid_boarder=(data_reg[33+ 1:32+ 1]!=2'b10); end
				 2: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+ 2:34+ 2],data_reg[31+ 2:0+ 2]};invalid_boarder=(data_reg[33+ 2:32+ 2]!=2'b10); end
				 3: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+ 3:34+ 3],data_reg[31+ 3:0+ 3]};invalid_boarder=(data_reg[33+ 3:32+ 3]!=2'b10); end
				 4: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+ 4:34+ 4],data_reg[31+ 4:0+ 4]};invalid_boarder=(data_reg[33+ 4:32+ 4]!=2'b10); end
				 5: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+ 5:34+ 5],data_reg[31+ 5:0+ 5]};invalid_boarder=(data_reg[33+ 5:32+ 5]!=2'b10); end
				 6: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+ 6:34+ 6],data_reg[31+ 6:0+ 6]};invalid_boarder=(data_reg[33+ 6:32+ 6]!=2'b10); end
				 7: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+ 7:34+ 7],data_reg[31+ 7:0+ 7]};invalid_boarder=(data_reg[33+ 7:32+ 7]!=2'b10); end
				 8: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+ 8:34+ 8],data_reg[31+ 8:0+ 8]};invalid_boarder=(data_reg[33+ 8:32+ 8]!=2'b10); end
				 9: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+ 9:34+ 9],data_reg[31+ 9:0+ 9]};invalid_boarder=(data_reg[33+ 9:32+ 9]!=2'b10); end
                                                                                                                              
				10: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+10:34+10],data_reg[31+10:0+10]};invalid_boarder=(data_reg[33+10:32+10]!=2'b10); end
				11: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+11:34+11],data_reg[31+11:0+11]};invalid_boarder=(data_reg[33+11:32+11]!=2'b10); end
				12: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+12:34+12],data_reg[31+12:0+12]};invalid_boarder=(data_reg[33+12:32+12]!=2'b10); end
				13: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+13:34+13],data_reg[31+13:0+13]};invalid_boarder=(data_reg[33+13:32+13]!=2'b10); end
				14: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+14:34+14],data_reg[31+14:0+14]};invalid_boarder=(data_reg[33+14:32+14]!=2'b10); end
				15: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+15:34+15],data_reg[31+15:0+15]};invalid_boarder=(data_reg[33+15:32+15]!=2'b10); end
				16: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+16:34+16],data_reg[31+16:0+16]};invalid_boarder=(data_reg[33+16:32+16]!=2'b10); end
				17: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+17:34+17],data_reg[31+17:0+17]};invalid_boarder=(data_reg[33+17:32+17]!=2'b10); end
				18: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+18:34+18],data_reg[31+18:0+18]};invalid_boarder=(data_reg[33+18:32+18]!=2'b10); end
				19: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+19:34+19],data_reg[31+19:0+19]};invalid_boarder=(data_reg[33+19:32+19]!=2'b10); end
                                                                                                                              
				20: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+20:34+20],data_reg[31+20:0+20]};invalid_boarder=(data_reg[33+20:32+20]!=2'b10); end
				21: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+21:34+21],data_reg[31+21:0+21]};invalid_boarder=(data_reg[33+21:32+21]!=2'b10); end
				22: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+22:34+22],data_reg[31+22:0+22]};invalid_boarder=(data_reg[33+22:32+22]!=2'b10); end
				23: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+23:34+23],data_reg[31+23:0+23]};invalid_boarder=(data_reg[33+23:32+23]!=2'b10); end
				24: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+24:34+24],data_reg[31+24:0+24]};invalid_boarder=(data_reg[33+24:32+24]!=2'b10); end
				25: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+25:34+25],data_reg[31+25:0+25]};invalid_boarder=(data_reg[33+25:32+25]!=2'b10); end
				26: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+26:34+26],data_reg[31+26:0+26]};invalid_boarder=(data_reg[33+26:32+26]!=2'b10); end
				27: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+27:34+27],data_reg[31+27:0+27]};invalid_boarder=(data_reg[33+27:32+27]!=2'b10); end
				28: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+28:34+28],data_reg[31+28:0+28]};invalid_boarder=(data_reg[33+28:32+28]!=2'b10); end
				29: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+29:34+29],data_reg[31+29:0+29]};invalid_boarder=(data_reg[33+29:32+29]!=2'b10); end
                                                                                                                              
				30: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+30:34+30],data_reg[31+30:0+30]};invalid_boarder=(data_reg[33+30:32+30]!=2'b10); end
				31: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+31:34+31],data_reg[31+31:0+31]};invalid_boarder=(data_reg[33+31:32+31]!=2'b10); end
				32: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+32:34+32],data_reg[31+32:0+32]};invalid_boarder=(data_reg[33+32:32+32]!=2'b10); end
				33: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+33:34+33],data_reg[31+33:0+33]};invalid_boarder=(data_reg[33+33:32+33]!=2'b10); end
				34: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+34:34+34],data_reg[31+34:0+34]};invalid_boarder=(data_reg[33+34:32+34]!=2'b10); end
				35: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+35:34+35],data_reg[31+35:0+35]};invalid_boarder=(data_reg[33+35:32+35]!=2'b10); end
				36: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+36:34+36],data_reg[31+36:0+36]};invalid_boarder=(data_reg[33+36:32+36]!=2'b10); end
				37: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+37:34+37],data_reg[31+37:0+37]};invalid_boarder=(data_reg[33+37:32+37]!=2'b10); end
				38: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+38:34+38],data_reg[31+38:0+38]};invalid_boarder=(data_reg[33+38:32+38]!=2'b10); end
				39: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+39:34+39],data_reg[31+39:0+39]};invalid_boarder=(data_reg[33+39:32+39]!=2'b10); end
                                                                                                                              
				40: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+40:34+40],data_reg[31+40:0+40]};invalid_boarder=(data_reg[33+40:32+40]!=2'b10); end
				41: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+41:34+41],data_reg[31+41:0+41]};invalid_boarder=(data_reg[33+41:32+41]!=2'b10); end
				42: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+42:34+42],data_reg[31+42:0+42]};invalid_boarder=(data_reg[33+42:32+42]!=2'b10); end
				43: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+43:34+43],data_reg[31+43:0+43]};invalid_boarder=(data_reg[33+43:32+43]!=2'b10); end
				44: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+44:34+44],data_reg[31+44:0+44]};invalid_boarder=(data_reg[33+44:32+44]!=2'b10); end
				45: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+45:34+45],data_reg[31+45:0+45]};invalid_boarder=(data_reg[33+45:32+45]!=2'b10); end
				46: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+46:34+46],data_reg[31+46:0+46]};invalid_boarder=(data_reg[33+46:32+46]!=2'b10); end
				47: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+47:34+47],data_reg[31+47:0+47]};invalid_boarder=(data_reg[33+47:32+47]!=2'b10); end
				48: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+48:34+48],data_reg[31+48:0+48]};invalid_boarder=(data_reg[33+48:32+48]!=2'b10); end
				/*49: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+49:34+49],data_reg[31+49:0+49]};invalid_boarder=(data_reg[33+49:32+49]!=2'b10); end
                                                                                                                              
				50: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+50:34+50],data_reg[31+50:0+50]};invalid_boarder=(data_reg[33+50:32+50]!=2'b10); end
				51: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+51:34+51],data_reg[31+51:0+51]};invalid_boarder=(data_reg[33+51:32+51]!=2'b10); end
				52: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+52:34+52],data_reg[31+52:0+52]};invalid_boarder=(data_reg[33+52:32+52]!=2'b10); end
				53: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+53:34+53],data_reg[31+53:0+53]};invalid_boarder=(data_reg[33+53:32+53]!=2'b10); end
				54: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+54:34+54],data_reg[31+54:0+54]};invalid_boarder=(data_reg[33+54:32+54]!=2'b10); end
				55: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+55:34+55],data_reg[31+55:0+55]};invalid_boarder=(data_reg[33+55:32+55]!=2'b10); end
				56: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+56:34+56],data_reg[31+56:0+56]};invalid_boarder=(data_reg[33+56:32+56]!=2'b10); end
				57: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+57:34+57],data_reg[31+57:0+57]};invalid_boarder=(data_reg[33+57:32+57]!=2'b10); end
				58: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+58:34+58],data_reg[31+58:0+58]};invalid_boarder=(data_reg[33+58:32+58]!=2'b10); end
				59: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+59:34+59],data_reg[31+59:0+59]};invalid_boarder=(data_reg[33+59:32+59]!=2'b10); end
                                                                                                                              
				60: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+60:34+60],data_reg[31+60:0+60]};invalid_boarder=(data_reg[33+60:32+60]!=2'b10); end
				61: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+61:34+61],data_reg[31+61:0+61]};invalid_boarder=(data_reg[33+61:32+61]!=2'b10); end
				62: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+62:34+62],data_reg[31+62:0+62]};invalid_boarder=(data_reg[33+62:32+62]!=2'b10); end
				63: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+63:34+63],data_reg[31+63:0+63]};invalid_boarder=(data_reg[33+63:32+63]!=2'b10); end
				64: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+64:34+64],data_reg[31+64:0+64]};invalid_boarder=(data_reg[33+64:32+64]!=2'b10); end
				65: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+2+65:34+65],data_reg[31+65:0+65]};invalid_boarder=(data_reg[33+65:32+65]!=2'b10); end
				default : correct2=1'b0;*/
				endcase
			end
			STATE_765432: begin
				case(pos48)
                                                                                                             
				 0: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+ 0:0+ 0]};invalid_boarder=(data_reg[`UNITWIDTH+1+ 0:`UNITWIDTH+ 0]!=2'b01); end
				 1: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+ 1:0+ 1]};invalid_boarder=(data_reg[`UNITWIDTH+1+ 1:`UNITWIDTH+ 1]!=2'b01); end
				 2: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+ 2:0+ 2]};invalid_boarder=(data_reg[`UNITWIDTH+1+ 2:`UNITWIDTH+ 2]!=2'b01); end
				 3: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+ 3:0+ 3]};invalid_boarder=(data_reg[`UNITWIDTH+1+ 3:`UNITWIDTH+ 3]!=2'b01); end
				 4: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+ 4:0+ 4]};invalid_boarder=(data_reg[`UNITWIDTH+1+ 4:`UNITWIDTH+ 4]!=2'b01); end
				 5: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+ 5:0+ 5]};invalid_boarder=(data_reg[`UNITWIDTH+1+ 5:`UNITWIDTH+ 5]!=2'b01); end
				 6: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+ 6:0+ 6]};invalid_boarder=(data_reg[`UNITWIDTH+1+ 6:`UNITWIDTH+ 6]!=2'b01); end
				 7: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+ 7:0+ 7]};invalid_boarder=(data_reg[`UNITWIDTH+1+ 7:`UNITWIDTH+ 7]!=2'b01); end
				 8: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+ 8:0+ 8]};invalid_boarder=(data_reg[`UNITWIDTH+1+ 8:`UNITWIDTH+ 8]!=2'b01); end
				 9: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+ 9:0+ 9]};invalid_boarder=(data_reg[`UNITWIDTH+1+ 9:`UNITWIDTH+ 9]!=2'b01); end
                                                                                                             
				10: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+10:0+10]};invalid_boarder=(data_reg[`UNITWIDTH+1+10:`UNITWIDTH+10]!=2'b01); end
				11: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+11:0+11]};invalid_boarder=(data_reg[`UNITWIDTH+1+11:`UNITWIDTH+11]!=2'b01); end
				12: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+12:0+12]};invalid_boarder=(data_reg[`UNITWIDTH+1+12:`UNITWIDTH+12]!=2'b01); end
				13: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+13:0+13]};invalid_boarder=(data_reg[`UNITWIDTH+1+13:`UNITWIDTH+13]!=2'b01); end
				14: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+14:0+14]};invalid_boarder=(data_reg[`UNITWIDTH+1+14:`UNITWIDTH+14]!=2'b01); end
				15: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+15:0+15]};invalid_boarder=(data_reg[`UNITWIDTH+1+15:`UNITWIDTH+15]!=2'b01); end
				16: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+16:0+16]};invalid_boarder=(data_reg[`UNITWIDTH+1+16:`UNITWIDTH+16]!=2'b01); end
				17: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+17:0+17]};invalid_boarder=(data_reg[`UNITWIDTH+1+17:`UNITWIDTH+17]!=2'b01); end
				18: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+18:0+18]};invalid_boarder=(data_reg[`UNITWIDTH+1+18:`UNITWIDTH+18]!=2'b01); end
				19: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+19:0+19]};invalid_boarder=(data_reg[`UNITWIDTH+1+19:`UNITWIDTH+19]!=2'b01); end
                                                                                                              				  
				20: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+20:0+20]};invalid_boarder=(data_reg[`UNITWIDTH+1+20:`UNITWIDTH+20]!=2'b01); end
				21: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+21:0+21]};invalid_boarder=(data_reg[`UNITWIDTH+1+21:`UNITWIDTH+21]!=2'b01); end
				22: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+22:0+22]};invalid_boarder=(data_reg[`UNITWIDTH+1+22:`UNITWIDTH+22]!=2'b01); end
				23: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+23:0+23]};invalid_boarder=(data_reg[`UNITWIDTH+1+23:`UNITWIDTH+23]!=2'b01); end
				24: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+24:0+24]};invalid_boarder=(data_reg[`UNITWIDTH+1+24:`UNITWIDTH+24]!=2'b01); end
				25: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+25:0+25]};invalid_boarder=(data_reg[`UNITWIDTH+1+25:`UNITWIDTH+25]!=2'b01); end
				26: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+26:0+26]};invalid_boarder=(data_reg[`UNITWIDTH+1+26:`UNITWIDTH+26]!=2'b01); end
				27: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+27:0+27]};invalid_boarder=(data_reg[`UNITWIDTH+1+27:`UNITWIDTH+27]!=2'b01); end
				28: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+28:0+28]};invalid_boarder=(data_reg[`UNITWIDTH+1+28:`UNITWIDTH+28]!=2'b01); end
				29: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+29:0+29]};invalid_boarder=(data_reg[`UNITWIDTH+1+29:`UNITWIDTH+29]!=2'b01); end
                                                                                                             
				30: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+30:0+30]};invalid_boarder=(data_reg[`UNITWIDTH+1+30:`UNITWIDTH+30]!=2'b01); end
				31: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+31:0+31]};invalid_boarder=(data_reg[`UNITWIDTH+1+31:`UNITWIDTH+31]!=2'b01); end
				32: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+32:0+32]};invalid_boarder=(data_reg[`UNITWIDTH+1+32:`UNITWIDTH+32]!=2'b01); end
				33: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+33:0+33]};invalid_boarder=(data_reg[`UNITWIDTH+1+33:`UNITWIDTH+33]!=2'b01); end
				34: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+34:0+34]};invalid_boarder=(data_reg[`UNITWIDTH+1+34:`UNITWIDTH+34]!=2'b01); end
				35: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+35:0+35]};invalid_boarder=(data_reg[`UNITWIDTH+1+35:`UNITWIDTH+35]!=2'b01); end
				36: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+36:0+36]};invalid_boarder=(data_reg[`UNITWIDTH+1+36:`UNITWIDTH+36]!=2'b01); end
				37: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+37:0+37]};invalid_boarder=(data_reg[`UNITWIDTH+1+37:`UNITWIDTH+37]!=2'b01); end
				38: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+38:0+38]};invalid_boarder=(data_reg[`UNITWIDTH+1+38:`UNITWIDTH+38]!=2'b01); end
				39: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+39:0+39]};invalid_boarder=(data_reg[`UNITWIDTH+1+39:`UNITWIDTH+39]!=2'b01); end
                                                                                                             
				40: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+40:0+40]};invalid_boarder=(data_reg[`UNITWIDTH+1+40:`UNITWIDTH+40]!=2'b01); end
				41: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+41:0+41]};invalid_boarder=(data_reg[`UNITWIDTH+1+41:`UNITWIDTH+41]!=2'b01); end
				42: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+42:0+42]};invalid_boarder=(data_reg[`UNITWIDTH+1+42:`UNITWIDTH+42]!=2'b01); end
				43: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+43:0+43]};invalid_boarder=(data_reg[`UNITWIDTH+1+43:`UNITWIDTH+43]!=2'b01); end
				44: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+44:0+44]};invalid_boarder=(data_reg[`UNITWIDTH+1+44:`UNITWIDTH+44]!=2'b01); end
				45: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+45:0+45]};invalid_boarder=(data_reg[`UNITWIDTH+1+45:`UNITWIDTH+45]!=2'b01); end
				46: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+46:0+46]};invalid_boarder=(data_reg[`UNITWIDTH+1+46:`UNITWIDTH+46]!=2'b01); end
				47: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+47:0+47]};invalid_boarder=(data_reg[`UNITWIDTH+1+47:`UNITWIDTH+47]!=2'b01); end
				48: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+48:0+48]};invalid_boarder=(data_reg[`UNITWIDTH+1+48:`UNITWIDTH+48]!=2'b01); end
				/*49: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+49:0+49]};invalid_boarder=(data_reg[`UNITWIDTH+1+49:`UNITWIDTH+49]!=2'b01); end
                                                                                                             
				50: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+50:0+50]};invalid_boarder=(data_reg[`UNITWIDTH+1+50:`UNITWIDTH+50]!=2'b01); end
				51: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+51:0+51]};invalid_boarder=(data_reg[`UNITWIDTH+1+51:`UNITWIDTH+51]!=2'b01); end
				52: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+52:0+52]};invalid_boarder=(data_reg[`UNITWIDTH+1+52:`UNITWIDTH+52]!=2'b01); end
				53: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+53:0+53]};invalid_boarder=(data_reg[`UNITWIDTH+1+53:`UNITWIDTH+53]!=2'b01); end
				54: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+54:0+54]};invalid_boarder=(data_reg[`UNITWIDTH+1+54:`UNITWIDTH+54]!=2'b01); end
				55: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+55:0+55]};invalid_boarder=(data_reg[`UNITWIDTH+1+55:`UNITWIDTH+55]!=2'b01); end
				56: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+56:0+56]};invalid_boarder=(data_reg[`UNITWIDTH+1+56:`UNITWIDTH+56]!=2'b01); end
				57: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+57:0+57]};invalid_boarder=(data_reg[`UNITWIDTH+1+57:`UNITWIDTH+57]!=2'b01); end
				58: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+58:0+58]};invalid_boarder=(data_reg[`UNITWIDTH+1+58:`UNITWIDTH+58]!=2'b01); end
				59: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+59:0+59]};invalid_boarder=(data_reg[`UNITWIDTH+1+59:`UNITWIDTH+59]!=2'b01); end
                                                                                                             
				60: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+60:0+60]};invalid_boarder=(data_reg[`UNITWIDTH+1+60:`UNITWIDTH+60]!=2'b01); end
				61: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+61:0+61]};invalid_boarder=(data_reg[`UNITWIDTH+1+61:`UNITWIDTH+61]!=2'b01); end
				62: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+62:0+62]};invalid_boarder=(data_reg[`UNITWIDTH+1+62:`UNITWIDTH+62]!=2'b01); end
				63: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+63:0+63]};invalid_boarder=(data_reg[`UNITWIDTH+1+63:`UNITWIDTH+63]!=2'b01); end
				64: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+64:0+64]};invalid_boarder=(data_reg[`UNITWIDTH+1+64:`UNITWIDTH+64]!=2'b01); end
				65: begin rx_data_48b_in={data_reg[`UNITWIDTH-1+65:0+65]};invalid_boarder=(data_reg[`UNITWIDTH+1+65:`UNITWIDTH+65]!=2'b01); end
				default : correct2=1'b0;*/
				endcase
			end
			endcase
end

reg [11:0] cnt_valid66;
always @(posedge clk) begin
	if(!reset_n)  cnt_valid66<=0;
	else if(in_enable) begin
		if(block_lock_pre==1'b0) cnt_valid66<=0;
		else if(invalid_boarder) cnt_valid66<=0;
		else if(cnt_valid66 >=1023) cnt_valid66<=cnt_valid66;
		else cnt_valid66<=cnt_valid66+1;
	end
end
assign block_lock=(cnt_valid66 >=1023);
wire correct = correct1;



`ifdef PCS_SIM
assert_always #(`OVL_FATAL) inst_assert_0(clk,reset_n,correct);
`endif
endmodule
