`timescale 1ns/1ps
module top_clock1_tb();
    reg clk, switch, set_s,set_min, set_h, set_d, set_mon, set_y;
    wire [41:0] segment;

    top_clock1 dutt(
        .clk(clk),
        .switch(switch),
        .set_s(set_s),
        .set_min(set_min),
        .set_h(set_h),
        .set_d(set_d),
        .set_mon(set_mon),
        .set_y(set_y),
        .segment(segment)
    );

    initial begin
      clk = 0;
      forever begin
        #5 clk = ~clk;
      end
    end

    initial begin
        set_s = 0;
        set_min = 0;
        set_h = 0;
        set_d = 0;
        set_mon = 0;
        set_y = 0;
        switch = 1;
        #10;
        switch = 0;
        set_s = 1;
        set_min = 1;
        set_h = 1;
        set_d = 1;
        set_mon = 1;
        set_y = 1;
        #500;
        set_min = 1;
        #100;
        set_min = 0;
        set_h = 1;
        #100;
        set_h = 1;
        $monitor("segment = %h", segment);
    end


endmodule