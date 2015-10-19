ock -add clk -initial 0
force reset 0
run 2
init -load -current
init -show
constraint -add -pin reset 1
assertion -add *
prove

