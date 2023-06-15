create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name ila_status
set_property -dict [list \
  CONFIG.C_PROBE5_WIDTH {32} \
  CONFIG.C_NUM_OF_PROBES {6} \
  CONFIG.Component_Name {ila_status} \
] [get_ips ila_status]

create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name ila_data
set_property -dict [list \
  CONFIG.C_PROBE8_WIDTH {64} \
  CONFIG.C_PROBE7_WIDTH {512} \
  CONFIG.C_PROBE3_WIDTH {64} \
  CONFIG.C_PROBE2_WIDTH {512} \
  CONFIG.C_NUM_OF_PROBES {11} \
  CONFIG.Component_Name {ila_data} \
] [get_ips ila_data]

create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name ila_send
set_property -dict [list \
  CONFIG.C_PROBE10_WIDTH {4} \
  CONFIG.C_PROBE9_WIDTH {2} \
  CONFIG.C_PROBE3_WIDTH {64} \
  CONFIG.C_PROBE2_WIDTH {512} \
  CONFIG.C_NUM_OF_PROBES {13} \
  CONFIG.Component_Name {ila_send} \
] [get_ips ila_send]