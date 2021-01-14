# PMOD Outputs
set_property PACKAGE_PIN Y11 [get_ports {digit_0[15]}];
set_property PACKAGE_PIN AA11 [get_ports {digit_0[14]}];
set_property PACKAGE_PIN Y10 [get_ports {digit_0[13]}];
set_property PACKAGE_PIN AA9 [get_ports {digit_0[12]}];
set_property PACKAGE_PIN AB11 [get_ports {digit_0[11]}];
set_property PACKAGE_PIN AB10 [get_ports {digit_0[10]}];
set_property PACKAGE_PIN AB9 [get_ports {digit_0[9]}];
set_property PACKAGE_PIN AA8 [get_ports {digit_0[8]}];
set_property PACKAGE_PIN W12 [get_ports {digit_0[7]}];
set_property PACKAGE_PIN W11 [get_ports {digit_0[6]}];
set_property PACKAGE_PIN V10 [get_ports {digit_0[5]}];
set_property PACKAGE_PIN W8 [get_ports {digit_0[4]}];
set_property PACKAGE_PIN V12 [get_ports {digit_0[3]}];
set_property PACKAGE_PIN W10 [get_ports {digit_0[2]}];
set_property PACKAGE_PIN V9 [get_ports {digit_0[1]}];
set_property PACKAGE_PIN V8 [get_ports {digit_0[0]}];

# Connect Outputs to LEDS for Debugging
set_property PACKAGE_PIN T22 [get_ports {leds_0[0]}];  # "LD0"
set_property PACKAGE_PIN T21 [get_ports {leds_0[1]}];  # "LD1"
set_property PACKAGE_PIN U22 [get_ports {leds_0[2]}];  # "LD2"
set_property PACKAGE_PIN U21 [get_ports {leds_0[3]}];  # "LD3"
set_property PACKAGE_PIN V22 [get_ports {leds_0[4]}];  # "LD4"
set_property PACKAGE_PIN W22 [get_ports {leds_0[5]}];  # "LD5"
set_property PACKAGE_PIN U19 [get_ports {leds_0[6]}];  # "LD6"
set_property PACKAGE_PIN U14 [get_ports {leds_0[7]}];  # "LD7"

# XADC MUX ADDR
set_property PACKAGE_PIN J15 [get_ports {XADC_MUXADDR_0[3]}]; # "XADC-GIO1"
set_property PACKAGE_PIN K15 [get_ports {XADC_MUXADDR_0[2]}]; # "XADC-GIO0"
set_property PACKAGE_PIN R15 [get_ports {XADC_MUXADDR_0[1]}]; # "XADC-GIO1"
set_property PACKAGE_PIN H15 [get_ports {XADC_MUXADDR_0[0]}]; # "XADC-GIO0"

# Configure LVCMOS 3.3V Output Pins
set_property IOSTANDARD LVCMOS33 [get_ports {digit_0[15]}];
set_property IOSTANDARD LVCMOS33 [get_ports {digit_0[14]}];
set_property IOSTANDARD LVCMOS33 [get_ports {digit_0[13]}];
set_property IOSTANDARD LVCMOS33 [get_ports {digit_0[12]}];
set_property IOSTANDARD LVCMOS33 [get_ports {digit_0[11]}];
set_property IOSTANDARD LVCMOS33 [get_ports {digit_0[10]}];
set_property IOSTANDARD LVCMOS33 [get_ports {digit_0[9]}];
set_property IOSTANDARD LVCMOS33 [get_ports {digit_0[8]}];
set_property IOSTANDARD LVCMOS33 [get_ports {digit_0[7]}];
set_property IOSTANDARD LVCMOS33 [get_ports {digit_0[6]}];
set_property IOSTANDARD LVCMOS33 [get_ports {digit_0[5]}];
set_property IOSTANDARD LVCMOS33 [get_ports {digit_0[4]}];
set_property IOSTANDARD LVCMOS33 [get_ports {digit_0[3]}];
set_property IOSTANDARD LVCMOS33 [get_ports {digit_0[2]}];
set_property IOSTANDARD LVCMOS33 [get_ports {digit_0[1]}];
set_property IOSTANDARD LVCMOS33 [get_ports {digit_0[0]}];

set_property IOSTANDARD LVCMOS18 [get_ports {leds_0[7]}];
set_property IOSTANDARD LVCMOS18 [get_ports {leds_0[6]}];
set_property IOSTANDARD LVCMOS18 [get_ports {leds_0[5]}];
set_property IOSTANDARD LVCMOS18 [get_ports {leds_0[4]}];
set_property IOSTANDARD LVCMOS18 [get_ports {leds_0[3]}];
set_property IOSTANDARD LVCMOS18 [get_ports {leds_0[2]}];
set_property IOSTANDARD LVCMOS18 [get_ports {leds_0[1]}];
set_property IOSTANDARD LVCMOS18 [get_ports {leds_0[0]}];

set_property IOSTANDARD LVCMOS18 [get_ports {VN_0}];
set_property IOSTANDARD LVCMOS18 [get_ports {VP_0}];

set_property IOSTANDARD LVCMOS18 [get_ports {XADC_MUXADDR_0[3]}];
set_property IOSTANDARD LVCMOS18 [get_ports {XADC_MUXADDR_0[2]}];
set_property IOSTANDARD LVCMOS18 [get_ports {XADC_MUXADDR_0[1]}];
set_property IOSTANDARD LVCMOS18 [get_ports {XADC_MUXADDR_0[0]}];

# Note that the bank voltage for IO Bank 13 is fixed to 3.3V on ZedBoard. 
# set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 34]];
# set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 35]];
# set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]];


set_false_path -to [get_ports leds_0];




