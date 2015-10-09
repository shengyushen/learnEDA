`resetall
`timescale 1ns/1fs





module HSSLane_20 (
              Rst     ,             
              TXD ,
              TXDCLK  ,
              RXD  ,
              RXDCLK  ,
              PhyOutP ,
              PhyOutN ,
              //DSYN    ,
              PhyInP  ,
              PhyInN 
             );
             
input       Rst     ;
input[`DATAWIDTH_PCS-1:0]  TXD ;
output      TXDCLK  ;
output[`DATAWIDTH_PCS-1:0] RXD  ;
output      RXDCLK  ;
output      PhyOutP ;
output      PhyOutN ;
//input       DSYN    ;
input       PhyInP  ;
input       PhyInN ;

/**************************************************define TXDCLK RXDCLK PHYCLK**********************************************/

reg    TXDCLK;
reg    RXDCLK;
parameter	PMA_CYC=1.426;	    //14G slow version: 1.428  1.426   
//parameter	PMA_CYC=1.667;	    //600M
//parameter	PMA_CYC=2.001;	    //500M  10G
// the PMA clk will be 2 times the HSSREFCLK
initial 
	begin
	  TXDCLK = 0;
    forever   begin   #(PMA_CYC/2)  TXDCLK=!TXDCLK ;   end
	end


initial 
	begin
	  RXDCLK = 0;
    forever   begin   #(PMA_CYC/2)  RXDCLK=!RXDCLK ;   end
	end

// the PHYCLK clk will be (`DATAWIDTH_PCS) times the PMA clk
reg    PHYCLK;
initial 
	begin
	 	PHYCLK = 0;
    forever   begin  #(PMA_CYC/(`DATAWIDTH_PCS*2))  PHYCLK=!PHYCLK ;   end
	end

/*******************************************implement serial function********************************************/

reg[`DATAWIDTH_PCS-1:0] PFromPCS;    //under TXDCLK
reg[`DATAWIDTH_PCS-1:0]  FromPCS;   //under PHYCLK
wire [`DATAWIDTH_PCS-1:0] PCSOutD;
always @(posedge  TXDCLK or Rst)    //under TXDCLK
begin
	  if (Rst)  PFromPCS <= 0;
	  else 	  PFromPCS <= PCSOutD;
	  				
	  			
end

reg chg;    //It's time to load 32bits data to FromPCS register
always @(posedge chg or Rst)
begin
	  if (Rst)  FromPCS <= 0;
	  else FromPCS <= PFromPCS;
end

reg[4:0] RdPtr;
always @(posedge PHYCLK or  Rst)
begin
	 if (Rst) begin RdPtr <= 0; chg <= 0; end
	 else 
 		begin
 			if (RdPtr==(`DATAWIDTH_PCS-1)) 
 				begin RdPtr <= 0; chg <= 1;    end
 			else 	begin RdPtr <= RdPtr + 1; chg <= 0; end
 		end
end	 			



/*********************************************Link down***************************************************/

parameter CYC=10;
reg clk;
	initial 
	begin
		clk=1;
		forever 
			#(CYC/2) clk=!clk;
	end

parameter MASK_MSB	=   4'd11;
parameter	MASK_LSB	=   4'd0;
parameter	MASK  	=   12'hfff;   
                  
reg PhyOutP;
reg PhyOutP_delay;
reg[31:0]       RandomD;
reg[63:0]       DownTime;
wire  		 Link_down;

