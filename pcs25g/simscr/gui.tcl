# these are for gui simulation
database -open -shm -into waves.shm waves -default
probe -create -database waves -all -depth all

set assert_stop_level {error}
assertion -strict on

# use this to avoid the x on reset from triggering assertion
assertion -off -all
run 10ns
assertion -on -all

run 100000ns
assertion -summary
