# usage: vivado -mode tcl -source createTopProject.tcl

create_project neuromorphic_asic_bridge_system_project ./neuromorphic_asic_bridge_system_project -part xc7z020clg484-1 -force

# Add Custom IP
set_property  ip_repo_paths  /home/oshears/Documents/vt/research/code/verilog/neuromorphic_fpga_bridge/ [current_project]
update_ip_catalog

# Create Block Design and Add Zynq
create_bd_design "neuromorphic_asic_bridge_system"
update_compile_order -fileset sources_1
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
endgroup

# Add Custom Neuromorphic Bridge IP
startgroup
create_bd_cell -type ip -vlnv user.org:user:neuromorphic_asic_bridge_top:1.0 neuromorphic_asic_br_0
endgroup

# Add UART and USB to the PS
startgroup
set_property -dict [list CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1}] [get_bd_cells processing_system7_0]
endgroup
startgroup
set_property -dict [list CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1}] [get_bd_cells processing_system7_0]
endgroup
startgroup
set_property -dict [list CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1}] [get_bd_cells processing_system7_0]
endgroup
startgroup
set_property -dict [list CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {1} CONFIG.PCW_CAN0_CAN0_IO {MIO 46 .. 47} CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} CONFIG.PCW_I2C0_I2C0_IO {MIO 50 .. 51}] [get_bd_cells processing_system7_0]
endgroup
startgroup
set_property -dict [list CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 1.8V} CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27}] [get_bd_cells processing_system7_0]
endgroup

# Block Automation
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]

# Connection Automation
startgroup
apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {/processing_system7_0/FCLK_CLK0 (50 MHz)} Freq {100} Ref_Clk0 {} Ref_Clk1 {} Ref_Clk2 {}}  [get_bd_pins neuromorphic_asic_br_0/pwm_clk]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/processing_system7_0/M_AXI_GP0} Slave {/neuromorphic_asic_br_0/S_AXI} ddr_seg {Auto} intc_ip {New AXI Interconnect} master_apm {0}}  [get_bd_intf_pins neuromorphic_asic_br_0/S_AXI]
endgroup

# May need to modify this to support 1MHZ operation 
# startgroup
# apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config { Clk {New Clocking Wizard} Freq {1} Ref_Clk0 {None} Ref_Clk1 {None} Ref_Clk2 {None}}  [get_bd_pins neuromorphic_asic_br_0/pwm_clk]
# apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {Auto} Clk_slave {Auto} Clk_xbar {Auto} Master {/processing_system7_0/M_AXI_GP0} Slave {/neuromorphic_asic_br_0/S_AXI} ddr_seg {Auto} intc_ip {New AXI Interconnect} master_apm {0}}  [get_bd_intf_pins neuromorphic_asic_br_0/S_AXI]
# endgroup

# Configure Neuromorphic Bridge IP
startgroup
make_bd_pins_external  [get_bd_pins neuromorphic_asic_br_0/digit]
endgroup
startgroup
make_bd_pins_external  [get_bd_pins neuromorphic_asic_br_0/VP]
endgroup
startgroup
make_bd_pins_external  [get_bd_pins neuromorphic_asic_br_0/VN]
endgroup
startgroup
make_bd_pins_external  [get_bd_pins neuromorphic_asic_br_0/VAUXN]
endgroup
startgroup
make_bd_pins_external  [get_bd_pins neuromorphic_asic_br_0/VAUXP]
endgroup

save_bd_design

update_compile_order -fileset sources_1

validate_bd_design -force

make_wrapper -files [get_files /home/oshears/Documents/vt/research/code/verilog/neuromorphic_fpga_bridge/vivado/neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.srcs/sources_1/bd/neuromorphic_asic_bridge_system/neuromorphic_asic_bridge_system.bd] -top
add_files -norecurse /home/oshears/Documents/vt/research/code/verilog/neuromorphic_fpga_bridge/vivado/neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.gen/sources_1/bd/neuromorphic_asic_bridge_system/hdl/neuromorphic_asic_bridge_system_wrapper.v

update_compile_order -fileset sources_1

# Load Constraints
read_xdc ../xdc/neuromorphic_asic_bridge_system_constraints.xdc

