module graydecoder_16_long(clk,reset_n,inp,outp);
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
	G0 : outp=5'd0;
	G1 : outp=5'd1;
	G2 : outp=5'd2;
	G3 : outp=5'd3;
	G4 : outp=5'd4;
	G5 : outp=5'd5;
	G6 : outp=5'd6;
	G7 : outp=5'd7;
	G8 : outp=5'd8;
	G9 : outp=5'd9;
	G10 : outp=5'd10;
	G11 : outp=5'd11;
	G12 : outp=5'd12;
	G13 : outp=5'd13;
	G14 : outp=5'd14;
	default: outp=5'd15;
	endcase
end


endmodule
