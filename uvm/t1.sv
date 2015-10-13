`include "uvm_macros.svh"
module tb;
import uvm_pkg::* ;

initial begin
	$display ("ssy");
end


class ssy_test extends uvm_test;
	`uvm_component_utils (ssy_test)

	function new (string name = "ssy_test", uvm_component parent = null);
		super.new (name,parent);
		$display("ssy_test.new");
	endfunction

	virtual function build_phase ();
		super.build_phase(phase);
		$display("ssy_test.build_phase");
	endfunction
endclass : ssy_test

endmodule : tb
