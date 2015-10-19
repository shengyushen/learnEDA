//----------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2010 Cadence Design Systems, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

//This is dummy DUT. 

module dut_dummy( 
  input wire ubus_req_master_0,
  output reg ubus_gnt_master_0,
  input wire ubus_req_master_1,
  output reg ubus_gnt_master_1,
  input wire ubus_clock,
  input wire ubus_reset,
  input wire [15:0] ubus_addr,
  input wire [1:0] ubus_size,
  output reg ubus_read,
  output reg ubus_write,
  output reg  ubus_start,
  input wire ubus_bip,
  inout wire [7:0] ubus_data,
  input wire ubus_wait,
  input wire ubus_error);
  bit[2:0]   st;

  // Basic arbiter, supports two masters, 0 has priority over 1

   always @(posedge ubus_clock or posedge ubus_reset) begin
     if(ubus_reset) begin
       ubus_start <= 1'b0;
       st<=3'h0;
     end
       else
         case(st)
         0: begin //Begin out of Reset
             ubus_start <= 1'b1;
             st<=3'h3;
         end
         3: begin //Start state
             ubus_start <= 1'b0;
             if((ubus_gnt_master_0==0) && (ubus_gnt_master_1==0)) begin
                 st<=3'h4;
             end
             else
                 st<=3'h1;
         end
         4: begin // No-op state
             ubus_start <= 1'b1;
             st<=3'h3;
         end
         1: begin // Addr state
             st<=3'h2;
             ubus_start <= 1'b0;
         end
         2: begin // Data state
             if((ubus_error==1) || ((ubus_bip==0) && (ubus_wait==0))) begin
                 st<=3'h3;
                 ubus_start <= 1'b1;
             end
             else begin
                 st<=3'h2;
                 ubus_start <= 1'b0;
             end
         end
         endcase
     end

   always @(negedge ubus_clock or posedge ubus_reset) begin
     if(ubus_reset == 1'b1) begin
       ubus_gnt_master_0 <= 0;
       ubus_gnt_master_1 <= 0;
     end
     else begin
       if(ubus_start && ubus_req_master_0) begin
         ubus_gnt_master_0 <= 1;
         ubus_gnt_master_1 <= 0;
       end
       else if(ubus_start && !ubus_req_master_0 && ubus_req_master_1) begin
         ubus_gnt_master_0 <= 0;
         ubus_gnt_master_1 <= 1;
       end
       else begin
         ubus_gnt_master_0 <= 0;
         ubus_gnt_master_1 <= 0;
       end
     end
   end

   always @(posedge ubus_clock or posedge ubus_reset) begin
     if(ubus_reset) begin
       ubus_read <= 1'bZ;
       ubus_write <= 1'bZ;
     end
     else if(ubus_start && !ubus_gnt_master_0 && !ubus_gnt_master_1) begin
       ubus_read <= 1'b0;
       ubus_write <= 1'b0;
     end
     else begin
       ubus_read <= 1'bZ;
       ubus_write <= 1'bZ;
     end
   end

endmodule

//----------------------------------------------------------------------
//   Copyright 2007-2011 Mentor Graphics Corporation
//   Copyright 2007-2011 Cadence Design Systems, Inc.
//   Copyright 2010 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

`include "ubus_example_tb.sv"


// Base Test
class ubus_example_base_test extends uvm_test;

  `uvm_component_utils(ubus_example_base_test)

  ubus_example_tb ubus_example_tb0;
  uvm_table_printer printer;
  bit test_pass = 1;

  function new(string name = "ubus_example_base_test", 
    uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Enable transaction recording for everything
    uvm_config_db#(int)::set(this, "*", "recording_detail", UVM_FULL);
    // Create the tb
    ubus_example_tb0 = ubus_example_tb::type_id::create("ubus_example_tb0", this);
    // Create a specific depth printer for printing the created topology
    printer = new();
    printer.knobs.depth = 3;
  endfunction : build_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    // Set verbosity for the bus monitor for this demo
     if(ubus_example_tb0.ubus0.bus_monitor != null)
       ubus_example_tb0.ubus0.bus_monitor.set_report_verbosity_level(UVM_FULL);
    `uvm_info(get_type_name(),
      $sformatf("Printing the test topology :\n%s", this.sprint(printer)), UVM_LOW)
  endfunction : end_of_elaboration_phase

  task run_phase(uvm_phase phase);
    //set a drain-time for the environment if desired
    phase.phase_done.set_drain_time(this, 50);
  endtask : run_phase

  function void extract_phase(uvm_phase phase);
    if(ubus_example_tb0.scoreboard0.sbd_error)
      test_pass = 1'b0;
  endfunction // void
  
  function void report_phase(uvm_phase phase);
    if(test_pass) begin
      `uvm_info(get_type_name(), "** UVM TEST PASSED **", UVM_NONE)
    end
    else begin
      `uvm_error(get_type_name(), "** UVM TEST FAIL **")
    end
  endfunction

endclass : ubus_example_base_test


// Read Modify Write Read Test
class test_read_modify_write extends ubus_example_base_test;

  `uvm_component_utils(test_read_modify_write)

  function new(string name = "test_read_modify_write", uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
  begin
    uvm_config_db#(uvm_object_wrapper)::set(this,
		    "ubus_example_tb0.ubus0.masters[0].sequencer.run_phase", 
			       "default_sequence",
				read_modify_write_seq::type_id::get());
    uvm_config_db#(uvm_object_wrapper)::set(this,
		    "ubus_example_tb0.ubus0.slaves[0].sequencer.run_phase", 
			       "default_sequence",
				slave_memory_seq::type_id::get());
    // Create the tb
    super.build_phase(phase);
  end
  endfunction : build_phase

endclass : test_read_modify_write


// Large word read/write test
class test_r8_w8_r4_w4 extends ubus_example_base_test;

  `uvm_component_utils(test_r8_w8_r4_w4)

  function new(string name = "test_r8_w8_r4_w4", uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
  begin
    super.build_phase(phase);
    uvm_config_db#(uvm_object_wrapper)::set(this,
		      "ubus_example_tb0.ubus0.masters[0].sequencer.run_phase", 
			       "default_sequence",
				r8_w8_r4_w4_seq::type_id::get());
    uvm_config_db#(uvm_object_wrapper)::set(this,
		      "ubus_example_tb0.ubus0.slaves[0].sequencer.run_phase", 
			       "default_sequence",
				slave_memory_seq::type_id::get());
  end
  endfunction : build_phase

endclass : test_r8_w8_r4_w4 


// 2 Master, 4 Slave test
class test_2m_4s extends ubus_example_base_test;

  `uvm_component_utils(test_2m_4s)

  function new(string name = "test_2m_4s", uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
     loop_read_modify_write_seq lrmw_seq;

  begin
    // Overides to the ubus_example_tb build_phase()
    // Set the topology to 2 masters, 4 slaves
    uvm_config_db#(int)::set(this,"ubus_example_tb0.ubus0", 
			       "num_masters", 2);
    uvm_config_db#(int)::set(this,"ubus_example_tb0.ubus0", 
			       "num_slaves", 4);
     
   // Control the number of RMW loops
    uvm_config_db#(int)::set(this,"ubus_example_tb0.ubus0.masters[0].sequencer.loop_read_modify_write_seq", "itr", 6);
    uvm_config_db#(int)::set(this,"ubus_example_tb0.ubus0.masters[1].sequencer.loop_read_modify_write_seq", "itr", 8);

     // Define the sequences to run in the run phase
    uvm_config_db#(uvm_object_wrapper)::set(this,"*.ubus0.masters[0].sequencer.main_phase", 
			       "default_sequence",
				loop_read_modify_write_seq::type_id::get());
     lrmw_seq = loop_read_modify_write_seq::type_id::create();
    uvm_config_db#(uvm_sequence_base)::set(this,
			       "ubus_example_tb0.ubus0.masters[1].sequencer.main_phase", 
			       "default_sequence",
				lrmw_seq);

     for(int i = 0; i < 4; i++) begin
	string slname;
	$swrite(slname,"ubus_example_tb0.ubus0.slaves[%0d].sequencer", i);
	uvm_config_db#(uvm_object_wrapper)::set(this, {slname,".run_phase"}, 
						  "default_sequence",
						  slave_memory_seq::type_id::get());
     end
     
    // Create the tb
    super.build_phase(phase);
  end
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    // Connect other slaves monitor to scoreboard
    ubus_example_tb0.ubus0.slaves[1].monitor.item_collected_port.connect(
      ubus_example_tb0.scoreboard0.item_collected_export);
    ubus_example_tb0.ubus0.slaves[2].monitor.item_collected_port.connect(
      ubus_example_tb0.scoreboard0.item_collected_export);
    ubus_example_tb0.ubus0.slaves[3].monitor.item_collected_port.connect(
      ubus_example_tb0.scoreboard0.item_collected_export);
  endfunction : connect_phase
  
  function void end_of_elaboration_phase(uvm_phase phase);
    // Set up slave address map for ubus0 (slaves[0] is overwritten here)
    ubus_example_tb0.ubus0.set_slave_address_map("slaves[0]", 16'h0000, 16'h3fff);
    ubus_example_tb0.ubus0.set_slave_address_map("slaves[1]", 16'h4000, 16'h7fff);
    ubus_example_tb0.ubus0.set_slave_address_map("slaves[2]", 16'h8000, 16'hBfff);
    ubus_example_tb0.ubus0.set_slave_address_map("slaves[3]", 16'hC000, 16'hFfff);
     super.end_of_elaboration_phase(phase);
  endfunction : end_of_elaboration_phase

endclass : test_2m_4s
//----------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2011 Cadence Design Systems, Inc.
//   Copyright 2010 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// SEQUENCE: incr_read_byte_seq
//
//------------------------------------------------------------------------------

