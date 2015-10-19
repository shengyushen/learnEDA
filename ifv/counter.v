module counter(clk,reset,count);
	input clk;
	input reset;
	output [2:0] count;
	reg [2:0] count;

	// psl default clock = posedge clk ;
	// psl P1: assert never (count == 3'b110) ;

	always @ (posedge clk or negedge reset)
	begin
		if(!reset)
			count = 3'b000;
		else if (count < 3'b101)
			count = count + 1;
	end
endmodule
