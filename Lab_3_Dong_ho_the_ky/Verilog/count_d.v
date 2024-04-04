module count_d(
    input clk,
    input rst_n,
    input set_d,
    input [3:0] cnt_mon,
    input [6:0] cnt_y,
    input pulse_d,
    output reg pulse_mon,
    output reg [4:0] cnt_d
);
    always @(posedge clk or negedge rst_n) begin
        if(~rst_n) begin 
            cnt_d <= 0;
        end
        else if(~set_d) begin
            cnt_d <= cnt_d + 1;
        end
        else if (pulse_d) begin
            if ( cnt_d == 31 && (cnt_mon == 1 || cnt_mon == 3 || cnt_mon == 5 || cnt_mon == 7 || cnt_mon == 8 || cnt_mon == 10 || cnt_mon == 12) ) 
                begin
                    cnt_d <= 1;
                    pulse_mon <= 1;
                end

            else if ( cnt_d == 30 && (cnt_mon == 4 || cnt_mon == 6 || cnt_mon == 9 || cnt_mon == 11) )
                begin
                    cnt_d <= 1;
                    pulse_mon <= 1;
                end
            else if ( cnt_d == 28 && cnt_mon == 2 && (cnt_y[1:0] != 2'b00 ))
                begin
                    cnt_d <= 1;
                    pulse_mon <= 1;
                end
            else if ( cnt_d == 29 && cnt_mon == 2 && cnt_y[1:0] == 2'b00)
                begin
                    cnt_d <= 1;
                    pulse_mon <= 1;
                end
            else begin
                cnt_d <= cnt_d + 1;
                pulse_mon <= 0;
            end
        end
    end
endmodule