#!/bin/bash 
export common_setting="-assert -propfile_vlog ssy.psl tbssy.sv ssy.v"
irun $common_setting \
	-input nongui.tcl 
