# comment this to improve simulation speed?
log_wave -r *

add_condition -notrace sim_end {
    stop
    puts "Test: OK"
}
 
run -all


exit