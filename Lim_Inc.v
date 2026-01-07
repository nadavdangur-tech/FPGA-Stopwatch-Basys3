`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Company:         Tel Aviv University
// Engineer:        
// 
// Create Date:     05/05/2019 00:16 AM
// Design Name:     EE3 lab1
// Module Name:     Lim_Inc
// Project Name:    Electrical Lab 3, FPGA Experiment #1
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool Versions:   Vivado 2016.4
// Description:     Incrementor modulo L, where the input a is *saturated* at L 
//                  If a+ci>L, then the output will be s=0,co=1 anyway.
// 
// Dependencies:    Compadder
// 
// Revision:        3.0
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module Lim_Inc(a, ci, sum, co);
    
    parameter L = 10;
    localparam N = $clog2(L);
    
    input [N-1:0] a;
    input ci;
    output [N-1:0] sum;
    output co;
    
    wire [N-1:0] intermed_sum;
    wire intermed_co;
    
    CSA #(N) csa (.a(a), .b({N{1'b0}}), .ci(ci), .sum(intermed_sum), .co(intermed_co));
    assign co = (intermed_sum>=L || intermed_co==1) ? 1 : 0;
    assign sum = (intermed_sum>=L || intermed_co==1) ? {N{1'b0}} : intermed_sum;
    
endmodule
