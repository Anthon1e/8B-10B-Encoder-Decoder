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
    input reset,
    input [5:0] L,
    input [4:0] data_buffer,
    input D, 
    input E,
    input rd_in,
    output reg rd_in_s4,
    output reg COMPLS6,
    output reg COMPLS4,
    output reg rd_out
    );
    wire L40, L31, L22, L13, L04, K, K4, F4, G4, H4, S;
    assign {S, K4, H4, G4, F4} = data_buffer;
    assign {L40, L31, L22, L13, L04, K} = L;
    /* Disparity clarificat ion:-
        P,N,S stands for Positive, Negative, Sender
        D1 stands for D-1 (entry running disparity)
        D0 stands for D0  (current running disparity) */
    /* Disparity classification for 5B/6B */
    // If either PD1S6 or ND1S6 is set, then RD6 is changed 
    wire PD1S6, ND0S6, ND1S6, PD0S6, RD6;
    assign PD1S6 = (L13 & D & E) ^ (~L22 & ~L31 & ~E);
    assign ND0S6 = PD1S6;
    assign ND1S6 = (L31 & ~D & ~E) | (E & ~L22 & ~L13) | K;
    assign PD0S6 = (E & ~L22 & ~L13) | K;
    assign RD6 = (PD0S6 | ND0S6);  
    /* Disparity classification for 3B/4B */  
    // If either PD1S5 or ND1S4 is set, then RD4 is changed
    wire ND1S4, ND0S4, PD1S4, PD0S4, RD4; 
    assign ND1S4 = F4 & G4; 
    assign ND0S4 = ~F4 & ~G4; 
    assign PD1S4 = ND0S4 | ((F4^G4) & K4);
    assign PD0S4 = F4 & G4 & H4;
    assign RD4 = (PD0S4 | ND0S4);
    // Assign rd_out for the next input
    reg rd_cur;
    always @(*)
    begin 
        rd_cur = RD6 ^ RD4;         // Running disparity of current input
        rd_out = rd_cur ^ rd_in;    // Use running disparity of current input to determine if we
                                    //  need to change entry running disparity of the next input.
    end
    /* Control of complementation:
        The complement is set if rd_in's sign does not 
        matched with D1S6 and D1S4 sign                 */
    // Disparity of D0S6 is based on the entry running disparity
    // Complement is set when PD1S6 is 1 (expect positive), but rd_in is 0(-) 
    //                     OR ND1S6 is 1 (expect negative), but rd_in is 1(+)
    always @(*)
    begin 
        COMPLS6 <= (PD1S6 & ~rd_in) | (ND1S6 & rd_in);
    end
    // PD1S4 is same, but here, the entry disparity 
    //  will be the out disparity of fcn 5B 
    // Complement is set when PD1S4 is 1 (expect positive), but rd_in is 0(-)
    //                     OR ND1S4 is 1 (expect negative), but rd_in is 1(+)
    always @(*)
    begin
        rd_in_s4 = RD6 ^ rd_in;
        COMPLS4 = ((PD1S4 & ~rd_in_s4) | (ND1S4 & rd_in_s4));
    end
endmodule
