# usage: vivado -mode tcl -source createBridgeProject.tcl

set_param general.maxThreads 8

create_project neuromorphic_asic_bridge_project ./neuromorphic_asic_bridge_project -part xc7z020clg484-1 -force

set_property board_part em.avnet.com:zed:part0:1.4 [current_project]

add_files {
    ../rtl/tb/char_pwm_gen_tb.v
    ../rtl/src/char_pwm_gen.v
    ../rtl/src/pwm_block.v 
    ../rtl/src/pmod_dac_block.v
    ../rtl/src/neuromorphic_asic_bridge_top.v 
    ../rtl/tb/neuromorphic_asic_bridge_top_tb.v 
    ../rtl/src/xadc_interface.v 
    ../rtl/src/axi_cfg_regs.v
    }


move_files -fileset sim_1 [get_files  ../rtl/tb/neuromorphic_asic_bridge_top_tb.v]
move_files -fileset sim_1 [get_files  ../rtl/tb/char_pwm_gen_tb.v]

add_files -fileset sim_1 -norecurse ../rtl/tb/design.txt
import_files -norecurse /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/rtl/tb/design.txt

set_property top neuromorphic_asic_bridge_top_tb [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]


create_ip -name xadc_wiz -vendor xilinx.com -library ip -version 3.3 -module_name xadc_wiz_0
# set_property -dict [list CONFIG.INTERFACE_SELECTION {ENABLE_DRP} CONFIG.XADC_STARUP_SELECTION {channel_sequencer} CONFIG.DCLK_FREQUENCY {50} CONFIG.ENABLE_RESET {true} CONFIG.OT_ALARM {false} CONFIG.USER_TEMP_ALARM {false} CONFIG.VCCINT_ALARM {false} CONFIG.VCCAUX_ALARM {false} CONFIG.ENABLE_VCCPINT_ALARM {false} CONFIG.ENABLE_VCCPAUX_ALARM {false} CONFIG.ENABLE_VCCDDRO_ALARM {false} CONFIG.ENABLE_EXTERNAL_MUX {true} CONFIG.CHANNEL_AVERAGING {256} CONFIG.ADC_OFFSET_CALIBRATION {true} CONFIG.SENSOR_OFFSET_CALIBRATION {true} CONFIG.SIM_FILE_NAME {design.txt} CONFIG.SEQUENCER_MODE {Continuous} CONFIG.ADC_CONVERSION_RATE {962} CONFIG.EXTERNAL_MUX_CHANNEL {VP_VN} CONFIG.SINGLE_CHANNEL_SELECTION {TEMPERATURE} CONFIG.CHANNEL_ENABLE_VP_VN {true}] [get_ips xadc_wiz_0]
# generate_target {instantiation_template} [get_files /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.srcs/sources_1/ip/xadc_wiz_0/xadc_wiz_0.xci]
# generate_target all [get_files  /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.srcs/sources_1/ip/xadc_wiz_0/xadc_wiz_0.xci]
# catch { config_ip_cache -export [get_ips -all xadc_wiz_0] }
# export_ip_user_files -of_objects [get_files /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.srcs/sources_1/ip/xadc_wiz_0/xadc_wiz_0.xci] -no_script -sync -force -quiet
# create_ip_run [get_files -of_objects [get_fileset sources_1] /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.srcs/sources_1/ip/xadc_wiz_0/xadc_wiz_0.xci]
# launch_runs xadc_wiz_0_synth_1 -jobs 16
# export_simulation -of_objects [get_files /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.srcs/sources_1/ip/xadc_wiz_0/xadc_wiz_0.xci] -directory /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.ip_user_files/sim_scripts -ip_user_files_dir /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.ip_user_files -ipstatic_source_dir /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.ip_user_files/ipstatic -lib_map_path [list {modelsim=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.cache/compile_simlib/modelsim} {questa=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.cache/compile_simlib/questa} {ies=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.cache/compile_simlib/ies} {xcelium=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.cache/compile_simlib/xcelium} {vcs=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.cache/compile_simlib/vcs} {riviera=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet
# set_property -dict [list CONFIG.TIMING_MODE {Continuous} CONFIG.DCLK_FREQUENCY {50} CONFIG.ADC_CONVERSION_RATE {962} CONFIG.ENABLE_CALIBRATION_AVERAGING {false} CONFIG.CHANNEL_AVERAGING {None} CONFIG.ADC_OFFSET_CALIBRATION {false} CONFIG.ADC_OFFSET_AND_GAIN_CALIBRATION {false} CONFIG.SENSOR_OFFSET_CALIBRATION {false} CONFIG.SENSOR_OFFSET_AND_GAIN_CALIBRATION {false} CONFIG.CHANNEL_ENABLE_VAUXP0_VAUXN0 {true} CONFIG.CHANNEL_ENABLE_VAUXP1_VAUXN1 {true} CONFIG.CHANNEL_ENABLE_VAUXP2_VAUXN2 {true} CONFIG.CHANNEL_ENABLE_VAUXP3_VAUXN3 {true}] [get_ips xadc_wiz_0]
# generate_target all [get_files  /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.srcs/sources_1/ip/xadc_wiz_0/xadc_wiz_0.xci]
# catch { config_ip_cache -export [get_ips -all xadc_wiz_0] }
# export_ip_user_files -of_objects [get_files /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.srcs/sources_1/ip/xadc_wiz_0/xadc_wiz_0.xci] -no_script -sync -force -quiet
# reset_run xadc_wiz_0_synth_1
# launch_runs xadc_wiz_0_synth_1 -jobs 16
# export_simulation -of_objects [get_files /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.srcs/sources_1/ip/xadc_wiz_0/xadc_wiz_0.xci] -directory /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.ip_user_files/sim_scripts -ip_user_files_dir /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.ip_user_files -ipstatic_source_dir /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.ip_user_files/ipstatic -lib_map_path [list {modelsim=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.cache/compile_simlib/modelsim} {questa=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.cache/compile_simlib/questa} {ies=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.cache/compile_simlib/ies} {xcelium=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.cache/compile_simlib/xcelium} {vcs=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.cache/compile_simlib/vcs} {riviera=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet
# set_property -dict [list CONFIG.CHANNEL_ENABLE_VP_VN {false} CONFIG.SIM_FILE_NAME {design}] [get_ips xadc_wiz_0]
# generate_target all [get_files  /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.srcs/sources_1/ip/xadc_wiz_0/xadc_wiz_0.xci]
# catch { config_ip_cache -export [get_ips -all xadc_wiz_0] }
# export_ip_user_files -of_objects [get_files /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.srcs/sources_1/ip/xadc_wiz_0/xadc_wiz_0.xci] -no_script -sync -force -quiet
# reset_run xadc_wiz_0_synth_1
# launch_runs xadc_wiz_0_synth_1 -jobs 16
# export_simulation -of_objects [get_files /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.srcs/sources_1/ip/xadc_wiz_0/xadc_wiz_0.xci] -directory /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.ip_user_files/sim_scripts -ip_user_files_dir /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.ip_user_files -ipstatic_source_dir /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.ip_user_files/ipstatic -lib_map_path [list {modelsim=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.cache/compile_simlib/modelsim} {questa=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.cache/compile_simlib/questa} {ies=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.cache/compile_simlib/ies} {xcelium=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.cache/compile_simlib/xcelium} {vcs=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.cache/compile_simlib/vcs} {riviera=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet
set_property -dict [list CONFIG.DCLK_FREQUENCY {10} CONFIG.ADC_CONVERSION_RATE {193}] [get_ips xadc_wiz_0]
generate_target all [get_files  /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.srcs/sources_1/ip/xadc_wiz_0/xadc_wiz_0.xci]
catch { config_ip_cache -export [get_ips -all xadc_wiz_0] }
export_ip_user_files -of_objects [get_files /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.srcs/sources_1/ip/xadc_wiz_0/xadc_wiz_0.xci] -no_script -sync -force -quiet
reset_run xadc_wiz_0_synth_1
launch_runs xadc_wiz_0_synth_1 -jobs 16
export_simulation -of_objects [get_files /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.srcs/sources_1/ip/xadc_wiz_0/xadc_wiz_0.xci] -directory /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.ip_user_files/sim_scripts -ip_user_files_dir /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.ip_user_files -ipstatic_source_dir /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.ip_user_files/ipstatic -lib_map_path [list {modelsim=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.cache/compile_simlib/modelsim} {questa=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.cache/compile_simlib/questa} {ies=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.cache/compile_simlib/ies} {xcelium=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.cache/compile_simlib/xcelium} {vcs=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.cache/compile_simlib/vcs} {riviera=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/vivado/neuromorphic_asic_bridge_project/neuromorphic_asic_bridge_project.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet


update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

set_property -name {xsim.simulate.log_all_signals} -value {true} -objects [get_filesets sim_1]
set_property -name {xsim.simulate.runtime} -value {all} -objects [get_filesets sim_1]

launch_simulation

add_wave {{/neuromorphic_asic_bridge_top_tb/uut}} 


# package IP

ipx::package_project -root_dir /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/ -vendor user.org -library user -taxonomy /UserIP -force
set_property taxonomy {/Embedded_Processing/AXI_Peripheral/Low_Speed_Peripheral /UserIP} [ipx::current_core]
set_property core_revision 1 [ipx::current_core]
ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::check_integrity [ipx::current_core]
ipx::save_core [ipx::current_core]
set_property  ip_repo_paths  /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/ [current_project]
update_ip_catalog

# Verify Implementation
# read_xdc ../xdc/neuromorphic_asic_bridge_constraints.xdc
# synth_design -rtl -rtl_skip_mlo -name rtl_1
# reset_run synth_1
# launch_runs impl_1 -jobs 16
# wait_on_run impl_1
# open_run impl_1
# reset_run impl_1
# launch_runs impl_1 -to_step write_bitstream -jobs 16
# wait_on_run impl_1
# reset_run synth_1
# launch_runs synth_1  -jobs 16
# wait_on_run synth_1
# open_run synth_1 -name synth_1
# report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose -max_paths 10 -input_pins -routable_nets -name timing_1

exit