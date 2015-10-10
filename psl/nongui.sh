#!/bin/bash 
irun -assert -propfile_vlog ssy.psl tbssy.sv ssy.v -top tbssy -controlassert ssy.controlassertion \
	-input nongui.tcl 
