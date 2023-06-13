`timescale 1 ns / 10 ps

module data_recv (
  input              clk,
  input              rst,
  input              tvalid,
  input      [255:0] tdata
); 

// 状态机
reg [3:0] curr_st, next_st;
parameter idle      = 4'b0000; //空闲状态
parameter fst1      = 4'b0001; //发送第一次数据
parameter fst2      = 4'b0010; //发送第二次数据
parameter recv      = 4'b0011; //发送数据
parameter last      = 4'b0100; //发送最后一次数据
parameter susp_fst1 = 4'b0101;
parameter susp_fst2 = 4'b0110;
parameter susp_recv = 4'b0111; //暂停数据发送

always @(posedge clk or posedge rst) begin
  if (rst) curr_st <= idle;
  else curr_st <= next_st;
end

wire [63:0] header; //同步头
assign header = tdata[191:128];
reg [15:0] size_cnt; //数据计数(byte)
wire tlast;
assign tlast = (size_cnt == (frame_size - 16'd16));
always @(*) begin
  case (curr_st)
    idle:  
      if (tvalid && (header == 64'h0000_0000_1acf_fc1d)) next_st = fst1; 
      else next_st = idle;
    fst1:
      if (tvalid) next_st = fst2;
      else next_st = susp_fst1;
    fst2:
      if (tvalid) next_st = recv;
      else next_st = susp_fst2;
    recv:
      if (tvalid && tlast) next_st = last;
      else if (tvalid) next_st = recv;
      else next_st = susp_recv;
    last:
      next_st <= idle;
    susp_fst1:
      if (tvalid) next_st = fst2;
      else next_st = susp_fst1;
    susp_fst2:
      if (tvalid) next_st = recv;
      else next_st = susp_fst2;
    susp_recv:
      if (tvalid && tlast) next_st = last;
      else if (tvalid) next_st = recv;
      else next_st = susp_recv;
    default: next_st = idle;
  endcase
end

reg [7:0] frame_cnt; //帧计数
always @(posedge clk)
  case (next_st)
    idle: begin 
    size_cnt <= 16'd0; 
    fifo_0_wr_en <= 1'b0; fifo_1_wr_en <= 1'b0;
    fifo_0_din <= 256'd0; fifo_1_din <= 256'd0; 
    end
    fst1: begin
      size_cnt <= 16'd0; frame_size <= tdata[223:208]; frame_cnt <= tdata[247:240]; 
      //根据帧计数的情况决定往哪个fifo存入数据，交替往两个fifo存入数据
      fifo_0_wr_en <= ((tdata[247:240]+1'b1)%2); fifo_1_wr_en <= ((tdata[247:240])%2);
      fifo_0_din <= tdata; fifo_1_din <= tdata; 
    end
    fst2: begin
      size_cnt <= size_cnt + 16'd16; 
      fifo_0_wr_en <= ((frame_cnt+1'b1)%2); fifo_1_wr_en <= ((frame_cnt)%2);
      fifo_0_din <= tdata; fifo_1_din <= tdata;
    end
    recv: begin
      size_cnt <= size_cnt + 16'd32; 
      fifo_0_wr_en <= ((frame_cnt+1'b1)%2); fifo_1_wr_en <= ((frame_cnt)%2);
      fifo_0_din <= tdata; fifo_1_din <= tdata;
    end
    last: begin
      size_cnt <= size_cnt + 16'd16; 
      fifo_0_wr_en <= ((frame_cnt+1'b1)%2); fifo_1_wr_en <= ((frame_cnt)%2);
      fifo_0_din <= tdata; fifo_1_din <= tdata; 
    end
    susp_fst1:
      begin size_cnt <= size_cnt; fifo_0_wr_en <= 1'b0; fifo_1_wr_en <= 1'b0; end
    susp_fst2:
      begin size_cnt <= size_cnt; fifo_0_wr_en <= 1'b0; fifo_1_wr_en <= 1'b0; end
    susp_recv:
      begin size_cnt <= size_cnt; fifo_0_wr_en <= 1'b0; fifo_1_wr_en <= 1'b0; end
    default: begin size_cnt <= 16'd0; fifo_0_wr_en <= 1'b0; fifo_1_wr_en <= 1'b0; end
  endcase

endmodule 