module ssy (
input clk,
input reset_n,
input request,
output idle,
output granted
);
localparam STATE00=2'b00;
localparam STATE01=2'b01;
localparam STATE10=2'b10;
localparam STATE11=2'b11;
reg  [1:0] state;
reg  [1:0] next_state;

always @(posedge clk) begin
	if(!reset_n) begin
		state <= STATE00;
	end 
	else begin
		state <= next_state;
	end
end

always @(*) 
begin
	case(state)
	STATE00 : if (request) next_state = STATE01 ;	
						else next_state = state;
  STATE01 :next_state = STATE10 ;
  STATE10 :next_state = STATE11 ;
  STATE11 :next_state = STATE00 ;
	endcase
end

assign granted = (state==STATE11);
assign idle = (state== STATE00);

endmodule

