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
    input reset,
    input bit_control,
    input [7:0] in,
    output [9:0] out,
    output rd_out
    );
    
    // Variable to hold values 
    wire clk = BYTECLK; 
    wire rd_in_s4, S, COMPLS6, COMPLS4, saved_K;
    wire [4:0] L, saved_L;    
    wire [7:0] saved_data_in;
    wire [5:0] abcdei;
    wire [3:0] fghj; 
    
    reg [7:0] data_in;
    reg K, rd_in;
    
    fcn5b   f5b(clk, data_in[4:0], L);
    fcn3b   f3b(clk, data_in[4:3], rd_in_s4, L, S); 
    disCtrl dis(clk, reset, K, L, S, data_in, rd_in, saved_data_in, saved_L, saved_K, rd_in_s4, COMPLS6, COMPLS4, rd_out);
    fcn5b6b f56(clk, reset, saved_data_in[4:0], saved_L, saved_K, COMPLS6, abcdei);
    fcn3b4b f34(clk, reset, saved_data_in[7:5], S, saved_K, COMPLS4, fghj);
    
    always @(posedge clk)
    begin
        if (reset) begin 
            K <= 0;
            rd_in = 0;
            data_in = 0;
        end
        else begin 
            K <= bit_control;
            rd_in = rd_out;
            data_in = in;
        end
    end
    
    assign out = {abcdei[5:0], fghj[3:0]}; // Encoded messages
endmodule
