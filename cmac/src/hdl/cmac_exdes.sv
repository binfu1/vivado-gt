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
module cmac_exdes (
  input    [3:0] gt_rxp,
  input    [3:0] gt_rxn,
  output   [3:0] gt_txp,
  output   [3:0] gt_txn,

  output         m_axis_rx_tvalid,
  output [511:0] m_axis_rx_tdata,
  output  [63:0] m_axis_rx_tkeep,
  output         m_axis_rx_tlast,
  output         m_axis_rx_tuser,

  input          s_axis_tx_tvalid,
  input  [511:0] s_axis_tx_tdata,
  input   [63:0] s_axis_tx_tkeep,
  input          s_axis_tx_tlast,
  input          s_axis_tx_tuser,
  output         s_axis_tx_tready,

  input          gt_refclk_p,
  input          gt_refclk_n,
  input          loopback_en,
  output         cmac_clk,
  output         usr_tx_reset,
  input          cmac_sys_reset,
  input          init_clk,
  output         tx_ovfout, 
  output         tx_unfout, 
  output         cmac_linkup,
  output  [35:0] cmac_debug_pin
);

  wire  [3:0] gt_powergoodout;
  wire [11:0] gt_loopback_in;
  wire        core_rx_reset;
  wire        core_tx_reset;
  wire        gtwiz_reset_rx_datapath;
  wire        gtwiz_reset_tx_datapath;
  wire  [8:0] ctl_tx_pause_req;
  wire        ctl_tx_resend_pause;

  wire        txusrclk2;

  wire [55:0] rx_preambleout;
  wire [55:0] tx_preamblein;

  wire  [7:0] rx_otn_bip8_0;
  wire  [7:0] rx_otn_bip8_1;
  wire  [7:0] rx_otn_bip8_2;
  wire  [7:0] rx_otn_bip8_3;
  wire  [7:0] rx_otn_bip8_4;
  wire [65:0] rx_otn_data_0;
  wire [65:0] rx_otn_data_1;
  wire [65:0] rx_otn_data_2;
  wire [65:0] rx_otn_data_3;
  wire [65:0] rx_otn_data_4;
  wire        rx_otn_ena;
  wire        rx_otn_lane0;
  wire        rx_otn_vlmarker;

  wire        stat_rx_aligned;
  wire        stat_rx_aligned_err;
  wire  [2:0] stat_rx_bad_code;
  wire  [2:0] stat_rx_bad_fcs;
  wire        stat_rx_bad_preamble;
  wire        stat_rx_bad_sfd;
  wire        stat_rx_bip_err_0;
  wire        stat_rx_bip_err_1;
  wire        stat_rx_bip_err_10;
  wire        stat_rx_bip_err_11;
  wire        stat_rx_bip_err_12;
  wire        stat_rx_bip_err_13;
  wire        stat_rx_bip_err_14;
  wire        stat_rx_bip_err_15;
  wire        stat_rx_bip_err_16;
  wire        stat_rx_bip_err_17;
  wire        stat_rx_bip_err_18;
  wire        stat_rx_bip_err_19;
  wire        stat_rx_bip_err_2;
  wire        stat_rx_bip_err_3;
  wire        stat_rx_bip_err_4;
  wire        stat_rx_bip_err_5;
  wire        stat_rx_bip_err_6;
  wire        stat_rx_bip_err_7;
  wire        stat_rx_bip_err_8;
  wire        stat_rx_bip_err_9;
  wire [19:0] stat_rx_block_lock;
  wire        stat_rx_broadcast;
  wire  [2:0] stat_rx_fragment;
  wire  [1:0] stat_rx_framing_err_0;
  wire  [1:0] stat_rx_framing_err_1;
  wire  [1:0] stat_rx_framing_err_10;
  wire  [1:0] stat_rx_framing_err_11;
  wire  [1:0] stat_rx_framing_err_12;
  wire  [1:0] stat_rx_framing_err_13;
  wire  [1:0] stat_rx_framing_err_14;
  wire  [1:0] stat_rx_framing_err_15;
  wire  [1:0] stat_rx_framing_err_16;
  wire  [1:0] stat_rx_framing_err_17;
  wire  [1:0] stat_rx_framing_err_18;
  wire  [1:0] stat_rx_framing_err_19;
  wire  [1:0] stat_rx_framing_err_2;
  wire  [1:0] stat_rx_framing_err_3;
  wire  [1:0] stat_rx_framing_err_4;
  wire  [1:0] stat_rx_framing_err_5;
  wire  [1:0] stat_rx_framing_err_6;
  wire  [1:0] stat_rx_framing_err_7;
  wire  [1:0] stat_rx_framing_err_8;
  wire  [1:0] stat_rx_framing_err_9;
  wire        stat_rx_framing_err_valid_0;
  wire        stat_rx_framing_err_valid_1;
  wire        stat_rx_framing_err_valid_10;
  wire        stat_rx_framing_err_valid_11;
  wire        stat_rx_framing_err_valid_12;
  wire        stat_rx_framing_err_valid_13;
  wire        stat_rx_framing_err_valid_14;
  wire        stat_rx_framing_err_valid_15;
  wire        stat_rx_framing_err_valid_16;
  wire        stat_rx_framing_err_valid_17;
  wire        stat_rx_framing_err_valid_18;
  wire        stat_rx_framing_err_valid_19;
  wire        stat_rx_framing_err_valid_2;
  wire        stat_rx_framing_err_valid_3;
  wire        stat_rx_framing_err_valid_4;
  wire        stat_rx_framing_err_valid_5;
  wire        stat_rx_framing_err_valid_6;
  wire        stat_rx_framing_err_valid_7;
  wire        stat_rx_framing_err_valid_8;
  wire        stat_rx_framing_err_valid_9;
  wire        stat_rx_got_signal_os;
  wire        stat_rx_hi_ber;
  wire        stat_rx_inrangeerr;
  wire        stat_rx_internal_local_fault;
  wire        stat_rx_jabber;
  wire        stat_rx_local_fault;
  wire [19:0] stat_rx_mf_err;
  wire [19:0] stat_rx_mf_len_err;
  wire [19:0] stat_rx_mf_repeat_err;
  wire        stat_rx_misaligned;
  wire        stat_rx_multicast;
  wire        stat_rx_oversize;
  wire        stat_rx_packet_1024_1518_bytes;
  wire        stat_rx_packet_128_255_bytes;
  wire        stat_rx_packet_1519_1522_bytes;
  wire        stat_rx_packet_1523_1548_bytes;
  wire        stat_rx_packet_1549_2047_bytes;
  wire        stat_rx_packet_2048_4095_bytes;
  wire        stat_rx_packet_256_511_bytes;
  wire        stat_rx_packet_4096_8191_bytes;
  wire        stat_rx_packet_512_1023_bytes;
  wire        stat_rx_packet_64_bytes;
  wire        stat_rx_packet_65_127_bytes;
  wire        stat_rx_packet_8192_9215_bytes;
  wire        stat_rx_packet_bad_fcs;
  wire        stat_rx_packet_large;
  wire  [2:0] stat_rx_packet_small;
  wire        stat_rx_pause;
  wire [15:0] stat_rx_pause_quanta0;
  wire [15:0] stat_rx_pause_quanta1;
  wire [15:0] stat_rx_pause_quanta2;
  wire [15:0] stat_rx_pause_quanta3;
  wire [15:0] stat_rx_pause_quanta4;
  wire [15:0] stat_rx_pause_quanta5;
  wire [15:0] stat_rx_pause_quanta6;
  wire [15:0] stat_rx_pause_quanta7;
  wire [15:0] stat_rx_pause_quanta8;
  wire  [8:0] stat_rx_pause_req;
  wire  [8:0] stat_rx_pause_valid;
  wire        stat_rx_user_pause;
  wire        stat_rx_received_local_fault;
  wire        stat_rx_remote_fault;
  wire        stat_rx_status;
  wire  [2:0] stat_rx_stomped_fcs;
  wire [19:0] stat_rx_synced;
  wire [19:0] stat_rx_synced_err;
  wire  [2:0] stat_rx_test_pattern_mismatch;
  wire        stat_rx_toolong;
  wire  [6:0] stat_rx_total_bytes;
  wire [13:0] stat_rx_total_good_bytes;
  wire        stat_rx_total_good_packets;
  wire  [2:0] stat_rx_total_packets;
  wire        stat_rx_truncated;
  wire  [2:0] stat_rx_undersize;
  wire        stat_rx_unicast;
  wire        stat_rx_vlan;
  wire [19:0] stat_rx_pcsl_demuxed;
  wire  [4:0] stat_rx_pcsl_number_0;
  wire  [4:0] stat_rx_pcsl_number_1;
  wire  [4:0] stat_rx_pcsl_number_10;
  wire  [4:0] stat_rx_pcsl_number_11;
  wire  [4:0] stat_rx_pcsl_number_12;
  wire  [4:0] stat_rx_pcsl_number_13;
  wire  [4:0] stat_rx_pcsl_number_14;
  wire  [4:0] stat_rx_pcsl_number_15;
  wire  [4:0] stat_rx_pcsl_number_16;
  wire  [4:0] stat_rx_pcsl_number_17;
  wire  [4:0] stat_rx_pcsl_number_18;
  wire  [4:0] stat_rx_pcsl_number_19;
  wire  [4:0] stat_rx_pcsl_number_2;
  wire  [4:0] stat_rx_pcsl_number_3;
  wire  [4:0] stat_rx_pcsl_number_4;
  wire  [4:0] stat_rx_pcsl_number_5;
  wire  [4:0] stat_rx_pcsl_number_6;
  wire  [4:0] stat_rx_pcsl_number_7;
  wire  [4:0] stat_rx_pcsl_number_8;
  wire  [4:0] stat_rx_pcsl_number_9;

  wire        stat_rx_rsfec_am_lock0;
  wire        stat_rx_rsfec_am_lock1;
  wire        stat_rx_rsfec_am_lock2;
  wire        stat_rx_rsfec_am_lock3;
  wire        stat_rx_rsfec_corrected_cw_inc;
  wire        stat_rx_rsfec_cw_inc;
  wire  [2:0] stat_rx_rsfec_err_count0_inc;
  wire  [2:0] stat_rx_rsfec_err_count1_inc;
  wire  [2:0] stat_rx_rsfec_err_count2_inc;
  wire  [2:0] stat_rx_rsfec_err_count3_inc;
  wire        stat_rx_rsfec_hi_ser;
  wire        stat_rx_rsfec_lane_alignment_status;
  wire [13:0] stat_rx_rsfec_lane_fill_0;
  wire [13:0] stat_rx_rsfec_lane_fill_1;
  wire [13:0] stat_rx_rsfec_lane_fill_2;
  wire [13:0] stat_rx_rsfec_lane_fill_3;
  wire  [7:0] stat_rx_rsfec_lane_mapping;
  wire        stat_rx_rsfec_uncorrected_cw_inc;

  wire        stat_tx_bad_fcs;
  wire        stat_tx_broadcast;
  wire        stat_tx_frame_error;
  wire        stat_tx_local_fault;
  wire        stat_tx_multicast;
  wire        stat_tx_packet_1024_1518_bytes;
  wire        stat_tx_packet_128_255_bytes;
  wire        stat_tx_packet_1519_1522_bytes;
  wire        stat_tx_packet_1523_1548_bytes;
  wire        stat_tx_packet_1549_2047_bytes;
  wire        stat_tx_packet_2048_4095_bytes;
  wire        stat_tx_packet_256_511_bytes;
  wire        stat_tx_packet_4096_8191_bytes;
  wire        stat_tx_packet_512_1023_bytes;
  wire        stat_tx_packet_64_bytes;
  wire        stat_tx_packet_65_127_bytes;
  wire        stat_tx_packet_8192_9215_bytes;
  wire        stat_tx_packet_large;
  wire        stat_tx_packet_small;
  wire  [5:0] stat_tx_total_bytes;
  wire [13:0] stat_tx_total_good_bytes;
  wire        stat_tx_total_good_packets;
  wire        stat_tx_total_packets;
  wire        stat_tx_unicast;
  wire        stat_tx_vlan;
  wire  [8:0] stat_tx_pause_valid;
  wire        stat_tx_pause;
  wire        stat_tx_user_pause;

  wire        ctl_tx_send_idle;
  wire        ctl_tx_send_rfi;
  wire        ctl_tx_send_lfi;

  assign cmac_clk                = txusrclk2;
  assign gt_loopback_in  = (loopback_en)?{4{3'b010}}:{4{3'b000}};

  assign core_rx_reset           = 1'b0;
  assign core_tx_reset           = 1'b0;
  assign gtwiz_reset_rx_datapath = 1'b0;
  assign gtwiz_reset_tx_datapath = 1'b0;
  assign tx_preamblein           = 56'b0;
  assign ctl_tx_pause_req        = 9'b0;
  assign ctl_tx_resend_pause     = 1'b0;
  assign ctl_tx_send_idle        = 1'b0;
  assign ctl_tx_send_rfi         = ~stat_rx_aligned;  //1'b0;
  assign ctl_tx_send_lfi         = 1'b0;

  assign cmac_linkup = &stat_rx_block_lock & stat_rx_status; //通道正常启动

  assign cmac_debug_pin[0] = stat_rx_rsfec_lane_alignment_status;
  assign cmac_debug_pin[1] = stat_rx_aligned;
  assign cmac_debug_pin[2] = stat_rx_aligned_err;
  assign cmac_debug_pin[3] = stat_rx_status;
  assign cmac_debug_pin[4] = stat_rx_rsfec_am_lock0;
  assign cmac_debug_pin[5] = stat_rx_rsfec_am_lock1;
  assign cmac_debug_pin[6] = stat_rx_rsfec_am_lock2;
  assign cmac_debug_pin[7] = stat_rx_rsfec_am_lock3;
  assign cmac_debug_pin[15: 8] = stat_rx_rsfec_lane_mapping[7:0];
  assign cmac_debug_pin[35:16] = stat_rx_block_lock[19:0];

    cmac_usplus cmac_inst (
      .gt_rxp_in                           (gt_rxp),
      .gt_rxn_in                           (gt_rxn),
      .gt_txp_out                          (gt_txp),
      .gt_txn_out                          (gt_txn),
    
      .gt_ref_clk_p                        (gt_refclk_p),
      .gt_ref_clk_n                        (gt_refclk_n),
      .gt_ref_clk_out                      (gt_ref_clk_out),
      .gt_rxrecclkout                      (),
      .gt_rxusrclk2                        (),
      .rx_clk                              (txusrclk2),
      .gt_txusrclk2                        (txusrclk2),

      .sys_reset                           (cmac_sys_reset),
      .core_rx_reset                       (core_rx_reset),
      .core_tx_reset                       (core_tx_reset),
      .gtwiz_reset_tx_datapath             (gtwiz_reset_tx_datapath),
      .gtwiz_reset_rx_datapath             (gtwiz_reset_rx_datapath),
      .usr_rx_reset                        (),
      .usr_tx_reset                        (usr_tx_reset),
      .gt_powergoodout                     (gt_powergoodout),
      .gt_loopback_in                      (gt_loopback_in),

      .init_clk                            (init_clk),

      .rx_axis_tvalid                      (m_axis_rx_tvalid),
      .rx_axis_tdata                       (m_axis_rx_tdata),
      .rx_axis_tkeep                       (m_axis_rx_tkeep),
      .rx_axis_tlast                       (m_axis_rx_tlast),
      .rx_axis_tuser                       (m_axis_rx_tuser),
      .rx_preambleout                      (rx_preambleout),

      .tx_axis_tvalid                      (s_axis_tx_tvalid),
      .tx_axis_tdata                       (s_axis_tx_tdata),
      .tx_axis_tkeep                       (s_axis_tx_tkeep),
      .tx_axis_tlast                       (s_axis_tx_tlast),
      .tx_axis_tuser                       (s_axis_tx_tuser),
      .tx_axis_tready                      (s_axis_tx_tready),
      .tx_ovfout                           (tx_ovfout),     //输入，发送本地故障指示码，置0
      .tx_unfout                           (tx_unfout),     //输出，表征LBUS是否运行不足
      .tx_preamblein                       (tx_preamblein), //输入，自定义TX前导输入数据，56'd0

      .rx_otn_bip8_0                       (rx_otn_bip8_0),
      .rx_otn_bip8_1                       (rx_otn_bip8_1),
      .rx_otn_bip8_2                       (rx_otn_bip8_2),
      .rx_otn_bip8_3                       (rx_otn_bip8_3),
      .rx_otn_bip8_4                       (rx_otn_bip8_4),
      .rx_otn_data_0                       (rx_otn_data_0),
      .rx_otn_data_1                       (rx_otn_data_1),
      .rx_otn_data_2                       (rx_otn_data_2),
      .rx_otn_data_3                       (rx_otn_data_3),
      .rx_otn_data_4                       (rx_otn_data_4),
      .rx_otn_ena                          (rx_otn_ena),
      .rx_otn_lane0                        (rx_otn_lane0),
      .rx_otn_vlmarker                     (rx_otn_vlmarker),

      .stat_rx_aligned                     (stat_rx_aligned),
      .stat_rx_aligned_err                 (stat_rx_aligned_err),
      .stat_rx_bad_code                    (stat_rx_bad_code),
      .stat_rx_bad_fcs                     (stat_rx_bad_fcs),
      .stat_rx_bad_preamble                (stat_rx_bad_preamble),
      .stat_rx_bad_sfd                     (stat_rx_bad_sfd),
      .stat_rx_bip_err_0                   (stat_rx_bip_err_0),
      .stat_rx_bip_err_1                   (stat_rx_bip_err_1),
      .stat_rx_bip_err_10                  (stat_rx_bip_err_10),
      .stat_rx_bip_err_11                  (stat_rx_bip_err_11),
      .stat_rx_bip_err_12                  (stat_rx_bip_err_12),
      .stat_rx_bip_err_13                  (stat_rx_bip_err_13),
      .stat_rx_bip_err_14                  (stat_rx_bip_err_14),
      .stat_rx_bip_err_15                  (stat_rx_bip_err_15),
      .stat_rx_bip_err_16                  (stat_rx_bip_err_16),
      .stat_rx_bip_err_17                  (stat_rx_bip_err_17),
      .stat_rx_bip_err_18                  (stat_rx_bip_err_18),
      .stat_rx_bip_err_19                  (stat_rx_bip_err_19),
      .stat_rx_bip_err_2                   (stat_rx_bip_err_2),
      .stat_rx_bip_err_3                   (stat_rx_bip_err_3),
      .stat_rx_bip_err_4                   (stat_rx_bip_err_4),
      .stat_rx_bip_err_5                   (stat_rx_bip_err_5),
      .stat_rx_bip_err_6                   (stat_rx_bip_err_6),
      .stat_rx_bip_err_7                   (stat_rx_bip_err_7),
      .stat_rx_bip_err_8                   (stat_rx_bip_err_8),
      .stat_rx_bip_err_9                   (stat_rx_bip_err_9),
      .stat_rx_block_lock                  (stat_rx_block_lock), //每个PCS通道的块锁定状态，值为1表示通道正常启动
      .stat_rx_broadcast                   (stat_rx_broadcast),
      .stat_rx_fragment                    (stat_rx_fragment),
      .stat_rx_framing_err_0               (stat_rx_framing_err_0),
      .stat_rx_framing_err_1               (stat_rx_framing_err_1),
      .stat_rx_framing_err_10              (stat_rx_framing_err_10),
      .stat_rx_framing_err_11              (stat_rx_framing_err_11),
      .stat_rx_framing_err_12              (stat_rx_framing_err_12),
      .stat_rx_framing_err_13              (stat_rx_framing_err_13),
      .stat_rx_framing_err_14              (stat_rx_framing_err_14),
      .stat_rx_framing_err_15              (stat_rx_framing_err_15),
      .stat_rx_framing_err_16              (stat_rx_framing_err_16),
      .stat_rx_framing_err_17              (stat_rx_framing_err_17),
      .stat_rx_framing_err_18              (stat_rx_framing_err_18),
      .stat_rx_framing_err_19              (stat_rx_framing_err_19),
      .stat_rx_framing_err_2               (stat_rx_framing_err_2),
      .stat_rx_framing_err_3               (stat_rx_framing_err_3),
      .stat_rx_framing_err_4               (stat_rx_framing_err_4),
      .stat_rx_framing_err_5               (stat_rx_framing_err_5),
      .stat_rx_framing_err_6               (stat_rx_framing_err_6),
      .stat_rx_framing_err_7               (stat_rx_framing_err_7),
      .stat_rx_framing_err_8               (stat_rx_framing_err_8),
      .stat_rx_framing_err_9               (stat_rx_framing_err_9),
      .stat_rx_framing_err_valid_0         (stat_rx_framing_err_valid_0),
      .stat_rx_framing_err_valid_1         (stat_rx_framing_err_valid_1),
      .stat_rx_framing_err_valid_10        (stat_rx_framing_err_valid_10),
      .stat_rx_framing_err_valid_11        (stat_rx_framing_err_valid_11),
      .stat_rx_framing_err_valid_12        (stat_rx_framing_err_valid_12),
      .stat_rx_framing_err_valid_13        (stat_rx_framing_err_valid_13),
      .stat_rx_framing_err_valid_14        (stat_rx_framing_err_valid_14),
      .stat_rx_framing_err_valid_15        (stat_rx_framing_err_valid_15),
      .stat_rx_framing_err_valid_16        (stat_rx_framing_err_valid_16),
      .stat_rx_framing_err_valid_17        (stat_rx_framing_err_valid_17),
      .stat_rx_framing_err_valid_18        (stat_rx_framing_err_valid_18),
      .stat_rx_framing_err_valid_19        (stat_rx_framing_err_valid_19),
      .stat_rx_framing_err_valid_2         (stat_rx_framing_err_valid_2),
      .stat_rx_framing_err_valid_3         (stat_rx_framing_err_valid_3),
      .stat_rx_framing_err_valid_4         (stat_rx_framing_err_valid_4),
      .stat_rx_framing_err_valid_5         (stat_rx_framing_err_valid_5),
      .stat_rx_framing_err_valid_6         (stat_rx_framing_err_valid_6),
      .stat_rx_framing_err_valid_7         (stat_rx_framing_err_valid_7),
      .stat_rx_framing_err_valid_8         (stat_rx_framing_err_valid_8),
      .stat_rx_framing_err_valid_9         (stat_rx_framing_err_valid_9),
      .stat_rx_got_signal_os               (stat_rx_got_signal_os),
      .stat_rx_hi_ber                      (stat_rx_hi_ber),
      .stat_rx_inrangeerr                  (stat_rx_inrangeerr),
      .stat_rx_internal_local_fault        (stat_rx_internal_local_fault),
      .stat_rx_jabber                      (stat_rx_jabber),
      .stat_rx_local_fault                 (stat_rx_local_fault),
      .stat_rx_mf_err                      (stat_rx_mf_err),
      .stat_rx_mf_len_err                  (stat_rx_mf_len_err),
      .stat_rx_mf_repeat_err               (stat_rx_mf_repeat_err),
      .stat_rx_misaligned                  (stat_rx_misaligned),
      .stat_rx_multicast                   (stat_rx_multicast),
      .stat_rx_oversize                    (stat_rx_oversize),
      .stat_rx_packet_1024_1518_bytes      (stat_rx_packet_1024_1518_bytes),
      .stat_rx_packet_128_255_bytes        (stat_rx_packet_128_255_bytes),
      .stat_rx_packet_1519_1522_bytes      (stat_rx_packet_1519_1522_bytes),
      .stat_rx_packet_1523_1548_bytes      (stat_rx_packet_1523_1548_bytes),
      .stat_rx_packet_1549_2047_bytes      (stat_rx_packet_1549_2047_bytes),
      .stat_rx_packet_2048_4095_bytes      (stat_rx_packet_2048_4095_bytes),
      .stat_rx_packet_256_511_bytes        (stat_rx_packet_256_511_bytes),
      .stat_rx_packet_4096_8191_bytes      (stat_rx_packet_4096_8191_bytes),
      .stat_rx_packet_512_1023_bytes       (stat_rx_packet_512_1023_bytes),
      .stat_rx_packet_64_bytes             (stat_rx_packet_64_bytes),
      .stat_rx_packet_65_127_bytes         (stat_rx_packet_65_127_bytes),
      .stat_rx_packet_8192_9215_bytes      (stat_rx_packet_8192_9215_bytes),
      .stat_rx_packet_bad_fcs              (stat_rx_packet_bad_fcs),
      .stat_rx_packet_large                (stat_rx_packet_large),
      .stat_rx_packet_small                (stat_rx_packet_small),
      .stat_rx_received_local_fault        (stat_rx_received_local_fault),
      .stat_rx_remote_fault                (stat_rx_remote_fault),
      .stat_rx_status                      (stat_rx_status), //PCS的状态，值为1表示PCS aligned，正常
      .stat_rx_stomped_fcs                 (stat_rx_stomped_fcs),
      .stat_rx_synced                      (stat_rx_synced),
      .stat_rx_synced_err                  (stat_rx_synced_err),
      .stat_rx_test_pattern_mismatch       (stat_rx_test_pattern_mismatch),
      .stat_rx_toolong                     (stat_rx_toolong),
      .stat_rx_total_bytes                 (stat_rx_total_bytes),
      .stat_rx_total_good_bytes            (stat_rx_total_good_bytes),
      .stat_rx_total_good_packets          (stat_rx_total_good_packets),
      .stat_rx_total_packets               (stat_rx_total_packets),
      .stat_rx_truncated                   (stat_rx_truncated),
      .stat_rx_undersize                   (stat_rx_undersize),
      .stat_rx_unicast                     (stat_rx_unicast),
      .stat_rx_vlan                        (stat_rx_vlan),
      .stat_rx_pcsl_demuxed                (stat_rx_pcsl_demuxed),
      .stat_rx_pcsl_number_0               (stat_rx_pcsl_number_0),
      .stat_rx_pcsl_number_1               (stat_rx_pcsl_number_1),
      .stat_rx_pcsl_number_10              (stat_rx_pcsl_number_10),
      .stat_rx_pcsl_number_11              (stat_rx_pcsl_number_11),
      .stat_rx_pcsl_number_12              (stat_rx_pcsl_number_12),
      .stat_rx_pcsl_number_13              (stat_rx_pcsl_number_13),
      .stat_rx_pcsl_number_14              (stat_rx_pcsl_number_14),
      .stat_rx_pcsl_number_15              (stat_rx_pcsl_number_15),
      .stat_rx_pcsl_number_16              (stat_rx_pcsl_number_16),
      .stat_rx_pcsl_number_17              (stat_rx_pcsl_number_17),
      .stat_rx_pcsl_number_18              (stat_rx_pcsl_number_18),
      .stat_rx_pcsl_number_19              (stat_rx_pcsl_number_19),
      .stat_rx_pcsl_number_2               (stat_rx_pcsl_number_2),
      .stat_rx_pcsl_number_3               (stat_rx_pcsl_number_3),
      .stat_rx_pcsl_number_4               (stat_rx_pcsl_number_4),
      .stat_rx_pcsl_number_5               (stat_rx_pcsl_number_5),
      .stat_rx_pcsl_number_6               (stat_rx_pcsl_number_6),
      .stat_rx_pcsl_number_7               (stat_rx_pcsl_number_7),
      .stat_rx_pcsl_number_8               (stat_rx_pcsl_number_8),
      .stat_rx_pcsl_number_9               (stat_rx_pcsl_number_9),

      .stat_rx_rsfec_am_lock0              (stat_rx_rsfec_am_lock0),
      .stat_rx_rsfec_am_lock1              (stat_rx_rsfec_am_lock1),
      .stat_rx_rsfec_am_lock2              (stat_rx_rsfec_am_lock2),
      .stat_rx_rsfec_am_lock3              (stat_rx_rsfec_am_lock3),
      .stat_rx_rsfec_corrected_cw_inc      (stat_rx_rsfec_corrected_cw_inc),
      .stat_rx_rsfec_cw_inc                (stat_rx_rsfec_cw_inc),
      .stat_rx_rsfec_err_count0_inc        (stat_rx_rsfec_err_count0_inc),
      .stat_rx_rsfec_err_count1_inc        (stat_rx_rsfec_err_count1_inc),
      .stat_rx_rsfec_err_count2_inc        (stat_rx_rsfec_err_count2_inc),
      .stat_rx_rsfec_err_count3_inc        (stat_rx_rsfec_err_count3_inc),
      .stat_rx_rsfec_hi_ser                (stat_rx_rsfec_hi_ser),
      .stat_rx_rsfec_lane_alignment_status (stat_rx_rsfec_lane_alignment_status),
      .stat_rx_rsfec_lane_fill_0           (stat_rx_rsfec_lane_fill_0),
      .stat_rx_rsfec_lane_fill_1           (stat_rx_rsfec_lane_fill_1),
      .stat_rx_rsfec_lane_fill_2           (stat_rx_rsfec_lane_fill_2),
      .stat_rx_rsfec_lane_fill_3           (stat_rx_rsfec_lane_fill_3),
      .stat_rx_rsfec_lane_mapping          (stat_rx_rsfec_lane_mapping),
      .stat_rx_rsfec_uncorrected_cw_inc    (stat_rx_rsfec_uncorrected_cw_inc),

      .stat_tx_bad_fcs                     (stat_tx_bad_fcs),
      .stat_tx_broadcast                   (stat_tx_broadcast),
      .stat_tx_frame_error                 (stat_tx_frame_error),
      .stat_tx_local_fault                 (stat_tx_local_fault),
      .stat_tx_multicast                   (stat_tx_multicast),
      .stat_tx_packet_1024_1518_bytes      (stat_tx_packet_1024_1518_bytes),
      .stat_tx_packet_128_255_bytes        (stat_tx_packet_128_255_bytes),
      .stat_tx_packet_1519_1522_bytes      (stat_tx_packet_1519_1522_bytes),
      .stat_tx_packet_1523_1548_bytes      (stat_tx_packet_1523_1548_bytes),
      .stat_tx_packet_1549_2047_bytes      (stat_tx_packet_1549_2047_bytes),
      .stat_tx_packet_2048_4095_bytes      (stat_tx_packet_2048_4095_bytes),
      .stat_tx_packet_256_511_bytes        (stat_tx_packet_256_511_bytes),
      .stat_tx_packet_4096_8191_bytes      (stat_tx_packet_4096_8191_bytes),
      .stat_tx_packet_512_1023_bytes       (stat_tx_packet_512_1023_bytes),
      .stat_tx_packet_64_bytes             (stat_tx_packet_64_bytes),
      .stat_tx_packet_65_127_bytes         (stat_tx_packet_65_127_bytes),
      .stat_tx_packet_8192_9215_bytes      (stat_tx_packet_8192_9215_bytes),
      .stat_tx_packet_large                (stat_tx_packet_large),
      .stat_tx_packet_small                (stat_tx_packet_small),
      .stat_tx_total_bytes                 (stat_tx_total_bytes),
      .stat_tx_total_good_bytes            (stat_tx_total_good_bytes),
      .stat_tx_total_good_packets          (stat_tx_total_good_packets),
      .stat_tx_total_packets               (stat_tx_total_packets),
      .stat_tx_unicast                     (stat_tx_unicast),
      .stat_tx_vlan                        (stat_tx_vlan),
      .ctl_tx_send_idle                    (ctl_tx_send_idle), //输入，发送空闲码，置0
      .ctl_tx_send_rfi                     (ctl_tx_send_rfi),  //输入，发送远程故障指示码，置0
      .ctl_tx_send_lfi                     (ctl_tx_send_lfi),  //输入，发送本地故障指示码，置0

      .ctl_rx_enable                       (1'b1), //输入，RX使能，要接收数据时置1
      .ctl_rx_force_resync                 (1'b0), //输入，强制RX通道复位，正常时为0
      .ctl_rx_test_pattern                 (1'b0), //输入，如果值为1，启用字句中定义的测试模式，置0，不启用
      .ctl_rsfec_ieee_error_indication_mode(1'b1), //输入，RS-FEC相关信号，lock时置1
      .ctl_rx_rsfec_enable                 (1'b1), //输入，RS-FEC相关信号，lock时置1
      .ctl_rx_rsfec_enable_correction      (1'b1), //输入，RS-FEC相关信号，lock时置1
      .ctl_rx_rsfec_enable_indication      (1'b1), //输入，RS-FEC相关信号，lock时置1
      .ctl_tx_enable                       (1'b1), //输入，TX使能，要发送数据时置1
      .ctl_tx_test_pattern                 (1'b0), //输入，如果值为1，启用字句中定义的测试模式，置0，不启用
      .ctl_tx_rsfec_enable                 (1'b1), //输入，RS-FEC的控制输入，lock时为置1

      .core_drp_reset                      (1'b0),
      .drp_clk                             (1'b0),
      .drp_addr                            (0),
      .drp_di                              (0),
      .drp_en                              (1'b0),
      .drp_do                              (),
      .drp_rdy                             (),
      .drp_we                              (1'b0)
    );

endmodule: cmac_exdes
