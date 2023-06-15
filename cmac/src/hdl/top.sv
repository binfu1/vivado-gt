// *************************************************************************
//
// Copyright 2020 Xilinx, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// *************************************************************************
`timescale 1ns/1ps
module cmac(
  input          init_clk,
  input          gt_refclk_p,
  input          gt_refclk_n,
  
  input    [3:0] gt_rxp,
  input    [3:0] gt_rxn,
  output   [3:0] gt_txp,
  output   [3:0] gt_txn
);

  wire         cmac_clk;    //用户时钟信号
  wire         cmac_linkup; //通道状态信号
  
  wire         tx_axis_tvalid;
  wire [511:0] tx_axis_tdata;
  wire  [63:0] tx_axis_tkeep;
  wire         tx_axis_tlast;
  wire         tx_axis_tuser;
  wire         tx_axis_tready;

  wire         rx_axis_tvalid;
  wire [511:0] rx_axis_tdata;
  wire  [63:0] rx_axis_tkeep;
  wire         rx_axis_tlast;
  wire         rx_axis_tuser;

  wire  [35:0] cmac_debug_pin; //调试信号

  // 控制复位和环回
  wire sys_reset; //高电平有效
  wire loopback_en; //高电平自回环
  wire start_write; //发送数据启动信号
  vio vio_i (
    .clk(init_clk),
    .probe_out0(start_write),
    .probe_out1(sys_reset),
    .probe_out2(loopback_en)
  );

  cmac_exdes cmac_inst (
    .gt_rxp              (gt_rxp),
    .gt_rxn              (gt_rxn),
    .gt_txp              (gt_txp),
    .gt_txn              (gt_txn),

    .s_axis_tx_tvalid    (tx_axis_tvalid),
    .s_axis_tx_tdata     (tx_axis_tdata),
    .s_axis_tx_tkeep     (tx_axis_tkeep),
    .s_axis_tx_tlast     (tx_axis_tlast),
    .s_axis_tx_tuser     (tx_axis_tuser),
    .s_axis_tx_tready    (tx_axis_tready),

    .m_axis_rx_tvalid    (rx_axis_tvalid),
    .m_axis_rx_tdata     (rx_axis_tdata),
    .m_axis_rx_tkeep     (rx_axis_tkeep),
    .m_axis_rx_tlast     (rx_axis_tlast),
    .m_axis_rx_tuser     (rx_axis_tuser),

    .gt_refclk_p         (gt_refclk_p),
    .gt_refclk_n         (gt_refclk_n),
    .loopback_en         (loopback_en),
    .cmac_clk            (cmac_clk),
    .usr_tx_reset        (usr_tx_reset),
    .cmac_sys_reset      (sys_reset),
    .init_clk            (init_clk),
    .tx_ovfout           (tx_ovfout),
    .tx_unfout           (tx_unfout),
    .cmac_linkup         (cmac_linkup),
    .cmac_debug_pin      (cmac_debug_pin)
  );

  wire gt_refclk_update;
  wire [31:0] gt_refclk_freq_value;
  frequency_counter #(
    .RefClk_Frequency_g   (100000000)
  ) frequency_counter_inst(
    .i_RefClk_p           (init_clk),
    .i_Clock_p            (cmac_clk),
    .o_Frequency_Update_p (gt_refclk_update),
    .ov32_Frequency_p     (gt_refclk_freq_value)
  );

  ila_status ila_status_i(
    .clk(init_clk),
    .probe0(start_write),
    .probe1(sys_reset),
    .probe2(loopback_en),
    .probe3(cmac_linkup),
    .probe4(gt_refclk_update),
    .probe5(gt_refclk_freq_value)
  );

  // 发送数据模块
  data_send data_send_i (
    .start_write(start_write),
    .axis_aclk(cmac_clk),
    .axis_aresetn(!usr_tx_reset),
    .axis_tready(tx_axis_tready),
    .axis_tvalid(tx_axis_tvalid),
    .axis_tdata(tx_axis_tdata),
    .axis_tkeep(tx_axis_tkeep),
    .axis_tlast(tx_axis_tlast),
    .tx_ovfout(tx_ovfout),
    .tx_unfout(tx_unfout)
  );

  ila_data ila_data_i(
    .clk(cmac_clk),
    .probe0(tx_axis_tready),
    .probe1(tx_axis_tvalid),
    .probe2(tx_axis_tdata),
    .probe3(tx_axis_tkeep),
    .probe4(tx_axis_tlast),
    .probe5(tx_axis_tuser),
    .probe6(rx_axis_tvalid),
    .probe7(rx_axis_tdata),
    .probe8(rx_axis_tkeep),
    .probe9(rx_axis_tlast),
    .probe10(rx_axis_tuser)
  );
    
endmodule: cmac
