`line 1 test.v 1
`line 4 test.v 1

`line 7 test.v 1

`line 10 test.v 1









`timescale 1ns/10ps
module t(
	input a ,
	output [1:0] b,
	output [1:0] c,
	output d
);

assign b = 
1 + 
  1 ;
assign c = 1+ 
2;



initial begin
	#1
	$display("%d",b);
	$display("%d",c);
	$display("%d",d);
end

endmodule


