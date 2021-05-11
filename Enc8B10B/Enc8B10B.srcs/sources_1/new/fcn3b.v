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
    input [1:0] data_in,  
    input rd_in_s4,
    input [4:0] L,
    output reg S
    );
    wire L13 = L[1];
    wire L31 = L[3];
    wire E, D;
    assign {E, D} = data_in;
    always @(posedge clk)
        S = (rd_in_s4 & L31 & D & ~E) ^ (~rd_in_s4 & L13 & ~D & E);
endmodule
