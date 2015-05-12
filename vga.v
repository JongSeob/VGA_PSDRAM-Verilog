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
	
	reg read_cycle_flag = 0;
	
	reg [9:0] index; // PSDRAM
	wire clk_25Mhz;
	
	// *****************  counter ************************//
	wire [9:0] hcount;
	wire [9:0] vcount;
	
	// hcount ==  1 ~ 640   에서 색 입력
	// vcount ==  1 ~ 480   	
	wire videoh = (hcount > 0) && (hcount < 641);
	wire videov = (vcount > 0) && (vcount < 481);
	
	wire videoon = videoh & videov;
	
	
	// ****************   FIFO ***************************//
		
   reg  			wr_en;
   reg  			rd_en;
   reg  [15:0] buf_in;
   wire [15:0] buf_out;
   wire 			buf_empty;
   wire 			buf_full;
   wire 			read_available;
	
	// ******************* Define RGB ********************** //
	//FIFO에 미리 저장된 RGB데이터를 읽어와 VGA로 전송한다.
	
	always @(posedge clk_25Mhz) begin
		if(videoon == 1) begin
			if(hcount & 1'b1) // 홀수 픽셀
				{vgaRed, vgaGreen, vgaBlue} <= buf_out[7:0];
			else 					// 짝수 픽셀
				{vgaRed, vgaGreen, vgaBlue} <= buf_out[15:8];
		end
		else begin
			{vgaRed, vgaGreen, vgaBlue} <= 8'h00;			
		end
				
		if( (hcount >= 0 && hcount <= 478) ) begin
			if( (hcount & 1) == 0) // hcount == 0, 2, 4, 6, 8, 10, ........... , 478
				rd_en <= 1;
			else						  // hcount == 1, 3, 5, 7, 9, 11, ........... , 477
				rd_en <= 0;					
		end
		
	end
	
	// ******************* State Machine ********************** //
	// PSDRAM에서 RGB데이터를 읽어와 FIFO에 저장시킨다.

	always @(posedge clk) begin
		state_reg <= state_next;
	end
	
	always @(posedge clk) begin
		MemWR <= 1;
		RamLB <= 0;
		RamUB <= 0;
		
		case(state_reg)
			STATE0 :	begin
							if(hcount == HMAX-1)			 // HMAX = 786
								read_cycle_flag <= 1;	 // HLINES = 640
							else if(index == HLINES-1)
								read_cycle_flag <= 0;
							
							if( (vcount >= 0) && (vcount <= 479) && (read_cycle_flag == 1)) begin
								MemAdr <= (vcount * 640) + index;
								RamCE <= 0;
								MemOE <= 0;
								state_next <= STATE1;
							end
							else begin
								RamCE <= 1;
								index <= 0;
							end
								
							wr_en  <= 0;
							
						end
			STATE1 : begin state_next <= STATE2; end	
			STATE2 : begin	state_next <= STATE3; end
			STATE3 : begin 
							//읽어온 데이터를 FIFO에 저장
							buf_in <= MemDataIn;
							wr_en  <= 1;
							
							MemOE <= 1;
							index <= index + 1;
							state_next <= STATE0;
						end
		endcase
	end
	
	assign Digit = buf_out;
	
	fifo rgb_fifo (
    .clk						(clk), 
	 .half_clk				(clk_25Mhz),
    .rst						(reset), 
    .wr_en					(wr_en), 
    .rd_en					(rd_en), 
    .buf_in					(buf_in), 
    .buf_out				(buf_out), 
    .buf_empty				(buf_empty), 
    .buf_full				(buf_full), 
//    .fifo_counter			(fifo_counter), 
    .read_available		(read_available)
    );
	 
	 Frequency_Divider #(.TARGET_FREQUENCY(25000000)) generateClk25Mhz (
    .Inclk			(clk), 
    .Outclk			(clk_25Mhz)	 	 
    );
		
	sync_generater sync_generater (
    .clk(clk), 
    .reset(reset), 
    .hsync(hsync), 
    .vsync(vsync), 
    .hcount(hcount), 
    .vcount(vcount)
    );	
	 

endmodule 