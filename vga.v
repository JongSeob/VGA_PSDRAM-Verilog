`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:00:18 11/03/2014 
// Design Name: 
// Module Name:    VGA 
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
module VGA
#(		
	parameter STATE0 = 4'b0000,
	parameter STATE1 = 4'b0001,
	parameter STATE2 = 4'b0010,
	parameter STATE3 = 4'b0011,
	parameter STATE4 = 4'b0100,
	
	parameter HMAX   = 786,
	parameter VMAX   = 521,
	parameter HLINES = 640,
	parameter VLINES = 480
 )
(
	input clk, 
	input reset, 
	
	output reg [2:0] vgaRed, 
	output reg [2:0] vgaGreen, 
	output reg [1:0] vgaBlue, 
	
	output hsync, 
	output vsync, 
		
	output reg MemOE,
	output reg MemWR,
	output reg RamCE,
	output reg RamLB,
	output reg RamUB,
	output reg [22:0] MemAdr,
	input  [15:0] MemDataIn,
	
	output [15:0] Digit	
	);
	
	reg [3:0] state_reg  = STATE0;
	reg [3:0] state_next = STATE0;
	
	wire clk_25Mhz;
	
	// ****************** Register Array **********************//
	
	reg [7:0] rgb_cur[639:0];  // Pallete의 index로 이용된다.
	reg [7:0] rgb_next[639:0];
	
	reg [9:0] rd_ptr = 0;
	reg [9:0] wr_ptr = 0;
	
	wire [7:0] rgb_pallete;
	
	reg write_complete = 0;
	
	// *****************  counter ************************//
	wire [9:0] hcount;
	wire [9:0] vcount;
	
	// hcount ==  1 ~ 640   에서 색 입력
	// vcount ==  1 ~ 480   	
	wire videoh = (hcount > 0) && (hcount < 641);
	wire videov = (vcount > 0) && (vcount < 481);
	
	wire videoon = videoh & videov;
	
	
	// ******************* Define RGB ********************** //
	//FIFO에 미리 저장된 RGB데이터를 읽어와 VGA로 전송한다.
	
	always @(posedge clk_25Mhz) begin
		if(videoon == 1) begin
			{vgaRed, vgaGreen, vgaBlue} <= rgb_pallete;
			//{vgaRed, vgaGreen, vgaBlue} <= rgb_cur[rd_ptr];
			rd_ptr <= rd_ptr + 1;
		end
		else begin
			{vgaRed, vgaGreen, vgaBlue} <= 8'h00;
			rd_ptr <= 0;			
		end			
		
	end
	
	// ******************* State Machine ********************** //
	// PSDRAM에서 RGB데이터를 읽어와 FIFO에 저장시킨다.

	always @(posedge clk, posedge reset) begin
		if(reset == 1)
			state_reg <= STATE0;
		else
			state_reg <= state_next;
	end
	
	always @(posedge clk) begin
		MemWR <= 1;
		RamLB <= 0;
		RamUB <= 0;
		
		case(state_reg)
			STATE0 :	begin
							if(hcount <= HMAX-1)
								write_complete <= 0;
			
							if( (vcount >= 0) && (vcount <= 479) && (write_complete == 0)) begin
								MemAdr <= (vcount * 640) + wr_ptr;
								RamCE <= 0;
								MemOE <= 0;
								state_next <= STATE1;
							end
							else begin
								MemOE <= 1;
								RamCE <= 1;
								state_next <= STATE0;
							end								
							
						end
			STATE1 : begin state_next <= STATE2; end	
			STATE2 : begin	state_next <= STATE3; end
			STATE3 : begin 
								rgb_next[wr_ptr*2]     <= MemDataIn[7:0];
								rgb_next[(wr_ptr*2)+1] <= MemDataIn[15:8];
								
								if(wr_ptr == 319) begin
									wr_ptr <= 0;
									write_complete <= 1;
								end
								else
									wr_ptr <= wr_ptr + 1;
							
								MemOE <= 1;
								RamCE <= 1;
								state_next <= STATE0;
						end
		endcase
	end
	
	integer i;
	
	always @(posedge clk) begin
		if(hcount == HMAX-1) begin
			for(i=0; i < 639; i = i+1) begin
				rgb_cur[i] = rgb_next[i];		
			end
		end			
	end
	
	 Frequency_Divider #(.TARGET_FREQUENCY(25000000)) generateClk25Mhz (
		 .Inclk			(clk), 
		 .Outclk			(clk_25Mhz)	 	 
    );
		
	sync_generater sync_generater (
		 .clk			(clk), 
		 .reset		(reset), 
		 .hsync		(hsync), 
		 .vsync		(vsync), 
		 .hcount		(hcount), 
		 .vcount		(vcount)
    );	
	
	Palette Palette_256color (
		 .index		(rgb_cur[rd_ptr]), 
		 .rgb			(rgb)
    );

endmodule 