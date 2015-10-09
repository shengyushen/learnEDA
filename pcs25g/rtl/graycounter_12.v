module graycounter_12(clk,reset_n,inp,enable,outp);
input clk;
input reset_n;

input	[3:0]	inp;
input		enable;
output	[3:0]	outp;
reg	[3:0]	outp;

parameter G0 =4'b0000;
parameter G1 =4'b0001;
parameter G2 =4'b0011;
parameter G3 =4'b0010;
parameter G4 =4'b0110;
parameter G5 =4'b0111;
parameter G6 =4'b0101;
parameter G7 =4'b0100;

parameter G8 =4'b1100;
parameter G9 =4'b1101;
parameter G10=4'b1001;
parameter G11=4'b1000;

always @(posedge clk)  begin
	if(!reset_n) begin
		outp<=G0;
	end
	else begin
		if(enable) begin
			case(outp)
			G0 : outp<=G1 ;
			G1 : outp<=G2 ;
			G2 : outp<=G3 ;
			G3 : outp<=G4 ;
			G4 : outp<=G5 ;
			G5 : outp<=G6 ;
			G6 : outp<=G7 ;
			G7 : outp<=G8 ;
			G8 : outp<=G9 ;
			G9 : outp<=G10;
			G10: outp<=G11;
			default: outp<=G0;
			endcase
		end
	end
end

`ifdef PCS_SIM
reg	[3:0]	outp1;
always @(*) begin
	case(inp)
     4'd0    : outp1=G0 ;
     4'd1    : outp1=G1 ;
     4'd2    : outp1=G2 ;
     4'd3    : outp1=G3 ;
     4'd4    : outp1=G4 ;
     4'd5    : outp1=G5 ;
     4'd6    : outp1=G6 ;
     4'd7    : outp1=G7 ;
     4'd8    : outp1=G8 ;
     4'd9    : outp1=G9 ;
     4'd10   : outp1=G10;
	default: outp1=G11;
	endcase
end
assert_always #(`OVL_FATAL) inst_assert_0(clk,reset_n,(outp1==outp));
`endif


endmodule
