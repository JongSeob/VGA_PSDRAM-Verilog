`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:04:52 04/15/2015 
// Design Name: 
// Module Name:    sync_generater 
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
module sync_generater(
	input clk,
	input reset,
	output reg hsync,
	output reg vsync,
	output reg [9:0] hcount,
	output reg [9:0] vcount
    );
	 
	parameter HMAX   = 786,
				 VMAX   = 521,
				 HLINES = 640,
				 HFP	  = 649,
				 HSP	  = 744,
				 VLINES = 480,
				 VFP	  = 483,
				 VSP	  = 484;
				 
	wire clk_25Mhz;
		
	// h_Ts번 카운트.
	always @(posedge clk_25Mhz or posedge reset)
	begin
		if(reset)
			hcount <= 0;
		else
			if(hcount == HMAX-1)
				hcount <= 0;
			else
				hcount <= hcount + 1;
	end
	
	// v_Ts번 카운트.
	// h영역이 1cycle 끝날 때마다 카운트
	always @(posedge clk_25Mhz or posedge reset)
	begin
		if(reset)
			vcount <= 0;
		else
			if(hcount == HMAX-1)
			begin
				if(vcount == VMAX-1)
					vcount <=0;
				else
					vcount <= vcount + 1;
			end
	end
	
	// hsync, vsync pulse width 동작
	always @(posedge clk_25Mhz)
	begin
		if( (hcount > HFP-1) && (hcount <= HSP-1) )
			hsync <= 0;
		else
			hsync <= 1;
			
		if( (vcount > VFP-1) && (vcount <= VSP-1) )
			vsync <= 0;
		else
			vsync <= 1;
	end
	
	
	Frequency_Divider #(.TARGET_FREQUENCY(25000000)) generateClk25Mhz (
    .Inclk			(clk), 
    .Outclk			(clk_25Mhz)	 	 
    );
	 
endmodule
