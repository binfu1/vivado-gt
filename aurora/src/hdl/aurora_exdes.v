`timescale 1 ns / 10 ps

   (* core_generation_info = "aurora_64b66b_0,aurora_64b66b_v12_0_6,{c_aurora_lanes=4,c_column_used=left,c_gt_clock_1=GTYQ0,c_gt_clock_2=None,c_gt_loc_1=1,c_gt_loc_10=X,c_gt_loc_11=X,c_gt_loc_12=X,c_gt_loc_13=X,c_gt_loc_14=X,c_gt_loc_15=X,c_gt_loc_16=X,c_gt_loc_17=X,c_gt_loc_18=X,c_gt_loc_19=X,c_gt_loc_2=2,c_gt_loc_20=X,c_gt_loc_21=X,c_gt_loc_22=X,c_gt_loc_23=X,c_gt_loc_24=X,c_gt_loc_25=X,c_gt_loc_26=X,c_gt_loc_27=X,c_gt_loc_28=X,c_gt_loc_29=X,c_gt_loc_3=3,c_gt_loc_30=X,c_gt_loc_31=X,c_gt_loc_32=X,c_gt_loc_33=X,c_gt_loc_34=X,c_gt_loc_35=X,c_gt_loc_36=X,c_gt_loc_37=X,c_gt_loc_38=X,c_gt_loc_39=X,c_gt_loc_4=4,c_gt_loc_40=X,c_gt_loc_41=X,c_gt_loc_42=X,c_gt_loc_43=X,c_gt_loc_44=X,c_gt_loc_45=X,c_gt_loc_46=X,c_gt_loc_47=X,c_gt_loc_48=X,c_gt_loc_5=X,c_gt_loc_6=X,c_gt_loc_7=X,c_gt_loc_8=X,c_gt_loc_9=X,c_lane_width=4,c_line_rate=10.0,c_gt_type=GTYE4,c_qpll=true,c_nfc=false,c_nfc_mode=IMM,c_refclk_frequency=156.25,c_simplex=false,c_simplex_mode=TX,c_stream=true,c_ufc=false,c_user_k=false,flow_mode=None,interface_mode=Streaming,dataflow_config=Duplex}" *)
(* DowngradeIPIdentifiedWarnings="yes" *)
 module aurora_exdes (
  input            RESET,
  // Error Detection Interface
  output reg       HARD_ERR,
  output reg       SOFT_ERR,
  // Status
  output reg [0:3] LANE_UP,
  output reg       CHANNEL_UP,
  input            PMA_INIT,
  input            INIT_CLK_IN,
  // GTX Reference Clock Interface
  input            GTYQ0_P,
  input            GTYQ0_N,
  // GTX Serial I/O
  input      [0:3] RXP,
  input      [0:3] RXN,
  output     [0:3] TXP,
  output     [0:3] TXN,

  input      [2:0] loopback_i,
  output           user_clk_i,
  output           reset2FrameGen,
  output           reset2FrameCheck,
  //TX Interface
  input   [0:255] tx_tdata_i,
  input           tx_tvalid_i,
  output          tx_tready_i,
  input           tx_tlast_i,
  input   [31:0]  tx_tkeep_i,  
  //RX Interface
  output  [0:255] rx_tdata_i,
  output          rx_tvalid_i,
  output          rx_tlast_i,
  output  [31:0]  rx_tkeep_i
 );
 `define DLY #1

