module gen192_sendtime_sendESC (clk,reset_n,sendtime,data,out_txen,ideal,) ;
output [191:0] data;
reg [191:0] data;
output  out_txen;
reg  out_txen;
input ideal;
input clk,reset_n;
input sendtime;
wire pop;

reg [8:0] cnt;

always @(posedge clk) begin
  if(!reset_n) begin
    cnt<=0;
  end
  else begin
    if(ideal) begin
      cnt<=cnt+1;
    end
  end
end

always @(*) begin
  out_txen=1'b0;
  case(cnt) 
  0  :  begin  data={4{`ESC_CHAR}};  out_txen=ideal;  end
  1  :  begin  data={4{`ESC_CHAR}};  out_txen=ideal;  end
  2  :  begin  data={4{`ESC_CHAR}};  out_txen=ideal;  end
  3  :  begin  data={4{`ESC_CHAR}};  out_txen=ideal;  end
  
  4  :  begin  data={4{`IDLE_CHAR}};  out_txen=ideal;  end
  5  :  begin  data={4{`IDLE_CHAR}};  out_txen=ideal;  end
  6  :  begin  data={4{`IDLE_CHAR}};  out_txen=ideal;  end
  7  :  begin  data={4{`IDLE_CHAR}};  out_txen=ideal;  end
  
  8  :  begin  data={4{{`SYNC_CHAR,11'h0}}};  out_txen=ideal;  end
  9  :  begin  data={4{{`SYNC_CHAR,11'h0}}};  out_txen=ideal;  end
  10 :  begin  data={4{{`SYNC_CHAR,11'h0}}};  out_txen=ideal;  end
  11 :  begin  data={4{{`SYNC_CHAR,11'h0}}};  out_txen=ideal;  end
  
  endcase
end

endmodule
