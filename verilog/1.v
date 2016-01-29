`line 1 test.v 1
`define y `\x + \
  1

`define \x \
1

`define z(x, y) x+ \
y









`timescale 1ns/10ps
module t(
	input a ,
	output [1:0] b,
	output [1:0] c,
	output d
);

assign b = `y ;
assign c = `z(1,2);



initial begin
	#1
	$display("%d",b);
	$display("%d",c);
	$display("%d",d);
end

endmodule


