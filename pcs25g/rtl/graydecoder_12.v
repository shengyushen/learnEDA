module graydecoder_12(clk,reset_n,inp,outp);
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
parameter G5 =4'b0111;
parameter G6 =4'b0101;
parameter G7 =4'b0100;

parameter G8 =4'b1100;
parameter G9 =4'b1101;
parameter G10=4'b1001;
parameter G11=4'b1000;

always @(*) begin
	case(inp)
	G0 : outp=4'd0;
	G1 : outp=4'd1;
	G2 : outp=4'd2 ;
	G3 : outp=4'd3 ;
	G4 : outp=4'd4 ;
	G5 : outp=4'd5 ;
	G6 : outp=4'd6 ;
	G7 : outp=4'd7 ;
	G8 : outp=4'd8 ;
	G9 : outp=4'd9 ;
	G10: outp=4'd10;
	default: outp=4'd11;
	endcase
end


endmodule
