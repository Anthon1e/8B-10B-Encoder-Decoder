`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2021 09:32:19 AM
// Design Name: 
// Module Name: inCheck
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


module inCheck(
    input clk, 
    input reset,
    input [9:0] data_in,
    input [2:0] P,
    input [3:0] D,
    output in_error
    );
    
    wire a, b, c, d, e, i, f, g, h, j;
    assign {a, b, c, d, e, i, f, g, h, j} = data_in;
    wire P13, P22, P31, PD0S6, ND0S6, PD0S4, ND0S4; 
    assign {P13, P22, P31} = P;
    assign {PD0S6, ND0S6, PD0S4, ND0S4} = D;
    
    // All invalid input cases
    reg case1, case2, case3, case4, case5, case6, case7, case8, case9; 
    always @(posedge clk) 
    begin
        // These cover all +6, +4 disparity cases in 6B/5B
        case1 = (a & b & c & d) | (~a & ~b & ~c & ~d) | (P13 & ~e & ~i) | (P31 & e & i);
        // These cover all +4 disparity cases in 4B/3B
        case2 = (f & g & h & j) | (~f & ~g & ~h & ~j);
        // These cover all cases of run-length 6 (D.7)
        case3 = (a & b & c & ~d & ~e & ~i & ND0S4) | (~a & ~b & ~c & d & e & i & PD0S4);
        // These cover all cases of run-length 6 (D.x.3)
        case4 = (f & g & ~h & ~j & PD0S6) | (~f & ~g & h & j & ND0S6);
        // These cover all cases of run-length 5
        case5 = (e & i & f & g & h) | (~e & ~i & ~f & ~g & ~h) | 
                (d & e & i & f & g) | (~d & ~e & ~i & ~f & ~g) ;
        // These cover all anti-case of run-length 5
        case6 = (i & ~e & ~g & ~h & ~j) | (~i & e & g & h & j);
        // These are the 2 samples that are not covered by equations
        case7 = (~a & ~b & c & d & e & i & ~f & ~g & ~h & j) |
                (a & b & ~c & ~d & ~e & ~i & f & g & h & ~j) ;
        // Do not know why but it is what it is 
        case8 = ((e & i & ~g & ~h & ~j) & ((c ^ d) | (d ^ e))) |
                ((~e & ~i & g & h & j) & ((c ^ d) | (d ^ e))) |
                (~P31 & e & ~i & ~g & ~h & ~j) | (~P13 & ~e & i & g & h & j) ;
        // These cover all cases +4 or -4 total disparity
        case9 = (PD0S6 & PD0S4) | (ND0S6 & ND0S4) ;
    end
    
    assign in_error = case1 | case2 | case3 | case4 | case5 
                    | case6 | case7 | case8 | case9;
endmodule   
