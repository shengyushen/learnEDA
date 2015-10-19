#!/bin/bash 
irun \
	-uvm t1.sv ssy_dut.v\
	+UVM_TESTNAME=ssy_test \
	+UVM_VERBOSITY=UVM_HIGH \
	-input run.tcl 

# option to show all the config operation
#	+UVM_CONFIG_DB_TRACE  \
#	-tcl
#	-access rw \
