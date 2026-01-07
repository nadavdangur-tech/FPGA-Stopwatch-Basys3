`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Company:         Tel Aviv University
// Engineer:        Leo Segre
// 
// Create Date:     05/05/2019 00:19 AM
// Design Name:     EE3 lab1
// Module Name:     Stash
// Project Name:    Electrical Lab 3, FPGA Experiment #1
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool versions:   Vivado 2016.4
// Description:     a Stash that stores all the samples in order upon sample_in and sample_in_valid.
//                  It exposes the chosen sample by sample_out and the exposed sample can be changed by next_sample. 
// Dependencies:    Lim_Inc
//
// Revision         1.0
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Stash(clk, reset, sample_in, sample_in_valid, next_sample, sample_out);

   parameter DEPTH = 5;
   
   input clk, reset, sample_in_valid, next_sample;
   input [7:0] sample_in;
   output [7:0] sample_out;
  
   // FILL HERE
   reg [7:0] sample_regs [0:DEPTH-1];
   reg [$clog2(DEPTH)-1:0] in_pointer;
   reg [$clog2(DEPTH)-1:0] out_pointer;
   wire [$clog2(DEPTH)-1:0] next_in_val;
   wire [$clog2(DEPTH)-1:0] next_out_val;
   integer j;
   wire rst;
   
   Lim_Inc #(DEPTH) rst_out (.a(out_pointer), .ci(next_sample), .sum(next_out_val), .co(rst_o));
   Lim_Inc #(DEPTH) rst_in (.a(in_pointer), .ci(sample_in_valid), .sum(next_in_val), .co(rst_i));
   
   always @(posedge clk) begin
       if (reset) begin
           in_pointer <= 0;
           out_pointer <= 0;
           for (j=0; j<DEPTH; j=j+1) begin
               sample_regs[j] <= 8'b0;
           end
       end else if (sample_in_valid) begin
            sample_regs[in_pointer] <= sample_in;
            out_pointer <= in_pointer;
            if (rst_i) 
                in_pointer <= 0;
            else
                in_pointer <= next_in_val;
       end
       if (next_sample) begin
           if (rst_o)
               out_pointer <= 0;
           else
               out_pointer <= next_out_val;
       end          
    end
    assign sample_out = sample_regs[out_pointer]; 
endmodule
