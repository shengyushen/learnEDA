module t1 ;


reg clk;
initial begin
	clk = 0;
	//forever begin
		#10 clk = !clk;
		#100 clk = !clk;
		#10 clk = !clk;
		#10 clk = !clk;
		#10 clk = !clk;
		#100 clk = !clk;
		#100 clk = !clk;
		#100 clk = !clk;
	//end

end


initial begin
	forever begin
		wait (clk==1);
		$display("hah %d",$stime);
		wait (clk==0);
	end
end

endmodule 
