module tbssy ();

reg clk;
reg reset_n;
reg request;
wire idle;
wire granted;


ssy instssy (
.clk(clk),
.reset_n(reset_n),
.request(request),
.idle(idle),
.granted(granted)
);

initial begin
	clk = 1'b0;
	forever begin
		#10 clk = !clk ;
	end
end

initial begin
	reset_n = 1'b0;
	#22 reset_n = 1'b1;
end

reg rand_req;
always @(posedge clk)
begin
	randcase
	1: rand_req <= 1'b1;
	1: rand_req <= 1'b0;
	endcase
end

always_comb 
begin
	if(idle ) request = rand_req;
	else request = 1'b0;
end


//always @(request) 
//begin
//	$display ("request %d at %d",request,$stime);
//end

//always @(posedge clk) begin
//	$display("idle %d at %d",idle,$stime);
//end

endmodule 
