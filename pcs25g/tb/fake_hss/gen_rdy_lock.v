 
 module gen_rdy_lock(HSSREFCLKAC,HSSRESET,HSSPLLLOCKA,HSSPRTREADYA,HSSPLLLOCKB,HSSPRTREADYB);
 
 input HSSREFCLKAC,HSSRESET;
 output HSSPLLLOCKA,HSSPRTREADYA,HSSPLLLOCKB,HSSPRTREADYB;
 
 reg  HSSPLLLOCKB;
 reg  HSSPRTREADYB;  
 
  reg  HSSPLLLOCKA;
 reg  HSSPRTREADYA;  
 
 reg Rst_rise;
 reg Pos_rst;
 


//  refclk350_c  HSSREFCLKAC hssreset 
 //  refclk350_t HSSREFCLKAT HSSPLLLOCKB,HSSPRTREADYB



/*initial
begin
                        HSSPLLLOCKB = 1'b0;
                        HSSPRTREADYB = 1'b0;
                        
                        HSSPLLLOCKA = 1'b0;
                        HSSPRTREADYA = 1'b0;

                        wait(Pos_rst)
                        #(5000)         
                        HSSPLLLOCKB = 1'b1;
                        HSSPRTREADYB = 1'b1;
                        HSSPLLLOCKA = 1'b1;
                        HSSPRTREADYA = 1'b1;

                
                
end




always @(posedge HSSREFCLKAC )   
begin
         Rst_rise <=HSSRESET;
         Pos_rst  <=Rst_rise&(!HSSRESET);
end*/


always @(posedge HSSREFCLKAC )   
begin
         if(HSSRESET)
	  begin
	   		HSSPLLLOCKB <= 1'b0;
                        HSSPRTREADYB <= 1'b0;
                        
                        HSSPLLLOCKA <= 1'b0;
                        HSSPRTREADYA <= 1'b0;
	  end
         Rst_rise <=HSSRESET;
         Pos_rst  <=Rst_rise&(!HSSRESET);
	 if(Pos_rst)
	  begin
	   		HSSPLLLOCKB <= 1'b1;
                        HSSPRTREADYB <= 1'b1;
                        HSSPLLLOCKA <= 1'b1;
                        HSSPRTREADYA <= 1'b1;
	  end
end

endmodule
