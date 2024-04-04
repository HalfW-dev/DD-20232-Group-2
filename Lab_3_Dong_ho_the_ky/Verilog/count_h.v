module count_h(
    input clk,
    input rst_n,
    input set_h,
    input pulse_h,

    output reg pulse_d,
    output reg [4:0] cnt_h
);
    always @(posedge clk or negedge rst_n) begin
      if(~rst_n) begin 
        cnt_h <= 0;
      end
      else if(~set_h) begin
        cnt_h <= cnt_h + 1;
      end
      else if (pulse_h) begin
        if (cnt_h == 23) begin
          cnt_h <= 0;
          pulse_d <= 1;
        end
        else begin
          cnt_h <= cnt_h + 1;
          pulse_d <= 0;
        end
      end
    end
endmodule