class incr_read_byte_seq extends ubus_base_sequence;

  function new(string name="incr_read_byte_seq");
    super.new(name);
  endfunction : new

  `uvm_object_utils(incr_read_byte_seq)

  read_byte_seq read_byte_seq0;

  rand int unsigned count;
    constraint count_ct { (count < 20); }
  rand bit [15:0] start_address;
  rand int unsigned incr_transmit_del = 0;
    constraint transmit_del_ct { (incr_transmit_del <= 10); }
 
  virtual task body();
    `uvm_info(get_type_name(),
      $sformatf("%s starting with count = %0d", 
      get_sequence_path(), count), UVM_MEDIUM);
    repeat(count) begin : repeat_block
      `uvm_do_with(read_byte_seq0,
        { read_byte_seq0.start_addr == start_address;
          read_byte_seq0.transmit_del == incr_transmit_del; } )
      start_address++;
    end : repeat_block
  endtask : body
 
endclass : incr_read_byte_seq


//------------------------------------------------------------------------------
//
// SEQUENCE: incr_write_byte_seq
//
//------------------------------------------------------------------------------

class incr_write_byte_seq extends ubus_base_sequence;

  function new(string name="incr_write_byte_seq");
    super.new(name);
  endfunction : new

  `uvm_object_utils(incr_write_byte_seq)
    
  write_byte_seq write_byte_seq0;

  rand int unsigned count;
    constraint count_ct { (count < 20); }
  rand bit [15:0] start_address;
  rand int unsigned incr_transmit_del = 0;
    constraint transmit_del_ct { (incr_transmit_del <= 10); }

  virtual task body();
    `uvm_info(get_type_name(),
      $sformatf("%s starting with count = %0d",
      get_sequence_path(), count), UVM_MEDIUM);
    repeat(count) begin : repeat_block
      `uvm_do_with(write_byte_seq0,
        { write_byte_seq0.start_addr == start_address;
          write_byte_seq0.transmit_del == incr_transmit_del; } )
      start_address++;
    end : repeat_block
  endtask : body

endclass : incr_write_byte_seq


//------------------------------------------------------------------------------
//
// SEQUENCE: incr_read_write_read_seq
//
//------------------------------------------------------------------------------

