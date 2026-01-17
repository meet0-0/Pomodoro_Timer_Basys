set_property PACKAGE_PIN W5  [get_ports clk100]
set_property IOSTANDARD LVCMOS33 [get_ports clk100]
create_clock -period 10.000 -name sys_clk -waveform {0 5} [get_ports clk100]

set_property PACKAGE_PIN V7 [get_ports dp]     ;# DP
set_property IOSTANDARD LVCMOS33 [get_ports dp]

## Buttons
set_property PACKAGE_PIN U18 [get_ports btnC]  ;# BTNC
set_property PACKAGE_PIN T18 [get_ports btnU]  ;# BTNU
set_property PACKAGE_PIN U17 [get_ports btnD]  ;# BTND
set_property PACKAGE_PIN W19 [get_ports btnL]  ;# BTNL
set_property IOSTANDARD LVCMOS33 [get_ports {btnC btnU btnD btnL}]

set_property PACKAGE_PIN V17 [get_ports {sw[0]}]
set_property PACKAGE_PIN V16 [get_ports {sw[1]}]
set_property PACKAGE_PIN W16 [get_ports {sw[2]}]
set_property PACKAGE_PIN W17 [get_ports {sw[3]}]
set_property PACKAGE_PIN W15 [get_ports {sw[4]}]
set_property PACKAGE_PIN V15 [get_ports {sw[5]}]
set_property PACKAGE_PIN W14 [get_ports {sw[6]}]
set_property PACKAGE_PIN W13 [get_ports {sw[7]}]
set_property PACKAGE_PIN V2  [get_ports {sw[8]}]
set_property PACKAGE_PIN T3  [get_ports {sw[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw[*]}]

set_property PACKAGE_PIN U16 [get_ports {led[0]}]
set_property PACKAGE_PIN E19 [get_ports {led[1]}]
set_property PACKAGE_PIN U19 [get_ports {led[2]}]
set_property PACKAGE_PIN V19 [get_ports {led[3]}]
set_property PACKAGE_PIN W18 [get_ports {led[4]}]
set_property PACKAGE_PIN U15 [get_ports {led[5]}]
set_property PACKAGE_PIN U14 [get_ports {led[6]}]
set_property PACKAGE_PIN V14 [get_ports {led[7]}]
set_property PACKAGE_PIN V13 [get_ports {led[8]}]
set_property PACKAGE_PIN V3  [get_ports {led[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]

set_property PACKAGE_PIN W7  [get_ports {seg[0]}]  ;# a
set_property PACKAGE_PIN W6  [get_ports {seg[1]}]  ;# b
set_property PACKAGE_PIN U8  [get_ports {seg[2]}]  ;# c
set_property PACKAGE_PIN V8  [get_ports {seg[3]}]  ;# d
set_property PACKAGE_PIN U5  [get_ports {seg[4]}]  ;# e
set_property PACKAGE_PIN V5  [get_ports {seg[5]}]  ;# f
set_property PACKAGE_PIN U7  [get_ports {seg[6]}]  ;# g
set_property IOSTANDARD LVCMOS33 [get_ports {seg[*]}]

set_property PACKAGE_PIN U2 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[*]}]