//********************************Wire Declarations**********************************
//Error Detection Interface
wire        hard_err_i;
wire        soft_err_i;
//Status
wire        channel_up_i;
wire  [0:3] lane_up_i;
//System Interface
wire        reset_i ;
reg         reset_r1 ;
reg         reset_r2 ;
reg         reset_r3 ;
wire        gt_rxcdrovrden_i ;
wire        power_down_i;
wire        gt_pll_lock_i ;
wire        fsm_resetdone_i ;
wire        tx_out_clk_i ;
// clock
wire        sync_clk_i;
wire        INIT_CLK_i  /* synthesis syn_keep = 1 */;
wire        drp_clk_i = INIT_CLK_i;
wire        DRP_CLK_i;
wire [9:0]  drpaddr_in_i;
wire [15:0] drpdi_in_i;
wire [15:0] drpdo_out_i;
wire        drprdy_out_i;
wire        drpen_in_i;
wire        drpwe_in_i;
wire [9:0]  gt0_drpaddr_i;
wire [15:0] gt0_drpdi_i;  
wire        gt0_drpen_i;  
wire        gt0_drpwe_i;  
wire [15:0] gt0_drpdo_i;  
wire [9:0]  drpaddr_in_lane1_i;
wire [15:0] drpdi_in_lane1_i;
wire [15:0] drpdo_out_lane1_i;
wire        drprdy_out_lane1_i;
wire        drpen_in_lane1_i;
wire        drpwe_in_lane1_i;
wire [9:0]  gt1_drpaddr_i;
wire [15:0] gt1_drpdi_i;  
wire        gt1_drpen_i;  
wire        gt1_drpwe_i;  
wire [15:0] gt1_drpdo_i;  
wire [9:0]  drpaddr_in_lane2_i;
wire [15:0] drpdi_in_lane2_i;
wire [15:0] drpdo_out_lane2_i;
wire        drprdy_out_lane2_i;
wire        drpen_in_lane2_i;
wire        drpwe_in_lane2_i;
wire [9:0]  gt2_drpaddr_i;
wire [15:0] gt2_drpdi_i;  
wire        gt2_drpen_i;  
wire        gt2_drpwe_i;  
wire [15:0] gt2_drpdo_i;  
wire [9:0]  drpaddr_in_lane3_i;
wire [15:0] drpdi_in_lane3_i;
wire [15:0] drpdo_out_lane3_i;
wire        drprdy_out_lane3_i;
wire        drpen_in_lane3_i;
wire        drpwe_in_lane3_i;
wire [9:0]  gt3_drpaddr_i;
wire [15:0] gt3_drpdi_i;  
wire        gt3_drpen_i;  
wire        gt3_drpwe_i;  
wire [15:0] gt3_drpdo_i;  
wire [31:0] s_axi_awaddr_i;
wire [31:0] s_axi_araddr_i;
wire [31:0] s_axi_wdata_i;
wire [3:0]  s_axi_wstrb_i;
wire [31:0] s_axi_rdata_i;
wire        s_axi_awvalid_i;
wire        s_axi_arvalid_i;
wire        s_axi_wvalid_i;
wire        s_axi_rvalid_i;
wire        s_axi_bvalid_i;
wire [1:0]  s_axi_bresp_i;
wire [1:0]  s_axi_rresp_i;
wire        s_axi_bready_i;
wire        s_axi_awready_i;
wire        s_axi_arready_i;
wire        s_axi_wready_i;
wire        s_axi_rready_i;
wire [31:0] s_axi_awaddr_lane1_i;
wire [31:0] s_axi_araddr_lane1_i;
wire [31:0] s_axi_wdata_lane1_i;
wire [3:0]  s_axi_wstrb_lane1_i;
wire [31:0] s_axi_rdata_lane1_i;
wire        s_axi_awvalid_lane1_i;
wire        s_axi_arvalid_lane1_i;
wire        s_axi_wvalid_lane1_i;
wire        s_axi_rvalid_lane1_i;
wire        s_axi_bvalid_lane1_i;
wire [1:0]  s_axi_bresp_lane1_i;
wire [1:0]  s_axi_rresp_lane1_i;
wire        s_axi_bready_lane1_i;
wire        s_axi_awready_lane1_i;
wire        s_axi_arready_lane1_i;
wire        s_axi_wready_lane1_i;
wire        s_axi_rready_lane1_i;
wire [31:0] s_axi_awaddr_lane2_i;
wire [31:0] s_axi_araddr_lane2_i;
wire [31:0] s_axi_wdata_lane2_i;
wire [3:0]  s_axi_wstrb_lane2_i;
wire [31:0] s_axi_rdata_lane2_i;
wire        s_axi_awvalid_lane2_i;
wire        s_axi_arvalid_lane2_i;
wire        s_axi_wvalid_lane2_i;
wire        s_axi_rvalid_lane2_i;
wire        s_axi_bvalid_lane2_i;
wire [1:0]  s_axi_bresp_lane2_i;
wire [1:0]  s_axi_rresp_lane2_i;
wire        s_axi_bready_lane2_i;
wire        s_axi_awready_lane2_i;
wire        s_axi_arready_lane2_i;
wire        s_axi_wready_lane2_i;
wire        s_axi_rready_lane2_i;
wire [31:0] s_axi_awaddr_lane3_i;
wire [31:0] s_axi_araddr_lane3_i;
wire [31:0] s_axi_wdata_lane3_i;
wire [3:0]  s_axi_wstrb_lane3_i;
wire [31:0] s_axi_rdata_lane3_i;
wire        s_axi_awvalid_lane3_i;
wire        s_axi_arvalid_lane3_i;
wire        s_axi_wvalid_lane3_i;
wire        s_axi_rvalid_lane3_i;
wire        s_axi_bvalid_lane3_i;
wire [1:0]  s_axi_bresp_lane3_i;
wire [1:0]  s_axi_rresp_lane3_i;
wire        s_axi_bready_lane3_i;
wire        s_axi_awready_lane3_i;
wire        s_axi_arready_lane3_i;
wire        s_axi_wready_lane3_i;
wire        s_axi_rready_lane3_i;
wire        link_reset_i;
wire        sysreset_from_vio_i =1'b0 ;
wire        gtreset_from_vio_i =1'b0 ;
wire        rx_cdrovrden_i =1'b0 ;
wire        gt_reset_i;
wire        gt_reset_i_tmp;
wire        gt_reset_i_tmp2;
wire        sysreset_from_vio_r3;
wire        sysreset_from_vio_r3_initclkdomain;
wire        gtreset_from_vio_r3;
wire        tied_to_ground_i;
wire        tied_to_vcc_i;
wire        gt_reset_i_eff;
wire        system_reset_i;
wire        pll_not_locked_i;
 
