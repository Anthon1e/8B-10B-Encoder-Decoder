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
// Description: Top level module for 8B10B Encoder
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
    output [9:0] data_out
    );
    
    // Variable to hold values 
    wire clk = BYTECLK; 
    wire K = bit_control;
    wire PDL6, COMPLS6, COMPLS4;
    wire [5:0] L;    // L
    wire [4:0] data_buffer;  
    wire [5:0] abcdei;
    wire [3:0] fghj; 
    
    fcn5b   f5b(clk, K, data_in[4:0], L);
    fcn3b   f3b(clk, K, data_in[7:3], PDL6, L, data_buffer); 
    disCtrl dis(clk, L, data_buffer, data_in[4], data_in[3], PDL6, COMPLS6, COMPLS4);
    fcn5b6b f56(clk, data_in[4:0], L, COMPLS6, abcdei);
    fcn3b4b f34(clk, data_buffer, COMPLS4, fghj);
    
    assign data_out = {abcdei[5:1], fghj[3:1], abcdei[0], fghj[0]};
endmodule
