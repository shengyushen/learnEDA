module chk192_sendtime_sendESC (clk,reset_n,rcvtime,data,pop,correct) ;
input [191:0] data;
input pop;
input clk;
input reset_n;
input rcvtime;

output correct;

reg [10:0] nodata_cnt;
reg [10:0] data_cnt;

always @(posedge clk) begin
  if(!reset_n) begin
    nodata_cnt<=0;
    data_cnt<=0;
  end
  else if(pop) begin
    nodata_cnt<=0;
  end
  else begin
    if(nodata_cnt<10000) begin
      nodata_cnt<=nodata_cnt+1;
    end
  end
end

assign	correct = !pop | (data=={4{`ESC_CHAR}} | data=={4{`IDLE_CHAR}} | data=={4{{`SYNC_CHAR,11'h0}}});

endmodule
