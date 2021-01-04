#xsct createLinux.tcl

petalinux-install-path /home/oshears/PetaLinux/

petalinux-create --type project --template zynq --name neuromorphic_peta_linux

petalinux-config -p neuromorphic_peta_linux --get-hw-description=../vitis/neuromorphic/export/neuromorphic/hw/
#petalinux-config --get-hw-description=~/Documents/vt/research/code/verilog/neuromorphic_fpga_bridge/vivado/neuromorphic_asic_bridge_system_project/neuromorphic_asic_bridge_system_wrapper.xsa

# In petalinux-config DTG Settings ---> (template) MACHINE_NAME to zedboard

# TODO: Need to debug errors and warnings in build/build.log
petalinux-build -p neuromorphic_peta_linux

#petalinux-package --boot --format BIN --fsbl <FSBL image> --fpga ../vitis/neuromorphic/export/neuromorphic/hw/neuromorphic_asic_bridge_system_wrapper.bit --u-boot

# TODO
# petalinux-package --boot --format BIN --fsbl images/linux/zynqmp_fsbl.elf --u-boot images/linux/u-boot.elf --pmufw images/linux/pmufw.elf --fpga images/linux/*.bit --force



# petalinux-build --sdk


# Demo Petalinux
petalinux-install-path /home/oshears/PetaLinux/
petalinux-create --type project --template zynq --name demo_petalinux
petalinux-config -p demo_petalinux --get-hw-description=../vitis/petalinux_neuromorphic/hw/zed.xsa
# petalinux-config:
# Subsystem AUTO HW Settings:
# Ethernet Settings -->
# Set it to manual
# u-boot autoconfig
# disable TFTP
# Image Packaging Configuration → Root filesystem type EXT (SD/eMMC/QSPI/SATA/USB)
petalinux-build
petalinux-package --boot --fsbl <FSBL image> --fpga <FPGA bitstream> --u-boot
petalinux-package --boot --fsbl images/linux/zynq_fsbl.elf --u-boot --force
petalinux-package --boot --fsbl images/linux/zynq_fsbl.elf --fpga ../vitis/neuromorphic/export/neuromorphic/hw/neuromorphic_asic_bridge_system_wrapper.bit --u-boot --force
# cp images/linux/BOOT.BIN /media/oshears/BOOT/
# cp images/linux/image.ub /media/oshears/BOOT/
# cp images/linux/boot.scr /media/oshears/BOOT/
# sudo tar xvf ./images/linux/rootfs.tar.gz -C /media/oshears/ROOTFS/

# From the PetaLinux User Guide Document

# PetaLinux BSP Installation
# PetaLinux reference board support packages (BSPs) are reference designs on supported boards
# for you to start working with and customizing your own projects. In addition, these designs can
# be used as a basis for creating your own projects on supported boards. PetaLinux BSPs are
# provided in the form of installable BSP files, and include all necessary design and configuration
# files, pre-built and tested hardware, and software images ready for downloading on your board or
# for booting in the QEMU system emulation environment. You can download a BSP to any
# location of your choice.
# BSP reference designs are not included in the PetaLinux tools installer and need to be
# downloaded and installed separately. PetaLinux BSP packages are available on the Xilinx.com
# Download Center. There is a README in each BSP which explains the details of the BSP.
# petalinux-create -t project -s <path-to-bsp>

# Creating a New PetaLinux Project
# This section describes how to create a new PetaLinux project. Projects created from templates
# must be bound to an actual hardware instance before they can be built.
# petalinux-create --type project --template zedboard --name <PROJECT_NAME>

# Importing Hardware Configuration
# This section explains the process of updating an existing/newly created PetaLinux project with a
# new hardware configuration. This enables you to make the PetaLinux tools software platform
# ready for building a Linux system, customized to your new hardware platform.
# petalinux-config --get-hw-description=<PATH-TO-HDF/XSA DIRECTORY> # DTG Settings (template -> zedboard)

# Build PetaLinux System Image
# When the build finishes, the generated images will be within the <plnx-proj-root>/images and /tftpboot directories.
# petalinux-build

# Generate Boot Image for Zynq-7000 Devices
# This section is for Zynq ® -7000 devices only and describes how to generate BOOT.BIN.
# petalinux-package --boot --fsbl <FSBL image> --fpga <FPGA bitstream> --u-boot

# Package Prebuilt Image
# This section describes how to package newly built images into a prebuilt directory.
# This step is typically done when you want to distribute your project as a BSP to other users.
# petalinux-package --prebuilt --fpga <FPGA bitstream>

petalinux-create --type project --template zynq --name standard
petalinux-config --get-hw-description=~/Documents/vivado/project_1/design_1_wrapper.xsa
petalinux-config -c rootfs
# package -> misc -> packagegroup-core-build-essential
# package -> misc -> gcc-runtime
# package -> misc -> python3 -> python3-mmap
# package -> misc -> python3-smmap
petalinux-build
# petalinux-build -x clean
petalinux-package --boot --fsbl ./images/linux/zynq_fsbl.elf --fpga ~/Documents/vivado/project_1/project_1.runs/impl_1/design_1_wrapper.bit --u-boot --force
cp images/linux/BOOT.BIN /media/oshears/BOOT/
cp images/linux/image.ub /media/oshears/BOOT/
cp images/linux/boot.scr /media/oshears/BOOT/
sudo tar xvf ./images/linux/rootfs.tar.gz -C /media/oshears/ROOTFS/