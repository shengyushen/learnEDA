`include "uvm_macros.svh"
module tb;
import uvm_pkg::* ;

initial begin
	$display ("initializing");
	// although I can call ssy_test with run_test directly
	// this may need to recompile the testbench
	//uvm_pkg::run_test("ssy_test");
	//actually we should specify the testname ssy_test at the command line
	// with +UVM_TESTNAME=ssy_test
	// and simple calling run_test without arguments
	uvm_pkg::run_test();
end


class ssy_test extends uvm_test;
	`uvm_component_utils (ssy_test)

	function new (string name = "ssy_test", uvm_component parent = null);
		super.new (name,parent);
		$display("ssy_test.new");
	endfunction

	virtual function void build_phase ( uvm_phase phase);
		super.build_phase(phase);
		$display("ssy_test.build_phase");
	endfunction
endclass : ssy_test

endmodule : tb
