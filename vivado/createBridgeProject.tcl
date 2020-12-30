# usage: vivado -mode tcl -source createBridgeProject.tcl

create_project neuromorphic_asic_bridge_project ./neuromorphic_asic_bridge_project -part xc7z020clg484-1 -force

set_property board_part em.avnet.com:zed:part0:1.4 [current_project]

add_files {
    ../rtl/tb/char_pwm_gen_tb.v
    ../rtl/src/char_pwm_gen.v 
    ../rtl/src/neuromorphic_asic_bridge_top.v 
    ../rtl/tb/neuromorphic_asic_bridge_top_tb.v 
    ../rtl/src/xadc_interface.v 
    ../rtl/src/axi_cfg_regs.v
    }


add_files -fileset constrs_1 -norecurse ../xdc/neuromorphic_asic_bridge_constraints.xdc

move_files -fileset sim_1 [get_files  ../rtl/tb/neuromorphic_asic_bridge_top_tb.v]
move_files -fileset sim_1 [get_files  ../rtl/tb/char_pwm_gen_tb.v]

add_files -fileset sim_1 -norecurse ../rtl/tb/design.txt

set_property top neuromorphic_asic_bridge_top_tb [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

set_property -name {xsim.simulate.log_all_signals} -value {true} -objects [get_filesets sim_1]
set_property -name {xsim.simulate.runtime} -value {all} -objects [get_filesets sim_1]

launch_simulation

add_wave {{/neuromorphic_asic_bridge_top_tb/uut}} 


# package IP

ipx::package_project -root_dir /home/oshears/Documents/vt/research/code/verilog/neuromorphic_fpga_bridge/ip/neuromorphic_asic_bridge -vendor user.org -library user -taxonomy /UserIP -force
set_property taxonomy {/Embedded_Processing/AXI_Peripheral/Low_Speed_Peripheral /UserIP} [ipx::current_core]
set_property core_revision 1 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::check_integrity [ipx::current_core]
ipx::save_core [ipx::current_core]
set_property  ip_repo_paths  /home/oshears/Documents/vt/research/code/verilog/neuromorphic_fpga_bridge/ip/neuromorphic_asic_bridge [current_project]
update_ip_catalog

exit