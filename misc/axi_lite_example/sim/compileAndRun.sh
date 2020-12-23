#!/usr/bin/bash

# https://www.xilinx.com/support/answers/63985.html


### COMPILE

# Compile Servo Controller Source Files and Test Bench Files
xvhdl ../src/servo_controller.vhd --log ./logs/xvhdl.log
xvhdl ../tb/Servo_Controller_Testbench.vhd --log ./logs/xvhdl.log

# Compile AXI RC Servo Source Files and Clock Divider Test Bench Files
xvhdl ../src/servo_controller_functions_pkg.vhd --log ./logs/xvhdl.log  --work axi_rc_servo_controller
xvhdl ../src/axi_rc_servo_controller.vhd --log ./logs/xvhdl.logs -L axi_rc_servo_controller
xvhdl ../src/clock_divider.vhd --log ./logs/xvhdl.log -L axi_rc_servo_controller
xvhdl ../tb/clock_divider_Testbench.vhd --log ./logs/xvhdl.log

# Compile AXI RC Servo Controller Test Bench Files
xvhdl ../tb/axi_lite_master_transaction_model/AXI_ADDRESS_CONTROL_CHANNEL_model.vhd
xvhdl ../tb/axi_lite_master_transaction_model/AXI_READ_DATA_CHANNEL_model.vhd
xvhdl ../tb/axi_lite_master_transaction_model/AXI_WRITE_DATA_CHANNEL_model.vhd
xvhdl ../tb/axi_lite_master_transaction_model/AXI_WRITE_RESPONSE_CHANNEL_model.vhd
xvhdl ../tb/axi_lite_master_transaction_model/AXI_lite_master_transaction_model.vhd
xvhdl ../tb/axi_rc_servo_controller_tb.vhd

### Test Bench ELABORATION

xelab -debug typical Servo_Controller_Testbench -s servo_controller_sim --log ./logs/xelab.log
xelab -debug typical clock_divider_Testbench -s clock_divider_sim --log ./logs/xelab.log
xelab -debug typical axi_rc_servo_controller_testbench -s axi_rc_servo_controller_sim --log ./logs/xelab.log


### SIMULATION

# Servo Controller Test Bench Simulation
xsim servo_controller_sim -t xsim_run.tcl --log ./logs/xsim.log --wdb servo_controller_sim.wdb

# Clock Divider Test Bench Simulation
xsim clock_divider_sim -t xsim_run.tcl --log ./logs/xsim.log --wdb clock_divider_sim.wdb

# AXI RC Servo Controller Test Bench Simulation
xsim axi_rc_servo_controller_sim -t xsim_run.tcl --log ./logs/xsim.log --wdb axi_rc_servo_controller_sim.wdb


# Remove Temporary Files
rm *.jou
rm *.log
rm *.pb
rm *.debug