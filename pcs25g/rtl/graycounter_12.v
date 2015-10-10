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



endmodule
