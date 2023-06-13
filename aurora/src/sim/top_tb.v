`timescale 1 ns / 10 ps
 
module top_tb;
reg init_clk;
reg gtyq0_p;
reg RESET;
reg PMA_INIT;
reg [2:0] loopback;
reg start;
wire gtyq0_n;

initial begin
  #0 begin 
    init_clk = 1'b1;
    gtyq0_p = 1'b1;
    RESET = 1'b1;
    PMA_INIT = 1'b1;
    loopback = 3'd3;
    start = 1'd0;
  end
  #100 begin
    RESET = 1'b0;
    PMA_INIT = 1'b0;
  end
end

always #5 init_clk = !init_clk;
always #5 gtyq0_p = !gtyq0_p;
assign gtyq0_n = !gtyq0_p;

top top_i(
  .INIT_CLK(init_clk),
  .GTYQ0_P(gtyq0_p),
  .GTYQ0_N(gtyq0_n),
  .RESET(RESET),
  .PMA_INIT(PMA_INIT),
  .loopback(loopback),
  .start(start)
);

endmodule