module sync_2xdff (/*AUTOARG*/
    // Outputs
    dout,
    // Inputs
    clk, rst_n, din
    );
parameter   WIDTH = 1;

input               clk;
input               rst_n;
input [WIDTH-1:0]   din;
output [WIDTH-1:0]  dout;


wire [WIDTH-1:0]   dout;



    always @(posedge clk)
        begin
            sync_dff0 <= din;
            sync_dff1 <= sync_dff0;
        end

assign  dout = sync_dff1;


endmodule