assign Link_down = (`LinkDown) ? (RandomD[MASK_MSB:MASK_LSB]== MASK) :  1'b0;
always @(PhyOutP_delay) begin PhyOutP <= (DownTime>0&&DownTime<`DOWNTIME) ?1'b0:PhyOutP_delay; end

	always @(posedge clk or Rst)   
	begin
		if (Rst) 
		begin
			RandomD <= 0;
			DownTime<=64'b0;
		end
		else
		begin 
			
			RandomD <= $random % 32'hffffffff;
			if(Link_down||DownTime>0)
				DownTime<=DownTime+1'b1;
				
			if(DownTime==`DOWNTIME)
				DownTime<=64'b0;
				
				
			
		end
	end
	
	




 











assign PhyOutN = !PhyOutP;
always @(posedge PHYCLK or Rst)
begin
	  if (Rst) PhyOutP_delay <= 0;
	  else
	    case (RdPtr)
	    	5'd0: PhyOutP_delay <= FromPCS[0];
	    	5'd1: PhyOutP_delay <= FromPCS[1];
	    	5'd2: PhyOutP_delay <= FromPCS[2];
	    	5'd3: PhyOutP_delay <= FromPCS[3];
	    	5'd4: PhyOutP_delay <= FromPCS[4];
	    	5'd5: PhyOutP_delay <= FromPCS[5];
	    	5'd6: PhyOutP_delay <= FromPCS[6];
	    	5'd7: PhyOutP_delay <= FromPCS[7];
	    	5'd8: PhyOutP_delay <= FromPCS[8];
	    	5'd9: PhyOutP_delay <= FromPCS[9];
	    	5'd10: PhyOutP_delay <= FromPCS[10];
	    	5'd11: PhyOutP_delay <= FromPCS[11];
	    	5'd12: PhyOutP_delay <= FromPCS[12];
	    	5'd13: PhyOutP_delay <= FromPCS[13];
	    	5'd14: PhyOutP_delay <= FromPCS[14];
	    	5'd15: PhyOutP_delay <= FromPCS[15];
	    	5'd16: PhyOutP_delay <= FromPCS[16];
	    	5'd17: PhyOutP_delay <= FromPCS[17];
	    	5'd18: PhyOutP_delay <= FromPCS[18];
	    	5'd19: PhyOutP_delay <= FromPCS[19];
	    	
	    	
	    	default: PhyOutP_delay <= FromPCS[0];
	    endcase
end


/*******************************************implement deserial function********************************************/
/*reg      PhyD;
always @(posedge PHYCLK or posedge Rst)
begin
	  if (Rst) PhyD <= 0;
	  else     PhyD <= PhyInP; 	     
end*/



reg[4:0] WtPtr;
always @(posedge PHYCLK or Rst)
begin
	 if (Rst) WtPtr <= 0;
	 else if(WtPtr==(`DATAWIDTH_PCS-1))    WtPtr <= 0;
	 else WtPtr <= WtPtr + 1'b1;
end


wire      chg1;    //indicate 32bits data have been collected

