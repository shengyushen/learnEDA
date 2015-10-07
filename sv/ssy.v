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



//this demostrate the importance of posedge clk
// if we dont use it, then the behavirot is not well defined in standard, 
// and the incisive will make the request2granted2 is false while request2granted is correct
// but actually what we described in this file is request2granted2
// if we use posedge clk, then request2granted2 is correct 
//fake psl request2granted  :  assert always ((request) -> next (next ( granted))) ;
//////////////////////////////////////////////
// sva request2granted2      :  assert always (    (request) -> next (next ( next granted))) @(rising_edge(clk));
// psl request2granted2_psl  :  assert always (    (request) -> next (next ( next granted))) @(posedge(clk));

// psl default clock = (posedge clk) ;

// function rose fell prev stable
//  rose is not the same as directly referring to the signal itself
// because the signal may stay 1 without rising
// psl request2granted2_rose :  assert always (rose(request) -> next (next ( next granted))) ;
// psl request2granted2_fell :  assert always (fell(request) ->      (next ( next granted))) ;
// prev is the same as prev 1, this may fail only at the first posedge
// psl request_prev     : assert always reset_n -> (prev(request)==prev(request,1));
// psl request_stable10 : assert always (state==STATE10 -> stable(request));
// psl request_stable11 : assert always (state==STATE11 -> stable(request));

//value functions
// psl noX              : assert always (!isunknown(request));
// psl count1s          : assert always (countones(state)<=2);
// psl one1s            : assert always (state==STATE01) -> next (onehot(state));
// psl one1atmost       : assert always (state==STATE11) -> next (onehot0(state));

// operator -> means current cycle implication
// psl request2granted2_noclk :  assert always ((request) -> next (next ( next granted))) ;

// operator |=> means sequence implication without overlapped
// operator |-> means overlapped last cycle and first cycle
// psl state0001_1011 : assert always {state==STATE00;state==STATE01} |=>  {state==STATE10;state==STATE11};
// psl state0001_0110 : assert always {state==STATE00;state==STATE01} |->  {state==STATE01;state==STATE10};

// operator && length matching AND that start and finish in the same cycle
// psl and_psl : assert always request -> next {{state==STATE01;state==STATE10;state==STATE11} && {true[*2];granted}};

// operator & AND start in the same cycle but not finished in the same
// psl and_nonlenmatch : assert always (request) -> next {{state==STATE01;state==STATE10} & {state==STATE01;state==STATE10;state==STATE11}};

// sequence  and operator :
// psl sequence seqst00 = {{state==STATE00}[+]};
// a : b means b is at the end of a
// psl sequence state0001(bitvector st; sequence seqst) = {{seqst:request};{st==STATE01}};
// psl sequence state0110 = {{state==STATE01};{state==STATE10}};
// psl sequence state1011 = {{state==STATE10};{state==STATE11}};
// psl seq00010110 : assert always state0001(state,seqst00) |-> state0110 ;
// psl seq00011011 : assert always state0001(state,seqst00) |=> state1011 ;

// operator within: for a within b, the first cycle of b must appear first
// psl state1011_within : assert always  request -> next {{state==STATE10} within {state==STATE01;state==STATE10;state==STATE11}};

// repetition : consecutive 
// psl conseq_repetition : assert always  request -> next {{state==STATE01}[*1:1]};

// repetition : non consecutive
// notice that STATE10 is not at next of request
// psl nonconseq_repetition : assert always request -> next {(state==STATE10)[=1:1]};

// repetition : goto end with the boolean formulua
// psl goto_repetition : assert always request -> next {(state==STATE10)[->1:1]};

// operator true 
// psl true_op : assert always request -> next {true[*2];granted};

// operator never
// it seems that never only support boolean formula
// psl never_op : assert never (request && granted);

// operator until : a until b , a may not hold in b
// psl idle_until_request : assert always idle -> (idle until (state==STATE01 )) ;
// operator until : a until b , a hold in b
// psl idle_until__request : assert always idle -> (idle until_ request) ;

// above until/until_ is universal, which means the left formula always holds before the right formula
// while before operator below is existential, which means it only need to hold for some cycle
// psl before_op : assert always request -> (state==STATE01 before granted);
// before_ means before or at the same cycle of the right formula
// psl before__op : assert always request -> ((state==STATE11 | state==STATE01) before_ granted);

// before/before_ does NOT guarentee that the left formula ever be true
// so before!/before!_ are given to do this
// psl before_op_forced : assert always request -> (state==STATE01 before! granted);
// psl before__op_forced : assert always request -> ((state==STATE11 | state==STATE01) before!_ granted);

// operator next with number
// psl request2granted2_rose_next :  assert always (rose(request) -> next [3] granted) ;
// universal next
// psl request2granted2_rose_next_univ :  assert always (rose(request) -> next_a [1:3] !request) ;
// existential next
// psl request2granted2_rose_next_exist:  assert always (rose(request) -> next_e [1:3] (state==STATE10)) ;

// operator eventually
// psl eventually_op :  assert always (request -> eventually! granted) ;

endmodule

