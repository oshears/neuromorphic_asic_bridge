# Open Platform


# Open App


# Run on Hardware
connect -url tcp:127.0.0.1:3121
targets -set -nocase -filter {name =~"APU*"}
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Digilent Zed 210248A39829" && level==0 && jtag_device_ctx=="jsn-Zed-210248A39829-23727093-0"}
fpga -file ./hello_world_test_app/_ide/bitstream/neuromorphic_asic_bridge_system_wrapper.bit
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw ./neuromorphic/export/neuromorphic/hw/neuromorphic_asic_bridge_system_wrapper.xsa -mem-ranges [list {0x40000000 0xbfffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
source ./hello_world_test_app/_ide/psinit/ps7_init.tcl
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "*A9*#0"}
dow ./hello_world_test_app/Debug/hello_world_test_app.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "*A9*#0"}
con


exit