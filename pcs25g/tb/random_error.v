module random_error (errorType,err);
input [2:0] errorType;
output err;
reg err;

integer   reg_random1;
reg err1;
initial begin
	//short error that can be corrected
	forever begin
		#(1) reg_random1=$random%2000;
		err1=(reg_random1==0);
	end
end

integer   reg_random2;
reg err2;
initial begin
	//short error that can be corrected
	forever begin
		#(5) reg_random2=$random%2000;
		err2=(reg_random2==0);
	end
end

integer   reg_random3;
reg err3;
initial begin
	//short error that can be corrected
	forever begin
		#(50) reg_random3=$random%400;
		err3=(reg_random3==0);
	end
end

always @(*) begin
	if(errorType==3'b001) err=err1;
	else if(errorType==3'b010) err=err2;
	else if(errorType==3'b011) err=err3;
	else err=1'b0;
end

endmodule
