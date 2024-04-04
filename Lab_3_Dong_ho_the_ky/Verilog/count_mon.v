module count_mon(
    input clk, 
    input set_mon,
    // input [5:0] cnt_s,
    // input [5:0] cnt_min,
    // input [4:0] cnt_h,
    // input [4:0] cnt_d,
    // input [6:0] cnt_y,
    input pulse_mon,
    output reg pulse_y,
    output reg [3:0] cnt_mon
);

always @(posedge clk or negedge set_mon) begin

  if (~set_mon) begin
    cnt_mon <= 1;
    pulse_y <= 0;
  end
  else begin
    if (~pulse_mon) 
    begin
        cnt_mon <= cnt_mon;
        pulse_y <= 0;
    end
    else begin
        if(cnt_mon == 12) begin
          cnt_mon <= 1;
          pulse_y <= 1;
        end
        else begin
          cnt_mon <= cnt_mon + 1;
          pulse_y <= 0;
        end
  end
    
    //     if (cnt_s == 59 && cnt_min == 59 && cnt_h == 23) begin
    //         if (cnt_d == 31 && cnt_mon == 12) begin
    //              cnt_mon <= 1;
    //              pulse_y <= 1;
    //         end
    //         else if ( cnt_d == 31 && (cnt_mon == 1 || cnt_mon == 3 || cnt_mon == 5|| cnt_mon == 7 || cnt_mon == 8 || cnt_mon == 10) ) begin
    //             cnt_mon <= cnt_mon + 1;
    //             pulse_y <= 0;
    //         end 
    //         else if ( cnt_d == 28 && cnt_mon == 2 && (cnt_y[1:0] != 2'b00) ) 
    //             begin
    //                 cnt_mon <= cnt_mon + 1;
    //                 pulse_y <= 0;
    //             end 
    //         else if ( cnt_d == 29 && cnt_mon == 2 && cnt_y[1:0] == 2'b00) 
    //             begin
    //                 cnt_mon <= cnt_mon + 1;
    //                 pulse_y <= 0;
    //             end 
    //         else begin
    //             cnt_mon <= cnt_mon;
    //             pulse_y <= 0;
    //         end 
    //     end
    //     else cnt_mon <= cnt_mon;
     end
end

endmodule