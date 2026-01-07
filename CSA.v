`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Company:         Tel Aviv University
// Engineer:        
// 
// Create Date:     11/10/2018 08:59:38 PM
// Design Name:     EE3 lab1
// Module Name:     CSA
// Project Name:    Electrical Lab 3, FPGA Experiment #1
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool Versions:   Vivado 2016.4
// Description:     Variable length binary adder. The parameter N determines
//                  the bit width of the operands. Implemented according to 
//                  Conditional Sum Adder.
// 
// Dependencies:    FA
// 
// Revision:        2.0
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module CSA(a, b, ci, sum, co);

    parameter N=4;
    parameter K = N >> 1;
    
    input [N-1:0] a;
    input [N-1:0] b;
    input ci;
    output [N-1:0] sum;
    output co;
    
    generate
        if (N==1) begin
            FA fa(.a(a[0]), .b(b[0]), .ci(ci), .sum(sum), .co(co));
        end
        else begin
            wire [K-1:0] s_low;
            wire [N-1:K] s0_high, s1_high;
            wire c_low, c0_high, c1_high;
            CSA #(.N(K)) csa_low (.a(a[K-1:0]), .b(b[K-1:0]), .ci(ci), .sum(s_low), .co(c_low));
            CSA #(.N(N-K)) csa_high0 (.a(a[N-1:K]), .b(b[N-1:K]), .ci(1'b0), .sum(s0_high), .co(c0_high));
            CSA #(.N(N-K)) csa_high1 (.a(a[N-1:K]), .b(b[N-1:K]), .ci(1'b1), .sum(s1_high), .co(c1_high)); 
            wire [N-K:0] mux_out;
            assign mux_out = c_low ? {c1_high, s1_high} : {c0_high, s0_high};
            assign co = mux_out[N-K];
            assign sum = {mux_out[N-K-1:0], s_low};
        end
    endgenerate
endmodule