class incr_read_write_read_seq extends ubus_base_sequence;

  function new(string name="incr_read_write_read_seq");
    super.new(name);
  endfunction : new

  `uvm_object_utils(incr_read_write_read_seq)

  incr_read_byte_seq  read0;
  incr_write_byte_seq write0;

  virtual task body();
    `uvm_info(get_type_name(),
      $sformatf("%s starting sequence",
      get_sequence_path()), UVM_MEDIUM);
    `uvm_do(read0)
    `uvm_do(write0)
    `uvm_do(read0)
  endtask : body

endclass : incr_read_write_read_seq


//------------------------------------------------------------------------------
//
// SEQUENCE: r8_w8_r4_w4_seq
//
//------------------------------------------------------------------------------

class r8_w8_r4_w4_seq extends ubus_base_sequence;

  function new(string name="r8_w8_r4_w4_seq");
    super.new(name);
  endfunction : new

  `uvm_object_utils(r8_w8_r4_w4_seq)

  read_word_seq read_word_seq0;
  read_double_word_seq read_double_word_seq0;
  write_word_seq write_word_seq0;
  write_double_word_seq write_double_word_seq0;

  rand bit [15:0] start_address;

  constraint start_address_ct { (start_address == 16'h4000); }

  virtual task body();
    `uvm_info(get_type_name(),
      $sformatf("%s starting...",
      get_sequence_path()), UVM_MEDIUM);
    `uvm_do_with(read_double_word_seq0, 
      { read_double_word_seq0.start_addr == start_address;
        read_double_word_seq0.transmit_del == 2; } )
    `uvm_do_with(write_double_word_seq0,
      { write_double_word_seq0.start_addr == start_address;
        write_double_word_seq0.transmit_del == 4; } )
    start_address = start_address + 8;
    `uvm_do_with(read_word_seq0,
      { read_word_seq0.start_addr == start_address;
        read_word_seq0.transmit_del == 6; } )
    `uvm_do_with(write_word_seq0,
      { write_word_seq0.start_addr == start_address;
        write_word_seq0.transmit_del == 8; } )
  endtask : body

endclass : r8_w8_r4_w4_seq
  

//------------------------------------------------------------------------------
//
// SEQUENCE: read_modify_write_seq
//
//------------------------------------------------------------------------------

class read_modify_write_seq extends ubus_base_sequence;

  function new(string name="read_modify_write_seq");
    super.new(name);
  endfunction : new

  `uvm_object_utils(read_modify_write_seq)

  read_byte_seq read_byte_seq0;
  write_byte_seq write_byte_seq0;

  rand bit [15:0] addr_check;
  bit [7:0] m_data0_check;

  virtual task body();
    `uvm_info(get_type_name(),
      $sformatf("%s starting...",
      get_sequence_path()), UVM_MEDIUM);
    // READ A RANDOM LOCATION
    `uvm_do_with(read_byte_seq0, {read_byte_seq0.transmit_del == 0; })
    addr_check = read_byte_seq0.rsp.addr;
    m_data0_check = read_byte_seq0.rsp.data[0] + 1;
    // WRITE MODIFIED READ DATA
    `uvm_do_with(write_byte_seq0,
      { write_byte_seq0.start_addr == addr_check;
        write_byte_seq0.data0 == m_data0_check; } )
    // READ MODIFIED WRITE DATA
    `uvm_do_with(read_byte_seq0,
      { read_byte_seq0.start_addr == addr_check; } )
    assert(m_data0_check == read_byte_seq0.rsp.data[0]) else
      `uvm_error(get_type_name(),
        $sformatf("%s Read Modify Write Read error!\n\tADDR: %h, EXP: %h, ACT: %h", 
        get_sequence_path(),addr_check,m_data0_check,read_byte_seq0.rsp.data[0]));
  endtask : body

endclass : read_modify_write_seq


//------------------------------------------------------------------------------
//
// SEQUENCE: loop_read_modify_write_seq
//
//------------------------------------------------------------------------------

class loop_read_modify_write_seq extends ubus_base_sequence;

  int itr;

  function new(string name="loop_read_modify_write_seq");
    super.new(name);
  endfunction : new

  `uvm_object_utils(loop_read_modify_write_seq)

  read_modify_write_seq rmw_seq;

  virtual task body();
    void'(uvm_config_db#(int)::get(null,get_full_name(),"itr", itr));
    `uvm_info(get_type_name(),
      $sformatf("%s starting...itr = %0d",
      get_sequence_path(),itr), UVM_NONE);
    for(int i = 0; i < itr; i++) begin
      `uvm_do(rmw_seq)
    end
  endtask : body

endclass : loop_read_modify_write_seq

//----------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2010 Cadence Design Systems, Inc.
//   Copyright 2010 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// CLASS: ubus_example_scoreboard
//
//------------------------------------------------------------------------------

class ubus_example_scoreboard extends uvm_scoreboard;

  uvm_analysis_imp#(ubus_transfer, ubus_example_scoreboard) item_collected_export;

  protected bit disable_scoreboard = 0;
  protected int num_writes = 0;
  protected int num_init_reads = 0;
  protected int num_uninit_reads = 0;
  int sbd_error = 0;

  protected int unsigned m_mem_expected[int unsigned];

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(ubus_example_scoreboard)
    `uvm_field_int(disable_scoreboard, UVM_DEFAULT)
    `uvm_field_int(num_writes, UVM_DEFAULT|UVM_DEC)
    `uvm_field_int(num_init_reads, UVM_DEFAULT|UVM_DEC)
    `uvm_field_int(num_uninit_reads, UVM_DEFAULT|UVM_DEC)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  //build_phase
  function void build_phase(uvm_phase phase);
    item_collected_export = new("item_collected_export", this);
  endfunction

  // write
  virtual function void write(ubus_transfer trans);
    if(!disable_scoreboard)
      memory_verify(trans);
  endfunction : write

  // memory_verify
  protected function void memory_verify(input ubus_transfer trans);
    int unsigned data, exp;
    for (int i = 0; i < trans.size; i++) begin
      // Check to see if entry in associative array for this address when read
      // If so, check that transfer data matches associative array data.
      if (m_mem_expected.exists(trans.addr + i)) begin
        if (trans.read_write == READ) begin
          data = trans.data[i];
          `uvm_info(get_type_name(),
            $sformatf("%s to existing address...Checking address : %0h with data : %0h", 
            trans.read_write.name(), trans.addr, data), UVM_LOW)
          assert(m_mem_expected[trans.addr + i] == trans.data[i]) else begin
            exp = m_mem_expected[trans.addr + i];
            `uvm_error(get_type_name(),
              $sformatf("Read data mismatch.  Expected : %0h.  Actual : %0h", 
              exp, data))
	      sbd_error = 1;
          end
          num_init_reads++;
        end
        if (trans.read_write == WRITE) begin
          data = trans.data[i];
          `uvm_info(get_type_name(),
            $sformatf("%s to existing address...Updating address : %0h with data : %0h", 
            trans.read_write.name(), trans.addr + i, data), UVM_LOW)
          m_mem_expected[trans.addr + i] = trans.data[i];
          num_writes++;
        end
      end
      // Check to see if entry in associative array for this address
      // If not, update the location regardless if read or write.
      else begin
        data = trans.data[i];
        `uvm_info(get_type_name(),
          $sformatf("%s to empty address...Updating address : %0h with data : %0h", 
          trans.read_write.name(), trans.addr + i, data), UVM_LOW)
        m_mem_expected[trans.addr + i] = trans.data[i];
        if(trans.read_write == READ)
          num_uninit_reads++;
        else if (trans.read_write == WRITE)
          num_writes++;
      end
    end
  endfunction : memory_verify

  // report_phase
  virtual function void report_phase(uvm_phase phase);
    if(!disable_scoreboard) begin
      `uvm_info(get_type_name(),
        $sformatf("Reporting scoreboard information...\n%s", this.sprint()), UVM_LOW)
    end
  endfunction : report_phase

endclass : ubus_example_scoreboard


//----------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2011 Cadence Design Systems, Inc.
//   Copyright 2010 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

`include "ubus_example_scoreboard.sv"
`include "ubus_master_seq_lib.sv"
`include "ubus_example_master_seq_lib.sv"
`include "ubus_slave_seq_lib.sv"


//------------------------------------------------------------------------------
//
// CLASS: ubus_example_tb
//
//------------------------------------------------------------------------------

class ubus_example_tb extends uvm_env;

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils(ubus_example_tb)

  // ubus environment
  ubus_env ubus0;

  // Scoreboard to check the memory operation of the slave.
  ubus_example_scoreboard scoreboard0;

  // new
  function new (string name, uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  // build_phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(int)::set(this,"ubus0", 
			       "num_masters", 1);
    uvm_config_db#(int)::set(this,"ubus0", 
			       "num_slaves", 1);
    
    ubus0 = ubus_env::type_id::create("ubus0", this);
    scoreboard0 = ubus_example_scoreboard::type_id::create("scoreboard0", this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    // Connect slave0 monitor to scoreboard
    ubus0.slaves[0].monitor.item_collected_port.connect(
      scoreboard0.item_collected_export);
  endfunction : connect_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    // Set up slave address map for ubus0 (basic default)
    ubus0.set_slave_address_map("slaves[0]", 0, 16'hffff);
  endfunction : end_of_elaboration_phase

endclass : ubus_example_tb


//----------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2011 Cadence Design Systems, Inc.
//   Copyright 2010 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

`define UBUS_ADDR_WIDTH 16

`include "ubus_pkg.sv"
`include "dut_dummy.v"
`include "ubus_if.sv"


module ubus_tb_top;
  import uvm_pkg::*;
  import ubus_pkg::*;
  `include "test_lib.sv" 

  ubus_if vif(); // SystemVerilog Interface
  
  dut_dummy dut(
    vif.sig_request[0],
    vif.sig_grant[0],
    vif.sig_request[1],
    vif.sig_grant[1],
    vif.sig_clock,
    vif.sig_reset,
    vif.sig_addr,
    vif.sig_size,
    vif.sig_read,
    vif.sig_write,
    vif.sig_start,
    vif.sig_bip,
    vif.sig_data,
    vif.sig_wait,
    vif.sig_error
  );

  initial begin
    uvm_config_db#(virtual ubus_if)::set(uvm_root::get(), "*", "vif", vif);
    run_test();
  end

  initial begin
    vif.sig_reset <= 1'b1;
    vif.sig_clock <= 1'b1;
    #51 vif.sig_reset = 1'b0;
  end

  //Generate Clock
  always
    #5 vif.sig_clock = ~vif.sig_clock;

endmodule
//----------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2011 Cadence Design Systems, Inc.
//   Copyright 2010 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitaions under the License.
//----------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// CLASS: slave_address_map_info
//
// The following class is used to determine which slave should respond 
// to a transfer on the bus
//------------------------------------------------------------------------------

class slave_address_map_info extends uvm_object;

  protected int min_addr;
  protected int max_addr;
 
  function new(string name = "slave_address_map_info");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(slave_address_map_info)
    `uvm_field_int(min_addr, UVM_DEFAULT)
    `uvm_field_int(max_addr, UVM_DEFAULT)
  `uvm_object_utils_end

  function void set_address_map (int min_addr, int max_addr); 
    this.min_addr = min_addr;
    this.max_addr = max_addr;
  endfunction : set_address_map

  // get the min addr
  function bit [15:0] get_min_addr();
    return min_addr;
  endfunction : get_min_addr

  // get the max addr
  function bit [15:0] get_max_addr();
    return max_addr;
  endfunction : get_max_addr

endclass : slave_address_map_info


// Enumerated for ubus bus state

typedef enum {RST_START, RST_STOP, NO_OP, ARBI, ADDR_PH, ADDR_PH_ERROR, 
  DATA_PH} ubus_bus_state;


//------------------------------------------------------------------------------
//
// CLASS: ubus_status
//
//------------------------------------------------------------------------------

class ubus_status extends uvm_object;

  ubus_bus_state bus_state;

  function new(string name = "ubus_status");
    super.new(name);
  endfunction

  `uvm_object_utils_begin(ubus_status)
    `uvm_field_enum(ubus_bus_state, bus_state, UVM_DEFAULT)
  `uvm_object_utils_end

endclass : ubus_status


//------------------------------------------------------------------------------
//
// CLASS: ubus_bus_monitor
//
//------------------------------------------------------------------------------

class ubus_bus_monitor extends uvm_monitor;

  // The virtual interface used to view HDL signals.
  protected virtual ubus_if vif;

  // Property indicating the number of transactions occuring on the ubus.
  protected int unsigned num_transactions = 0;

  // The following two bits are used to control whether checks and coverage are
  // done both in the bus monitor class and the interface.
  bit checks_enable = 1; 
  bit coverage_enable = 1;

  // Analysis ports for the item_collected and state notifier.
  uvm_analysis_port #(ubus_transfer) item_collected_port;
  uvm_analysis_port #(ubus_status) state_port;

  // The state of the ubus
  protected ubus_status status;

  // The following property is used to store slave address map
  protected slave_address_map_info slave_addr_map[string];

  // The following property holds the transaction information currently
  // being captured (by the collect_address_phase and data_phase methods). 
  protected ubus_transfer trans_collected;

  // Events needed to trigger covergroups
  protected event cov_transaction;
  protected event cov_transaction_beat;

  // Fields to hold trans data and wait_state.  No coverage of dynamic arrays.
  protected bit [15:0] addr;
  protected bit [7:0] data;
  protected int unsigned wait_state;

  // Transfer collected covergroup
  covergroup cov_trans @cov_transaction;
    option.per_instance = 1;
    trans_start_addr : coverpoint trans_collected.addr {
      option.auto_bin_max = 16; }
    trans_dir : coverpoint trans_collected.read_write;
    trans_size : coverpoint trans_collected.size {
      bins sizes[] = {1, 2, 4, 8};
      illegal_bins invalid_sizes = default; }
    trans_addrXdir : cross trans_start_addr, trans_dir;
    trans_dirXsize : cross trans_dir, trans_size;
  endgroup : cov_trans

  // Transfer collected data covergroup
  covergroup cov_trans_beat @cov_transaction_beat;
    option.per_instance = 1;
    beat_addr : coverpoint addr {
      option.auto_bin_max = 16; }
    beat_dir : coverpoint trans_collected.read_write;
    beat_data : coverpoint data {
      option.auto_bin_max = 8; }
    beat_wait : coverpoint wait_state {
      bins waits[] = { [0:9] };
      bins others = { [10:$] }; }
    beat_addrXdir : cross beat_addr, beat_dir;
    beat_addrXdata : cross beat_addr, beat_data;
  endgroup : cov_trans_beat

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(ubus_bus_monitor)
    `uvm_field_int(checks_enable, UVM_DEFAULT)
    `uvm_field_int(coverage_enable, UVM_DEFAULT)
    `uvm_field_int(num_transactions, UVM_DEFAULT)
    `uvm_field_aa_object_string(slave_addr_map, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    cov_trans = new();
    cov_trans.set_inst_name({get_full_name(), ".cov_trans"});
    cov_trans_beat = new();
    cov_trans_beat.set_inst_name({get_full_name(), ".cov_trans_beat"});
    trans_collected = new();
    item_collected_port = new("item_collected_port", this);
    state_port = new("state_port", this);
    status = new("status");
  endfunction : new

  // set_slave_configs
  function void set_slave_configs(string slave_name,
    int min_addr, int max_addr);
    slave_addr_map[slave_name] = new();
    slave_addr_map[slave_name].set_address_map(min_addr, max_addr);
  endfunction : set_slave_configs

  function void build_phase(uvm_phase phase);
      if(!uvm_config_db#(virtual ubus_if)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase

  // run phase
  task run_phase(uvm_phase phase);
    fork
      observe_reset();
      collect_transactions();
    join
  endtask : run_phase

  // observe_reset
  task observe_reset();
    fork
      forever begin
        @(posedge vif.sig_reset);
        status.bus_state = RST_START;
        state_port.write(status);
      end
      forever begin
        @(negedge vif.sig_reset);
        status.bus_state = RST_STOP;
        state_port.write(status);
      end
    join
  endtask : observe_reset

  // collect_transactions
  virtual protected task collect_transactions();
    forever begin
      collect_arbitration_phase();
      collect_address_phase();
      collect_data_phase();
      `uvm_info(get_type_name(),$sformatf("Transfer collected :\n%s", 
        trans_collected.sprint()), UVM_HIGH)
      if (checks_enable)
        perform_transfer_checks();
      if (coverage_enable)
        perform_transfer_coverage(); 
      item_collected_port.write(trans_collected);
    end
  endtask : collect_transactions

  // collect_arbitration_phase
  task collect_arbitration_phase();
    string tmpStr;
    @(posedge vif.sig_clock iff (vif.sig_grant != 0));
    status.bus_state = ARBI;
    state_port.write(status);
    void'(this.begin_tr(trans_collected));
    // Check which grant is asserted to determine which master is performing
    // the transfer on the bus.
    for (int j = 0; j <= 15; j++) begin
      if (vif.sig_grant[j] === 1) begin
        $sformat(tmpStr,"masters[%0d]", j);
        trans_collected.master = tmpStr;
        break;   
      end 
    end
  endtask : collect_arbitration_phase

  // collect_address_phase
  task collect_address_phase();
    @(posedge vif.sig_clock);
    trans_collected.addr = vif.sig_addr;
    case (vif.sig_size)
      2'b00 : trans_collected.size = 1;
      2'b01 : trans_collected.size = 2;
      2'b10 : trans_collected.size = 4;
      2'b11 : trans_collected.size = 8;
    endcase
    trans_collected.data = new[trans_collected.size];
    case ({vif.sig_read,vif.sig_write})
      2'b00 : begin
        trans_collected.read_write = NOP;
        status.bus_state = NO_OP;
        state_port.write(status);
      end
      2'b10 : begin
        trans_collected.read_write = READ;
        status.bus_state = ADDR_PH;
        state_port.write(status);
      end
      2'b01 : begin
        trans_collected.read_write = WRITE;
        status.bus_state = ADDR_PH;
        state_port.write(status);
      end
      2'b11 : begin
        status.bus_state = ADDR_PH_ERROR;
        state_port.write(status);
        if (checks_enable)
          `uvm_error(get_type_name(),
            "Read and Write true at the same time")
      end            
    endcase
  endtask : collect_address_phase

  // collect_data_phase
  task collect_data_phase();
    int i;
    if (trans_collected.read_write != NOP) begin
      check_which_slave();
      for (i = 0; i < trans_collected.size; i++) begin
        status.bus_state = DATA_PH;
        state_port.write(status);
        @(posedge vif.sig_clock iff vif.sig_wait === 0);
        trans_collected.data[i] = vif.sig_data;
      end
      num_transactions++;
      this.end_tr(trans_collected);
    end
  endtask : collect_data_phase

  // check_which_slave
  function void check_which_slave();
    string slave_name;
    bit slave_found;
    slave_found = 1'b0;
    if(slave_addr_map.first(slave_name))
      do begin
        if (slave_addr_map[slave_name].get_min_addr() <= trans_collected.addr
          && trans_collected.addr <= slave_addr_map[slave_name].get_max_addr()) 
        begin
          trans_collected.slave = slave_name;
          slave_found = 1'b1;
        end
        if (slave_found == 1'b1)
          break;
      end
    while (slave_addr_map.next(slave_name));
      assert(slave_found) else begin
        `uvm_error(get_type_name(),
          $sformatf("Master attempted a transfer at illegal address 16'h%0h", 
          trans_collected.addr))
      end
  endfunction : check_which_slave

  // perform_transfer_checks
  function void perform_transfer_checks();
    check_transfer_size();
    check_transfer_data_size();
  endfunction : perform_transfer_checks

  // check_transfer_size
  function void check_transfer_size();
   if (trans_collected.read_write != NOP) begin
    assert_transfer_size : assert(trans_collected.size == 1 || 
      trans_collected.size == 2 || trans_collected.size == 4 || 
      trans_collected.size == 8) else begin
      `uvm_error(get_type_name(),
        "Invalid transfer size!")
    end
   end
  endfunction : check_transfer_size

  // check_transfer_data_size
  function void check_transfer_data_size();
    if (trans_collected.size != trans_collected.data.size())
      `uvm_error(get_type_name(),
        "Transfer size field / data size mismatch.")
  endfunction : check_transfer_data_size

  // perform_transfer_coverage
  function void perform_transfer_coverage();
    if (trans_collected.read_write != NOP) begin
      -> cov_transaction;
      for (int unsigned i = 0; i < trans_collected.size; i++) begin
        addr = trans_collected.addr + i;
        data = trans_collected.data[i];
        //wait_state = trans_collected.wait_state[i];
        -> cov_transaction_beat;
      end
    end
  endfunction : perform_transfer_coverage

endclass : ubus_bus_monitor


//----------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2011 Cadence Design Systems, Inc.
//   Copyright 2010 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// CLASS: ubus_env
//
//------------------------------------------------------------------------------

class ubus_env extends uvm_env;

  // Virtual Interface variable
  protected virtual interface ubus_if vif;

  // Control properties
  protected bit has_bus_monitor = 1;
  protected int num_masters = 0;
  protected int num_slaves = 0;

  // The following two bits are used to control whether checks and coverage are
  // done both in the bus monitor class and the interface.
  bit intf_checks_enable = 1; 
  bit intf_coverage_enable = 1;

  // Components of the environment
  ubus_bus_monitor bus_monitor;
  ubus_master_agent masters[];
  ubus_slave_agent slaves[];

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(ubus_env)
    `uvm_field_int(has_bus_monitor, UVM_DEFAULT)
    `uvm_field_int(num_masters, UVM_DEFAULT)
    `uvm_field_int(num_slaves, UVM_DEFAULT)
    `uvm_field_int(intf_checks_enable, UVM_DEFAULT)
    `uvm_field_int(intf_coverage_enable, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build_phase
  function void build_phase(uvm_phase phase);
    string inst_name;
//    set_phase_domain("uvm");
    super.build_phase(phase);
     if(!uvm_config_db#(virtual ubus_if)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
     
    if(has_bus_monitor == 1) begin
      bus_monitor = ubus_bus_monitor::type_id::create("bus_monitor", this);
    end
    
    void'(uvm_config_db#(int)::get(this, "", "num_masters", num_masters));
   
    masters = new[num_masters];
    for(int i = 0; i < num_masters; i++) begin
      $sformat(inst_name, "masters[%0d]", i);
      masters[i] = ubus_master_agent::type_id::create(inst_name, this);
      void'(uvm_config_db#(int)::set(this,{inst_name,".monitor"}, 
				 "master_id", i));
      void'(uvm_config_db#(int)::set(this,{inst_name,".driver"}, 
				 "master_id", i));
    end

    void'(uvm_config_db#(int)::get(this, "", "num_slaves", num_slaves));
    
    slaves = new[num_slaves];
    for(int i = 0; i < num_slaves; i++) begin
      $sformat(inst_name, "slaves[%0d]", i);
      slaves[i] = ubus_slave_agent::type_id::create(inst_name, this);
    end
  endfunction : build_phase

  // set_slave_address_map
  function void set_slave_address_map(string slave_name, 
    int min_addr, int max_addr);
    ubus_slave_monitor tmp_slave_monitor;
    if( bus_monitor != null ) begin
      // Set slave address map for bus monitor
      bus_monitor.set_slave_configs(slave_name, min_addr, max_addr);
    end
    // Set slave address map for slave monitor
    $cast(tmp_slave_monitor, lookup({slave_name, ".monitor"}));
    tmp_slave_monitor.set_addr_range(min_addr, max_addr);
  endfunction : set_slave_address_map

  // update_vif_enables
  protected task update_vif_enables();
    forever begin
      @(intf_checks_enable || intf_coverage_enable);
      vif.has_checks <= intf_checks_enable;
      vif.has_coverage <= intf_coverage_enable;
    end
  endtask : update_vif_enables

  // implement run task
  task run_phase(uvm_phase phase);
    fork
      update_vif_enables();
    join
  endtask : run_phase

endclass : ubus_env


//----------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2010 Cadence Design Systems, Inc.
//   Copyright 2010 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------
/******************************************************************************

  FILE : ubus_bus_monitor_if.sv

 ******************************************************************************/

interface ubus_if;

  // Control flags
  bit                has_checks = 1;
  bit                has_coverage = 1;

  // Actual Signals
  logic              sig_clock;
  logic              sig_reset;
  logic       [15:0] sig_request;
  logic       [15:0] sig_grant;
  logic       [15:0] sig_addr;
  logic        [1:0] sig_size;
  logic              sig_read;
  logic              sig_write;
  logic              sig_start;
  logic              sig_bip;
  wire logic   [7:0] sig_data;
  logic        [7:0] sig_data_out;
  logic              sig_wait;
  logic              sig_error;

  logic              rw;

assign sig_data = rw ? sig_data_out : 8'bz;

// Coverage and assertions to be implemented here.

always @(negedge sig_clock)
begin

// Address must not be X or Z during Address Phase
assertAddrUnknown:assert property (
                  disable iff(!has_checks) 
                  ($onehot(sig_grant) |-> !$isunknown(sig_addr)))
                  else
                    $error("ERR_ADDR_XZ\n Address went to X or Z \
                            during Address Phase");

// Read must not be X or Z during Address Phase
assertReadUnknown:assert property ( 
                  disable iff(!has_checks) 
                  ($onehot(sig_grant) |-> !$isunknown(sig_read)))
                  else
                    $error("ERR_READ_XZ\n READ went to X or Z during \
                            Address Phase");

// Write must not be X or Z during Address Phase
assertWriteUnknown:assert property ( 
                   disable iff(!has_checks) 
                   ($onehot(sig_grant) |-> !$isunknown(sig_write)))
                   else
                     $error("ERR_WRITE_XZ\n WRITE went to X or Z during \
                             Address Phase");

// Size must not be X or Z during Address Phase
assertSizeUnknown:assert property ( 
                  disable iff(!has_checks) 
                  ($onehot(sig_grant) |-> !$isunknown(sig_size)))
                  else
                    $error("ERR_SIZE_XZ\n SIZE went to X or Z during \
                            Address Phase");


// Wait must not be X or Z during Data Phase
assertWaitUnknown:assert property ( 
                  disable iff(!has_checks) 
                  ($onehot(sig_grant) |=> !$isunknown(sig_wait)))
                  else
                    $error("ERR_WAIT_XZ\n WAIT went to X or Z during \
                            Data Phase");


// Error must not be X or Z during Data Phase
assertErrorUnknown:assert property ( 
                   disable iff(!has_checks) 
                   ($onehot(sig_grant) |=> !$isunknown(sig_error)))
                   else
                    $error("ERR_ERROR_XZ\n ERROR went to X or Z during \
                            Data Phase");


//Reset must be asserted for at least 3 clocks each time it is asserted
assertResetFor3Clocks: assert property (
                       disable iff(!has_checks) 
                       ($rose(sig_reset) |=> sig_reset[*2]))
                       else 
                         $error("ERR_SHORT_RESET_DURING_TEST\n",
                                "Reset was asserted for less than 3 clock \
                                 cycles");

// Only one grant is asserted
//assertSingleGrant: assert property (
//                   disable iff(!has_checks)
//                   (sig_start |=> $onehot0(sig_grant)))
//                   else
//                     $error("ERR_GRANT\n More that one grant asserted");

// Read and write never true at the same time
assertReadOrWrite: assert property (
                   disable iff(!has_checks) 
                   ($onehot(sig_grant) |-> !(sig_read && sig_write)))
                   else
                     $error("ERR_READ_OR_WRITE\n Read and Write true at \
                             the same time");

end

endinterface : ubus_if

//----------------------------------------------------------------------
//   Copyright 2007-2011 Mentor Graphics Corporation
//   Copyright 2007-2011 Cadence Design Systems, Inc.
//   Copyright 2010 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// CLASS: ubus_master_agent
//
//------------------------------------------------------------------------------

class ubus_master_agent extends uvm_agent;

  protected int master_id;

  ubus_master_driver driver;
  uvm_sequencer#(ubus_transfer) sequencer;
  ubus_master_monitor monitor;

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(ubus_master_agent)
    `uvm_field_int(master_id, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor = ubus_master_monitor::type_id::create("monitor", this);

    if(get_is_active() == UVM_ACTIVE) begin
      sequencer = uvm_sequencer#(ubus_transfer)::type_id::create("sequencer", this);
      driver = ubus_master_driver::type_id::create("driver", this);
    end
  endfunction : build_phase

  // connect_phase
  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction : connect_phase

endclass : ubus_master_agent


//----------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2011 Cadence Design Systems, Inc.
//   Copyright 2010 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// CLASS: ubus_master_driver
//
//------------------------------------------------------------------------------

class ubus_master_driver extends uvm_driver #(ubus_transfer);

  // The virtual interface used to drive and view HDL signals.
  protected virtual ubus_if vif;

  // Master Id
  protected int master_id;

  // Provide implmentations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(ubus_master_driver)
    `uvm_field_int(master_id, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     if(!uvm_config_db#(virtual ubus_if)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive();
      reset_signals();
    join
  endtask : run_phase

  // get_and_drive 
  virtual protected task get_and_drive();
    @(negedge vif.sig_reset);
    forever begin
      @(posedge vif.sig_clock);
      seq_item_port.get_next_item(req);
      $cast(rsp, req.clone());
      rsp.set_id_info(req);
      drive_transfer(rsp);
      seq_item_port.item_done();
      seq_item_port.put_response(rsp);
    end
  endtask : get_and_drive

  // reset_signals
  virtual protected task reset_signals();
    forever begin
      @(posedge vif.sig_reset);
      vif.sig_request[master_id]  <= 0;
      vif.rw                      <= 'h0;
      vif.sig_addr           <= 'hz;
      vif.sig_data_out       <= 'hz;
      vif.sig_size           <= 'bz;
      vif.sig_read           <= 'bz;
      vif.sig_write          <= 'bz;
      vif.sig_bip            <= 'bz;
    end
  endtask : reset_signals

  // drive_transfer
  virtual protected task drive_transfer (ubus_transfer trans);
    if (trans.transmit_delay > 0) begin
      repeat(trans.transmit_delay) @(posedge vif.sig_clock);
    end
    arbitrate_for_bus();
    drive_address_phase(trans);
    drive_data_phase(trans);
  endtask : drive_transfer

  // arbitrate_for_bus
  virtual protected task arbitrate_for_bus();
    vif.sig_request[master_id] <= 1;
    @(posedge vif.sig_clock iff vif.sig_grant[master_id] === 1);
    vif.sig_request[master_id] <= 0;
  endtask : arbitrate_for_bus

  // drive_address_phase
  virtual protected task drive_address_phase (ubus_transfer trans);
    vif.sig_addr <= trans.addr;
    drive_size(trans.size);
    drive_read_write(trans.read_write);
    @(posedge vif.sig_clock);
    vif.sig_addr <= 32'bz;
    vif.sig_size <= 2'bz;
    vif.sig_read <= 1'bz;
    vif.sig_write <= 1'bz;  
  endtask : drive_address_phase

  // drive_data_phase
  virtual protected task drive_data_phase (ubus_transfer trans);
    bit err;
    for(int i = 0; i <= trans.size - 1; i ++) begin
      if (i == (trans.size - 1))
        vif.sig_bip <= 0;
      else
        vif.sig_bip <= 1;
      case (trans.read_write)
        READ    : read_byte(trans.data[i], err);
        WRITE   : write_byte(trans.data[i], err);
      endcase
    end //for loop
    vif.sig_data_out <= 8'bz;
    vif.sig_bip <= 1'bz;
  endtask : drive_data_phase

  // read_byte
  virtual protected task read_byte (output bit [7:0] data, output bit error);
    vif.rw <= 1'b0;
    @(posedge vif.sig_clock iff vif.sig_wait === 0);
    data = vif.sig_data;
  endtask : read_byte

  // write_byte
  virtual protected task write_byte (bit[7:0] data, output bit error);
    vif.rw <= 1'b1;
    vif.sig_data_out <= data;
    @(posedge vif.sig_clock iff vif.sig_wait === 0);
    vif.rw <= 'h0;
  endtask : write_byte

  // drive_size
  virtual protected task drive_size (int size);
    case (size)
      1: vif.sig_size <=  2'b00;
      2: vif.sig_size <=  2'b01;
      4: vif.sig_size <=  2'b10;
      8: vif.sig_size <=  2'b11;
    endcase
  endtask : drive_size

  // drive_read_write            
  virtual protected task drive_read_write(ubus_read_write_enum rw);
    case (rw)
      NOP   : begin vif.sig_read <= 0; vif.sig_write <= 0; end
      READ  : begin vif.sig_read <= 1; vif.sig_write <= 0; end
      WRITE : begin vif.sig_read <= 0; vif.sig_write <= 1; end
    endcase
  endtask : drive_read_write

endclass : ubus_master_driver


//----------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2011 Cadence Design Systems, Inc.
//   Copyright 2010 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// CLASS: ubus_master_monitor
//
//------------------------------------------------------------------------------

class ubus_master_monitor extends uvm_monitor;

  // This property is the virtual interfaced needed for this component to drive
  // and view HDL signals. 
  protected virtual ubus_if vif;

  // Master Id
  protected int master_id;

  // The following two bits are used to control whether checks and coverage are
  // done both in the monitor class and the interface.
  bit checks_enable = 1;
  bit coverage_enable = 1;

  uvm_analysis_port #(ubus_transfer) item_collected_port;

  // The following property holds the transaction information currently
  // begin captured (by the collect_address_phase and data_phase methods). 
  protected ubus_transfer trans_collected;

  // Fields to hold trans addr, data and wait_state.
  protected bit [15:0] addr;
  protected bit [7:0] data;
  protected int unsigned wait_state;

  // Transfer collected covergroup
  covergroup cov_trans;
    option.per_instance = 1;
    trans_start_addr : coverpoint trans_collected.addr {
      option.auto_bin_max = 16; }
    trans_dir : coverpoint trans_collected.read_write;
    trans_size : coverpoint trans_collected.size {
      bins sizes[] = {1, 2, 4, 8};
      illegal_bins invalid_sizes = default; }
    trans_addrXdir : cross trans_start_addr, trans_dir;
    trans_dirXsize : cross trans_dir, trans_size;
  endgroup : cov_trans

  // Transfer collected beat covergroup
  covergroup cov_trans_beat;
    option.per_instance = 1;
    beat_addr : coverpoint addr {
      option.auto_bin_max = 16; }
    beat_dir : coverpoint trans_collected.read_write;
    beat_data : coverpoint data {
      option.auto_bin_max = 8; }
    beat_wait : coverpoint wait_state {
      bins waits[] = { [0:9] };
      bins others = { [10:$] }; }
    beat_addrXdir : cross beat_addr, beat_dir;
    beat_addrXdata : cross beat_addr, beat_data;
  endgroup : cov_trans_beat

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(ubus_master_monitor)
    `uvm_field_int(master_id, UVM_DEFAULT)
    `uvm_field_int(checks_enable, UVM_DEFAULT)
    `uvm_field_int(coverage_enable, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    cov_trans = new();
    cov_trans.set_inst_name({get_full_name(), ".cov_trans"});
    cov_trans_beat = new();
    cov_trans_beat.set_inst_name({get_full_name(), ".cov_trans_beat"});
    trans_collected = new();
    item_collected_port = new("item_collected_port", this);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual ubus_if)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    `uvm_info({get_full_name()," MASTER ID"},$sformatf(" = %0d",master_id),UVM_MEDIUM)
    fork
      collect_transactions();
    join
  endtask : run_phase

  // collect_transactions
  virtual protected task collect_transactions();
    forever begin
      @(posedge vif.sig_clock);
      if (m_parent != null)
        trans_collected.master = m_parent.get_name();
      collect_arbitration_phase();
      collect_address_phase();
      collect_data_phase();
      `uvm_info(get_full_name(), $sformatf("Transfer collected :\n%s",
        trans_collected.sprint()), UVM_MEDIUM)
      if (checks_enable)
        perform_transfer_checks();
      if (coverage_enable)
         perform_transfer_coverage();
      item_collected_port.write(trans_collected);
    end
  endtask : collect_transactions

  // collect_arbitration_phase
  virtual protected task collect_arbitration_phase();
    @(posedge vif.sig_request[master_id]);
    @(posedge vif.sig_clock iff vif.sig_grant[master_id] === 1);
    void'(this.begin_tr(trans_collected));
  endtask : collect_arbitration_phase

  // collect_address_phase
  virtual protected task collect_address_phase();
    @(posedge vif.sig_clock);
    trans_collected.addr = vif.sig_addr;
    case (vif.sig_size)
      2'b00 : trans_collected.size = 1;
      2'b01 : trans_collected.size = 2;
      2'b10 : trans_collected.size = 4;
      2'b11 : trans_collected.size = 8;
    endcase
    trans_collected.data = new[trans_collected.size];
    case ({vif.sig_read,vif.sig_write})
      2'b00 : trans_collected.read_write = NOP;
      2'b10 : trans_collected.read_write = READ;
      2'b01 : trans_collected.read_write = WRITE;
    endcase
  endtask : collect_address_phase

  // collect_data_phase
  virtual protected task collect_data_phase();
    int i;
    if (trans_collected.read_write != NOP)
      for (i = 0; i < trans_collected.size; i++) begin
        @(posedge vif.sig_clock iff vif.sig_wait === 0);
        trans_collected.data[i] = vif.sig_data;
      end
    this.end_tr(trans_collected);
  endtask : collect_data_phase

  // perform_transfer_checks
  virtual protected function void perform_transfer_checks();
    check_transfer_size();
    check_transfer_data_size();
  endfunction : perform_transfer_checks

  // check_transfer_size
  virtual protected function void check_transfer_size();
    assert_transfer_size : assert(trans_collected.size == 1 || 
      trans_collected.size == 2 || trans_collected.size == 4 || 
      trans_collected.size == 8) else begin
      `uvm_error(get_type_name(),
        "Invalid transfer size!")
    end
  endfunction : check_transfer_size

  // check_transfer_data_size
  virtual protected function void check_transfer_data_size();
    if (trans_collected.size != trans_collected.data.size())
      `uvm_error(get_type_name(),
        "Transfer size field / data size mismatch.")
  endfunction : check_transfer_data_size

  // perform_transfer_coverage
  virtual protected function void perform_transfer_coverage();
    cov_trans.sample();
    for (int unsigned i = 0; i < trans_collected.size; i++) begin
      addr = trans_collected.addr + i;
      data = trans_collected.data[i];
//Wait state is not currently monitored
//      wait_state = trans_collected.wait_state[i];
      cov_trans_beat.sample();
    end
  endfunction : perform_transfer_coverage

  virtual function void report_phase(uvm_phase phase);
    `uvm_info(get_full_name(),$sformatf("Covergroup 'cov_trans' coverage: %2f",
					cov_trans.get_inst_coverage()),UVM_LOW)
  endfunction

endclass : ubus_master_monitor


//----------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2010 Cadence Design Systems, Inc.
//   Copyright 2010 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// SEQUENCE: ubus_base_sequence
//
//------------------------------------------------------------------------------

// This sequence raises/drops objections in the pre/post_body so that root
// sequences raise objections but subsequences do not.

virtual class ubus_base_sequence extends uvm_sequence #(ubus_transfer);

  function new(string name="ubus_base_seq");
    super.new(name);
  endfunction
  
  // Raise in pre_body so the objection is only raised for root sequences.
  // There is no need to raise for sub-sequences since the root sequence
  // will encapsulate the sub-sequence. 
  virtual task pre_body();
    if (starting_phase!=null) begin
       `uvm_info(get_type_name(),
		 $sformatf("%s pre_body() raising %s objection", 
			   get_sequence_path(),
			   starting_phase.get_name()), UVM_MEDIUM);
       starting_phase.raise_objection(this);
    end
  endtask

  // Drop the objection in the post_body so the objection is removed when
  // the root sequence is complete. 
  virtual task post_body();
    if (starting_phase!=null) begin
       `uvm_info(get_type_name(),
		 $sformatf("%s post_body() dropping %s objection", 
			   get_sequence_path(),
			   starting_phase.get_name()), UVM_MEDIUM);
    starting_phase.drop_objection(this);
    end
  endtask
  
endclass : ubus_base_sequence

//------------------------------------------------------------------------------
//
// SEQUENCE: read_byte
//
//------------------------------------------------------------------------------

class read_byte_seq extends ubus_base_sequence;

  function new(string name="read_byte_seq");
    super.new(name);
  endfunction
  
  `uvm_object_utils(read_byte_seq)

  rand bit [15:0] start_addr;
  rand int unsigned transmit_del = 0;
  constraint transmit_del_ct { (transmit_del <= 10); }

  virtual task body();
    `uvm_do_with(req, 
      { req.addr == start_addr;
        req.read_write == READ;
        req.size == 1;
        req.error_pos == 1000;
        req.transmit_delay == transmit_del; } )
    get_response(rsp);
    `uvm_info(get_type_name(),
      $sformatf("%s read : addr = `x%0h, data[0] = `x%0h",
      get_sequence_path(), rsp.addr, rsp.data[0]), 
      UVM_HIGH);
  endtask
  
endclass : read_byte_seq


//------------------------------------------------------------------------------
//
// SEQUENCE: read_half_word_seq
//
//------------------------------------------------------------------------------

class read_half_word_seq extends ubus_base_sequence;

  function new(string name="read_half_word_seq");
    super.new(name);
  endfunction
  
  `uvm_object_utils(read_half_word_seq)

  rand bit [15:0] start_addr;
  rand int unsigned transmit_del = 0;
  constraint transmit_del_ct { (transmit_del <= 10); }

  virtual task body();
    `uvm_do_with(req, 
      { req.addr == start_addr;
        req.read_write == READ;
        req.size == 2;
        req.error_pos == 1000;
        req.transmit_delay == transmit_del; } )
    get_response(rsp);
    `uvm_info(get_type_name(),
      $sformatf("%s read : addr = `x%0h, data[0] = `x%0h, data[1] = `x%0h", 
      get_sequence_path(), rsp.addr, rsp.data[0], rsp.data[1]), UVM_HIGH);
  endtask

endclass : read_half_word_seq


//------------------------------------------------------------------------------
//
// SEQUENCE: read_word_seq
//
//------------------------------------------------------------------------------

class read_word_seq extends ubus_base_sequence;

  function new(string name="read_word_seq");
    super.new(name);
  endfunction
  
  `uvm_object_utils(read_word_seq)

  rand bit [15:0] start_addr;
  rand int unsigned transmit_del = 0;
  constraint transmit_del_ct { (transmit_del <= 10); }

  virtual task body();
    `uvm_do_with(req, 
      { req.addr == start_addr;
        req.read_write == READ;
        req.size == 4;
        req.error_pos == 1000;
        req.transmit_delay == transmit_del; } )
    get_response(rsp);
    `uvm_info(get_type_name(),
      $sformatf("%s read : addr = `x%0h, data[0] = `x%0h, \
      data[1] = `x%0h, data[2] = `x%0h, data[3] = `x%0h",
      get_sequence_path(), rsp.addr, rsp.data[0], rsp.data[1], 
      rsp.data[2], rsp.data[3]), UVM_HIGH);
  endtask
  
endclass : read_word_seq


//------------------------------------------------------------------------------
//
// SEQUENCE: read_double_word_seq
//
//------------------------------------------------------------------------------

class read_double_word_seq extends ubus_base_sequence;

  function new(string name="read_double_word_seq");
    super.new(name);
  endfunction
  
  `uvm_object_utils(read_double_word_seq)

  rand bit [15:0] start_addr;
  rand int unsigned transmit_del = 0;
  constraint transmit_del_ct { (transmit_del <= 10); }

  virtual task body();
    `uvm_do_with(req, 
      { req.addr == start_addr;
        req.read_write == READ;
        req.size == 8;
        req.error_pos == 1000;
        req.transmit_delay == transmit_del; } )
    get_response(rsp);
    `uvm_info(get_type_name(),
      $sformatf("%s read : addr = `x%0h, data[0] = `x%0h, \
      data[1] = `x%0h, data[2] = `x%0h, data[3] = `x%0h, data[4] = `x%0h, \
      data[5] = `x%0h, data[6] = `x%0h, data[7] = `x%0h",
      get_sequence_path(), rsp.addr, rsp.data[0], rsp.data[1], rsp.data[2],
      rsp.data[3], rsp.data[4], rsp.data[5], rsp.data[6], rsp.data[7]), 
      UVM_HIGH);
  endtask
  
endclass : read_double_word_seq


//------------------------------------------------------------------------------
//
// SEQUENCE: write_byte_seq
//
//------------------------------------------------------------------------------

class write_byte_seq extends ubus_base_sequence;

  function new(string name="write_byte_seq");
    super.new(name);
  endfunction

  `uvm_object_utils(write_byte_seq)
    
  rand bit [15:0] start_addr;
  rand bit [7:0] data0;
  rand int unsigned transmit_del = 0;
  constraint transmit_del_ct { (transmit_del <= 10); }

  virtual task body();
    `uvm_do_with(req, 
      { req.addr == start_addr;
        req.read_write == WRITE;
        req.size == 1;
        req.data[0] == data0;
        req.error_pos == 1000;
        req.transmit_delay == transmit_del; } )
    `uvm_info(get_type_name(),
      $sformatf("%s wrote : addr = `x%0h, data[0] = `x%0h",
      get_sequence_path(), req.addr, req.data[0]),
      UVM_HIGH);
  endtask

endclass : write_byte_seq


//------------------------------------------------------------------------------
//
// SEQUENCE: write_half_word_seq
//
//------------------------------------------------------------------------------

class write_half_word_seq extends ubus_base_sequence;

  function new(string name="write_half_word_seq");
    super.new(name);
  endfunction

  `uvm_object_utils(write_half_word_seq)
    
  rand bit [15:0] start_addr;
  rand bit [7:0] data0;
  rand bit [7:0] data1;
  rand int unsigned transmit_del = 0;
  constraint transmit_del_ct { transmit_del <= 10; }

  virtual task body();
    `uvm_do_with(req, 
      { req.addr == start_addr; 
        req.read_write == WRITE;
        req.size == 2; 
        req.data[0] == data0; req.data[1] == data1;
        req.error_pos == 1000; 
        req.transmit_delay == transmit_del; } )
    `uvm_info(get_type_name(),
      $sformatf("%s wrote : addr = `x%0h, data[0] = `x%0h, data[1] = `x%0h",
      get_sequence_path(), req.addr, req.data[0], req.data[1]), UVM_HIGH);
  endtask

endclass : write_half_word_seq


//------------------------------------------------------------------------------
//
// SEQUENCE: write_word_seq
//
//------------------------------------------------------------------------------

class write_word_seq extends ubus_base_sequence;

  function new(string name="write_word_seq");
    super.new(name);
  endfunction

  `uvm_object_utils(write_word_seq)
    
  rand bit [15:0] start_addr;
  rand bit [7:0] data0; rand bit [7:0] data1;
  rand bit [7:0] data2; rand bit [7:0] data3;
  rand int unsigned transmit_del = 0;
  constraint transmit_del_ct { (transmit_del <= 10); }

  virtual task body();
    `uvm_do_with(req, 
      { req.addr == start_addr;
        req.read_write == WRITE;
        req.size == 4;
         req.data[0] == data0; req.data[1] == data1;
         req.data[2] == data2; req.data[3] == data3;
        req.error_pos == 1000;
        req.transmit_delay == transmit_del; } )
    `uvm_info(get_type_name(),
      $sformatf("%s wrote : addr = `x%0h, data[0] = `x%0h, \
      data[1] = `x%0h, data[2] = `x%0h, data[3] = `x%0h", 
      get_sequence_path(), req.addr, req.data[0],
      req.data[1], req.data[2], req.data[3]),
      UVM_HIGH);
  endtask

