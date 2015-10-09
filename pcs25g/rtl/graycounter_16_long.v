module graycounter_16_long(clk,reset_n,inp,enable,outp);
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

parameter G8 =5'b01100;
parameter G9 =5'b01101;
parameter G10=5'b01111;
parameter G11=5'b01110;
parameter G12=5'b01010;
parameter G13=5'b01011;
parameter G14=5'b01001;
parameter G15=5'b01000;


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
			G7 : outp<=G8;
			G8 : outp<=G9;
			G9 : outp<=G10;
			G10: outp<=G11;
			G11: outp<=G12;
			G12: outp<=G13;
			G13: outp<=G14;
			G14: outp<=G15;
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
	5'd7: outp1=G7 ;
	5'd8: outp1=G8 ;
	5'd9: outp1=G9 ;
	5'd10: outp1=G10 ;
	5'd11: outp1=G11 ;
	5'd12: outp1=G12 ;
	5'd13: outp1=G13 ;
	5'd14: outp1=G14 ;
	default: outp1=G15 ;
	endcase
end

assert_always #(`OVL_FATAL) inst_assert_0(clk,reset_n,(outp1==outp));
`endif

endmodule
