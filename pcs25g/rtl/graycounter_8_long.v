module graycounter_8_long(clk,reset_n,inp,enable,outp);
input clk;
input reset_n;

input	[4:0]	inp;
input		enable;
output	[4:0]	outp;
reg	[4:0]	outp;

parameter G0 =5'b00000;
parameter G1 =5'b00001;
parameter G2 =5'b00011;
parameter G3 =5'b00010;
parameter G4 =5'b00110;
parameter G5 =5'b00111;
parameter G6 =5'b00101;
parameter G7 =5'b00100;

always @(posedge clk)  begin
	if(!reset_n) begin
		outp<=G0;
	end
	else begin
		if(enable) begin
			case(outp)
			G0 : outp<=G1;
			G1 : outp<=G2;
			G2 : outp<=G3;
			G3 : outp<=G4;
			G4 : outp<=G5;
			G5 : outp<=G6;
			G6 : outp<=G7;
			default: outp<=G0;
			endcase
		end
	end
end

`ifdef PCS_SIM
reg	[4:0]	outp1;
always @(*) begin
	case(inp)
	5'd0: outp1=G0 ;
	5'd1: outp1=G1 ;
	5'd2: outp1=G2 ;
	5'd3: outp1=G3 ;
	5'd4: outp1=G4 ;
	5'd5: outp1=G5 ;
	5'd6: outp1=G6 ;
	default: outp1=G7 ;
	endcase
end

assert_always #(`OVL_FATAL) inst_assert_0(clk,reset_n,(outp1==outp));
`endif

endmodule
