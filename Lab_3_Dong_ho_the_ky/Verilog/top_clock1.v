module top_clock1(
    input clk,
    input switch, 
    input set_s, set_min, set_h, set_d, set_mon, set_y,
    output reg [41:0] segment
);

    reg clk_1s;
    reg [24:0] counter;

    initial begin
        counter = 0;
        clk_1s = 0;
    end

    always @(posedge clk) begin
        if (counter == 0) begin
            counter <= 149;
            clk_1s <= ~clk_1s;
        end else begin
            counter <= counter - 1;
        end
    end


    wire pulse_min, pulse_h, pulse_d, pulse_mon, pulse_y;
    wire [5:0] cnt_s; 
    wire [5:0] cnt_min;
    wire [4:0] cnt_h;
    wire [4:0] cnt_d;
    wire [3:0] cnt_mon;
    wire [6:0] cnt_y;
    wire [41:0] seg1;
    wire [41:0] seg2;

    count_s duts(
        .clk(clk_1s),
        .set_s(set_s),
        .pulse_min(pulse_min),
        .cnt_s(cnt_s)
    );

    count_min dutmin(
        .clk(clk_1s),
        .set_min(set_min),
        .pulse_min(pulse_min),
        .pulse_h(pulse_h),
        .cnt_min(cnt_min)
    );

    count_h duth(
        .clk(clk_1s),
        .set_h(set_h),
        .pulse_h(pulse_h),
        .pulse_d(pulse_d),
        .cnt_h(cnt_h)
    );

    count_d dutd(
        .clk(clk_1s),
        .set_d(set_d),
        .cnt_mon(cnt_mon),
        .cnt_y(cnt_y),
        .pulse_d(pulse_d),
        .pulse_mon(pulse_mon),
        .cnt_d(cnt_d)
    );

    count_mon dutmon(
        .clk(clk_1s),
        .set_mon(set_mon),
        .pulse_mon(pulse_mon),
        .pulse_y(pulse_y),
        .cnt_mon(cnt_mon)
    );

    count_y duty(
        .clk(clk_1s),
        .set_y(set_y),
        .pulse_y(pulse_y),
        .cnt_y(cnt_y)
    );

    led_s ds(
        .cnt_s(cnt_s),
        .seg(seg1[13:0]) //HEX3, HEX2
    );

    led_min dmin(
        .cnt_min(cnt_min),
        .seg(seg1[27:14]) //HEX5, HEX4
    );

    led_h dh (
        .cnt_h(cnt_h),
        .seg(seg1[41:28]) //HEX7, HEX6
    );

    led_d dd(
        .cnt_d(cnt_d),
        .seg(seg2[13:0])
    );

    led_mon dmon(
        .cnt_mon(cnt_mon),
        .seg(seg2[27:14])
    );

    led_y dy(
        .cnt_y(cnt_y),
        .seg(seg2[41:28])
    );
     
    always @(switch or seg1 or seg2) begin
        case (switch)
            0 : segment = seg1;
            1 : segment = seg2;
        endcase
    end

endmodule