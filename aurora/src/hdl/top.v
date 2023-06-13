`timescale 1 ns / 10 ps
`define SYNTH
//`define SIM

module top ( 
`ifdef SIM
  input         RESET,
  input         PMA_INIT,
  input   [2:0] loopback,
  input         start,
`endif  
  input         INIT_CLK,
  input         GTYQ0_P,
  input         GTYQ0_N,
  input   [0:3] RXP,
  input   [0:3] RXN,
  output  [0:3] TXP,
  output  [0:3] TXN
);

wire        HARD_ERR;
wire        SOFT_ERR;
wire  [0:3] LANE_UP;
wire        channel_RESETup;

`ifdef SYNTH
wire        RESET; //高电平复位
wire        PMA_INIT; //高电平复位
wire  [2:0] loopback; //0表示不回环，1、2、3、4表示在不同地方环回
wire        start;
// 控制复位和环回
vio vio_i (
  .clk(INIT_CLK),
  .probe_out0(RESET),
  .probe_out1(PMA_INIT),
  .probe_out2(loopback),
  .probe_out3(start)
);
`endif

// 例化aurora4
wire cmac_clk; //用户逻辑时钟
wire rst_send, rst_recv; //send和recv模块复位信号
//发送数据接口
wire tx_tvalid, tx_tready, tx_tlast;
wire [255:0] tx_tdata;
wire [31:0] tx_tkeep;
//接收数据接口
wire rx_tvalid, rx_tlast;
wire [255:0] rx_tdata;
wire [31:0] rx_tkeep;
aurora_exdes aurora_exdes_i (
  .RESET(RESET),
  .HARD_ERR(HARD_ERR),
  .SOFT_ERR(SOFT_ERR),
  .LANE_UP(LANE_UP),
  .CHANNEL_UP(channel_up),
  .INIT_CLK_IN(INIT_CLK),
  .PMA_INIT(PMA_INIT),
  .GTYQ0_P(GTYQ0_P),
  .GTYQ0_N(GTYQ0_N),
  .RXP(RXP),
  .RXN(RXN),
  .TXP(TXP),
  .TXN(TXN),
  .loopback_i(loopback),
  .user_clk_i(cmac_clk),
  .reset2FrameGen(rst_send),
  .reset2FrameCheck(rst_recv),
  .tx_tvalid_i(tx_tvalid),
  .tx_tready_i(tx_tready),
  .tx_tdata_i(tx_tdata),
  .tx_tkeep_i(tx_tkeep),
  .tx_tlast_i(tx_tlast),
  .rx_tvalid_i(rx_tvalid),
  .rx_tdata_i(rx_tdata),
  .rx_tkeep_i(rx_tkeep),
  .rx_tlast_i(rx_tlast)
);
wire rst_sys = RESET || (!channel_up); //复位信号

`ifdef SYNTH
// 频率监控
wire gt_refclk_update;
wire [31:0] gt_refclk_freq_value;
frequency_counter #(
  .RefClk_Frequency_g   (100000000)
) frequency_counter_i(
  .i_RefClk_p           (INIT_CLK),
  .i_Clock_p            (cmac_clk),
  .o_Frequency_Update_p (gt_refclk_update),
  .ov32_Frequency_p     (gt_refclk_freq_value)
);

// 链路监控
ila_status ila_status_i (
  .clk(INIT_CLK),
  .probe0(HARD_ERR),
  .probe1(SOFT_ERR),
  .probe2(channel_up),
  .probe3(LANE_UP),
  .probe4(gt_refclk_update),
  .probe5(gt_refclk_freq_value)
);
`endif

// 发送数据模块
data_send data_send_i (
  .start_write(start),
  .axis_aclk(cmac_clk),
  .axis_aresetn(!rst_send),
  .axis_tready(tx_tready),
  .axis_tvalid(tx_tvalid),
  .axis_tdata(tx_tdata),
  .axis_tkeep(tx_tkeep),
  .axis_tlast(tx_tlast)
);

`ifdef SYNTH
// 数据监控
ila_data ila_data_i (
  .clk(cmac_clk),
  .probe0(rst_send),
  .probe1(start),
  .probe2(tx_tready),
  .probe3(tx_tvalid),
  .probe4(tx_tdata),
  .probe5(tx_tkeep),
  .probe6(tx_tlast),
  .probe7(rx_tvalid),
  .probe8(rx_tdata),
  .probe9(rx_tkeep),
  .probe10(rx_tlast)
);
`endif

endmodule