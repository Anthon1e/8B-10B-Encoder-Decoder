`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2021 02:33:50 PM
// Design Name: 
// Module Name: Enc8B10B_tb
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


module Enc8B10B_tb();
    reg clock, reset, K;
    reg [7:0] in;
    wire [9:0] out;
    reg err;
    
    Enc8B10B DUT (clock, reset, K, in, out);
    
    initial begin
        // Set up for the rise of clock every 2 seconds
        clock = 1'b0;
        #1;
        forever begin
            clock = 1'b1;
            #1;
            clock = 1'b0;
            #1;
        end
    end
    
    initial begin 
        err = 0; 
        reset = 1;
        in = 9'b100_00011;
        K = 0;
        #8;
        
        reset = 0;
        #2;
        
        in = 9'b000_11111;     
        #2;
        
        in = 9'b010_00011;
        #6;
        
        if (~err) $display("INTERFACE OK");
        $stop;    
    end    
endmodule

