# usage: vivado -mode tcl -source createBridgeProject.tcl

set_param general.maxThreads 8

create_project pmod_dac_test_block_project ./pmod_dac_test_block_project -part xc7z020clg484-1 -force

set_property board_part em.avnet.com:zed:part0:1.4 [current_project]

add_files {
    ../rtl/tb/pmod_dac_test_block_tb.v
    ../rtl/src/pmod_dac_test_block.v
    }


move_files -fileset sim_1 [get_files  ../rtl/tb/pmod_dac_test_block_tb.v]


# Load Constraints
read_xdc ../xdc/pmod_dac_test_block.xdc

set_property top pmod_dac_test_block_tb [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

set_property -name {xsim.simulate.log_all_signals} -value {true} -objects [get_filesets sim_1]
set_property -name {xsim.simulate.runtime} -value {all} -objects [get_filesets sim_1]

launch_simulation


# Verify Implementation
# read_xdc ../xdc/neuromorphic_asic_bridge_constraints.xdc
# synth_design -rtl -rtl_skip_mlo -name rtl_1
# reset_run synth_1
# launch_runs impl_1 -jobs 16
# wait_on_run impl_1
# open_run impl_1


exit