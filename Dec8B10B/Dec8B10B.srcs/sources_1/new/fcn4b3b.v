`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2021 11:14:26 AM
// Design Name: 
// Module Name: fcn4b3b
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fcn4b3b(
    input clk, 
    input reset,
    input [7:0] data_in,
    input [2:0] P,
    output [3:0] KHGF
    );
    
    wire c, d, e, i, f, g, h, j;
    assign {c, d, e, i, f, g, h, j} = data_in;
    wire P13, P22, P31; 
    assign {P13, P22, P31} = P;
    reg K, F, G, H;
    
    always @(posedge clk)
    begin
        F = f ^ (((g & h & j) | (f & h & j) | ((h ^ j) & ~(c | d | e | i)))
              ^ ((f & g & j) | ~(f | g | h) | (~f & ~g & h & j)));
        G = g ^ (((f & g & j) | ~(f | g | h) | (~f & ~g & h & j))
              ^ ((~f & ~h & ~j) | ((h ^ j) & ~(c | d | e | i)) | (~g & ~h & ~j)));
        H = h ^ (((f & g & j) | ~(f | g | h) | (~f & ~g & h & j))
              ^ ((~g & ~h & ~j) | (f & h & j) | ((h ^ j) & ~(c | d | e | i))));
        K = ((c & d & e & i) | (~c & ~d & ~e & ~i)) ^
            (~e & i & g & h & j & P13) ^ (e & ~i & ~g & ~h & ~j & P31);  
    end
    
    assign KHGF = {K, H, G, F};
endmodule