endclass : write_word_seq


//------------------------------------------------------------------------------
//
// SEQUENCE: write_double_word_seq
//
//------------------------------------------------------------------------------

class write_double_word_seq extends ubus_base_sequence;

  function new(string name="write_double_word_seq");
    super.new(name);
  endfunction

  `uvm_object_utils(write_double_word_seq)
    
  rand bit [15:0] start_addr;
  rand bit [7:0] data0; rand bit [7:0] data1;
  rand bit [7:0] data2; rand bit [7:0] data3;
  rand bit [7:0] data4; rand bit [7:0] data5;
  rand bit [7:0] data6; rand bit [7:0] data7;
  rand int unsigned transmit_del = 0;
  constraint transmit_del_ct { (transmit_del <= 10); }

  virtual task body();
    `uvm_do_with(req, 
      { req.addr == start_addr;
        req.read_write == WRITE;
        req.size == 8;
         req.data[0] == data0; req.data[1] == data1;
         req.data[2] == data2; req.data[3] == data3;
         req.data[4] == data4; req.data[5] == data5;
         req.data[6] == data6; req.data[7] == data7;
        req.error_pos == 1000;
        req.transmit_delay == transmit_del; } )
    `uvm_info(get_type_name(),
      $sformatf("Writing  %s : addr = `x%0h, data[0] = `x%0h, \
      data[1] = `x%0h, data[2] = `x%0h, data[3] = `x%0h, data[4] = `x%0h, \
      data[5] = `x%0h, data[6] = `x%0h, data[7] = `x%0h",
      get_sequence_path(), req.addr, req.data[0], req.data[1], req.data[2], 
      req.data[3], req.data[4], req.data[5], req.data[6], req.data[7]), 
      UVM_HIGH);
  endtask

