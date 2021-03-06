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


## Compiling IP and Generating Hardware XSA File
```
vivado -mode tcl -source createBridgeProject.tcl
vivado -mode tcl -source createTopProject.tcl
```

## Compiling Vitis Sample Project
```
xsct createPlatformProject.tcl
```

## Configuring UART
```
sudo minicom -D /dev/ttyACM0
```