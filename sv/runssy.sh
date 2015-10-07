#!/bin/bash
irun tbssy.sv ssy.v \
	-access rwc \
	-gui \
	-input ssy.tcl \
	-assert \
	-simvisargs "-layout rtldesign" 
