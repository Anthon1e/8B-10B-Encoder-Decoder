`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2021 03:47:10 PM
// Design Name: 
// Module Name: disCtrl
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


module disCtrl(
    input clk, 
    input reset,
    input [9:0] data_in,
    input rd_in,
    input [2:0] P,
    output [3:0] D,
    output reg rd_out,
    output reg rd_error
    );
    
    wire a, b, c, d, e, i, f, g, h, j;
    assign {a, b, c, d, e, i, f, g, h, j} = data_in;
    wire P13, P22, P31;
    assign {P13, P22, P31} = P;
    
    /* Disparity check for 6B/5B */
    // If either PD1S6 or ND1S6 is set, then RD6 is changed 
    wire PD1S6, ND0S6, ND1S6, PD0S6, RD6;
    assign PD1S6 = (P22 & ~e & ~i) | (P13 & ~i) | (P13 & d & e & i) | (P13 & ~e);
    assign ND1S6 = (P22 & e & i) | (P31 & i) | (P31 & ~d & ~e & ~i) | (P31 & e);
    assign PD0S6 = (P22 & e & i) | (P31 & i) | (P31 & e);
    assign ND0S6 = (P22 & ~e & ~i) | (P13 & ~i) | (P13 & ~e);
    assign RD6 = (PD0S6 | ND0S6);  
    /* Disparity check for 4B/3B */  
    // If either PD1S5 or ND1S4 is set, then RD4 is changed
    wire ND1S4, ND0S4, PD1S4, PD0S4, RD4, rd_in_s4;
    assign rd_in_s4 = RD6 ^ rd_in; 
    assign PD1S4 = (~f & ~h & ~j) | (~f & ~g & h & j) | (~f & ~g & ~j) |
                   (~f & ~g & ~h) | (~g & ~h & ~j) ;
    assign ND1S4 = (f & h & j) | (f & g & ~h & ~j) | (f & g & j) | 
                   (f & g & h) | (g & h & j) ;
    assign PD0S4 = (f & h & j) | (f & g & j) | (f & g & h) | (g & h & j);
    assign ND0S4 = (~f & ~h & ~j) |  (~f & ~g & ~j) | 
                   (~f & ~g & ~h) | (~g & ~h & ~j) ;
    assign RD4 = (PD0S4 | ND0S4);
    /* Disparity checking for error */
    always @(posedge clk) 
    begin
        if (reset) rd_error = 0;
        else
        rd_error <= (rd_in & PD0S6)       |   // rd_in is +, but dis of 6B/5B is +2
                    (~rd_in & ND0S6)      |   // rd_in is -, but dis of 6B/5B is -2
                    (rd_in_s4 & PD0S4)    |   // rd_in_s4 is +, but dis of 4B/3B is +2
                    (~rd_in_s4 & ND0S4)   ;   // rd_in_s4 is -, but dis of 4B/3B is -2   
    end
    /* Running disparity of the end */
    wire rd_cur;
    assign rd_cur = RD6 ^ RD4;          // Running disparity of current input
    always @(posedge clk) 
    begin
        if (reset) rd_out = 0;
        else rd_out <= rd_cur ^ rd_in;  // Use running disparity of current input to determine if we
                                        //  need to change entry running disparity of the next input.
    end
    assign D = {PD0S6, ND0S6, PD0S4, ND0S4};
endmodule
