module ssy_dut(
input	clock,
input reset_n,
input [31:0] ui,
output [31:0] uo
);

reg [31:0] ui1;

always @(posedge clock)
begin
	if(reset_n==1'b0) begin
		ui1<= 32'b0;
	end
	else begin
		ui1 <= ui;
	end
end


assign uo= ui1;

endmodule 

