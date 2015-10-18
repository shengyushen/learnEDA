`include "uvm_macros.svh"

interface ssy_if;
	logic sig_clock;
	logic sig_reset_n;
endinterface : ssy_if

module tb;
import uvm_pkg::* ;

ssy_if inst_if();

initial begin
	inst_if.sig_reset_n = 1'b0;
	#105ns inst_if.sig_reset_n=1'b1;
end

initial begin
	inst_if.sig_clock=1'b0;
	forever begin
		#10ns inst_if.sig_clock=!(inst_if.sig_clock);
	end
end


//initial begin
//	forever begin
//		@(posedge inst_if.sig_clock);
//		if((inst_if.sig_reset_n)==1'b1) begin
//			$display("posedge clock");
//		end
//	end
//end

initial begin
	uvm_config_db#(virtual ssy_if)::set(uvm_root::get(), "*", "vif",inst_if);
	// although I can call ssy_test with run_test directly
	// this may need to recompile the testbench
	//uvm_pkg::run_test("ssy_test");
	//actually we should specify the testname ssy_test at the command line
	// with +UVM_TESTNAME=ssy_test
	// and simple calling run_test without arguments
	uvm_pkg::run_test();
end


//	testbench
//		uvm_test
//			uvm_env
//				uvm_agent for a particular interface
//						uvmsequence
//								to
//					uvm_sequencer
//								to
//						uvm_sequence_item
//								to
//					uvm_driver
//				other uvm_env


// the port of a component is an API of this connection
// while an export provide its implementation
// by connecting them together, 
// we can have definition

//blocking and non-blocking semantics
// put : port          -> export
//       run loop put with new seq_item  -> put implemetation
// get : export -> port
//				get implementation with new seq_itmer -> run loop get


class ssy_item extends uvm_sequence_item;
	rand int unsigned ui;
	constraint  c1 {ui > 10 && ui< 100;}

	`uvm_object_utils_begin(ssy_item)
		`uvm_field_int (ui,UVM_ALL_ON)
	`uvm_object_utils_end

	function new (string name = "ssy_item");
		super.new (name);
		$display("a new ssy_item");
	endfunction : new
endclass : ssy_item

class ssy_seq1 extends uvm_sequence #(ssy_item) ;
	`uvm_object_utils(ssy_seq1)

	function new (string name = "ssy_seq1");
		super.new (name);
	endfunction : new

	virtual task pre_body();
		if(starting_phase!=null) begin
		$display("pre_body!!!");
			 starting_phase.raise_objection(this);
		end
	endtask : pre_body

	virtual task body ();
		$display("ssy_seq1:: body");
		repeat (50)
		`uvm_do(req)
		$display("ssy_seq1:: end of body");
	endtask : body

	virtual task post_body();
		if(starting_phase!=null) begin
		$display("post_body!!!");
			 starting_phase.drop_objection(this);
		end
	endtask : post_body
endclass : ssy_seq1

class ssy_driver extends uvm_driver #(ssy_item);
	`uvm_component_utils(ssy_driver)

	virtual ssy_if vif;

	function new (string name = "ssy_driver", uvm_component parent = null);
		super.new (name,parent);
	endfunction : new

	virtual  function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//for those thing defined by youself and be configed
		// you must read the configed value again with get
		void'(uvm_config_db#(virtual ssy_if)::get(this, "", "vif", vif));
	endfunction : build_phase

	ssy_item s_item;
	virtual task run_phase(uvm_phase phase);
		@(posedge vif.sig_reset_n);
		forever begin
			@(posedge vif.sig_clock);
			// run loop here means get semantics
			$display("ssy_driver::run_phase 1");
			seq_item_port.get_next_item(s_item);
			//$cast(rsp,s_item.clone());
			//drive_item(s_item);
			//rsp.set_id_info(s_item);
			seq_item_port.item_done();
			//seq_item_port.put_response(rsp);
			$display("ssy_driver::run_phase 4");
		end
	endtask : run_phase


	//task drive_item(input ssy_item si);
	//endtask : drive_item
	
endclass : ssy_driver

class ssy_monitor extends uvm_monitor;
	`uvm_component_utils (ssy_monitor)
	function new (string name = "ssy_monitor", uvm_component parent = null);
		super.new (name,parent);
	endfunction : new

endclass : ssy_monitor

//class ssy_sequencer extends uvm_sequencer #(ssy_item);
//	`uvm_component_utils (ssy_sequencer)
//	function new (string name = "ssy_sequencer", uvm_component parent = null);
//		super.new (name,parent);
//		$display("	ssy_sequencer::new after super.new");
//	endfunction : new
//
//	virtual task get_next_item(output REQ t);
//		$display("ssy_sequencer::get_next_item before super");
//		super.get_next_item(t);
//		$display("ssy_sequencer::get_next_item after super");
//	endtask : get_next_item
//endclass : ssy_sequencer

class ssy_agent extends uvm_agent ;
	uvm_sequencer #(ssy_item) inst_sequencer;
	ssy_driver inst_driver;
	ssy_monitor inst_monitor;

	`uvm_component_utils (ssy_agent)
	function new (string name = "ssy_agent", uvm_component parent = null);
		super.new (name,parent);
	endfunction : new

	virtual  function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		inst_monitor = ssy_monitor::type_id::create("inst_monitor",this);
		//is_active already in uvm_agent
//		if(is_active == UVM_ACTIVE) begin
			inst_sequencer = uvm_sequencer#(ssy_item)::type_id::create("inst_sequencer",this);
			inst_driver    = ssy_driver::type_id::create("inst_driver",this);
	//	end
	endfunction : build_phase

	//connecting the components
	virtual function void connect_phase(uvm_phase phase);
//		if(is_active == UVM_ACTIVE) begin
			inst_driver.seq_item_port.connect(inst_sequencer.seq_item_export);
//		end
	endfunction : connect_phase
	
endclass : ssy_agent

class ssy_env extends uvm_env;
	`uvm_component_utils (ssy_env)

	ssy_agent inst_agent;
	
	function new (string name = "ssy_env" , uvm_component parent = null);
		//calling super.new must be the first statement 
		//$display("ssy_env::new before suprt.new");
		super.new (name,parent);
	endfunction : new

	virtual function void build_phase ( uvm_phase phase);
		super.build_phase(phase);
		inst_agent = ssy_agent::type_id::create("inst_agent",this);
	endfunction : build_phase
endclass : ssy_env


class ssy_test extends uvm_test;
	`uvm_component_utils (ssy_test)

	ssy_env inst_ssy_env;

	function new (string name = "ssy_test", uvm_component parent = null);
		super.new (name,parent);
	endfunction

	virtual function void build_phase ( uvm_phase phase);
		inst_ssy_env = ssy_env::type_id::create("inst_ssy_env",this);
		$display("ssy_test::about to set default sequence");
		//main_phase is already there in sequencer, so I dont need to call config get 
		// but if I define some thing in a new class and use config set to write it, 
		// I need to call config get in that build_phase of that class
		uvm_config_db#(uvm_object_wrapper)::set ( 
			this,
			"inst_ssy_env.inst_agent.inst_sequencer.main_phase",
			"default_sequence",
			ssy_seq1::type_id::get()
		);
		$display("ssy_test::finish setting default sequence");
		super.build_phase(phase);
	endfunction


	  task run_phase(uvm_phase phase);
	    //set a drain-time for the environment if desired
	    phase.phase_done.set_drain_time(this, 50ns);
	  endtask : run_phase

endclass : ssy_test

endmodule : tb
