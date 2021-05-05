`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2021 11:13:03 AM
// Design Name: 
// Module Name: disCtrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Disparity classifications and control of complementation 
//              Figure 5 and 6 in Encoder diagram
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module disCtrl(
    input clk,
    input [4:0] L,
    input S,
    input D, // down-level from Figure 7
    input E,
    output COMPLS6,
    output COMPLS4
    );
    wire L40, L31, L22, L13, L04, K, F, G, H;
    assign {H, G, F} = S;
    assign {L40, L31, L22, L13, L04, K} = L;
    /* Disparity clarificat ion:-
        P,N,S stands for Positive, Negative, Sender
        D1 stands for D-1 (entry running disparity)
        D0 stands for D0  (current running disparity) */
    /* Disparity classification for 5B/6B */
    wire PD1S6, ND0S6, ND1S6, PD0S6;
    assign PD1S6 = (L13 & D & E) || (L22 & L31 & E);
    assign ND0S6 = PD1S6;
    assign ND1S6 = (~L31 & D & E) || (~E & L22 & L13) || K;
    assign PD0S6 = (~E & L22 & L13) || K;
    /* Disparity classification for 3B/4B */  
    wire ND1S4, ND0S4, PD1S4, PD0S4; 
    assign ND1S4 = F & G; 
    assign ND0S4 = ~F & ~G; 
    assign PD1S4 = ND0S4 || ((F^G) & K);
    assign PD0S4 = F & G & H;
    /* Control of complementation:
        NEED MORE CLARIFICATION ON THIS
    */
    wire PDL6, PDL4;
    reg PDL6_upd, PDL4_upd; 
    /* Upper flip-flop for running disparity of bit i */
    assign PDL6 = (~PD0S6 & COMPLS6) || 
                  (COMPLS6 & ND0S6)  || 
                  (ND0S6 & PD0S6 & ~PDL4_upd);  // Current running disparity for bit i
    always @(negedge clk)
    begin
        PDL6_upd <= PDL6; 
    end
    assign COMPLS4 = (ND1S4 & PDL6_upd) ||      // Compare with D-1 entry disparity
                     (~PDL6_upd & PD1S4);       // to determine the complement for 4B
    /* Lower flip-flop for running disparity of bit j */
    assign PDL4 = (COMPLS4 & ~PD0S4) ||
                  (ND0S4 & COMPLS4)  ||
                  (PDL6_upd & PD0S4 & ND0S4);   // Current running disparity for bit j
    always @(negedge clk)
    begin 
        PDL4_upd <= PDL4; 
    end 
    assign COMPLS6 = (ND1S6 & PDL4_upd) ||      // Compare with D-1 entry disparity
                     (~PDL4_upd & PD1S6);       // to determine the complement for 6B
endmodule
