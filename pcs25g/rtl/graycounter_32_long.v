module graycounter_32_long(clk,reset_n,inp,enable,outp);
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
			G15: outp<=G16;
			
			G16: outp<=G17;
			G17: outp<=G18;
			G18: outp<=G19;
			G19: outp<=G20;
			G20: outp<=G21;
			G21: outp<=G22;
			G22: outp<=G23;
			G23: outp<=G24;
				    
			G24: outp<=G25;
			G25: outp<=G26;
			G26: outp<=G27;
			G27: outp<=G28;
			G28: outp<=G29;
			G29: outp<=G30;
			G30: outp<=G31;

			default: outp<=G0;
			endcase
		end
	end
end


endmodule
