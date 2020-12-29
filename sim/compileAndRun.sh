#!/usr/bin/bash

# https://www.xilinx.com/support/answers/63985.html


# Clean Up Old Log Files
echo "Cleaning up old log files"
rm ./logs/*.log 2> /dev/null
rm -rf ./xsim.dir 2> /dev/null

OPTIND=1 

GUI=0
NO_COMPILE=0

while getopts "gn:" flag
do
    case "${flag}" in
        g) 
            GUI=1
            ;;
        n) 
            NO_COMPILE=1
            ;;
    esac
done

shift $((OPTIND-1))

# echo "GUI: $GUI"
# echo "NO_COMPILE: $NO_COMPILE"

### COMPILE
echo "Compiling source and test bench files"

# Compile Source Files and Test Bench Files
xvlog ../rtl/src/char_pwm_gen.v >> ./logs/xvlog.log
xvlog ../rtl/src/axi_cfg_regs.v >> ./logs/xvlog.log
xvlog ../rtl/src/xadc_interface.v >> ./logs/xvlog.log
xvlog ../rtl/src/neuromorphic_asic_bridge_top.v >> ./logs/xvlog.log

xvlog ../rtl/tb/neuromorphic_asic_bridge_top_tb.v >> ./logs/xvlog.log

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

xelab -debug typical neuromorphic_asic_bridge_top_tb -s neuromorphic_asic_bridge_top_sim >> ./logs/xelab.log

if grep -q ERROR ./logs/xelab.log
then
    echo "Errors found in elaboration log files ./logs/xelab.log"
    grep ERROR ./logs/xelab.log
    exit 1
fi

### SIMULATION
echo "Simulating test bench files"

# AXI RC Servo Controller Test Bench Simulation
if [ $GUI != "" ]
then
    echo "Running simulation with GUI"
    xsim neuromorphic_asic_bridge_top_sim -t xsim_run.tcl --log ./logs/xsim.log --wdb neuromorphic_asic_bridge_top_sim.wdb --gui --onfinish stop --onerror stop
else
    echo "Running simulation without GUI"
    xsim neuromorphic_asic_bridge_top_sim -t xsim_run.tcl --log ./logs/xsim.log --wdb neuromorphic_asic_bridge_top_sim.wdb --onfinish quit --onerror quit
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