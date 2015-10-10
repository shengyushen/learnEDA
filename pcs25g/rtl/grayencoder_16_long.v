module grayencoder_16_long(clk,reset_n,inp,outp);
input clk;
input reset_n;

input	[4:0]	inp;
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


always @(*) begin
	case(inp)
	5'd0 : outp=G0;
	5'd1 : outp=G1;
	5'd2 : outp=G2;
	5'd3 : outp=G3;
	5'd4 : outp=G4;
	5'd5 : outp=G5;
	5'd6 : outp=G6;
	5'd7 : outp=G7;
	5'd8 : outp=G8;
	5'd9 : outp=G9;
	5'd10 : outp=G10;
	5'd11 : outp=G11;
	5'd12 : outp=G12;
	5'd13 : outp=G13;
	5'd14 : outp=G14;
	default: outp=G15;
	endcase
end


endmodule
