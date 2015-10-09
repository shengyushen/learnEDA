module grayencoder_6(clk,reset_n,inp,outp);
input clk;
input reset_n;

input	[3:0]	inp;
output	[3:0]	outp;
reg	[3:0]	outp;

parameter G0 =4'b0000;
parameter G1 =4'b0001;
parameter G2 =4'b0011;
parameter G3 =4'b0010;
parameter G4 =4'b0110;
parameter G5 =4'b0100;

always @(*) begin
	case(inp)
	4'd0: outp=G0 ;
	4'd1: outp=G1 ;
	4'd2: outp=G2 ;
	4'd3: outp=G3 ;
	4'd4: outp=G4 ;
	default: outp=G5 ;
	endcase
end

`ifdef PCS_SIM
reg	[3:0]	last_outp;
always @(posedge clk) begin
	last_outp<=outp;
end
reg	correct;
always @(*) begin
	case(outp)
	G0 : correct=(last_outp==outp || last_outp==G5);
	G1 : correct=(last_outp==outp || last_outp==G0);
	G2 : correct=(last_outp==outp || last_outp==G1);
	G3 : correct=(last_outp==outp || last_outp==G2);
	G4 : correct=(last_outp==outp || last_outp==G3);
	default : correct=(last_outp==outp || last_outp==G4) && (inp==5);
	endcase
end

assert_always #(`OVL_FATAL) inst_assert_0(clk,reset_n,correct);
`endif

endmodule
