`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Company:         Tel Aviv University
// Engineer:        
// 
// Create Date:     05/05/2019 00:19 AM
// Design Name:     EE3 lab1
// Module Name:     Counter
// Project Name:    Electrical Lab 3, FPGA Experiment #1
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool versions:   Vivado 2016.4
// Description:     a counter that advances its reading as long as time_reading 
//                  signal is high and zeroes its reading upon init_regs=1 input.
//                  the time_reading output represents: 
//                  {dekaseconds,seconds}
// Dependencies:    Lim_Inc
//
// Revision         3.0
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Counter(clk, init_regs, count_enabled, time_reading);

   parameter CLK_FREQ = 100000000;// in Hz
   
   input clk, init_regs, count_enabled;
   output reg [7:0] time_reading;

   reg [$clog2(CLK_FREQ)-1:0] clk_cnt;
   reg [3:0] ones_seconds;    
   reg [3:0] tens_seconds;      
   
   // FILL HERE THE LIMITED-COUNTER INSTANCES
   wire sec_count;
   wire tens_count;
   wire [3:0] sec_sum;
   wire [3:0] tens_sum;
   wire [$clog2(CLK_FREQ)-1:0] freq_sum;
   wire irrelevant;
   
   Lim_Inc #(CLK_FREQ) freq_inc (.a(clk_cnt), .ci(count_enabled), .sum(freq_sum), .co(sec_count));
   Lim_Inc sec_inc (.a(ones_seconds), .ci(sec_count), .sum(sec_sum), .co(tens_count));
   Lim_Inc tens_inc (.a(tens_seconds), .ci(tens_count), .sum(tens_sum), .co()); 
   
   //------------- Synchronous ----------------
   always @(posedge clk)
     begin
		// FILL HERE THE ADVANCING OF THE REGISTERS AS A FUNCTION OF init_regs, count_enabled
		if (init_regs) begin
		  clk_cnt <= {$clog2(CLK_FREQ){1'b0}};
		  ones_seconds <= 4'b0;
		  tens_seconds <= 4'b0;
		  time_reading <= 8'b0;
		end else if (count_enabled) begin 
		  clk_cnt <= freq_sum;
		  ones_seconds <= sec_sum;
		  tens_seconds <= tens_sum;
		  time_reading <= {tens_sum, sec_sum};
		end
     end

endmodule
