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
    integer i;
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
        err = 0;
        #2; 
        
        reset = 1; 
        #2; 
        
        for (i = 0; i < 1024; i = i + 1) begin
            /* Reset stage */
            if (reset == 1) begin
                in = 0; 
                reset = 0;
                invalid_count = 0;
                valid_count = 0;
                #2; 
            /* Begin with all 268 cases */ 
            end else begin
                if (code_err == 1) begin 
                    invalid_count <= invalid_count + 1; 
                    $display("Invalid %d", in); end
                if (code_err == 0) valid_count <= valid_count + 1;
                
                in = in + 1;
                #2;
            end
        end
        
        if (code_err == 1)  invalid_count = invalid_count + 1; 
        if (code_err == 0)  valid_count = valid_count + 1;
        #2;
        if (~err) $display("INTERFACE OK");
        $stop; 
    end
endmodule
