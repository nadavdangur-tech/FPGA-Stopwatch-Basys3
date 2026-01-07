`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Company:         Tel Aviv University
// Engineer:        
// 
// Create Date:     05/05/2019 01:28AM
// Design Name:     EE3 lab1
// Module Name:     Stopwatch
// Project Name:    Electrical Lab 3, FPGA Experiment #1
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool versions:   Vivado 2016.4
// Description:     Top module of the stopwatch circuit. Displays 2 independent 
//                  stopwatches on the 4 digits of the 7-segment component.
//                  Uses btnC as reset, btnU as trigger, and btnR as split button to
//                  control the currently selected stopwatch.
//                  Pressing btnL at any time - toggles the selection between the 
//                  left hand side (LHS) and the RHS stopwatches.
//                  The stopwatch's time reading is outputted using an, seg and dp signals
//                  that should be connected to the 4-digit-7-segment display and driven
//                  by 100MHz clock. 
// Dependencies:    Debouncer, Ctl, Counter, Seg_7_Display
//
// Revision:        3.0
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Stopwatch(clk, btnC, btnU, btnR, btnL, btnD, seg, an, dp, led_left, led_right);

    input              clk, btnC, btnU, btnR, btnL, btnD;
    output  wire [6:0] seg;
    output  wire [3:0] an;
    output  wire       dp; 
    output  wire [2:0] led_left;
    output  wire [2:0] led_right;

    wire [15:0] time_reading;
    wire trig, split, reset, toggle, sample_in_valid;
    wire next_sample;
    wire trig_left, init_regs_left, count_enabled_left;
    reg selected_stopwatch;
    
	// FILL HERE INSTANTIATIONS
	
	 Debouncer d_toggle (.clk(clk), .input_unstable(btnL), .output_stable(toggle));
	 Debouncer d_reset (.clk(clk), .input_unstable(btnC), .output_stable(reset));
	 Debouncer d_split (.clk(clk), .input_unstable(btnR), .output_stable(split));
	 Debouncer d_trig (.clk(clk), .input_unstable(btnU), .output_stable(trig));
	 Debouncer d_sample (.clk(clk), .input_unstable(btnD), .output_stable(sample_in_valid));
	 
	 always @(posedge clk) begin
        if (reset)
            selected_stopwatch <= 0; 
        else if (toggle)
            selected_stopwatch <= ~selected_stopwatch;
     end
     
     assign led_left  = (selected_stopwatch == 0) ? 3'b111 : 3'b0;
     assign led_right = (selected_stopwatch == 1) ? 3'b111 : 3'b0;
     
     assign next_sample = (selected_stopwatch==1) ? trig : 0;
     assign trig_left = (selected_stopwatch==0) ? trig : 0;
     
     Ctl ctl_clk (.clk(clk), .reset(reset), .trig(trig_left), .split(split), .init_regs(init_regs_left), .count_enabled(count_enabled_left));
     
     Counter count (.clk(clk), .init_regs(init_regs_left), .count_enabled(count_enabled_left), .time_reading(time_reading[15:8]));
     
     Seg_7_Display seg_7 (.x(time_reading), .clk(clk), .clr(reset), .a_to_g(seg), .an(an), .dp(dp)); 
     
     Stash stsh (.clk(clk), .reset(reset), .sample_in(time_reading[15:8]), .sample_in_valid(sample_in_valid), .next_sample(next_sample), .sample_out(time_reading[7:0]));
	 
endmodule
