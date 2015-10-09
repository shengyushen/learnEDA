set allreg [find -recursive all -internals -registers *]
set maxcnt 100
set cnt 0
foreach r ${allreg} {
	#puts $r
	set v [value $r]
	if {[string equal "1\'b0" ${v}] \
	|| [string equal "1\'b1" ${v}]  \
	|| [string equal "1\'h0" ${v}]  \
	|| [string equal "1\'h1" ${v}]  \
	|| [string equal "1\'d0" ${v}]  \
	|| [string equal "1\'d1" ${v}]  \
	|| [string equal "1\'o0" ${v}]  \
	|| [string equal "1\'o1" ${v}]  \
	} {
	} else {
	  puts "XVALUE : ${r}" ;
		incr cnt
	}
	
	if { $maxcnt > 0 } {
		if { $cnt >= $maxcnt } break
	}
}
