`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:27:25 11/17/2014 
// Design Name: 
// Module Name:    Freq_Divider 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Freq_Divider(mclk, clk_25Mhz);
	input mclk;
	output reg clk_25Mhz = 0;	//For VGA
		
	always @(posedge mclk)
	begin
		clk_25Mhz <= ~clk_25Mhz;
	end
	
endmodule
