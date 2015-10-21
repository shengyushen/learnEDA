clock -add clk -initial 0
force reset 0
run 2

# this init command already define the init state
init -load -current
init -show
debug -init

# these following commands are for setting prove
constraint -add -pin reset 1
assertion -add *
#define delay_assertion 4
prove

