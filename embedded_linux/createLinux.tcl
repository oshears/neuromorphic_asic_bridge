#xsct createLinux.tcl

petalinux-install-path /home/oshears/PetaLinux/

petalinux-create --type project --template zynq --name neuromorphic_peta_linux

petalinux-config -p neuromorphic_peta_linux --get-hw-description=../vitis/neuromorphic/export/neuromorphic/hw/

# In petalinux-config DTG Settings ---> (template) MACHINE_NAME to zedboard

petalinux-build -p neuromorphic_peta_linux

# petalinux-package