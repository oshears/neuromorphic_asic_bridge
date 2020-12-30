platform create -name {neuromorphic_asic_bridge_system} -hw {/home/oshears/Documents/vt/research/code/verilog/neuromorphic_fpga_bridge/vivado/neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system.xsa} -proc {ps7_cortexa9_0} -os {standalone} -fsbl-target {psu_cortexa53_0} -out {/home/oshears/Documents/vitis_workspace};platform write
platform read {/home/oshears/Documents/vitis_workspace/neuromorphic_asic_bridge_system/platform.spr}
platform active {neuromorphic_asic_bridge_system}
