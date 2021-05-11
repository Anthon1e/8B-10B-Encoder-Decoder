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
    input reset,
    input [2:0] data_in,
    input S,
    input K,
    input COMPLS4,
    output [3:0] data_out
    );
    wire H, G, F;
    assign {H, G, F} = data_in;
    reg f, g, h, j;
    /* Transformation of 3 input bits FGH into the 4 fghj */
    always @(posedge clk)
    begin
        if (reset) begin 
            f <= 0;
            g <= 0;
            h <= 0;
            j <= 0;
        end else begin 
            f <= (F & ~((S & F & G & H) ^ (K & F & G & H))) ^ COMPLS4; 
            g <= (G | (~F & ~G & ~H)) ^ COMPLS4;
            h <= H ^ COMPLS4; 
            j <= (( (S & F & G & H) ^ (F & G & H & K) ) | ((F ^ G) & ~H)) ^ COMPLS4;
        end
    end
    assign data_out = {f, g, h, j};
endmodule
