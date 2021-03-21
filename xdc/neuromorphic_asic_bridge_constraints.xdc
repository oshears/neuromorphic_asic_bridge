# Clock Constraints
create_clock -period 10 [get_ports S_AXI_ACLK]
create_clock -period 1000 [get_ports pwm_clk]

# PMOD Outputs
set_property PACKAGE_PIN Y11 [get_ports {digit[15]}];
set_property PACKAGE_PIN AA11 [get_ports {digit[14]}];
set_property PACKAGE_PIN Y10 [get_ports {digit[13]}];
set_property PACKAGE_PIN AA9 [get_ports {digit[12]}];
set_property PACKAGE_PIN AB11 [get_ports {digit[11]}];
set_property PACKAGE_PIN AB10 [get_ports {digit[10]}];
set_property PACKAGE_PIN AB9 [get_ports {digit[9]}];
set_property PACKAGE_PIN AA8 [get_ports {digit[8]}];
set_property PACKAGE_PIN W12 [get_ports {digit[7]}];
set_property PACKAGE_PIN W11 [get_ports {digit[6]}];
set_property PACKAGE_PIN V10 [get_ports {digit[5]}];
set_property PACKAGE_PIN W8 [get_ports {digit[4]}];
set_property PACKAGE_PIN V12 [get_ports {digit[3]}];
set_property PACKAGE_PIN W10 [get_ports {digit[2]}];
set_property PACKAGE_PIN V9 [get_ports {digit[1]}];
set_property PACKAGE_PIN V8 [get_ports {digit[0]}];

# XADC Inputs
set_property PACKAGE_PIN L11 [get_ports {VP_0}]
set_property PACKAGE_PIN M12 [get_ports {VN_0}]

# Configure LVCMOS 1.8V Output Pins
set_property IOSTANDARD LVCMOS18 [get_ports [list {digit[15]} {digit[14]} {digit[13]} {digit[12]} {digit[11]} {digit[10]} {digit[9]} {digit[8]} {digit[7]} {digit[6]} {digit[5]} {digit[4]} {digit[3]} {digit[2]} {digit[1]} {digit[0]}]];
set_property IOSTANDARD LVCMOS18 [get_ports [list {VP} {VN}]];


# Input + Output Delays


# False Paths
set_false_path -to [get_ports leds]