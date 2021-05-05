`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2021 01:41:36 PM
// Design Name: 
// Module Name: fcn5b6b
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 3B/4B classification or the S function 
//              Figure 4 in Encoder diagram
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fcn3b(
    input clk, 
    input K,
    input [7:5] data_in,  
    input NDL6, // down-level from disCtrl (fig 2)
    input PDL6,
    input L13,
    input L31,
    input D,
    input E,
    output [2:0] data_buffer,
    output reg S
    );
    wire F, G, H;
    assign {H, G, F} = data_in;
    // Buffers to hold the values of F,G,H and K 
    reg F4, G4, H4, K4;
    always @(negedge clk) 
    begin
        F4 <= F; 
        G4 <= G;
        H4 <= H;
        K4 <= K;  
    end 
    // Bit encoding in 3B/4B Classifications
    // Redundant so obmitted here (see disCtrl function for more details) 
    assign data_buffer = {H4, G4, F4};
    // Flip flop to update value of S
    always @(negedge clk)
    begin
        S = (~PDL6 & ~L31 & ~D & E) || (~NDL6 & ~L13 & D & ~E);
    end
endmodule