# Open Elaborated Design
generate_target all [get_files /home/oshears/Documents/vt/research/code/verilog/neuromorphic_fpga_bridge/vivado/neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.srcs/sources_1/bd/neuromorphic_asic_bridge_system/neuromorphic_asic_bridge_system.bd]
create_ip_run [get_files -of_objects [get_fileset sources_1] /home/oshears/Documents/vt/research/code/verilog/neuromorphic_fpga_bridge/vivado/neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.srcs/sources_1/bd/neuromorphic_asic_bridge_system/neuromorphic_asic_bridge_system.bd]
launch_runs neuromorphic_asic_bridge_system_processing_system7_0_0_synth_1
wait_on_run neuromorphic_asic_bridge_system_processing_system7_0_0_synth_1
launch_runs neuromorphic_asic_bridge_system_neuromorphic_asic_br_0_0_synth_1
wait_on_run neuromorphic_asic_bridge_system_neuromorphic_asic_br_0_0_synth_1
launch_runs neuromorphic_asic_bridge_system_rst_ps7_0_50M_0_synth_1
wait_on_run neuromorphic_asic_bridge_system_rst_ps7_0_50M_0_synth_1
launch_runs neuromorphic_asic_bridge_system_auto_pc_0_synth_1
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

# Export Hardware for Vitis
write_hw_platform -fixed -include_bit -force -file /home/oshears/Documents/vt/research/code/verilog/neuromorphic_fpga_bridge/vivado/neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system.xsa

# Generate Output Products
# generate_target all [get_files  /home/oshears/Documents/vt/research/code/verilog/neuromorphic_fpga_bridge/vivado/neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.srcs/sources_1/bd/neuromorphic_asic_bridge_system/neuromorphic_asic_bridge_system.bd]
# catch { config_ip_cache -export [get_ips -all neuromorphic_asic_bridge_system_processing_system7_0_0] }
# catch { config_ip_cache -export [get_ips -all neuromorphic_asic_bridge_system_auto_pc_0] }
# export_ip_user_files -of_objects [get_files /home/oshears/Documents/vt/research/code/verilog/neuromorphic_fpga_bridge/vivado/neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.srcs/sources_1/bd/neuromorphic_asic_bridge_system/neuromorphic_asic_bridge_system.bd] -no_script -sync -force -quiet
# create_ip_run [get_files -of_objects [get_fileset sources_1] /home/oshears/Documents/vt/research/code/verilog/neuromorphic_fpga_bridge/vivado/neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.srcs/sources_1/bd/neuromorphic_asic_bridge_system/neuromorphic_asic_bridge_system.bd]
# launch_runs neuromorphic_asic_bridge_system_processing_system7_0_0_synth_1 -jobs 16
# export_simulation -of_objects [get_files /home/oshears/Documents/vt/research/code/verilog/neuromorphic_fpga_bridge/vivado/neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.srcs/sources_1/bd/neuromorphic_asic_bridge_system/neuromorphic_asic_bridge_system.bd] -directory /home/oshears/Documents/vt/research/code/verilog/neuromorphic_fpga_bridge/vivado/neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.ip_user_files/sim_scripts -ip_user_files_dir /home/oshears/Documents/vt/research/code/verilog/neuromorphic_fpga_bridge/vivado/neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.ip_user_files -ipstatic_source_dir /home/oshears/Documents/vt/research/code/verilog/neuromorphic_fpga_bridge/vivado/neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.ip_user_files/ipstatic -lib_map_path [list {modelsim=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_fpga_bridge/vivado/neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.cache/compile_simlib/modelsim} {questa=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_fpga_bridge/vivado/neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.cache/compile_simlib/questa} {ies=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_fpga_bridge/vivado/neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.cache/compile_simlib/ies} {xcelium=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_fpga_bridge/vivado/neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.cache/compile_simlib/xcelium} {vcs=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_fpga_bridge/vivado/neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.cache/compile_simlib/vcs} {riviera=/home/oshears/Documents/vt/research/code/verilog/neuromorphic_fpga_bridge/vivado/neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_project.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet


exit