assign chg1=(WtPtr==5'b0);

/***********************************************************************************************************/

reg[`DATAWIDTH_PCS-1:0] RXD;
reg[`DATAWIDTH_PCS-1:0] PPCSInD;
always @(posedge PHYCLK or Rst)
begin
	  if (Rst) RXD <= 0;
	  else
	    case (WtPtr)
	    	5'd0:  PPCSInD[0]<= PhyInP;
	    	5'd1:  PPCSInD[1]<= PhyInP;
	    	5'd2:  PPCSInD[2]<= PhyInP;
	    	5'd3:  PPCSInD[3]<= PhyInP;
	    	5'd4:  PPCSInD[4]<= PhyInP;
	    	5'd5:  PPCSInD[5]<= PhyInP;
	    	5'd6:  PPCSInD[6]<= PhyInP;
	    	5'd7:  PPCSInD[7]<= PhyInP;
	    	5'd8:  PPCSInD[8]<= PhyInP;
	    	5'd9:  PPCSInD[9]<= PhyInP;
	    	5'd10: PPCSInD[10]<= PhyInP;
	    	5'd11: PPCSInD[11]<= PhyInP;
	    	5'd12: PPCSInD[12]<= PhyInP;
	    	5'd13: PPCSInD[13]<= PhyInP;
	    	5'd14: PPCSInD[14]<= PhyInP;
	    	5'd15: PPCSInD[15]<= PhyInP;
	    	5'd16: PPCSInD[16]<= PhyInP;
	    	5'd17: PPCSInD[17]<= PhyInP;
	    	5'd18: PPCSInD[18]<= PhyInP;
	    	5'd19: PPCSInD[19]<= PhyInP;
	    	 
	    	 default:;
	    	
	    endcase
end


reg[`DATAWIDTH_PCS-1:0] PCSInD0;

always @(posedge chg1 or Rst)
begin
	if (Rst) PCSInD0 <= 0;
	else     PCSInD0 <=PPCSInD;
end



always @(posedge RXDCLK or Rst)   //under RXDCLK 
begin
	if (Rst) RXD <= 0;
	else     RXD <= PCSInD0;
end


/***************************************************insert lane skew and random error*********************************************************/
wire [`DATAWIDTH_PCS-1:0] TXD_temp;
   my_memory my_memory_0(
			 // Outputs
			 .data_out		(TXD_temp[`DATAWIDTH_PCS-1:0]),
			 // Inputs
			 .rst			(Rst),
			 .clk			(TXDCLK),
			 .data_in		(TXD[`DATAWIDTH_PCS-1:0]));
   


   Interfere_PCS_HSS Interfere_PCS_HSS_0(
					 // Outputs
					 .Dout			(PCSOutD[`DATAWIDTH_PCS-1:0]),
					 // Inputs
					 .clk			(TXDCLK),
					 .Rst			(Rst),
					 .Din			(TXD_temp[`DATAWIDTH_PCS-1:0]));
   






   
endmodule














`resetall
`timescale 1ns/1ps

module my_memory(
				rst,
				clk,
				data_in,
				data_out
				);

		
input		rst;
input		clk;
input[`DATAWIDTH_PCS-1:0]	data_in;
output[`DATAWIDTH_PCS-1:0]	data_out;

/**************************************************generate initial bit_skew and word skew***************************************/

reg[3:0]  word_skew;					
	reg[4:0]	bit_skew;
parameter	WORD_SKEW_RAMDOM_SEED	=	4'd6;
parameter	BIT_SKEW_RAMDOM_SEED	=	`DATAWIDTH_PCS;
parameter		MEM_DEPTH  = 16;	
parameter		ADDR_WIDTH = 4;		
	


	always @(posedge clk or rst)
	begin
		if(rst)    //if(NewStart)
		                     
			begin
			
					
						bit_skew <= ($random)% BIT_SKEW_RAMDOM_SEED;			
						word_skew	<= ($random)% WORD_SKEW_RAMDOM_SEED ;
						
											
									
				
				
			end
	
	end











		
reg[`DATAWIDTH_PCS-1:0]		data[MEM_DEPTH-1:0];
	
		reg[ADDR_WIDTH -1 :0]	wt_addr, rd_addr;
		reg		start;
		reg[11:0] skew_period;
		reg[3:0]  skew_again;
		
		/***************************************control move of wt_addr and rd_addr************************************/
		always @(posedge clk or rst)
		begin
			if(rst)
			begin
				wt_addr <=  0;
				rd_addr <=  0;
				start   <=  0;
				skew_period<=10'b0;
			end
			else
			begin
				start   <=  1;
				
				if(start)
				begin
					skew_period <= skew_period+1'b1;
					
					if(skew_period==12'hfff)                                            //Every 3172ns insert bit skew and lane delay
						begin
							//bit_skew <= ($random)% BIT_SKEW_RAMDOM_SEED;                            
							skew_again =($random)% WORD_SKEW_RAMDOM_SEED;
							if((wt_addr>rd_addr)&&((4'd15-skew_again)>wt_addr))
								wt_addr <=  skew_again + 1;
							else
							wt_addr <=  wt_addr + 1;
					
						end
					else
							wt_addr <=  wt_addr + 1;
					rd_addr <=  rd_addr + 1;				
				end
				else
				begin
					wt_addr <=  word_skew + 1;                  //initial value of rd_addr and wt_addr
					rd_addr <=  0;				
				end
			end
		end
		
		
		reg[4:0]	i;
		always @(posedge clk or rst)
		begin
			if(rst)
			begin
				i=0;
				for(i=0;i<=15;i = i+1)
					data[i] <=  $random % {`DATAWIDTH_PCS{1'b1}};          //insert random data
			end
			else
			begin
				data[wt_addr] <=  data_in;
			end
		end
		
		reg[`DATAWIDTH_PCS-1:0]	data_out_temp;
		always @(posedge clk or rst)
		begin
			if(rst)
			begin
				data_out_temp <=  {`DATAWIDTH_PCS{1'b0}}; 				
			end
			else
			begin
				data_out_temp <= data[rd_addr];				
			end
		end
		
		
		
		reg[`DATAWIDTH_PCS-1:0]	last_data_out;
		always @(posedge clk or rst)
		begin
			if(rst)
			begin
				last_data_out <= {`DATAWIDTH_PCS{1'b0}}; 					
			end
			else
			begin
				last_data_out <=  data_out_temp;				
			end
		end
		
		
		
		
		wire[`DATAWIDTH_PCS-1:0]	shift_data;
		assign		shift_data =   (bit_skew == 5'd0) ? last_data_out :
		            (bit_skew == 5'd1) ? {data_out_temp[0],  last_data_out[19:1]}:
								(bit_skew == 5'd2) ? {data_out_temp[1:0],last_data_out[19:2]}:								
								(bit_skew == 5'd3) ? {data_out_temp[2:0],last_data_out[19:3]}:
								(bit_skew == 5'd4) ? {data_out_temp[3:0],last_data_out[19:4]}:
								(bit_skew == 5'd5) ? {data_out_temp[4:0],last_data_out[19:5]}:
								(bit_skew == 5'd6) ? {data_out_temp[5:0],last_data_out[19:6]}:
								(bit_skew == 5'd7) ? {data_out_temp[6:0],last_data_out[19:7]}:
								(bit_skew == 5'd8) ? {data_out_temp[7:0],last_data_out[19:8]}:
								(bit_skew == 5'd9) ? {data_out_temp[8:0],last_data_out[19:9]}:
								(bit_skew == 5'd10) ? {data_out_temp[9:0],last_data_out[19:10]}:
								(bit_skew == 5'd11) ? {data_out_temp[10:0],last_data_out[19:11]}:
								(bit_skew == 5'd12) ? {data_out_temp[11:0],last_data_out[19:12]}:
								(bit_skew == 5'd13) ? {data_out_temp[12:0],last_data_out[19:13]}:
								(bit_skew == 5'd14) ? {data_out_temp[13:0],last_data_out[19:14]}:
								(bit_skew == 5'd15) ? {data_out_temp[14:0],last_data_out[19:15]}:
								(bit_skew == 5'd16) ? {data_out_temp[15:0],last_data_out[19:16]}:
								(bit_skew == 5'd17) ? {data_out_temp[16:0],last_data_out[19:17]}:
								(bit_skew == 5'd18) ? {data_out_temp[17:0],last_data_out[19:18]}:								
								(bit_skew == 5'd19) ? {data_out_temp[18:0],last_data_out[19]}:
								
								
												 last_data_out;
		
		reg[`DATAWIDTH_PCS-1:0]	data_out;
		always @(posedge clk or rst)
		begin
			if(rst)
			begin
				data_out <=   {`DATAWIDTH_PCS{1'b0}}; 					  
			end
			else
			begin
				if(`BW_skew)
					data_out <=   shift_data;		
				else if(`W_skew)
					data_out <=last_data_out;
				else data_out <=   data_in;				
			end
		end				
endmodule

