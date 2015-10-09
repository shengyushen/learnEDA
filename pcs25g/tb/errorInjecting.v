module errorInjecting(
	clk,
	reset_n,
	in_errorInjectionMode,
	ind,
	outd
);
input clk;
input reset_n;
input [1:0] in_errorInjectionMode;
input [31:0] ind;
output [31:0] outd;
reg [31:0] outd;
reg [31:0] outdpre;
reg [31:0] outdpre_nxt;

//assign outd=ind;
sync_2xdff inst_sync_2xdff(
    // Outputs
    .dout(reset_n_sync),
    // Inputs
    .clk(clk), 
    .rst_n(1'b1), 
    .din(reset_n)
    );

reg [23:0] cnt;
always  @(*) begin
	outdpre_nxt =  ind;
end
always @(posedge clk) begin
	if(!reset_n_sync) begin
		outdpre <= 32'b0;
	end 
	else begin
		outdpre <= outdpre_nxt;
	end
end

always @(posedge clk) begin
	if(!reset_n_sync) begin
		outd <= 32'b0;
		cnt<=24'b0;
	end
	else begin
		case(in_errorInjectionMode) 
		2'b00: begin
			//no error 
			outd <= outdpre;
		end
		2'b01: begin
			//10^-3 error
			if(cnt==24'h00_0400) begin
				cnt<=24'b0;
				outd<={outdpre[31:4],4'b0000};
			end
			else begin
				cnt<=cnt+8;
				outd<=outdpre;
			end
		end
		2'b10: begin
			//10^-5 error
			if(cnt==24'h02_0000) begin
				cnt<=24'b0;
				outd<={outdpre[31:4],4'b0000};
			end
			else begin
				cnt<=cnt+8;
				outd<=outdpre;
			end
		end
		default: begin
			//10^-7 error
			if(cnt==24'h80_0000) begin
				cnt<=24'b0;
				outd<={outdpre[31:4],4'b0000};
			end
			else begin
				cnt<=cnt+8;
				outd<=outdpre;
			end
		end
		endcase
	end
end
endmodule
