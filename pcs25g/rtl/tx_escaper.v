module tx_escaper (
	in_enable,
  clk,
  reset_n,
  in_blocklock_swizzled_local,

  //upper interface
  in_txdata_en,
  in_txdata,
  in_txsync,
  out_ideal,

  //lower interface
  out_txdata_en,
  out_txdata,
  in_ideal,
  
  out_inserting_idle,
  in_lane_id
);

parameter  STATE_NORMAL=3'b000;
parameter  STATE_SENDING_ESC=3'b001;
parameter  STATE_SENDING_IDL=3'b010;
parameter  STATE_SENDING_SYNC=3'b011;
input in_enable;
input  clk;
input  reset_n;
input  [`LANENUMBER-1:0]	in_blocklock_swizzled_local;
wire  [`LANENUMBER-1:0]	in_blocklock_swizzled_local2;

input  in_txdata_en;
input  [`UNITWIDTH-1:0] in_txdata;
input	in_txsync;
output out_ideal;
reg out_ideal;

output out_txdata_en;
output [`UNITWIDTH-1:0] out_txdata;
input  in_ideal;

output	out_inserting_idle;
input	[2:0] in_lane_id;


reg data_en_current;
reg [`UNITWIDTH-1:0] data_current;


reg  [2:0] state;
assign	out_inserting_idle=(state==STATE_SENDING_IDL);

sync_2xdff #(`LANENUMBER) inst_in_blocklock_swizzled_local_sync1(
	.dout(in_blocklock_swizzled_local2),
	.clk(clk), 
	.rst_n(1'b1), 
	.din(in_blocklock_swizzled_local)
);


always @(*) begin
    out_ideal=1'b0;
    if(in_ideal) begin
      case(state)
      STATE_NORMAL : begin
        out_ideal=1'b1;
      end
      
      STATE_SENDING_IDL : begin
        //to send the second char, the idle
	out_ideal=1'b0;
      end
      
      STATE_SENDING_SYNC : begin
        //to send the second char, the sync
	out_ideal=1'b0;
      end
      
      STATE_SENDING_ESC  : begin
        //to send the second ESC_CHAR
	out_ideal=1'b0;
      end

      endcase
    end
    else begin
      /*if(data_en_current==1'b0) begin
        out_ideal=1'b1;
      end*/
      //no one process this case
      out_ideal=1'b0;
    end
end

always @(posedge clk) begin
  if(!reset_n) begin
    state<=STATE_NORMAL;
    data_en_current<=1'b1;
    // Not reseting data can boost speed
    data_current<={`UNITWIDTH{1'b0}};
  end 
  else if(in_enable) begin
    if(in_ideal) begin
      case(state)
      STATE_NORMAL : begin
	if(in_txdata_en) begin
	  if(in_txsync) begin//send a sync 
	    data_en_current<=1'b1;
	    data_current<=`ESC_CHAR;
	    state<=STATE_SENDING_SYNC;
	  end
	  else if (in_txdata==`ESC_CHAR) begin
	    //sending an `ESC_CHAR
	    //I need to send another `ESC_CHAR after it
	    data_en_current<=1'b1;
	    data_current<=`ESC_CHAR;
	    state<=STATE_SENDING_ESC;
	  end
	  else begin
	    data_en_current<=1'b1;
	    data_current<=in_txdata;
	  end
	end
	else begin//no data to be send, to send an escaped ideal
	  state<=STATE_SENDING_IDL;
	  data_en_current<=1'b1;
	  data_current<=`ESC_CHAR;
	end
      end
      
      STATE_SENDING_IDL : begin
        //to send the second char, the idle
	state<=STATE_NORMAL;
	data_en_current<=1'b1;
	data_current<=`IDLE_CHAR;
      end
      
      STATE_SENDING_SYNC : begin
        //to send the second char, the sync
	state<=STATE_NORMAL;
	data_en_current<=1'b1;
	data_current<={`SYNC_CHAR,in_lane_id,4'b0,in_blocklock_swizzled_local2};
      end
      
      STATE_SENDING_ESC  : begin
        //to send the second ESC_CHAR
	state<=STATE_NORMAL;
	data_en_current<=1'b1;
	data_current<=`ESC_CHAR;
      end
      endcase
    end
  end
end

assign out_txdata_en=data_en_current && in_ideal;
assign out_txdata=data_current;

`ifdef PCS_SIM
//no ideal -> no data enable
assert_always #(`OVL_FATAL) inst_assert_inp_enable_ideal(clk,reset_n,out_ideal || !in_txdata_en);
//no ideal -> no data enable
assert_always #(`OVL_FATAL) inst_assert_outp_enable_ideal(clk,reset_n,in_ideal || !out_txdata_en);
//ideal -> data enable
//this means that the sata stream will never been broken
assert_always #(`OVL_FATAL) inst_assert_outp_non_stop(clk,reset_n,!in_ideal || out_txdata_en);
// sync -> in_txdata_en
// we are using a fifo so may not be this case
//assert_always #(`OVL_FATAL) inst_assert_outp_sync_en(clk,reset_n,!in_txsync || in_txdata_en);
`endif

endmodule
