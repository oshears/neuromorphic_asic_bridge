# ----------------------------------------------------------------------------
# Clock Source - Bank 13
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN Y9 [get_ports {clk}];  # "GCLK"
create_clock -name clk -period 10.000 [get_ports clk]

# ----------------------------------------------------------------------------
# JA Pmod - Bank 13 
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN Y11  [get_ports {dac_cs_n}];  # "JA1"
#set_property PACKAGE_PIN AA8  [get_ports {JA10}];  # "JA10"
set_property PACKAGE_PIN AA11 [get_ports {dac_din}];  # "JA2"
set_property PACKAGE_PIN Y10  [get_ports {dac_ldac_n}];  # "JA3"
set_property PACKAGE_PIN AA9  [get_ports {dac_sclk}];  # "JA4"
#set_property PACKAGE_PIN AB11 [get_ports {JA7}];  # "JA7"
#set_property PACKAGE_PIN AB10 [get_ports {JA8}];  # "JA8"
#set_property PACKAGE_PIN AB9  [get_ports {JA9}];  # "JA9"

# ----------------------------------------------------------------------------
# User LEDs - Bank 33
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN T22 [get_ports {leds[0]}];  # "LD0"
set_property PACKAGE_PIN T21 [get_ports {leds[1]}];  # "LD1"
set_property PACKAGE_PIN U22 [get_ports {leds[2]}];  # "LD2"
set_property PACKAGE_PIN U21 [get_ports {leds[3]}];  # "LD3"
#set_property PACKAGE_PIN V22 [get_ports {LD4}];  # "LD4"
#set_property PACKAGE_PIN W22 [get_ports {LD5}];  # "LD5"
#set_property PACKAGE_PIN U19 [get_ports {LD6}];  # "LD6"
#set_property PACKAGE_PIN U14 [get_ports {LD7}];  # "LD7"


set_property PACKAGE_PIN F22 [get_ports {rst}];  # "SW0"



set_property IOSTANDARD LVCMOS33 [get_ports {leds}];
set_property IOSTANDARD LVCMOS33 [get_ports {clk}];
set_property IOSTANDARD LVCMOS33 [get_ports {rst}];
set_property IOSTANDARD LVCMOS33 [get_ports {dac_cs_n}];
set_property IOSTANDARD LVCMOS33 [get_ports {dac_din}];
set_property IOSTANDARD LVCMOS33 [get_ports {dac_ldac_n}];
set_property IOSTANDARD LVCMOS33 [get_ports {dac_sclk}];



