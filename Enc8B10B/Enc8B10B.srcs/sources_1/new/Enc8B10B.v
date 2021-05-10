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
    output reg [9:0] out,
    output rd_out
    );
    
    // Variable to hold values 
    wire clk = BYTECLK; 
    wire rd_in_s4, COMPLS6, COMPLS4;
    wire [5:0] L;    // L
    wire [4:0] data_buffer;  
    wire [5:0] abcdei;
    wire [3:0] fghj; 
    
    reg [7:0] data_in;
    reg K, rd_in, en;
    wire next_K;
    
    always @(negedge clk) 
    begin 
        if (reset) begin
            data_in <= 8'b0;
            rd_in <= 0;
            K <= 0;
        end
        else begin
            rd_in <= rd_out;
            data_in <= in;
            K <= bit_control;
        end
    end
    
    fcn5b   f5b(clk, reset, K, data_in[4:0], L);
    fcn3b   f3b(clk, reset, K, data_in[7:3], rd_in_s4, L, data_buffer); 
    disCtrl dis(clk, reset, L, data_buffer, data_in[3], data_in[4], 
                rd_in, rd_in_s4, COMPLS6, COMPLS4, rd_out);
    fcn5b6b f56(clk, reset, data_in[4:0], L, COMPLS6, abcdei);
    fcn3b4b f34(clk, reset, data_buffer, COMPLS4, fghj);
    
    always @(negedge clk)
    begin
        out <= {abcdei[5:0], fghj[3:0]}; // Encoded messages
    end
endmodule
