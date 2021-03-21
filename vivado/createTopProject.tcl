# usage: vivado -mode tcl -source createTopProject.tcl

set_param general.maxThreads 8

# Create Project
create_project neuromorphic_asic_bridge_system_project ./neuromorphic_asic_bridge_system_project -part xc7z020clg484-1 -force

# Add Custom IP
set_property  ip_repo_paths  /home/oshears/Documents/vt/research/code/verilog/neuromorphic_asic_bridge/ [current_project]
update_ip_catalog

# Create Block Design and Add Zynq Processing System
create_bd_design "neuromorphic_asic_bridge_system"
update_compile_order -fileset sources_1
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0

# Add Custom Neuromorphic Bridge IP
create_bd_cell -type ip -vlnv user.org:user:neuromorphic_asic_bridge_top:1.0 neuromorphic_asic_br_0

# Apply Block Automation
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]

# Configure Zynq PS with ZedBoard defaults
set_property -dict [list CONFIG.preset {ZedBoard}] [get_bd_cells processing_system7_0]

# Configure AXI CLK to 25MHz
set_property -dict [list CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {10}] [get_bd_cells processing_system7_0]
# Create slow clock for pwm_clk
set_property -dict [list CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {1} CONFIG.PCW_EN_CLK1_PORT {1}] [get_bd_cells processing_system7_0]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK1] [get_bd_pins neuromorphic_asic_br_0/pwm_clk]

# Apply Connection Automation (Connect Clocks)
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/processing_system7_0/M_AXI_GP0} Slave {/neuromorphic_asic_br_0/S_AXI} ddr_seg {Auto} intc_ip {New AXI Interconnect} master_apm {0}}  [get_bd_intf_pins neuromorphic_asic_br_0/S_AXI]

# Configure Neuromorphic Bridge IP
make_bd_pins_external  [get_bd_pins neuromorphic_asic_br_0/digit]
make_bd_pins_external  [get_bd_pins neuromorphic_asic_br_0/leds]
make_bd_pins_external  [get_bd_pins neuromorphic_asic_br_0/VP]
make_bd_pins_external  [get_bd_pins neuromorphic_asic_br_0/VN]
make_bd_pins_external  [get_bd_pins neuromorphic_asic_br_0/XADC_MUXADDR]

# Add Internal Logic Analyzer
create_bd_cell -type ip -vlnv xilinx.com:ip:ila:6.2 ila_0
set_property -dict [list CONFIG.C_PROBE0_WIDTH {16} CONFIG.C_NUM_OF_PROBES {1} CONFIG.C_ENABLE_ILA_AXI_MON {false} CONFIG.C_MONITOR_TYPE {Native}] [get_bd_cells ila_0]
connect_bd_net [get_bd_pins neuromorphic_asic_br_0/digit] [get_bd_pins ila_0/probe0]
# connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins ila_0/clk]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK1] [get_bd_pins ila_0/clk]
# create_bd_port -dir I GCLK
# connect_bd_net [get_bd_ports GCLK] [get_bd_pins ila_0/clk]

# Save Block Design
save_bd_design

# Validate Block Design
validate_bd_design -force

# Make a top level wrapper
make_wrapper -files [get_files ./neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.srcs/sources_1/bd/neuromorphic_asic_bridge_system/neuromorphic_asic_bridge_system.bd] -top
add_files -norecurse ./neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.gen/sources_1/bd/neuromorphic_asic_bridge_system/hdl/neuromorphic_asic_bridge_system_wrapper.v

# Update Compile Order
update_compile_order -fileset sources_1

# Load Constraints
read_xdc ../xdc/neuromorphic_asic_bridge_system_constraints.xdc
import_files -fileset constrs_1 ../xdc/neuromorphic_asic_bridge_system_constraints.xdc
set_property target_constrs_file ../xdc/neuromorphic_asic_bridge_system_constraints.xdc [current_fileset -constrset]

# Generate Output Products
generate_target all [get_files ./neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.srcs/sources_1/bd/neuromorphic_asic_bridge_system/neuromorphic_asic_bridge_system.bd]

# Open Elaborated Design
# create_ip_run [get_files -of_objects [get_fileset sources_1] ./neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.srcs/sources_1/bd/neuromorphic_asic_bridge_system/neuromorphic_asic_bridge_system.bd]
# launch_runs neuromorphic_asic_bridge_system_processing_system7_0_0_synth_1 -jobs 16
# wait_on_run neuromorphic_asic_bridge_system_processing_system7_0_0_synth_1
# launch_runs neuromorphic_asic_bridge_system_neuromorphic_asic_br_0_0_synth_1 -jobs 16
# wait_on_run neuromorphic_asic_bridge_system_neuromorphic_asic_br_0_0_synth_1
# launch_runs neuromorphic_asic_bridge_system_rst_ps7_0_100M_0_synth_1 -jobs 16
# wait_on_run neuromorphic_asic_bridge_system_rst_ps7_0_100M_0_synth_1
# launch_runs neuromorphic_asic_bridge_system_auto_pc_0_synth_1 -jobs 16
# wait_on_run neuromorphic_asic_bridge_system_auto_pc_0_synth_1
# launch_runs neuromorphic_asic_bridge_system_ila_0_0_synth_1 -jobs 16
# wait_on_run neuromorphic_asic_bridge_system_ila_0_0_synth_1

# synth_design -rtl -rtl_skip_mlo -name rtl_1

# Run Synthesis
launch_runs synth_1 -jobs 16
wait_on_run synth_1
# open_run synth_1 -name synth_1
# report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose -max_paths 10 -input_pins -routable_nets -name timing_1
## Add ILA
# create_debug_core u_ila_0 ila
# set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
# set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
# set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
# set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
# set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
# set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
# set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
# set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
# connect_debug_port u_ila_0/clk [get_nets [list neuromorphic_asic_bridge_system_i/processing_system7_0/inst/FCLK_CLK1 ]]
# set_property port_width 16 [get_debug_ports u_ila_0/probe0]
# set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
# connect_debug_port u_ila_0/probe0 [get_nets [list {digit_0_OBUF[0]} {digit_0_OBUF[1]} {digit_0_OBUF[2]} {digit_0_OBUF[3]} {digit_0_OBUF[4]} {digit_0_OBUF[5]} {digit_0_OBUF[6]} {digit_0_OBUF[7]} {digit_0_OBUF[8]} {digit_0_OBUF[9]} {digit_0_OBUF[10]} {digit_0_OBUF[11]} {digit_0_OBUF[12]} {digit_0_OBUF[13]} {digit_0_OBUF[14]} {digit_0_OBUF[15]} ]]

# Run Implementation
# launch_runs impl_1 -jobs 16
# wait_on_run impl_1

# Generate Bitstream
launch_runs impl_1 -to_step write_bitstream -jobs 16 -verbose
wait_on_run impl_1

# Open Implemented Design for Hardware Export
open_run impl_1

# Export Hardware for Vitis
# write_hw_platform -fixed -include_bit -force -file ./neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system.xsa
write_hw_platform -fixed -include_bit -force -file ./neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_wrapper.xsa

exit