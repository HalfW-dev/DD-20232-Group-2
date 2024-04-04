module count_y(
    input clk,
    input rst_n,
    input set_y,
    // input [5:0] cnt_s,
    // input [5:0] cnt_min,
    // input [4:0] cnt_h,
    // input [4:0] cnt_d,
    // input [3:0] cnt_mon,
    input pulse_y,
    output reg [6:0] cnt_y
);
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin 
            cnt_y <= 0;
        end
        else if(~set_y) begin
            cnt_y <= cnt_y + 1;
        end
        else if (pulse_y) begin
            if(cnt_y == 99) begin
                cnt_y <= 0;
            end
            else begin
                cnt_y <= cnt_y + 1;
            end
        end
    end

endmodule