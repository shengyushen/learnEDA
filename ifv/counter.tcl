# there are four phases
# 1 modeling check mode checking design
# 2 clock optimization 
# 3 constrain verification check mode checking the reachability of constrains
# 4 verification
# only 1 and 4 turn on by default
# to turn on 2 
# define stop_verification clock_not_opt
# to turn on 3
# define constraint_trace on

# engines
# axe* are bdd reachable
# bow* are sat based bmc that is sound but not complete
# dagger is sat based induction, GOOD
# hammer is sat+ bdd cegar
# saber is ic3/pdr GOOD
# spear* is atpg
# sword* may be sat based craig interpolant induction GOOD
# define engine xxx

# verify all safety assertion together, may improve or worsen the reset
# define clubbing on

# this turn on memory and counter abstraction
define word_level_reduction on

# define a new counter and its range we are interest in 
# and let the tool to infer the incr and decr condition
counter -add count_reg
counter -abstract count_reg -interesting_values 0 1 2 3 4 5 
counter -show


clock -add clk -initial 0
force reset_n 0
run 2

# this init command already define the init state
init -load -current
init -show

# opening the waveform to view the init state
# debug -init

# these following commands are for setting prove
constraint -add -pin reset_n 1
# this add all property as assertion, I dont like this
#assertion -add *
#constraint -add *
#define delay_assertion 4

# interactive assertion and constraint with temporal logic operator seems to be supported in documentation
# but I just can not add them
#assertion -add -name assert_interactive -interactive {always (count_reg==3'b001) -> next eventually! (count_reg==3'b100)}

# make the input to change only on clock edge
# constraint -add -change <signal name> -clock <clock name> -edge <posedge|negedge>

prove


# debug <assertion fail name>
