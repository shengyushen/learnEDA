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


class ssy_env extends uvm_env;
	`uvm_component_utils (ssy_env)

	function new (string name = "ssy_env" , uvm_component parent = null);
		//calling super.new must be the first statement 
		//$display("ssy_env::new before suprt.new");
		super.new (name,parent);
		$display("ssy_env::new after super.new");
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		$display("ssy_env::build_phase before super.build_phase");
		super.build_phase(phase);
		$display("ssy_env::build_phase after super.build_phase");
	endfunction : build_phase
endclass : ssy_env

class ssy_test extends uvm_test;
	`uvm_component_utils (ssy_test)

	ssy_env inst_env;

	function new (string name = "ssy_test", uvm_component parent = null);
		//calling super.new must be the first statement 
		//$display("ssy_test::new before super.new");
		super.new (name,parent);
		$display("ssy_test::new after super.new");
	endfunction

	virtual function void build_phase ( uvm_phase phase);
		$display("ssy_test::build_phase before super.build_phase");
		super.build_phase(phase);
		$display("ssy_test::build_phase after super.build_phase");
		$display("ssy_test::build_phase before inst_env= create");
		inst_env = ssy_env::type_id::create("inst_env",this);
		$display("ssy_test::build_phase after inst_env= create");
	endfunction
endclass : ssy_test

endmodule : tb
