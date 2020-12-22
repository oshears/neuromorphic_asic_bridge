#!/usr/bin/bash

# https://www.xilinx.com/support/answers/63985.html


xvhdl ../src/servo_controller.vhd --log ./logs/xvhdl.log
xvhdl ../tb/Servo_Controller_Testbench.vhd --log ./logs/xvhdl.log
# xvhdl servo_controller_functions_pkg.vhd
# xvhdl clock_divider.vhd
# xvhdl axi_rc_servo_controller.vhd
# xvhdl clock_divider_Testbench.vhd
# xvhdl AXI_ADDRESS_CONTROL_CHANNEL_model.vhd
# xvhdl AXI_lite_master_transaction_model.vhd
# xvhdl axi_rc_servo_controller_tb.vhd
# xvhdl AXI_READ_DATA_CHANNEL_model.vhd
# xvhdl AXI_WRITE_DATA_CHANNEL_model.vhd
# xvhdl AXI_WRITE_RESPONSE_CHANNEL_model.vhd

xelab -debug typical Servo_Controller_Testbench -s servo_controller_sim --log ./logs/xelab.log
xsim servo_controller_sim -t servo_controller_xsim_run.tcl --log ./logs/xsim.log --wdb servo_controller_sim.wdb

rm *.jou
rm *.log
rm *.pb