module count_min(
    input clk,
    input rst_n,
    input set_min,
    input pulse_min,

    output reg pulse_h,
    output reg [5:0] cnt_min
);

    always @(posedge clk or negedge rst_n) begin
      if(~rst_n) begin 
        cnt_min <= 0;
      end
      else if(~set_min) begin
        cnt_min <= cnt_min + 1;
      end
      else if (pulse_min) begin
        if (cnt_min == 59) begin
          cnt_min <= 0;
          pulse_h <= 1;
        end
        else begin
          cnt_min <= cnt_min + 1;
          pulse_h <= 0;
        end 
      end
    end
endmodule
