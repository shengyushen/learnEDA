module ssyfifo(
	in_enable,
	reset_n,
	clkw,
	out_idle,
	in_data,
	in_datavalid,

	clkr,
	in_idle,
	out_data,
	out_datavalid
);
parameter WIDTH=192;
input	in_enable;
input reset_n;

input clkw;
output out_idle;
input [WIDTH-1:0] in_data;
input in_datavalid;

input clkr;
input in_idle;
output [WIDTH-1:0] out_data;
output out_datavalid;

reg [2:0] pw;
wire [2:0] pw_sync2;
reg [2:0] pr;
wire [2:0] pr_sync2;

parameter G0=3'b000;
parameter G1=3'b001;
parameter G2=3'b011;
parameter G3=3'b010;
parameter G4=3'b110;
parameter G5=3'b111;
parameter G6=3'b101;
parameter G7=3'b100;


reg [WIDTH-1:0] reg0;
reg [WIDTH-1:0] reg1;
reg [WIDTH-1:0] reg2;
reg [WIDTH-1:0] reg3;
reg [WIDTH-1:0] reg4;
reg [WIDTH-1:0] reg5;
reg [WIDTH-1:0] reg6;
reg [WIDTH-1:0] reg7;



//write section
wire resetw_n;
sync_2xdff inst_reset_sync_w (.clk(clkw),.din(reset_n),.dout(resetw_n),.rst_n(1'b1));

always @(posedge clkw) begin
	if(!resetw_n) begin
		pw <= G0 ;
		reg0 <= 0;
		reg1 <= 0;
		reg2 <= 0;
		reg3 <= 0;
		reg4 <= 0;
		reg5 <= 0;
		reg6 <= 0;
		reg7 <= 0;
	end 
	else if(in_enable && in_datavalid) begin
		case (pw)
    G0: begin pw <=G1; reg0<=in_data; end 
    G1: begin pw <=G2; reg1<=in_data; end 
    G2: begin pw <=G3; reg2<=in_data; end 
    G3: begin pw <=G4; reg3<=in_data; end 
    G4: begin pw <=G5; reg4<=in_data; end 
    G5: begin pw <=G6; reg5<=in_data; end 
    G6: begin pw <=G7; reg6<=in_data; end 
    G7: begin pw <=G0; reg7<=in_data; end 
		endcase
	end
end

sync_2xdff #(3) inst_rdpointer_gray_sync1(
  .dout(pr_sync2),
  .clk(clkw),
  .rst_n(1'b1),
  .din(pr)
);

reg out_full;
always @(*) begin
	case (pw)
  G0: begin out_full=(pr_sync2==G1); end 
  G1: begin out_full=(pr_sync2==G2); end 
  G2: begin out_full=(pr_sync2==G3); end 
  G3: begin out_full=(pr_sync2==G4); end 
  G4: begin out_full=(pr_sync2==G5); end 
  G5: begin out_full=(pr_sync2==G6); end 
  G6: begin out_full=(pr_sync2==G7); end 
  G7: begin out_full=(pr_sync2==G0); end 
	endcase
end

assign out_idle=!out_full;

//read section
wire empty=(pw_sync2==pr);

wire resetr_n;
sync_2xdff inst_reset_sync_r (.clk(clkr),.din(reset_n),.dout(resetr_n),.rst_n(1'b1));
always @(posedge clkr) begin
	if(!resetr_n) begin
		pr <= G0 ;
	end 
	else if(in_enable && out_datavalid) begin
		case (pr)
    G0: begin pr <=G1; end 
    G1: begin pr <=G2; end 
    G2: begin pr <=G3; end 
    G3: begin pr <=G4; end 
    G4: begin pr <=G5; end 
    G5: begin pr <=G6; end 
    G6: begin pr <=G7; end 
    G7: begin pr <=G0; end 
		endcase
	end
end

sync_2xdff #(3) inst_wrpointer_gray_sync1(
  .dout(pw_sync2),
  .clk(clkr),
  .rst_n(1'b1),
  .din(pw)
);

reg [WIDTH-1:0] out_data;
always @(*) begin
	case (pr)
  G0: out_data=reg0;
  G1: out_data=reg1;
  G2: out_data=reg2;
  G3: out_data=reg3;
  G4: out_data=reg4;
  G5: out_data=reg5;
  G6: out_data=reg6;
  G7: out_data=reg7;
	endcase
end

assign out_datavalid=in_idle && !empty;

`ifdef PCS_SIM
assert_always #(`OVL_FATAL) inst_assert_0(clkw,resetw_n,(!in_datavalid|!out_full));

`endif

endmodule
