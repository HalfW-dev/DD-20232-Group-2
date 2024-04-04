module count_mon(
    input clk, 
    input rst_n,
    input set_mon,
    input pulse_mon,
    
    output reg pulse_y,
    output reg [3:0] cnt_mon
);

  always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin 
      cnt_mon <= 0;
    end
    else if(~set_mon) begin
      cnt_mon <= cnt_mon + 1;
    end
    else if (pulse_mon) begin
      if(cnt_mon == 12) begin
        cnt_mon <= 1;
        pulse_y <= 1;
      end
      else begin
        cnt_mon <= cnt_mon + 1;
        pulse_y <= 0;
      end
    end
  end
endmodule