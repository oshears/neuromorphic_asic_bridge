# Neuromorphic ASIC Bridge

## Overview
The HDL FPGA Module to Interact with the MICS Neuromorphic Reservoir Computing (RC) ASIC. This FPGA is in charge of sending one of four letters signals to the (RC) ASIC via PWM waves. The ASIC responds with its prediction of the letter's class via four amplitude modulated signals.

## Architecture

<Insert Circuit/Architecture Diagram>

## Modules
### AXI Interface
### Registers
#### Input Generator Register
#### Output Analyzer Register
### Input Generator
### Output Analyzer
### Camera Interface


## Configuring UART
```
sudo minicom -D /dev/ttyACM0
```

## PetaLinux
### Terminology
#### Board Support Package (BSP)
#### First Stage Boot Loader (FSBL) Image
#### U-Boot
#### YOCTO

# Logging Into PetaLinux
username: root
password: root

# Read and Write Registers from U-Boot
```
md 0x43c00000 
mw 0x43c00000 0x000000FF
```

# Read and Write Registers from Linux Commmand Line
#### Using `devmem`
```
devmem 0x43c00000
devmem 0x43c00000 32 0x000000FF
```
#### Using `peek` and `poke`
```
poke 0x43C00000
poke 0x43C00000 1
```

# Compile and Run the Demo from PetaLinux
```
gcc -o demo demo.c
demo
```
