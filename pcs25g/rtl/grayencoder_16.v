module grayencoder_16(inp,outp);
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
parameter G10=4'b1111;
parameter G11=4'b1110;
parameter G12=4'b1010;
parameter G13=4'b1011;
parameter G14=4'b1001;
parameter G15=4'b1000;

always @(*) begin
	case(inp)
	4'b0000: outp=G0 ;
	4'b0001: outp=G1 ;
	4'b0010: outp=G2 ;
	4'b0011: outp=G3 ;
	4'b0100: outp=G4 ;
	4'b0101: outp=G5 ;
	4'b0110: outp=G6 ;
	4'b0111: outp=G7 ;
	4'b1000: outp=G8 ;
	4'b1001: outp=G9 ;
	4'b1010: outp=G10;
	4'b1011: outp=G11;
	4'b1100: outp=G12;
	4'b1101: outp=G13;
	4'b1110: outp=G14;
	default: outp=G15;
	endcase
end

endmodule
