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
// Description: Actual transformation of 3 input bits FGH into  
//                  the 4 fghj output bits according to given rules
//              Figure 8 in Encoder diagram 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fcn3b4b(
    input clk,
    input [4:0] data_buffer,
    input COMPLS4,
    output [3:0] data_out
    );
    wire K4,H4,G4,F4,S;
    assign {S,K4,H4,G4,F4} = data_buffer;
    reg f,g,h,j;
    /* Transformation of 3 input bits FGH into the 4 fghj */
    always @(negedge clk)
    begin
        f = (F4 & ~(S & F4 & G4 & H4) & ~(F4 & G4 & H4 & K4)) ^ COMPLS4; 
        g = (G4 | (~F4 & ~G4 & ~H4)) ^ COMPLS4;
        h = H4 ^ COMPLS4; 
        j = ((S & F4 & G4 & H4) | (F4 & G4 & H4 & K4) | ((F4 ^ G4) & ~H4)) ^ COMPLS4;
    end
    assign data_out = {f,g,h,j};
endmodule
