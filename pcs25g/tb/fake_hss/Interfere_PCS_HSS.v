`resetall
`timescale 1ns/1ps

//this module is to generate random data error (from PCS to HSS)




module Interfere_PCS_HSS(
                    	clk,
                    	Rst,
                    	
                    	Din,
                    	Dout
                    	);

input			clk;
input              	Rst;

input[`DATAWIDTH_PCS-1:0]        	Din;
output[`DATAWIDTH_PCS-1:0]       	Dout;


parameter INTERFERE_MASK_MSB_A	=   4'd15;
parameter	INTERFERE_MASK_LSB_A	= 	4'd0;
parameter	INTERFERE_MASK_A	  	= 	16'hffff;                           //for E-7 errors injection if inject_error_number is 3,this value is about e4e1c for [19:0] if inject_error_number is 1,this value is about 4c4b4 for [18:0]

	
parameter	INTERFERE_MASK_MSB_B	= 	4'd13;
parameter	INTERFERE_MASK_LSB_B	= 	4'd0;
parameter	INTERFERE_MASK_B		  =  	14'h3fff;                             ////about one data error per 12000 ns

	
	reg[19:0]          	RandomD;
	always @(posedge clk or Rst)   
	begin
		if (Rst) 
		begin
			RandomD = 0;
		end
		else
		begin 
			RandomD = $random % 20'hfffff;
		end
	end

	wire   lost;
	wire   bit_error;
	/*assign GenErr = (Interfere_flag == 2'b01) ? (RandomD[INTERFERE_MASK_MSB_A:INTERFERE_MASK_LSB_A]==INTERFERE_MASK_A) :
				 (Interfere_flag == 2'b10) ? (RandomD[INTERFERE_MASK_MSB_B:INTERFERE_MASK_LSB_B]== INTERFERE_MASK_B) :
				 						1'b0;*/
assign bit_error = (`Error_PCS_HSS) ? (RandomD[INTERFERE_MASK_MSB_A:INTERFERE_MASK_LSB_A]==INTERFERE_MASK_A) :1'b0;
assign lost =       (`Lost_PCS_HSS) ? (RandomD[INTERFERE_MASK_MSB_B:INTERFERE_MASK_LSB_B]==INTERFERE_MASK_B) :1'b0;
	
	
	reg[`DATAWIDTH_PCS-1:0]         	Dout;
	always @(posedge clk or Rst)   
	begin
		if (Rst) 
		begin
			Dout <={`DATAWIDTH_PCS{1'b0}}; 
		end
		else
		begin 
			if (lost) 
			begin
				Dout <={`DATAWIDTH_PCS{1'b0}}; 
				$display("PHY layer Lost data:%h at time %d",Din,$time);
				
			end
			else if(bit_error)
			   begin
				  Dout <={~Din[`DATAWIDTH_PCS-1],Din[`DATAWIDTH_PCS-2:2],~Din[1],~Din[0]}; 
				  $display("PHY layer insert bit error of data:%h at time %d",Din,$time);
				
			   end
		 else
			begin
				Dout <= Din;
			end
		end
	end

endmodule
