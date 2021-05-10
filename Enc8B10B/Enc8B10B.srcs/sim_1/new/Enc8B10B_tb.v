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
    wire rd_out;

    // Store expected output from text file
    reg [9:0] memory [803:0];
    reg change_rd [267:0]; 
    reg [9:0] neg_rd_val [267:0];
    reg [9:0] pos_rd_val [267:0]; 
    // Useful for error checking
    reg [9:0] ex_out; 
    integer i;
    reg side;
    reg err;
    
    Enc8B10B DUT (clock, reset, K, in, out, rd_out);
    
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
        $readmemb("Enc8B10B_tb.txt", memory);
        for (i = 0; i < 268; i = i + 1) begin
            neg_rd_val[i] = memory[i*3];
            pos_rd_val[i] = memory[i*3+1];
            change_rd[i] = memory[i*3+2];
        end
        err = 0; 
        #2;
        
        reset = 1;
        #2; 
        
        for (i = 0; i < 269; i = i + 1) begin
            /* Reset stage */
            if (reset == 1) begin
                in = 0; 
                K = 0;
                reset = 0;
                #2; 
            /* Begin with all 256 cases */ 
            end else begin
                /* Normal characters check */
                if (i < 256)        in = in + 1;
                /* Special character check */       
                else if (i < 264) 
                begin
                    if (i == 256) begin
                        in = 8'b000_11100;
                        K = 1;    end
                    else            in[7:5] = in[7:5] + 1; 
                end
                else if (i == 264)  in = 8'b111_10111;
                else if (i == 265)  in = 8'b111_11011;
                else if (i == 266)  in = 8'b111_11101;
                else if (i == 267)  in = 8'b111_11110;
                
                #2;
                /* For vector expected output file: check disparity to decide whether to pick RD- or RD+ */
                // We are looking at i-1 for rd_val since there is 1 cycle delay until the results come out
                // We are looking at i-2 for change_rd since it depends on previous values
                if (i == 1) begin                   // First case, take RD-
                    ex_out = neg_rd_val[i-1];   
                    side = 0;                                   end
                if (change_rd[i-2] == 1) begin      // If current RD is #, then take value from the other RD
                    if (side == 0) begin
                        ex_out = pos_rd_val[i-1];
                        side = 1;                               end
                    else begin
                        ex_out = neg_rd_val[i-1];      
                        side = 0;                           end end
                if (change_rd[i-2] == 0) begin      // If current RD is =, then take value from same RD
                    if (side == 1)  ex_out = pos_rd_val[i-1];
                    else            ex_out = neg_rd_val[i-1];   end
                
                /* Check errors */ 
                if (out !== ex_out) begin 
                    $display("ASSERTION FAILED: Case %d, Expected: %b, Got: %b", i-1, ex_out, out); 
                    err = 1; 
                end
                else $display("Case %d is Correct, Output is %b", i-1, out);
               
            end
        end
        
        if (~err) $display("INTERFACE OK");
        $stop;    
    end    
endmodule

