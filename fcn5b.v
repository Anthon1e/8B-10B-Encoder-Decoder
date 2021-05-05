`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2021 11:00:55 AM
// Design Name: 
// Module Name: fcn5b
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 5B/6B classification or the L function 
//              Figure 3 in Encoder diagram
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fcn5b(
    input clk, 
    input K,
    input [4:0] data_in,
    output [5:0] L
	);
	// A is the lowest order bit
	wire A,B,C,D,E;
	assign {E,D,C,B,A} = data_in;
	
	// Bit encoding for 5B/6B Classifications
	// It counts the number of 1s and 0s in ABCD
	// L40 means Four 1s and No 0s 
	wire L40, L31, L22, L13, L04; 
	assign L40 = A & B & C & D;								// A=B=C=D=1
	assign L04 = ~A & ~B & ~C & ~D; 						// A=B=C=D=0 
	assign L13 = ((A^B) & ~C & ~D) || (~A & ~B & (C^D)); 	// A and B diff, C=D=0 OR A=B=0, C and D diff
	assign L31 = ((A^B) & C & D) || (A & B & (C^D));		// A and B diff, C=D=1 OR A=B=1, C and D diff
	assign L22 = A & B & ~C & ~D ||
				 ~A & ~B & C & D ||							// A=B=1,C=D=0 OR A=B=0,C=D=1		
				 (A^B) & (C^D); 							// A and B diff, C and D diff, so 2 1s and 2 0s 
	assign L = {L40, L31, L22, L13, L04, K}; 
endmodule
