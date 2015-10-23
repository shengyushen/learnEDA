module counter(
	input clk,
	input reset_n,
	input enable,
	output [2:0] count
);

	reg [2:0] count_reg;

	// psl default clock = posedge clk ;

	// comment : psl with (assert cover)/assume key word is 
	// automatically identified as assertion/constraint
	// and used in verification
	// psl assert_1 : assert never (count_reg == 3'b110) ;

	// assert_2 and constraint_1 is actually intended to be used at the first cycle
	// psl assert_2 : assert eventually! (count_reg==3'b100);
	// psl constraint_1 : assume eventually! enable;
	// psl constraint_2 : assume always enable -> next eventually! enable ;

	always @ (posedge clk or negedge reset_n)
	begin
		if(!reset_n)
			count_reg = 3'b000;
		else if (count_reg < 3'b101 && enable==1'b1)
			count_reg = count_reg + 1;
	end
	
	assign count = count_reg ;
	`ifdef ABV_ON
		//aux code comes here
	`endif
endmodule
