#!/bin/bash 
export common_setting="-assert -propfile_vlog ssy.psl tbssy.sv ssy.v"

irun $common_setting \
	-access rwc \
	-gui \
	-input gui.tcl \
	-simvisargs "-layout rtldesign" 
