/* test.v */

`include "cells.v"
`include "LadnerFischer32.v"
`include "BrentKung32.v"

module main;

  reg [31:0] A, B;
  reg Cin;
  wire Cout;
  wire [31:0] S;
  reg [32:0] ans;
  reg [31:0] testv[7:0];
  integer i, j;

  LadnerFischer32 lf32(A, B, Cin, S, Cout); 

  initial
  begin
    $readmemh("testcases32.txt", testv);

    Cin = 1'b0;
    for (i = 0; i < 8; i = i + 1) begin
      for (j = 0; j < 8; j = j + 1) begin
        A = testv[i];
        B = testv[j];
        ans = A + B + Cin;

        #20
        $display("A = %h, B = %h, Cin = %b, Cout = %b, S = %h", A, B, Cin, Cout, S);
        if ({Cout,S} !== ans) $display("ERROR: Sum not %h!", ans);
      end
    end

    $finish;
  end

endmodule

