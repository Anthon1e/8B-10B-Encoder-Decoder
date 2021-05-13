`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/12/2021 11:01:16 AM
// Design Name: 
// Module Name: Dec8B10B
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


module Dec8B10B(
    input BYTECLK, 
    input reset,
    input [9:0] in,
    output reg rdispout,
    output reg disp_err,
    output reg code_err,
    output reg k_out,
    output reg [7:0] out
    );
    
    // Variable to hold values 
    wire clk = BYTECLK; 
    wire [4:0] EDCBA;
    wire [3:0] KHGF;
    wire [2:0] P;
    wire rd_out, rd_error, in_error;
    
    reg [9:0] data_in;
    reg rd_in;
    
    fcn6b   f6b(clk, reset, data_in[9:4], P);
    fcn6b5b f65(clk, reset, data_in[9:4], P, EDCBA);
    fcn4b3b f43(clk, reset, data_in[7:0], P, KHGF);
    disCtrl dis(clk, reset, data_in, rd_in, P, rd_out, rd_error);
    inCheck err(clk, reset, data_in, P, in_error); 
    
    always @(posedge clk)
    begin
        if (reset) begin 
            data_in = 0;
            rd_in = 0;
        end else begin
            rd_in = rd_out; 
            data_in = in;
        end
    end
    
    always @(posedge clk)
    begin
        if (reset) begin 
            out = 8'b0;
            k_out = 0;
            disp_err = 0;
            code_err = 0;
            rdispout = 0;
        end else begin 
            out = {KHGF[2:0], EDCBA};
            k_out = KHGF[3];
            rdispout = rd_out;
            // If there is error from input, set 1 to code_err, ignore the result
            if (in_error)   code_err = 1;
            else            code_err = 0;
            // If there is disparity error, set 1 to disp_err, still give out result
            if (rd_error)   disp_err = 1;
            else            disp_err = 0;
        end
    end
endmodule
