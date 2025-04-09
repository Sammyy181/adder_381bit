set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property PACKAGE_PIN E3 [get_ports clk]
create_clock -period 10 [get_ports clk]

##UART Pins
set_property IOSTANDARD LVCMOS33 [get_ports RxD]
set_property PACKAGE_PIN C4 [get_ports RxD]
set_property IOSTANDARD LVCMOS33 [get_ports TxD]
set_property PACKAGE_PIN D4 [get_ports TxD]

##Reset & Enable switches
set_property IOSTANDARD LVCMOS33 [get_ports reset]
set_property PACKAGE_PIN P4 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports enable_A]
set_property PACKAGE_PIN R3 [get_ports enable_A]
set_property IOSTANDARD LVCMOS33 [get_ports enable_B]
set_property PACKAGE_PIN T1 [get_ports enable_B]

set_property IOSTANDARD LVCMOS33 [get_ports start_add]
set_property PACKAGE_PIN U2 [get_ports start_add]

set_property IOSTANDARD LVCMOS33 [get_ports start_Tx]
set_property PACKAGE_PIN U4 [get_ports start_Tx]

LEDs
set_property IOSTANDARD LVCMOS33 [get_ports A_done]
set_property PACKAGE_PIN U1 [get_ports A_done]
set_property IOSTANDARD LVCMOS33 [get_ports B_done]
set_property PACKAGE_PIN P5 [get_ports B_done]

set_property IOSTANDARD LVCMOS33 [get_ports add_done]
set_property PACKAGE_PIN V1 [get_ports add_done]

set_property IOSTANDARD LVCMOS33 [get_ports Tx_done]
set_property PACKAGE_PIN V4 [get_ports Tx_done]

set_property IOSTANDARD LVCMOS33 [get_ports reset_on]
set_property PACKAGE_PIN P2 [get_ports reset_on]