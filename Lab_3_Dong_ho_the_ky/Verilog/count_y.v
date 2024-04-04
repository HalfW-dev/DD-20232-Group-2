module count_y(
    input clk,
    input set_y,
    // input [5:0] cnt_s,
    // input [5:0] cnt_min,
    // input [4:0] cnt_h,
    // input [4:0] cnt_d,
    // input [3:0] cnt_mon,
    input pulse_y,
    output reg [6:0] cnt_y
);

    always @(posedge clk or negedge set_y) begin
        if (~set_y) begin
            cnt_y <= 0;
            end
        else begin
            if (~pulse_y) begin
                cnt_y <= cnt_y;
                end
            else cnt_y <= cnt_y + 1;
        end

    end

endmodule