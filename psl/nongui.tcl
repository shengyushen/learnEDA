assertion -strict on
run 100000ns
assertion -summary
# assertion -off -all 
# disabling certain types of directive
assertion -off -depth all -directive {assert assume}
#  this is used to preven the exit command from reporting runing assertions as errora
# but is does not work
# assertion -logging -error off -all
exit

