#!/usr/bin/bash

# https://www.xilinx.com/support/answers/63985.html


# Clean Up Old Log Files
echo "Cleaning up old log files"
rm ./logs/*.log
rm -rf ./xsim.dir


### COMPILE
echo "Compiling source and test bench files"

# Compile Servo Controller Source Files and Test Bench Files
xvhdl ../src/servo_controller.vhd >> ./logs/xvhdl.log
xvhdl ../tb/Servo_Controller_Testbench.vhd >> ./logs/xvhdl.log

# Compile AXI RC Servo Source Files and Clock Divider Test Bench Files
xvhdl ../src/servo_controller_functions_pkg.vhd >> ./logs/xvhdl.log  --work axi_rc_servo_controller
xvhdl ../src/axi_rc_servo_controller.vhd >> ./logs/xvhdl.log -L axi_rc_servo_controller
xvhdl ../src/clock_divider.vhd >> ./logs/xvhdl.log -L axi_rc_servo_controller
xvhdl ../tb/clock_divider_Testbench.vhd >> ./logs/xvhdl.log

# Compile AXI RC Servo Controller Test Bench Files
xvhdl ../tb/axi_lite_master_transaction_model/AXI_ADDRESS_CONTROL_CHANNEL_model.vhd >> ./logs/xvhdl.log
xvhdl ../tb/axi_lite_master_transaction_model/AXI_READ_DATA_CHANNEL_model.vhd >> ./logs/xvhdl.log
xvhdl ../tb/axi_lite_master_transaction_model/AXI_WRITE_DATA_CHANNEL_model.vhd >> ./logs/xvhdl.log
xvhdl ../tb/axi_lite_master_transaction_model/AXI_WRITE_RESPONSE_CHANNEL_model.vhd >> ./logs/xvhdl.log
xvhdl ../tb/axi_lite_master_transaction_model/AXI_lite_master_transaction_model.vhd >> ./logs/xvhdl.log
xvhdl ../tb/axi_rc_servo_controller_tb.vhd >> ./logs/xvhdl.log

if grep -q ERROR ./logs/xvhdl.log
then
    echo "Errors found in compile log files: ./logs/xvhdl.log"
    exit 1
fi

### Test Bench ELABORATION
echo "Elaborating test bench files"

xelab -debug typical Servo_Controller_Testbench -s servo_controller_sim >> ./logs/xelab.log
xelab -debug typical clock_divider_Testbench -s clock_divider_sim >> ./logs/xelab.log
xelab -debug typical axi_rc_servo_controller_testbench -s axi_rc_servo_controller_sim >> ./logs/xelab.log

if grep -q ERROR ./logs/xelab.log
then
    echo "Errors found in elaboration log files ./logs/xelab.log"
    exit 1
fi

### SIMULATION
echo "Simulating test bench files"

# Servo Controller Test Bench Simulation
# xsim servo_controller_sim -t xsim_run.tcl --log ./logs/xsim.log --wdb servo_controller_sim.wdb

# Clock Divider Test Bench Simulation
# xsim clock_divider_sim -t xsim_run.tcl --log ./logs/xsim.log --wdb clock_divider_sim.wdb

# AXI RC Servo Controller Test Bench Simulation
xsim axi_rc_servo_controller_sim -t xsim_run.tcl --log ./logs/xsim.log --wdb axi_rc_servo_controller_sim.wdb


# Remove Temporary Files
echo "Removing temporary files"
rm *.jou 2> /dev/null
rm *.log 2> /dev/null
rm *.pb 2> /dev/null
rm *.debug 2> /dev/null
rm *.str 2> /dev/null

# Terminate Script
exit 0