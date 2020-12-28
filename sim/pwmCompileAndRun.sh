#!/usr/bin/bash

# https://www.xilinx.com/support/answers/63985.html


# Clean Up Old Log Files
echo "Cleaning up old log files"
rm ./logs/*.log 2> /dev/null
rm -rf ./xsim.dir 2> /dev/null

while getopts gui:no_compile: flag
do
    case "${flag}" in
        gui) gui=${OPTARG};;
        no_compile) no_compile=${OPTARG};;
    esac
done

### COMPILE
echo "Compiling source and test bench files"

# Compile Servo Controller Source Files and Test Bench Files
xvlog ../rtl/src/char_pwm_gen.v >> ./logs/xvlog.log
xvlog ../rtl/tb/char_pwm_gen_tb.v >> ./logs/xvlog.log

if grep -qs ERROR ./logs/xvhdl.log
then
    echo "Errors found in compile log files: ./logs/xvhdl.log"
    grep ERROR ./logs/xvhdl.log
    exit 1
fi

if grep -qs ERROR ./logs/xvlog.log
then
    echo "Errors found in compile log files: ./logs/xvlog.log"
    grep ERROR ./logs/xvlog.log
    exit 1
fi

### Test Bench ELABORATION
echo "Elaborating test bench files"

xelab -debug typical char_pwm_gen_tb -s char_pwm_gen_sim >> ./logs/xelab.log

if grep -q ERROR ./logs/xelab.log
then
    echo "Errors found in elaboration log files ./logs/xelab.log"
    grep ERROR ./logs/xelab.log
    exit 1
fi

### SIMULATION
echo "Simulating test bench files"

# AXI RC Servo Controller Test Bench Simulation
if $gui
then
    xsim char_pwm_gen_sim --log ./logs/xsim.log --wdb char_pwm_gen_sim.wdb --gui
else
    xsim char_pwm_gen_sim -t xsim_run.tcl --log ./logs/xsim.log --wdb char_pwm_gen_sim.wdb 
fi

# Remove Temporary Files
echo "Removing temporary files"
rm *.jou 2> /dev/null
rm *.log 2> /dev/null
rm *.pb 2> /dev/null
rm *.debug 2> /dev/null
rm *.str 2> /dev/null

# Terminate Script
exit 0