module tb();

include(`/usr/share/doc/m4/examples/forloop.m4')

reg [5139:0] inputData;

forloop(`instcnt', `0', `24', `
wire [139:0] parity_top_inst_`'instcnt`';')




reg [5279:0] errorData;

reg [527:0] error;

forloop(`instcnt', `0', `13', `
reg [9:0] erridx_`'instcnt`';')

wire [10:0]  errnum_inst_0=11'b0;
forloop(`instcnt', `1', `528', `
wire [10:0] errnum_inst_`'instcnt`';
assign errnum_inst_`'instcnt`'= errnum_inst_`'eval(instcnt-1)`' + error[`'eval(instcnt-1)`'];
')

wire isCorrectable = (errnum_inst_528<=7);
//use random data
integer i;
initial begin
	forever begin
	  #1
		for(i=0;i<=5139;i=i+1) begin
			inputData[i] = $random %2;
		end

		for(i=0;i<=5279;i=i+1) begin
			errorData[i] = $random %2;
		end

		error = 528'b0;
		forloop(`instcnt', `0', `13', `
			erridx_`'instcnt`'=$random %528;
			error[erridx_`'instcnt`']=$random%2;')


	end
end




merge inst_merge(
.inputData(inputData),
.error(error),
.errorData(errorData)
);

endmodule

