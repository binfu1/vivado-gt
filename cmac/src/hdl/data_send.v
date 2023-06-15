`timescale 1 ns / 10 ps

module data_send (
  input          start_write,
  input          axis_aclk,
  input          axis_aresetn,
  input          axis_tready,
  output         axis_tvalid,
  output [511:0] axis_tdata,
  output [63:0]  axis_tkeep,
  output         axis_tlast,
  input          tx_ovfout,
  input          tx_unfout
); 

wire aclk, aresetn, tready;
reg tvalid, tlast;
reg [511:0] tdata;
reg [63:0]  tkeep;
assign aclk = axis_aclk;
assign aresetn = axis_aresetn;
assign tready = axis_tready;
assign axis_tvalid = tvalid;
assign axis_tdata = tdata;
assign axis_tkeep = tkeep;
assign axis_tlast = tlast;

reg  start_write_dly1;
wire start_write_arise;
always @(posedge aclk) begin
  if (!aresetn) begin
    start_write_dly1 <= 1'd0;
  end
  else begin
    start_write_dly1 <= start_write;
  end
end
assign start_write_arise = ({start_write, start_write_dly1} == {2'b10}) ? 1'b1 : 1'b0;

reg [1:0] wch_state;
reg [3:0] wch_cnt;
localparam WCH_IDLE  = 2'd0;
localparam WCH_READY = 2'd1;
localparam WCH_SUSP  = 2'd2;
localparam WCH_LAST  = 2'd3;

always @(posedge aclk) begin
  if (!aresetn) begin
    wch_state <= WCH_IDLE;
    tvalid    <= 1'b0;
    tdata     <= 512'd0;
    tkeep     <= 64'h00000000_00000000;
    tlast     <= 1'd0;
    wch_cnt   <= 4'd0;
  end
  else begin
    case (wch_state)
      WCH_IDLE: begin
        if (start_write && tready && !tx_ovfout && !tx_unfout) begin
          wch_state <= WCH_READY;
          tvalid    <= 1'b1;
          tdata     <= 512'd1;
          tkeep     <= 64'hffffffff_ffffffff;
          tlast     <= 1'd0;
          wch_cnt   <= wch_cnt + 4'd1;
        end
        else begin
          wch_state <= WCH_IDLE;
          tvalid    <= 1'b0;
          tdata     <= 512'd0;
          tkeep     <= 64'h00000000_00000000;
          tlast     <= 1'd0;
          wch_cnt   <= 1'd0;
        end
      end
      WCH_READY: begin
        if (tready && !tx_ovfout && !tx_unfout && wch_cnt < 4'd10) begin
          wch_state <= WCH_READY;
          tvalid    <= 1'b1;
          tdata     <= tdata + 512'd1;
          tkeep     <= 64'hffffffff_ffffffff;
          tlast     <= 1'd0;
          wch_cnt   <= wch_cnt + 4'd1;
        end
        else if (tready && !tx_ovfout && !tx_unfout && wch_cnt >= 4'd10)begin
          wch_state <= WCH_LAST;
          tvalid    <= 1'b1;
          tdata     <= tdata + 512'd1;
          tkeep     <= 64'hffffffff_ffffffff;
          tlast     <= 1'd1;
          wch_cnt   <= wch_cnt + 4'd1;
        end
        else if (!tready || tx_ovfout || tx_unfout && wch_cnt < 4'd10)begin
          wch_state <= WCH_SUSP;
          tvalid    <= 1'b0;
          tdata     <= tdata;
          tkeep     <= 64'h00000000_00000000;
          tlast     <= 1'd0;
          wch_cnt   <= 1'd0;
        end
      end
      WCH_SUSP: begin
        if (tready && !tx_ovfout && !tx_unfout && wch_cnt < 4'd10) begin
          wch_state <= WCH_READY;
          tvalid    <= 1'b1;
          tdata     <= tdata + 512'd1;
          tkeep     <= 64'hffffffff_ffffffff;
          tlast     <= 1'd0;
          wch_cnt   <= wch_cnt + 4'd1;
        end
        else if (tready && !tx_ovfout && !tx_unfout && wch_cnt >= 4'd10)begin
          wch_state <= WCH_LAST;
          tvalid    <= 1'b1;
          tdata     <= tdata + 512'd1;
          tkeep     <= 64'hffffffff_ffffffff;
          tlast     <= 1'd0;
          wch_cnt   <= wch_cnt + 4'd1;
        end
        else if (!tready || tx_ovfout || tx_unfout && wch_cnt < 4'd10)begin
          wch_state <= WCH_SUSP;
          tvalid    <= 1'b0;
          tdata     <= tdata;
          tkeep     <= 64'h00000000_00000000;
          tlast     <= 1'd1;
          wch_cnt   <= 1'd0;
        end
      end
      WCH_LAST: begin
        wch_state <= WCH_IDLE;
        tvalid    <= 1'b0;
        tdata     <= tdata;
        tkeep     <= 64'h00000000_00000000;
        tlast     <= 1'd0;
        wch_cnt   <= 4'd0;
      end
      default: begin
        wch_state <= WCH_IDLE;
        tvalid    <= 1'b0;
        tdata     <= 512'd0;
        tkeep     <= 64'h00000000_00000000;
        tlast     <= 1'd0;
        wch_cnt   <= 4'd0;
      end
    endcase
  end
end

ila_send ila_send_i(
  .clk(aclk),
  .probe0(tready),
  .probe1(tvalid),
  .probe2(tdata),
  .probe3(tkeep),
  .probe4(tlast),
  .probe5(tx_ovfout),
  .probe6(tx_unfout),
  .probe7(ctl_tx_enable),
  .probe8(ctl_tx_rsfec_enable),
  .probe9(wch_state),
  .probe10(wch_cnt),
  .probe11(start_write),
  .probe12(aresetn)
);

endmodule 