//*********************************Main Body of Code**********************************
assign reset2FrameGen   = reset_r1 | !channel_up_i;
assign reset2FrameCheck = reset_r2 | !channel_up_i;
always @(posedge user_clk_i)
  reset_r1 <= `DLY system_reset_i;
always @(posedge user_clk_i)
  reset_r2 <= `DLY system_reset_i;
always @(posedge user_clk_i)
  reset_r3 <= `DLY reset_i;

BUFG initclk_bufg_i (
  .I(INIT_CLK_IN),
  .O(INIT_CLK_i)
);

//____________________________Register User I/O___________________________________
// Register User Outputs from core.
always @(posedge user_clk_i)
begin
  HARD_ERR         <=  hard_err_i;
  SOFT_ERR         <=  soft_err_i;
  LANE_UP          <=  lane_up_i;
  CHANNEL_UP       <=  channel_up_i;
end

//____________________________Register User I/O___________________________________
// System Interface
assign power_down_i             =   1'b0;
assign tied_to_ground_i         =   1'b0;
assign tied_to_ground_vec_i     = 281'd0;
assign tied_to_vcc_i            =   1'b1;
// AXI4 Lite Interface
assign  s_axi_awaddr_i          =  32'h0;
assign  s_axi_wdata_i           =  16'h0;
assign  s_axi_wstrb_i           =  'h0;
assign  s_axi_araddr_i          =  32'h0;
assign  s_axi_awvalid_i         =  1'b0;
assign  s_axi_wvalid_i          =  1'b0;
assign  s_axi_arvalid_i         =  1'b0;
assign  s_axi_rvalid_i          =  1'b0;
assign  s_axi_rready_i          =  1'b0;
assign  s_axi_bready_i          =  1'b0;
assign  s_axi_awaddr_lane1_i    =  32'h0;
assign  s_axi_wdata_lane1_i     =  16'h0;
assign  s_axi_wstrb_lane1_i     =  'h0;
assign  s_axi_araddr_lane1_i    =  32'h0;
assign  s_axi_awvalid_lane1_i   =  1'b0;
assign  s_axi_wvalid_lane1_i    =  1'b0;
assign  s_axi_arvalid_lane1_i   =  1'b0;
assign  s_axi_rvalid_lane1_i    =  1'b0;
assign  s_axi_rready_lane1_i    =  1'b0;
assign  s_axi_bready_lane1_i    =  1'b0;
assign  s_axi_awaddr_lane2_i    =  32'h0;
assign  s_axi_wdata_lane2_i     =  16'h0;
assign  s_axi_wstrb_lane2_i     =  'h0;
assign  s_axi_araddr_lane2_i    =  32'h0;
assign  s_axi_awvalid_lane2_i   =  1'b0;
assign  s_axi_wvalid_lane2_i    =  1'b0;
assign  s_axi_arvalid_lane2_i   =  1'b0;
assign  s_axi_rvalid_lane2_i    =  1'b0;
assign  s_axi_rready_lane2_i    =  1'b0;
assign  s_axi_bready_lane2_i    =  1'b0;
assign  s_axi_awaddr_lane3_i    =  32'h0;
assign  s_axi_wdata_lane3_i     =  16'h0;
assign  s_axi_wstrb_lane3_i     =  'h0;
assign  s_axi_araddr_lane3_i    =  32'h0;
assign  s_axi_awvalid_lane3_i   =  1'b0;
assign  s_axi_wvalid_lane3_i    =  1'b0;
assign  s_axi_arvalid_lane3_i   =  1'b0;
assign  s_axi_rvalid_lane3_i    =  1'b0;
assign  s_axi_rready_lane3_i    =  1'b0;
assign  s_axi_bready_lane3_i    =  1'b0;

reg [127:0] pma_init_stage = {128{1'b1}};
reg [23:0]  pma_init_pulse_width_cnt = 24'h0;
reg         pma_init_assertion = 1'b0;
reg         pma_init_assertion_r;
reg         gt_reset_i_delayed_r1;
reg         gt_reset_i_delayed_r2;
wire        gt_reset_i_delayed;
always @(posedge INIT_CLK_i)
begin
  pma_init_stage[127:0] <= {pma_init_stage[126:0], gt_reset_i_tmp};
end

assign gt_reset_i_delayed = pma_init_stage[127];

always @(posedge INIT_CLK_i)
begin
  gt_reset_i_delayed_r1 <=  gt_reset_i_delayed;
  gt_reset_i_delayed_r2 <=  gt_reset_i_delayed_r1;
  pma_init_assertion_r  <= pma_init_assertion;
  if(~gt_reset_i_delayed_r2 & gt_reset_i_delayed_r1 & ~pma_init_assertion & (pma_init_pulse_width_cnt != 24'hFFFFFF))
    pma_init_assertion <= 1'b1;
  else if (pma_init_assertion & pma_init_pulse_width_cnt == 24'hFFFFFF)
    pma_init_assertion <= 1'b0;
  if(pma_init_assertion)
    pma_init_pulse_width_cnt <= pma_init_pulse_width_cnt + 24'h1;
end

assign gt_reset_i_eff = pma_init_assertion ? 1'b1 : gt_reset_i_delayed;
assign gt_reset_i_tmp = PMA_INIT;
assign reset_i  =   RESET | gt_reset_i_tmp2;
assign gt_reset_i = gt_reset_i_eff;
assign gt_rxcdrovrden_i  =  1'b0;

aurora_64b66b_0_rst_sync_exdes u_rst_sync_gtrsttmpi (
  .prmry_in     (gt_reset_i_tmp),
  .scndry_aclk  (user_clk_i),
  .scndry_out   (gt_reset_i_tmp2)
);

//___________________________Module Instantiations_________________________________
// this is shared mode, clock, GT common and reset are part of the core.
aurora_64b66b aurora_64b66b_block_i (
// TX AXI4-S Interface
.s_axi_tx_tdata(tx_tdata_i),
.s_axi_tx_tvalid(tx_tvalid_i),
.s_axi_tx_tready(tx_tready_i),
.s_axi_tx_tkeep(tx_tkeep_i),
.s_axi_tx_tlast(tx_tlast_i),
// RX AXI4-S Interface
.m_axi_rx_tdata(rx_tdata_i),
.m_axi_rx_tvalid(rx_tvalid_i),
.m_axi_rx_tkeep(rx_tkeep_i),
.m_axi_rx_tlast(rx_tlast_i),
// GT Serial I/O
.rxp(RXP),
.rxn(RXN),
.txp(TXP),
.txn(TXN),
//GT Reference Clock Interface
.gt_refclk1_p (GTYQ0_P),
.gt_refclk1_n (GTYQ0_N),
// Error Detection Interface
.hard_err              (hard_err_i),
.soft_err              (soft_err_i),
// Status
.channel_up            (channel_up_i),
.lane_up               (lane_up_i),
// System Interface
.user_clk_out          (user_clk_i),
.gt_reset_out    (),
.gt_refclk1_out  (),
.gt_powergood (),
.sync_clk_out(sync_clk_i),
.reset_pb(reset_r3),
.gt_rxcdrovrden_in(gt_rxcdrovrden_i),
.power_down(power_down_i),
.loopback(loopback_i),
.pma_init(gt_reset_i),
.gt_pll_lock(gt_pll_lock_i),
// ---------- AXI4-Lite input signals ---------------
.s_axi_awaddr(s_axi_awaddr_i),
.s_axi_awvalid(s_axi_awvalid_i),
.s_axi_awready(s_axi_awready_i),
.s_axi_awaddr_lane1(s_axi_awaddr_lane1_i),
.s_axi_awvalid_lane1(s_axi_awvalid_lane1_i),
.s_axi_awready_lane1(s_axi_awready_lane1_i),
.s_axi_awaddr_lane2(s_axi_awaddr_lane2_i),
.s_axi_awvalid_lane2(s_axi_awvalid_lane2_i),
.s_axi_awready_lane2(s_axi_awready_lane2_i),
.s_axi_awaddr_lane3(s_axi_awaddr_lane3_i),
.s_axi_awvalid_lane3(s_axi_awvalid_lane3_i),
.s_axi_awready_lane3(s_axi_awready_lane3_i),
.s_axi_wdata(s_axi_wdata_i),
.s_axi_wstrb(s_axi_wstrb_i),
.s_axi_wvalid(s_axi_wvalid_i),
.s_axi_wready(s_axi_wready_i),
.s_axi_bvalid(s_axi_bvalid_i),
.s_axi_bresp(s_axi_bresp_i),
.s_axi_bready(s_axi_bready_i),
.s_axi_wdata_lane1(s_axi_wdata_lane1_i),
.s_axi_wstrb_lane1(s_axi_wstrb_lane1_i),
.s_axi_wvalid_lane1(s_axi_wvalid_lane1_i),
.s_axi_wready_lane1(s_axi_wready_lane1_i),
.s_axi_bvalid_lane1(s_axi_bvalid_lane1_i),
.s_axi_bresp_lane1(s_axi_bresp_lane1_i),
.s_axi_bready_lane1(s_axi_bready_lane1_i),
.s_axi_wdata_lane2(s_axi_wdata_lane2_i),
.s_axi_wstrb_lane2(s_axi_wstrb_lane2_i),
.s_axi_wvalid_lane2(s_axi_wvalid_lane2_i),
.s_axi_wready_lane2(s_axi_wready_lane2_i),
.s_axi_bvalid_lane2(s_axi_bvalid_lane2_i),
.s_axi_bresp_lane2(s_axi_bresp_lane2_i),
.s_axi_bready_lane2(s_axi_bready_lane2_i),
.s_axi_wdata_lane3(s_axi_wdata_lane3_i),
.s_axi_wstrb_lane3(s_axi_wstrb_lane3_i),
.s_axi_wvalid_lane3(s_axi_wvalid_lane3_i),
.s_axi_wready_lane3(s_axi_wready_lane3_i),
.s_axi_bvalid_lane3(s_axi_bvalid_lane3_i),
.s_axi_bresp_lane3(s_axi_bresp_lane3_i),
.s_axi_bready_lane3(s_axi_bready_lane3_i),
.s_axi_araddr(s_axi_araddr_i),
.s_axi_arvalid(s_axi_arvalid_i),
.s_axi_arready(s_axi_arready_i),
.s_axi_araddr_lane1(s_axi_araddr_lane1_i),
.s_axi_arvalid_lane1(s_axi_arvalid_lane1_i),
.s_axi_arready_lane1(s_axi_arready_lane1_i),
.s_axi_araddr_lane2(s_axi_araddr_lane2_i),
.s_axi_arvalid_lane2(s_axi_arvalid_lane2_i),
.s_axi_arready_lane2(s_axi_arready_lane2_i),
.s_axi_araddr_lane3(s_axi_araddr_lane3_i),
.s_axi_arvalid_lane3(s_axi_arvalid_lane3_i),
.s_axi_arready_lane3(s_axi_arready_lane3_i),
.s_axi_rdata(s_axi_rdata_i),
.s_axi_rvalid(s_axi_rvalid_i),
.s_axi_rresp(s_axi_rresp_i),
.s_axi_rready(s_axi_rready_i),
.s_axi_rdata_lane1(s_axi_rdata_lane1_i),
.s_axi_rvalid_lane1(s_axi_rvalid_lane1_i),
.s_axi_rresp_lane1(s_axi_rresp_lane1_i),
.s_axi_rready_lane1(s_axi_rready_lane1_i),
.s_axi_rdata_lane2(s_axi_rdata_lane2_i),
.s_axi_rvalid_lane2(s_axi_rvalid_lane2_i),
.s_axi_rresp_lane2(s_axi_rresp_lane2_i),
.s_axi_rready_lane2(s_axi_rready_lane2_i),
.s_axi_rdata_lane3(s_axi_rdata_lane3_i),
.s_axi_rvalid_lane3(s_axi_rvalid_lane3_i),
.s_axi_rresp_lane3(s_axi_rresp_lane3_i),
.s_axi_rready_lane3(s_axi_rready_lane3_i),

.init_clk                    (INIT_CLK_i),
.link_reset_out              (link_reset_i),
.mmcm_not_locked_out         (pll_not_locked_i),

.gt_qpllclk_quad1_out                  (),
.gt_qpllrefclk_quad1_out               (),
.gt_qplllock_quad1_out                 (),
.gt_qpllrefclklost_quad1_out           (),

.sys_reset_out               (system_reset_i),
.tx_out_clk                  (tx_out_clk_i)
);

endmodule
