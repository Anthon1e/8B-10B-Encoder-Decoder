`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2021 11:24:15 AM
// Design Name: 
// Module Name: fcn6b
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


module fcn6b(
    input clk, 
    input reset,
    input [5:0] data_in,
    output [2:0] P
    );
    
    wire a, b, c, d, e, i, P13, P22, P31;
    assign {a, b, c, d, e, i} = data_in;
    
    assign P13 = ((a^b) & ~c & ~d) | 
                 (~a & ~b & (c^d)) ;                // a and b diff, c=d=0 OR a=b=0, c and d diff
    assign P31 = ((a^b) & c & d) | (a & b & (c^d)); // a and b diff, c=d=1 OR a=b=1, c and d diff 
    assign P22 = (a & b & ~c & ~d) |
                 (c & d & ~a & ~b) |                  // a=b=1, c=d=0 OR a=b=0, c=d=1
                 ((a^b) & (c^d)) ;                    // a,b diff, c,d diff, so 2 1s and 2 0s         
     assign P = {P13, P22, P31};
endmodule
