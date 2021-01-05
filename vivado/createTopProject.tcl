# usage: vivado -mode tcl -source createTopProject.tcl

# Create Project
create_project neuromorphic_asic_bridge_system_project ./neuromorphic_asic_bridge_system_project -part xc7z020clg484-1 -force

# Add Custom IP
set_property  ip_repo_paths  /home/oshears/Documents/vt/research/code/verilog/neuromorphic_fpga_bridge/ [current_project]
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

# Create slow clock for pwm_clk
set_property -dict [list CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {1} CONFIG.PCW_EN_CLK1_PORT {1}] [get_bd_cells processing_system7_0]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK1] [get_bd_pins neuromorphic_asic_br_0/pwm_clk]

# Apply Connection Automation (Connect Clocks)
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/processing_system7_0/M_AXI_GP0} Slave {/neuromorphic_asic_br_0/S_AXI} ddr_seg {Auto} intc_ip {New AXI Interconnect} master_apm {0}}  [get_bd_intf_pins neuromorphic_asic_br_0/S_AXI]

# Configure Neuromorphic Bridge IP
make_bd_pins_external  [get_bd_pins neuromorphic_asic_br_0/digit]
make_bd_pins_external  [get_bd_pins neuromorphic_asic_br_0/VP]
make_bd_pins_external  [get_bd_pins neuromorphic_asic_br_0/VN]
make_bd_pins_external  [get_bd_pins neuromorphic_asic_br_0/VAUXN]
make_bd_pins_external  [get_bd_pins neuromorphic_asic_br_0/VAUXP]

# Save Block Design
save_bd_design

# Update Compile Order
update_compile_order -fileset sources_1

# Validate Block Design
validate_bd_design -force

# Make a top level wrapper
make_wrapper -files [get_files ./neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.srcs/sources_1/bd/neuromorphic_asic_bridge_system/neuromorphic_asic_bridge_system.bd] -top
add_files -norecurse ./neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.gen/sources_1/bd/neuromorphic_asic_bridge_system/hdl/neuromorphic_asic_bridge_system_wrapper.v

# Update Compile Order
update_compile_order -fileset sources_1

# Load Constraints
read_xdc ../xdc/neuromorphic_asic_bridge_system_constraints.xdc

# Generate Output Products
generate_target all [get_files ./neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.srcs/sources_1/bd/neuromorphic_asic_bridge_system/neuromorphic_asic_bridge_system.bd]

# Open Elaborated Design
create_ip_run [get_files -of_objects [get_fileset sources_1] ./neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.srcs/sources_1/bd/neuromorphic_asic_bridge_system/neuromorphic_asic_bridge_system.bd]
launch_runs neuromorphic_asic_bridge_system_processing_system7_0_0_synth_1 -jobs 16
wait_on_run neuromorphic_asic_bridge_system_processing_system7_0_0_synth_1
launch_runs neuromorphic_asic_bridge_system_neuromorphic_asic_br_0_0_synth_1 -jobs 16
wait_on_run neuromorphic_asic_bridge_system_neuromorphic_asic_br_0_0_synth_1
launch_runs neuromorphic_asic_bridge_system_rst_ps7_0_100M_0_synth_1 -jobs 16
wait_on_run neuromorphic_asic_bridge_system_rst_ps7_0_100M_0_synth_1
launch_runs neuromorphic_asic_bridge_system_auto_pc_0_synth_1 -jobs 16
wait_on_run neuromorphic_asic_bridge_system_auto_pc_0_synth_1
synth_design -rtl -rtl_skip_mlo -name rtl_1

# Run Synthesis
launch_runs synth_1 -jobs 16
wait_on_run synth_1

# Run Implementation
launch_runs impl_1 -jobs 16
wait_on_run impl_1

# Generate Bitstream
launch_runs impl_1 -to_step write_bitstream -jobs 16
wait_on_run impl_1

# Open Implemented Design for Hardware Export
open_run impl_1

# Export Hardware for Vitis
# write_hw_platform -fixed -include_bit -force -file ./neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system.xsa
write_hw_platform -fixed -include_bit -force -file ./neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_wrapper.xsa

exit