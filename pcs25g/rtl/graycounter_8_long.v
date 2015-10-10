module graycounter_8_long(clk,reset_n,inp,enable,outp);
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
			default: outp<=G0;
			endcase
		end
	end
end

endmodule
