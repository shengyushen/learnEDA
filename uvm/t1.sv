`include "uvm_macros.svh"

interface ssy_if;
	logic sig_clock;
	logic sig_reset_n;
	bit [31:0]  ui;

	bit [31:0]  uo;

	always @(posedge sig_clock) begin
		if(sig_reset_n==1'b1) begin
			$display("a new item with ui=%d",ui);
		end
	end
endinterface : ssy_if

module tb;
import uvm_pkg::* ;

ssy_if inst_if();

ssy_dut inst_dut(
	.clock(inst_if.sig_clock),
	.reset_n(inst_if.sig_reset_n),
	.ui(inst_if.ui),
	.uo(inst_if.uo)
);

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
//					uvm_monitor
//					uvm_driver
//					uvm_sequencer
//						uvmsequence
//								to
//						uvm_sequence_item
//								to


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
	endfunction : new
endclass : ssy_item

class ssy_seq1 extends uvm_sequence #(ssy_item) ;
	`uvm_object_utils(ssy_seq1)

	function new (string name = "ssy_seq1");
		super.new (name);
	endfunction : new

	virtual task pre_body();
		if(starting_phase!=null) begin
			 starting_phase.raise_objection(this);
		end
	endtask : pre_body

	virtual task body ();
		repeat (50)
		`uvm_do(req)
	endtask : body

	virtual task post_body();
		if(starting_phase!=null) begin
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
			seq_item_port.get_next_item(s_item);
			drive_item (s_item);
			seq_item_port.item_done();
		end
	endtask : run_phase

	task drive_item(ssy_item si);
		vif.ui <= si.ui ;
	endtask : drive_item

endclass : ssy_driver

class ssy_monitor extends uvm_monitor;
	`uvm_component_utils (ssy_monitor)

	virtual ssy_if vif;
	uvm_analysis_port #(ssy_item) item_collected_port;

	covergroup cov_0 @ (posedge vif.sig_clock);
		option.per_instance = 1;
		uo0 : coverpoint vif.uo[0] iff (vif.sig_reset_n);
	endgroup : cov_0

	event trans_event;
	covergroup cov_1 (ref bit [31:0] ruo , ref bit ruo_3, ref bit ruo_4, input int c) @ trans_event;
		//using ref can make the ruo to be the current value of uo
		// while without ref the ruo is the same as when new cov_1
		option.per_instance = 1;
		uo_1 : coverpoint ruo[1] ;
		option.weight = c;
		uo_2 : coverpoint ruo[2] {
			option.weight = 2;
		}
		uo_34 : cross ruo_3, ruo_4 {
			option.weight = 2;
		} 
		cross12 : cross uo_1, uo_2 ;
	endgroup : cov_1

	covergroup cov_2 (ref bit [31:0] ruo ) ;
		option.per_instance = 1;

		uo_15_0 : coverpoint ruo[15:0] {
			option.auto_bin_max = 256;
		}
		uo_31_15 : coverpoint ruo [31:16] {
			bins a [4] = {[0:10]} ;  //create four bin with uniform distribution
			bins b[] = {[0:10]};   //creating as many as the number of range
			bins c[] = {1,2,3};  // three bins
			//bins d = {[100:$]} with (item % 3 == 0);   // a bin with all values larger than 100 and divided by 3 
			ignore_bins ign_value = {7,8};
			ignore_bins ign_trans = (7=>8);
			bins others = default; //all other is here
		}
		uo_trans : coverpoint ruo [3:2] {
			bins onezeroone = (1 => 0 => 1);
			bins onezeroone_oneoneone = (1 => 0 => 1), (1=>1=>1);
			bins nnn = ([1:0],3 => 1,3);
			bins nnnn = (3=>4[*3:5]); // 3=>4 repeat 3 to 5 times
			wildcard bins nnnnn = (2'b0x=>2'b1x[*3:5]); // 3=>4 repeat 3 to 5 times
			bins otherseq = default sequence; // all other sequence
		}
	endgroup : cov_2

	//these value must be collected
	bit b3,b4;
	bit [31:0] uuo;
	ssy_item inst_item;
	function new (string name = "ssy_monitor", uvm_component parent = null);
		super.new (name,parent);
		cov_0 = new();
		cov_1 = new(uuo,b3,b4,1);
		item_collected_port = new("item_collected_port",this);
		inst_item = new();
	endfunction : new

	virtual function void build_phase ( uvm_phase phase);
		super.build_phase(phase);
		void'(uvm_config_db#(virtual ssy_if)::get(this, "", "vif", vif));
	endfunction : build_phase


	virtual task run_phase(uvm_phase phase);
	begin
		@(posedge vif.sig_reset_n);
		forever begin
			@(posedge vif.sig_clock);
			//this is collection data
			uuo = vif.uo;
			b3  = vif.uo[3];
			b4  = vif.uo[4];
			inst_item.ui = vif.uo ;
			item_collected_port.write(inst_item);
			check_0 : assert (uuo != 0 && uuo!=1);
			-> trans_event;
		end
	end
	endtask : run_phase
