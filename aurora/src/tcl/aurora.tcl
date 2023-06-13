#create_ip -name aurora_64b66b -vendor xilinx.com -library ip -version 12.0 -module_name aurora_64b66b
#set_property -dict [list \
#  CONFIG.Component_Name {aurora_64b66b} \
#  CONFIG.CHANNEL_ENABLE {X1Y0 X1Y1 X1Y2 X1Y3} \
#  CONFIG.C_AURORA_LANES {4} \
#  CONFIG.C_INIT_CLK {100} \
#  CONFIG.C_GT_LOC_4 {4} \
#  CONFIG.C_GT_LOC_3 {3} \
#  CONFIG.C_GT_LOC_2 {2} \
#  CONFIG.SupportLevel {1} \
#  CONFIG.C_LINE_RATE {10} \
#] [get_ips aurora_64b66b]

create_ip -name aurora_64b66b -vendor xilinx.com -library ip -version 12.0 -module_name aurora_64b66b
set_property -dict [list \
  CONFIG.Component_Name {aurora_64b66b} \
  CONFIG.CHANNEL_ENABLE {X1Y0 X1Y1 X1Y2 X1Y3} \
  CONFIG.C_AURORA_LANES {4} \
  CONFIG.C_REFCLK_FREQUENCY {322.265625} \
  CONFIG.C_INIT_CLK {100} \
  CONFIG.C_GT_LOC_4 {4} \
  CONFIG.C_GT_LOC_3 {3} \
  CONFIG.C_GT_LOC_2 {2} \
  CONFIG.SupportLevel {1} \
] [get_ips aurora_64b66b]