endclass : write_double_word_seq


//----------------------------------------------------------------------
//   Copyright 2007-2011 Mentor Graphics Corporation
//   Copyright 2007-2010 Cadence Design Systems, Inc.
//   Copyright 2010 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// CLASS: ubus_master_sequencer
//
//------------------------------------------------------------------------------

class ubus_master_sequencer extends uvm_sequencer #(ubus_transfer);

   `uvm_component_utils(ubus_master_sequencer)
     
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

endclass : ubus_master_sequencer


//----------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2010 Cadence Design Systems, Inc.
//   Copyright 2010 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------


package ubus_pkg;

   import uvm_pkg::*;

`include "uvm_macros.svh"

   typedef uvm_config_db#(virtual ubus_if) ubus_vif_config;
   typedef virtual ubus_if ubus_vif;

`include "ubus_transfer.sv"

`include "ubus_master_monitor.sv"
`include "ubus_master_sequencer.sv"
`include "ubus_master_driver.sv"
`include "ubus_master_agent.sv"

`include "ubus_slave_monitor.sv"
`include "ubus_slave_sequencer.sv"
`include "ubus_slave_driver.sv"
`include "ubus_slave_agent.sv"

`include "ubus_bus_monitor.sv"

`include "ubus_env.sv"

endpackage: ubus_pkg

//----------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2011 Cadence Design Systems, Inc.
//   Copyright 2010 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// CLASS: ubus_slave_agent
//
//------------------------------------------------------------------------------

class ubus_slave_agent extends uvm_agent;

  ubus_slave_driver driver;
  ubus_slave_sequencer sequencer;
  ubus_slave_monitor monitor;

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(ubus_slave_agent)
  `uvm_component_utils_end

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build_phase
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor = ubus_slave_monitor::type_id::create("monitor", this);
    if(get_is_active() == UVM_ACTIVE) begin
      driver = ubus_slave_driver::type_id::create("driver", this);
      sequencer = ubus_slave_sequencer::type_id::create("sequencer", this);
    end
  endfunction : build_phase

  // connect_phase
  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
      sequencer.addr_ph_port.connect(monitor.addr_ph_imp);
    end
  endfunction : connect_phase

