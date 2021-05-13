`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2021 02:16:57 PM
// Design Name: 
// Module Name: Dec8B10B_tb
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


module Dec8B10B_tb();
    reg clock, reset;
    reg [9:0] in;
    wire [7:0] out;
    wire rdispout, disp_err, code_err, k_out;

    // Useful for error checking
    reg err;
    
    Dec8B10B DUT (clock, reset, in, rdispout, disp_err, code_err, k_out, out);
    
    initial begin
        // Set up for the rise of clock every 2 seconds
        clock = 1'b1;
        #1;
        forever begin
            clock = 1'b0;
            #1;
            clock = 1'b1;
            #1;
        end
    end
    
    initial begin 
        err = 0;
        #2; 
        
        reset = 1;
        in = 10'b011000_1010; 
        #5; 
        
        reset = 0; 
        #2; 
        
        in = 10'b100101_1011;
        #2; 
        if (out !== 8'b10100000) begin 
            $display("ASSERTION FAILED: Case 1, Expected: 10100000, Got: %b", out); 
            err = 1; 
        end
        
        in = 10'b001100_1011;
        #2; 
        if (out !== 8'b00001001) begin 
            $display("ASSERTION FAILED: Case 2, Expected: 00001001, Got: %b", out); 
            err = 1; 
        end
        
        in = 10'b100100_1001;
        #2; 
        if (out !== 8'b00011000) begin 
            $display("ASSERTION FAILED: Case 3, Expected: 00011000, Got: %b", out); 
            err = 1; 
        end     
        
        in = 10'b000011_1001;
        #2; 
        if (out !== 8'b00110000) begin 
            $display("ASSERTION FAILED: Case 4, Expected: 00110000, Got: %b", out); 
            err = 1; 
        end
        
        in = 10'b110000_1101;
        #4;
        
        if (~err) $display("INTERFACE OK");
        $stop; 
    end
endmodule
