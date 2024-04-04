module count_min(
    input clk, 
    input set_min,
    input pulse_min,
    output reg pulse_h,
    output reg [5:0] cnt_min
);

    always @(posedge clk or negedge set_min) begin
      if (~set_min) begin
        cnt_min <= 0;
        pulse_h <= 0;
        end
      else begin 
        if(~pulse_min) begin
            cnt_min <= cnt_min;
            pulse_h <= 0;
            end
        else begin
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
    end
endmodule
