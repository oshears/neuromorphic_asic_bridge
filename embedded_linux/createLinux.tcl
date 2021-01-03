#xsct createLinux.tcl

petalinux-install-path /home/oshears/PetaLinux/

petalinux-create --type project --template zynq --name neuromorphic_peta_linux

petalinux-config -p neuromorphic_peta_linux --get-hw-description=../vitis/neuromorphic/export/neuromorphic/hw/

# In petalinux-config DTG Settings ---> (template) MACHINE_NAME to zedboard

# TODO: Need to debug errors and warnings in build/build.log
petalinux-build -p neuromorphic_peta_linux

#petalinux-package --boot --format BIN --fsbl <FSBL image> --fpga ../vitis/neuromorphic/export/neuromorphic/hw/neuromorphic_asic_bridge_system_wrapper.bit --u-boot

# TODO
# petalinux-package --boot --format BIN --fsbl images/linux/zynqmp_fsbl.elf --u-boot images/linux/u-boot.elf --pmufw images/linux/pmufw.elf --fpga images/linux/*.bit --force