set assert_stop_level {error}
assertion -strict on

# use this to avoid the x on reset from triggering assertion
# this syntax is different from that of assertion controlfile, which use assertion -off/on *
assertion -off -all
run 10ns
assertion -on -all

run 20000ns
assertion -summary
exit
