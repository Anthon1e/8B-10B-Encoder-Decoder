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
    
    // Store valid input from text file
    reg [9:0] memory [803:0];
    reg [9:0] value_in [535:0];
    // Useful for error checking
    integer i, j, check;
    integer valid_count;
    integer invalid_count;
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
        // This file stores all valid input to the decoder
        $readmemb("Dec8B10B_tb.txt", memory);
        // Variable initialization 
        j = 0;
        check = 0;
        for (i = 0; i < 268; i = i + 1) begin
            value_in[j] = memory[i*3];
            value_in[j+1] = memory[i*3 + 1];
            j = j + 2;
        end
        err = 0;
        /* Wait time for FPGA configuration */
        #120; 
        
        /* Begin the reset stage */
        reset = 1; 
        #2; 
        
        /* Give the decoder 2^10 inputs, from 0 to 1023 */
        for (i = 0; i < 1024; i = i + 1) begin
            /* Reset stage */
            if (reset == 1) begin
                in = 0; 
                reset = 0;
                #4;
                invalid_count = 0;
                valid_count = 0; 
            /* Begin with all 268 cases */ 
            end else begin  
                /* If the input is raised as invalid, check with the file if it actually should be */
                if (code_err == 1) begin 
                    invalid_count = invalid_count + 1;     // Count number of invalid inputs
                    for (j = 0; j < 536; j = j + 1) begin
                        if ((in - 2) == value_in[j]) check = 1;
                    end
                    if (check == 32'b1) err = 1;
                    check = 0;
                end
                /* If the input is valid, check with the file if it actually should be */
                if (code_err == 0) begin 
                    valid_count = valid_count + 1;         // Count number of valid inputs
                    for (j = 0; j < 536; j = j + 1) begin
                        if ((in - 2) == value_in[j]) check = 1;
                    end
                    if (check == 32'b0) err = 1;
                    check = 0;
                end
                
                /* Increment the input after each clock cycle */
                in = in + 1;
                #2;
            end
        end
        
        /* Second last check for the second last input, this is because there is a 2 cycle delay */
        if (code_err == 1)  invalid_count = invalid_count + 1; 
        if (code_err == 0)  valid_count = valid_count + 1;
        in = 10'bxxxxxxxxxx;
        #2;
        /* Final check for the last input, this is because there is a 2 cycle delay */
        if (code_err == 1)  invalid_count = invalid_count + 1; 
        if (code_err == 0)  valid_count = valid_count + 1;
        
        /* If no error, code is working */
        if (~err) $display("INTERFACE OK");
        $stop; 
    end
endmodule
