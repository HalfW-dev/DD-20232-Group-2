module count_s(
    input set_s,
    input clk,
    output reg pulse_min,
    output reg [5:0] cnt_s
);

    always @(posedge clk or negedge set_s) begin
      if(~set_s) begin 
        cnt_s <= 0; 
      end
        else begin
          if (cnt_s == 59) begin
            cnt_s <= 0; 
            pulse_min <= 1;
            end
          else begin
            cnt_s <= cnt_s + 1;
            pulse_min <= 0;
            end
        end
    end
endmodule

// module count_60s (
//     input clk, rst_n,
//     output reg [5:0] sec
// );
//     parameter n = 60;
//     always @(posedge clk or negedge rst_n) begin
//         if(~rst_n) sec <= 0;
//         else begin
//             if (sec == n) sec <= 0;
//             else sec <= sec + 1;
//         end

//     end
// endmodule