endclass : ubus_slave_agent


//----------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2011 Cadence Design Systems, Inc.
//   Copyright 2010 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// CLASS: ubus_slave_driver
//
//------------------------------------------------------------------------------

class ubus_slave_driver extends uvm_driver #(ubus_transfer);

  // The virtual interface used to drive and view HDL signals.
  protected virtual ubus_if vif;

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils(ubus_slave_driver)

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
     if(!uvm_config_db#(virtual ubus_if)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      get_and_drive();
      reset_signals();
    join
  endtask : run_phase

  // get_and_drive
  virtual protected task get_and_drive();
    @(negedge vif.sig_reset);
    forever begin
      @(posedge vif.sig_clock);
      seq_item_port.get_next_item(req);
      respond_to_transfer(req);
      seq_item_port.item_done();
    end
  endtask : get_and_drive

  // reset_signals
  virtual protected task reset_signals();
    forever begin
      @(posedge vif.sig_reset);
      vif.sig_error      <= 1'bz;
      vif.sig_wait       <= 1'bz;
      vif.rw             <= 1'b0;
    end
  endtask : reset_signals

  // respond_to_transfer
  virtual protected task respond_to_transfer(ubus_transfer resp);
    if (resp.read_write != NOP)
    begin
      vif.sig_error <= 1'b0;
      for (int i = 0; i < resp.size; i++)
      begin
        case (resp.read_write)
          READ : begin
            vif.rw <= 1'b1;
            vif.sig_data_out <= resp.data[i];
          end
          WRITE : begin
          end
        endcase
        if (resp.wait_state[i] > 0) begin
          vif.sig_wait <= 1'b1;
          repeat (resp.wait_state[i])
            @(posedge vif.sig_clock);
        end
        vif.sig_wait <= 1'b0;
        @(posedge vif.sig_clock);
        resp.data[i] = vif.sig_data;
      end
      vif.rw <= 1'b0;
      vif.sig_wait  <= 1'bz;
      vif.sig_error <= 1'bz;
    end
  endtask : respond_to_transfer

endclass : ubus_slave_driver


//----------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2011 Cadence Design Systems, Inc.
//   Copyright 2010 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// CLASS: ubus_slave_monitor
//
//------------------------------------------------------------------------------

class ubus_slave_monitor extends uvm_monitor;

  // This property is the virtual interface needed for this component to drive
  // and view HDL signals.
  protected virtual ubus_if vif;

  // The following two unsigned integer properties are used by
  // check_addr_range() method to detect if a transaction is for this target.
  protected int unsigned min_addr = 16'h0000;
  protected int unsigned max_addr = 16'hFFFF;

  // The following two bits are used to control whether checks and coverage are
  // done both in the monitor class and the interface.
  bit checks_enable = 1;
  bit coverage_enable = 1;

  uvm_analysis_port#(ubus_transfer) item_collected_port;
  uvm_blocking_peek_imp#(ubus_transfer,ubus_slave_monitor) addr_ph_imp;

  // The following property holds the transaction information currently
  // begin captured (by the collect_address_phase and data_phase methods). 
  protected ubus_transfer trans_collected;

  // monitor notifier that the address phase (and full item) has been collected
  protected event address_phase_grabbed;

  // Events needed to trigger covergroups
  protected event cov_transaction;
  protected event cov_transaction_beat;

  // Fields to hold trans data and wait_state.  No coverage of dynamic arrays.
  protected bit [15:0] addr;
  protected bit [7:0] data;
  protected int unsigned wait_state;

  // Transfer collected covergroup
  covergroup cov_trans;
    option.per_instance = 1;
    trans_start_addr : coverpoint trans_collected.addr {
      option.auto_bin_max = 16; }
    trans_dir : coverpoint trans_collected.read_write;
    trans_size : coverpoint trans_collected.size {
      bins sizes[] = {1, 2, 4, 8};
      illegal_bins invalid_sizes = default; }
    trans_addrXdir : cross trans_start_addr, trans_dir;
    trans_dirXsize : cross trans_dir, trans_size;
  endgroup : cov_trans

  // Transfer collected data covergroup
  covergroup cov_trans_beat;
    option.per_instance = 1;
    beat_addr : coverpoint addr {
      option.auto_bin_max = 16; }
    beat_dir : coverpoint trans_collected.read_write;
    beat_data : coverpoint data {
      option.auto_bin_max = 8; }
    beat_wait : coverpoint wait_state {
      bins waits[] = { [0:9] };
      bins others = { [10:$] }; }
    beat_addrXdir : cross beat_addr, beat_dir;
    beat_addrXdata : cross beat_addr, beat_data;
  endgroup : cov_trans_beat

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils_begin(ubus_slave_monitor)
    `uvm_field_int(min_addr, UVM_DEFAULT)
    `uvm_field_int(max_addr, UVM_DEFAULT)
    `uvm_field_int(checks_enable, UVM_DEFAULT)
    `uvm_field_int(coverage_enable, UVM_DEFAULT)
  `uvm_component_utils_end

  // new - constructor
  function new(string name, uvm_component parent=null);
    super.new(name, parent);
    cov_trans = new();
    cov_trans.set_inst_name({get_full_name(), ".cov_trans"});
    cov_trans_beat = new();
    cov_trans_beat.set_inst_name({get_full_name(), ".cov_trans_beat"});
    trans_collected = new();
    item_collected_port = new("item_collected_port", this);
    addr_ph_imp = new("addr_ph_imp", this);
  endfunction : new

  function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(virtual ubus_if)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase

  // set the monitor's address range
  function void set_addr_range(bit [15:0] min_addr, bit [15:0] max_addr);
    this.min_addr = min_addr;
    this.max_addr = max_addr;
  endfunction : set_addr_range

  // get the monitor's min addr
  function bit [15:0] get_min_addr();
    return min_addr;
  endfunction : get_min_addr

  // get the monitor's max addr
  function bit [15:0] get_max_addr();
    return max_addr;
  endfunction : get_max_addr

  // run phase
  virtual task run_phase(uvm_phase phase);
    fork
      collect_transactions();
    join
  endtask : run_phase

  // collect_transactions
  virtual protected task collect_transactions();
    bit range_check;
    forever begin
      if (m_parent != null)
        trans_collected.slave = m_parent.get_name();
      collect_address_phase();
      range_check = check_addr_range();
      if (range_check) begin
        void'(this.begin_tr(trans_collected));
        -> address_phase_grabbed;
        collect_data_phase();
        `uvm_info(get_type_name(), $sformatf("Transfer collected :\n%s",
          trans_collected.sprint()), UVM_FULL)
        if (checks_enable)
          perform_transfer_checks();
        if (coverage_enable)
          perform_transfer_coverage();
        item_collected_port.write(trans_collected);
      end
    end
  endtask : collect_transactions

  // check_addr_range
  virtual protected function bit check_addr_range();
    if ((trans_collected.addr >= min_addr) &&
      (trans_collected.addr <= max_addr)) begin
      return 1;
    end
    return 0;
  endfunction : check_addr_range

  // collect_address_phase
  virtual protected task collect_address_phase();
    @(posedge vif.sig_clock iff ( (vif.sig_read === 1) || 
      (vif.sig_write === 1) ) );
    trans_collected.addr = vif.sig_addr;
    case (vif.sig_size)
      2'b00 : trans_collected.size = 1;
      2'b01 : trans_collected.size = 2;
      2'b10 : trans_collected.size = 4;
      2'b11 : trans_collected.size = 8;
    endcase
    trans_collected.data = new[trans_collected.size];
    case ({vif.sig_read,vif.sig_write})
      2'b00 : trans_collected.read_write = NOP;
      2'b10 : trans_collected.read_write = READ;
      2'b01 : trans_collected.read_write = WRITE;
    endcase
  endtask : collect_address_phase

  // collect_data_phase
  virtual protected task collect_data_phase();
    if (trans_collected.read_write != NOP) begin
      for (int i = 0; i < trans_collected.size; i++) begin
        @(posedge vif.sig_clock iff vif.sig_wait === 0);
        trans_collected.data[i] = vif.sig_data;
      end
    end
    this.end_tr(trans_collected);
  endtask : collect_data_phase

  // perform_transfer_checks
  protected function void perform_transfer_checks();
    check_transfer_size();
    check_transfer_data_size();
  endfunction : perform_transfer_checks

  // check_transfer_size
  protected function void check_transfer_size();
    assert_transfer_size : assert(trans_collected.size == 1 || 
      trans_collected.size == 2 || trans_collected.size == 4 || 
      trans_collected.size == 8) else begin
      `uvm_error(get_type_name(),
        "Invalid transfer size!")
    end
  endfunction : check_transfer_size

  // check_transfer_data_size
  protected function void check_transfer_data_size();
    if (trans_collected.size != trans_collected.data.size())
      `uvm_error(get_type_name(),
        "Transfer size field / data size mismatch.")
  endfunction : check_transfer_data_size

  // perform_transfer_coverage
  protected function void perform_transfer_coverage();
    cov_trans.sample();
    for (int unsigned i = 0; i < trans_collected.size; i++) begin
      addr = trans_collected.addr + i;
      data = trans_collected.data[i];
//Wait state inforamtion is not currently monitored.
//      wait_state = trans_collected.wait_state[i];
      cov_trans_beat.sample();
    end
  endfunction : perform_transfer_coverage

  task peek(output ubus_transfer trans);
    @address_phase_grabbed;
    trans = trans_collected;
  endtask : peek

  virtual function void report_phase(uvm_phase phase);
    `uvm_info(get_full_name(),$sformatf("Covergroup 'cov_trans' coverage: %2f",
					cov_trans.get_inst_coverage()),UVM_LOW)
  endfunction

endclass : ubus_slave_monitor


//----------------------------------------------------------------------
//   Copyright 2007-2011 Mentor Graphics Corporation
//   Copyright 2007-2010 Cadence Design Systems, Inc.
//   Copyright 2010 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// SEQUENCE: simple_response_seq
//
//------------------------------------------------------------------------------

class simple_response_seq extends uvm_sequence #(ubus_transfer);
   ubus_slave_sequencer p_sequencer;
   
  function new(string name="simple_response_seq");
    super.new(name);
  endfunction

//  `uvm_sequence_utils(simple_response_seq, ubus_slave_sequencer)
    
  `uvm_object_utils(simple_response_seq)

  ubus_transfer util_transfer;

  virtual task body();
     $cast(p_sequencer, m_sequencer);
     
    `uvm_info(get_type_name(),
      $sformatf("%s starting...",
      get_sequence_path()), UVM_MEDIUM);
    forever begin
      p_sequencer.addr_ph_port.peek(util_transfer);

      // Need to raise/drop objection before each item because we don't want
      // to be stopped in the middle of a transfer.
      uvm_test_done.raise_objection(this);
      `uvm_do_with(req, 
        { req.read_write == util_transfer.read_write; 
          req.size == util_transfer.size; 
          req.error_pos == 1000; } )
      uvm_test_done.drop_objection(this);
    end
  endtask : body

endclass : simple_response_seq


//------------------------------------------------------------------------------
//
// SEQUENCE: slave_memory_seq
//
//------------------------------------------------------------------------------

class slave_memory_seq extends uvm_sequence #(ubus_transfer);

  function new(string name="slave_memory_seq");
    super.new(name);
  endfunction

//  `uvm_sequence_utils(slave_memory_seq, ubus_slave_sequencer)

  `uvm_object_utils(slave_memory_seq)
  `uvm_declare_p_sequencer(ubus_slave_sequencer)

  ubus_transfer util_transfer;

  int unsigned m_mem[int unsigned];

  virtual task pre_do(bit is_item);
    // Update the properties that are relevant to both read and write
    req.size       = util_transfer.size;
    req.addr       = util_transfer.addr;             
    req.read_write = util_transfer.read_write;             
    req.error_pos  = 1000;             
    req.transmit_delay = 0;
    req.data = new[util_transfer.size];
    req.wait_state = new[util_transfer.size];
    for(int unsigned i = 0 ; i < util_transfer.size ; i ++) begin
      req.wait_state[i] = 2;
      // For reads, populate req with the random "readback" data of the size
      // requested in util_transfer
      if( req.read_write == READ ) begin : READ_block
        if (!m_mem.exists(util_transfer.addr + i)) begin
          m_mem[util_transfer.addr + i] = $urandom;
        end
        req.data[i] = m_mem[util_transfer.addr + i];
      end
    end
  endtask

  function void post_do(uvm_sequence_item this_item);
    // For writes, update the m_mem associative array
    if( util_transfer.read_write == WRITE ) begin : WRITE_block
      for(int unsigned i = 0 ; i < req.size ; i ++) begin : for_block
        m_mem[req.addr + i] = req.data[i];
      end : for_block
    end
  endfunction

  virtual task body();
    `uvm_info(get_type_name(),
      $sformatf("%s starting...",
      get_sequence_path()), UVM_MEDIUM);

    $cast(req, create_item(ubus_transfer::get_type(), p_sequencer, "req"));

    forever
    begin
      p_sequencer.addr_ph_port.peek(util_transfer);

      // Need to raise/drop objection before each item because we don't want
      // to be stopped in the middle of a transfer.
      starting_phase.raise_objection(this);

      start_item(req);
      finish_item(req);

      starting_phase.drop_objection(this);
    end
  endtask : body

endclass : slave_memory_seq


//----------------------------------------------------------------------
//   Copyright 2007-2011 Mentor Graphics Corporation
//   Copyright 2007-2010 Cadence Design Systems, Inc.
//   Copyright 2010 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// CLASS: ubus_slave_sequencer
//
//------------------------------------------------------------------------------

class ubus_slave_sequencer extends uvm_sequencer #(ubus_transfer);

  // TLM port to peek the address phase from the slave monitor
  uvm_blocking_peek_port#(ubus_transfer) addr_ph_port;

  // Provide implementations of virtual methods such as get_type_name and create
  `uvm_component_utils(ubus_slave_sequencer)

  
  function new (string name, uvm_component parent);
    super.new(name, parent);
    addr_ph_port = new("addr_ph_port", this);
  endfunction : new

endclass : ubus_slave_sequencer


//----------------------------------------------------------------------
//   Copyright 2007-2010 Mentor Graphics Corporation
//   Copyright 2007-2010 Cadence Design Systems, Inc.
//   Copyright 2010 Synopsys, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// ubus transfer enums, parameters, and events
//
//------------------------------------------------------------------------------

typedef enum { NOP,
               READ,
               WRITE
             } ubus_read_write_enum;

//------------------------------------------------------------------------------
//
// CLASS: ubus_transfer
//
//------------------------------------------------------------------------------

class ubus_transfer extends uvm_sequence_item;                                  

  rand bit [15:0]           addr;
  rand ubus_read_write_enum read_write;
  rand int unsigned         size;
  rand bit [7:0]            data[];
  rand bit [3:0]            wait_state[];
  rand int unsigned         error_pos;
  rand int unsigned         transmit_delay = 0;
  string                    master = "";
  string                    slave = "";

  constraint c_read_write {
    read_write inside { READ, WRITE };
  }
  constraint c_size {
    size inside {1,2,4,8};
  }
  constraint c_data_wait_size {
    data.size() == size;
    wait_state.size() == size;
  }
  constraint c_transmit_delay { 
    transmit_delay <= 10 ; 
  }

  `uvm_object_utils_begin(ubus_transfer)
    `uvm_field_int      (addr,           UVM_DEFAULT)
    `uvm_field_enum     (ubus_read_write_enum, read_write, UVM_DEFAULT)
    `uvm_field_int      (size,           UVM_DEFAULT)
    `uvm_field_array_int(data,           UVM_DEFAULT)
    `uvm_field_array_int(wait_state,     UVM_DEFAULT)
    `uvm_field_int      (error_pos,      UVM_DEFAULT)
    `uvm_field_int      (transmit_delay, UVM_DEFAULT)
    `uvm_field_string   (master,         UVM_DEFAULT|UVM_NOCOMPARE)
    `uvm_field_string   (slave,          UVM_DEFAULT|UVM_NOCOMPARE)
  `uvm_object_utils_end

  // new - constructor
  function new (string name = "ubus_transfer_inst");
    super.new(name);
  endfunction : new

endclass : ubus_transfer


