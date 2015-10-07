database -open -shm -into waves.shm waves -default
probe -create -database waves -all -depth all
assertion -strict on
run 1000ns
assertion -summary