endclass : ssy_monitor

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
		inst_sequencer = uvm_sequencer#(ssy_item)::type_id::create("inst_sequencer",this);
		inst_driver    = ssy_driver::type_id::create("inst_driver",this);
	endfunction : build_phase

	//connecting the components
	virtual function void connect_phase(uvm_phase phase);
		inst_driver.seq_item_port.connect(inst_sequencer.seq_item_export);
	endfunction : connect_phase
	
endclass : ssy_agent

class ssy_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(ssy_scoreboard)

	uvm_analysis_imp #(ssy_item, ssy_scoreboard) item_collected_export;

	function new (string name = "ssy_scoreboard", uvm_component parent = null);
		super.new (name,parent);
		item_collected_export = new("item_collected_export",this);
	endfunction : new

	virtual function void build_phase ( uvm_phase phase);
		super.build_phase(phase);
		//uvm_analysis_imp and uvm_analysis_port are not extends from uvm_object, so no type_id::create
	endfunction : build_phase

	virtual function void write (ssy_item si);
		$display("haha got %d",si.ui);
	endfunction : write
endclass : ssy_scoreboard

class ssy_env extends uvm_env;
	`uvm_component_utils (ssy_env)

	ssy_agent inst_agent;
	ssy_scoreboard inst_scoreboard;
	
	function new (string name = "ssy_env" , uvm_component parent = null);
		//calling super.new must be the first statement 
		//$display("ssy_env::new before suprt.new");
		super.new (name,parent);
	endfunction : new

	virtual function void build_phase ( uvm_phase phase);
		super.build_phase(phase);
		inst_agent = ssy_agent::type_id::create("inst_agent",this);
		inst_scoreboard=ssy_scoreboard::type_id::create("inst_scoreboard", this);
	endfunction : build_phase

	virtual function void connect_phase(uvm_phase phase);
		inst_agent.inst_monitor.item_collected_port.connect(inst_scoreboard.item_collected_export);
	endfunction : connect_phase
endclass : ssy_env


class ssy_test extends uvm_test;
	`uvm_component_utils (ssy_test)

	ssy_env inst_ssy_env;

	function new (string name = "ssy_test", uvm_component parent = null);
		super.new (name,parent);
	endfunction

	virtual function void build_phase ( uvm_phase phase);
		inst_ssy_env = ssy_env::type_id::create("inst_ssy_env",this);
		//main_phase is already there in sequencer, so I dont need to call config get 
		// but if I define some thing in a new class and use config set to write it, 
		// I need to call config get in that build_phase of that class
		uvm_config_db#(uvm_object_wrapper)::set ( 
			this,
			"inst_ssy_env.inst_agent.inst_sequencer.main_phase",
			"default_sequence",
			ssy_seq1::type_id::get()
		);
		// I can even override by type, that is use type b to replace all type a
		//factory.set_type_override_by_type(uart_frame::get_type(),
		//short_delay_frame::get_type());
		super.build_phase(phase);
	endfunction

endclass : ssy_test

endmodule : tb
