# Clock Constraints
#create_clock -period 10 [get_ports S_AXI_ACLK]
#create_clock -period 10 [get_ports pwm_clk]

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

# FMC XADC Inputs
# set_property PACKAGE_PIN A17 [get_ports {VAUXN_0[3]}];
# set_property PACKAGE_PIN B15 [get_ports {VAUXN_0[2]}];
# set_property PACKAGE_PIN D15 [get_ports {VAUXN_0[1]}];
# set_property PACKAGE_PIN E16 [get_ports {VAUXN_0[0]}];
# set_property PACKAGE_PIN A16 [get_ports {VAUXP_0[3]}];
# set_property PACKAGE_PIN C15 [get_ports {VAUXP_0[2]}];
# set_property PACKAGE_PIN E15 [get_ports {VAUXP_0[1]}];
# set_property PACKAGE_PIN F16 [get_ports {VAUXP_0[0]}];

set_property PACKAGE_PIN D16 [get_ports {VAUXP_0[8]}]
set_property PACKAGE_PIN D17 [get_ports {VAUXN_0[8]}]
set_property PACKAGE_PIN F16 [get_ports {VAUXP_0[0]}]
set_property PACKAGE_PIN E16 [get_ports {VAUXN_0[0]}]
set_property PACKAGE_PIN L11 [get_ports {VP_0}]
set_property PACKAGE_PIN M12 [get_ports {VN_0}]

set_property PACKAGE_PIN W7 [get_ports {VAUX_SEL_0[3]}]
set_property PACKAGE_PIN W6 [get_ports {VAUX_SEL_0[2]}]
set_property PACKAGE_PIN W5 [get_ports {VAUX_SEL_0[1]}]
set_property PACKAGE_PIN U7 [get_ports {VAUX_SEL_0[0]}]

# AUXS Outputs

# Configure LVCMOS 1.8V Output Pins
set_property IOSTANDARD LVCMOS18 [get_ports {digit_0[15]}]
set_property IOSTANDARD LVCMOS18 [get_ports {digit_0[14]}]
set_property IOSTANDARD LVCMOS18 [get_ports {digit_0[13]}]
set_property IOSTANDARD LVCMOS18 [get_ports {digit_0[12]}]
set_property IOSTANDARD LVCMOS18 [get_ports {digit_0[11]}]
set_property IOSTANDARD LVCMOS18 [get_ports {digit_0[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {digit_0[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {digit_0[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {digit_0[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {digit_0[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {digit_0[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {digit_0[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {digit_0[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {digit_0[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {digit_0[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {digit_0[0]}]

set_property IOSTANDARD LVCMOS18 [get_ports {leds_0[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {leds_0[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {leds_0[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {leds_0[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {leds_0[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {leds_0[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {leds_0[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {leds_0[0]}]

# set_property IOSTANDARD LVCMOS18 [get_ports {VAUXN_0[3]}]
# set_property IOSTANDARD LVCMOS18 [get_ports {VAUXN_0[2]}]
# set_property IOSTANDARD LVCMOS18 [get_ports {VAUXN_0[1]}]
# set_property IOSTANDARD LVCMOS18 [get_ports {VAUXN_0[0]}]
# set_property IOSTANDARD LVCMOS18 [get_ports {VAUXP_0[3]}]
# set_property IOSTANDARD LVCMOS18 [get_ports {VAUXP_0[2]}]
# set_property IOSTANDARD LVCMOS18 [get_ports {VAUXP_0[1]}]
# set_property IOSTANDARD LVCMOS18 [get_ports {VAUXP_0[0]}]

set_property IOSTANDARD LVCMOS18 [get_ports {VAUXN_0[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {VAUXP_0[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {VAUXN_0[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {VAUXP_0[0]}]

set_property IOSTANDARD LVCMOS18 [get_ports {VAUX_SEL_0[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {VAUX_SEL_0[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {VAUX_SEL_0[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {VAUX_SEL_0[0]}]


set_false_path -to [get_ports leds_0]




