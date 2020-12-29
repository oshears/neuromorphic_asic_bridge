# usage: vivado -source createProject.tcl

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


add_files -fileset constrs_1 -norecurse ../xdc/constraints.xdc

update_compile_order -fileset sources_1

update_compile_order -fileset sources_1

move_files -fileset sim_1 [get_files  ../rtl/tb/neuromorphic_asic_bridge_top_tb.v]
move_files -fileset sim_1 [get_files  ../rtl/tb/char_pwm_gen_tb.v]

# import_files -fileset sim_1 -norecurse ../rtl/tb/design.txt
add_files -fileset sim_1 -norecurse ../rtl/tb/design.txt


update_compile_order -fileset sources_1

set_property top neuromorphic_asic_bridge_top_tb [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
update_compile_order -fileset sim_1

launch_simulation