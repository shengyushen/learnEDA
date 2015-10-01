module t1 ;

typedef enum {FALSE,TRUE} boolT;

class ssy #(parameter boolT yesorno=FALSE);
	string s1;
	string s2[100];
	string s3[];
	boolT yn=yesorno.first();

	function new ();
		s1 = "s1";
		s2[0] = "s20";
		s2[1] = "s21";
		s3 = new[10];
		s3[9] = "s39";
		$display ("in new %s",s1);
	endfunction : new
endclass :ssy

ssy #(TRUE) dc;

initial begin
	dc = new ;
	dc.s1 = "s1";
	dc.s2[99] = "s2100";
	$display ("%s",dc.s1);
	$display ("%s",dc.s2[99]);
	$display ("%s",dc.s3[9]);
	if(dc.yn==TRUE) begin
		$display("TRUE");
	end
end


reg clk;
initial begin
	clk = 0;
	forever begin
		#10ns clk = !clk;
		#100ms clk = !clk;
	end

end

endmodule : t1
