#add_wave {{/servo_controller/minimum_high_pulse_width_ns}} {{/servo_controller/maximum_high_pulse_width_ns}} {{/servo_controller/clk}} {{/servo_controller/rst}} {{/servo_controller/servo_position_input}} {{/servo_controller/servo_control_out}} 
log_wave -r *
run 10 us
add_wave -r *