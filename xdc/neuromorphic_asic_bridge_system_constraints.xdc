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

# FMC XADC Inputs
set_property PACKAGE_PIN A17 [get_ports {VAUXN_0[3]}];
set_property PACKAGE_PIN B15 [get_ports {VAUXN_0[2]}];
set_property PACKAGE_PIN D15 [get_ports {VAUXN_0[1]}];
set_property PACKAGE_PIN E16 [get_ports {VAUXN_0[0]}];
set_property PACKAGE_PIN A16 [get_ports {VAUXP_0[3]}];
set_property PACKAGE_PIN C15 [get_ports {VAUXP_0[2]}];
set_property PACKAGE_PIN E15 [get_ports {VAUXP_0[1]}];
set_property PACKAGE_PIN F16 [get_ports {VAUXP_0[0]}];

# Configure LVCMOS 1.8V Output Pins
set_property IOSTANDARD LVCMOS18 [get_ports [list {digit_0[15]} {digit_0[14]} {digit_0[13]} {digit_0[12]} {digit_0[11]} {digit_0[10]} {digit_0[9]} {digit_0[8]} {digit_0[7]} {digit_0[6]} {digit_0[5]} {digit_0[4]} {digit_0[3]} {digit_0[2]} {digit_0[1]} {digit_0[0]}]];
set_property IOSTANDARD LVCMOS18 [get_ports [list {VAUXN_0[3]} {VAUXN_0[2]} {VAUXN_0[1]} {VAUXN_0[0]}]];
set_property IOSTANDARD LVCMOS18 [get_ports [list {VAUXP_0[3]} {VAUXP_0[2]} {VAUXP_0[1]} {VAUXP_0[0]}]];
