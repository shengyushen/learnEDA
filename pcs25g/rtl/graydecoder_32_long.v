module graydecoder_32_long(clk,reset_n,inp,outp);
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

parameter G16=5'b11000;
parameter G17=5'b11001;
parameter G18=5'b11011;
parameter G19=5'b11010;
parameter G20=5'b11110;
parameter G21=5'b11111;
parameter G22=5'b11101;
parameter G23=5'b11100;

parameter G24=5'b10100;
parameter G25=5'b10101;
parameter G26=5'b10111;
parameter G27=5'b10110;
parameter G28=5'b10010;
parameter G29=5'b10011;
parameter G30=5'b10001;
parameter G31=5'b10000;

always @(*) begin
	case(inp)
	G0  : outp=5'd0 ;
	G1  : outp=5'd1 ;
	G2  : outp=5'd2 ;
	G3  : outp=5'd3 ;
	G4  : outp=5'd4 ;
	G5  : outp=5'd5 ;
	G6  : outp=5'd6 ;
	G7  : outp=5'd7 ;

	G8  : outp=5'd8 ;
	G9  : outp=5'd9 ;
	G10 : outp=5'd10;
	G11 : outp=5'd11;
	G12 : outp=5'd12;
	G13 : outp=5'd13;
	G14 : outp=5'd14;
	G15 : outp=5'd15;

	G16 : outp=5'd16;
	G17 : outp=5'd17;
	G18 : outp=5'd18;
	G19 : outp=5'd19;
	G20 : outp=5'd20;
	G21 : outp=5'd21;
	G22 : outp=5'd22;
	G23 : outp=5'd23;

	G24 : outp=5'd24;
	G25 : outp=5'd25;
	G26 : outp=5'd26;
	G27 : outp=5'd27;
	G28 : outp=5'd28;
	G29 : outp=5'd29;
	G30 : outp=5'd30;

	default: outp=5'd31;
	endcase
end


endmodule
