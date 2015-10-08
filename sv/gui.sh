#!/bin/bash 
./commonsetting.sh
irun $common_setting \
	-access rwc \
	-gui \
	-input gui.tcl \
	-simvisargs "-layout rtldesign" 
	
