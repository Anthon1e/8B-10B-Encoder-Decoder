`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2021 10:52:35 AM
// Design Name: 
// Module Name: 8B10B
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: The top module for 8B10B Encoder
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Enc8B10B(
    input BYTECLK, 
    input bit_control,
    input [7:0] data_in,
    input rd_in,
    output bit_control_out,
    output logic_rd_out,
    output [9:0] data_out
    );
    
    // Variable to hold values 
    wire clk = BYTECLK; 
    wire K = bit_control;
    wire COMPL6, COMPL4;
    wire [5:0] data_out_f5b;
    wire [2:0] data_out_f3b;
    wire [5:0] L;
    
    fcn5b   f5b(clk, K, data_in[4:0], L);
    fcn3b   f3b(clk, K, data_in[7:5], data_out_f3b); 
    disCtrl dis(clk, L, data_out_f3b, COMPL6, COMPL4);
    fcn5b6b f56(L, COMPL6, data_in[4:0], data_out[5:0]);
    fcn3b4b f34(L, COMPL4, data_in[7:5], data_out[9:6]);
endmodule
