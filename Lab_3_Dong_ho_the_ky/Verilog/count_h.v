module count_h(
    input clk,
    input set_h,
    input pulse_h,
    output reg pulse_d,
    output reg [4:0] cnt_h
);

    always @(posedge clk or negedge set_h) begin
      if (~set_h) begin
        cnt_h <= 0;
        pulse_d <= 0;
        end
      else begin
        if (~pulse_h) begin
          cnt_h <= cnt_h;
          pulse_d <= 0;
          end
        else begin
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
        
    end
endmodule
