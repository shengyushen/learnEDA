module sync2stage (
                        clk,
                        data_in,
                        data_out
                );

input           clk;
input           data_in;
output          data_out;
wire            data_out;

reg             drs1;
reg             drs2;
wire            data_wam;


assign data_wam = data_in;

always @(posedge clk)
  begin
    drs1 <= data_wam;
    drs2 <= drs1;
  end

assign data_out = drs2;

endmodule
