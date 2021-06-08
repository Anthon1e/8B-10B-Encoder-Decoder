`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2021 11:14:26 AM
// Design Name: 
// Module Name: fcn6b5b
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


module fcn6b5b(
    input clk, 
    input reset,
    input [5:0] data_in,
    input [2:0] P,
    output [4:0] EDCBA
    );
    
    wire a, b, c, d, e, i;
    assign {a, b, c, d, e, i} = data_in;
    wire P13, P22, P31; 
    assign {P13, P22, P31} = P;
    reg A, B, C, D, E;
    
    always @(posedge clk)
    begin
        A = a ^ ((P22 & ~b & ~c & ~(e^i)) |
                (P31 & i)               |
                (P13 & d & e & i)       |
                (P22 & ~a & ~c & ~(e^i))|
                (P13 & ~e)              |
                (a & b & e & i)         |
                (~c & ~d & ~e & ~i));
        B = b ^ (((a & b & e & i) | ~(c | d | e | i) | (P31 & i))
              ^ ((P22 & a & c & ~(e ^ i)) | (P13 & ~e))
              ^ ((P22 & b & c & ~(e ^ i)) | (P13 & d & e & i)));
        C = c ^ (((P31 & i) | (P22 & b & c & ~(e ^ i)) | (P13 & d & e & i))
              | ((P22 & ~a & ~c & ~(e ^ i)) | (P13 & ~e))
              | ((P13 & ~e) | ~(c | d | e | i) | ~(a | b | e | i)));
        D = d ^ (((a & b & e & i) | ~(c | d | e | i) | (P31 & i))
              ^ ((P22 & a & c & ~(e ^ i)) | (P13 & ~e))
              ^ ((P13 & d & e & i) | (P22 & ~b & ~c & ~(e ^ i))));
        E = e ^ (((P22 & ~a & ~c & ~(e ^ i)) | (P13 & ~i))
              ^ ((P13 & ~e) | ~(c | d | e | i) | ~(a | b | e | i))
              ^ ((P13 & d & e & i) | (P22 & ~b & ~c & ~(e ^ i))));
    end
                 
    assign EDCBA = {E, D, C, B, A};
endmodule
