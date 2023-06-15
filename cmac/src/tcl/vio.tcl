create_ip -name vio -vendor xilinx.com -library ip -version 3.0 -module_name vio
set_property -dict [list \
  CONFIG.C_PROBE_OUT2_INIT_VAL {0x1} \
  CONFIG.C_PROBE_OUT1_INIT_VAL {0x1} \
  CONFIG.C_NUM_PROBE_OUT {3} \
  CONFIG.C_EN_PROBE_IN_ACTIVITY {0} \
  CONFIG.C_NUM_PROBE_IN {0} \
] [get_ips vio]