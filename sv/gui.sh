#!/bin/bash 
# ./common_setting.sh
# -access rwc is for
# r : display the value
# w : Write access is required for forcing or depositing values with Tcl force and deposit commands, or for a PLI/VPI/VHPI application to put values to objects.
# c : findout driven and driving 
# so actually we only need read
irun -assert -propfile_vlog ssy.psl tbssy.sv ssy.v -top tbssy -controlassert ssy.controlassertion \
	-access +r \
	-gui \
	-input gui.tcl \
	-simvisargs "-layout rtldesign" 
	
