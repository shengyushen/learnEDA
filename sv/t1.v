module t1 ;

class 

reg clk;
initial begin
	clk = 0;
	forever begin
		#10ns clk = !clk;
		#100ms clk = !clk;
	end

end

endmodule : t1
