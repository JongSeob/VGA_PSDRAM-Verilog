`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:07:13 04/10/2015 
// Design Name: 
// Module Name:    vga_test 
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
module vga_test
 (
	input 	clk,
	
	// Standard I/O
   input  [7:0] SideSwitch,
   output reg [7:0] Led,
   input  [3:0] BtnSwitch,
	
	// VGA
	output [3:1] vgaRed,
	output [3:1] vgaGreen,
	output [3:2] vgaBlue,
	output		 Hsync,
	output 		 Vsync,
	
	//7_Segment
	output [3:0] AnodeControl,
   output SegA,
   output SegB,
   output SegC,
   output SegD,
   output SegE,
   output SegF,
   output SegG,
   output Seg_DP,
	
	//PSDRAM
	
	output reg MemOE,
   output reg MemWR,	
   output reg RamCE,   
   output reg RamLB,
   output reg RamUB,
   output reg [23:1] MemAdr,
   inout  [15:0] MemDB,
	
	// UART
	input  RXD,
	output TXD,
	
	// 사용되지 않는 신호들
	output RamCRE,
   output RamADV,
	output RamClk,
	input  RamWait	
    );
	
	wire reset = BtnSwitch[0];
	
	reg BtnSwitch3_reg;  // 버튼3의 상승엣지를 검출하기위해 이전값을 저장
	
	reg PsdramState = 1;	// PSDRAM이 어떤 모듈에의해서 조작되는지를 표시.
								// 0 == vga 모듈
								// 1 == Uart_Data_Save 모듈(Default)
	
	
	always @(posedge clk) // 버튼3의 상승엣지 검출 , PsdramState 변화
	begin
		BtnSwitch3_reg <= BtnSwitch[3];
		
		if( {BtnSwitch3_reg, BtnSwitch[3]} == 2'b01 )
			PsdramState <= ~PsdramState;
	end
		
	
	// 7-Segment
	reg  [15:0] Digit;
	wire [15:0] psdram_Digit;
	wire [15:0] vga_Digit;
			
	//UART -> PSDRAM
	wire [7:0] ReceivedData;
	wire 		  ValidData; // Active High
	
	// ******************* PSDRAM ********************** //
		
	// PSDRAM Signal from psdram module
	wire psdram_MemOE;
	wire psdram_MemWR;
	wire psdram_RamCE;
	wire psdram_RamLB;
	wire psdram_RamUB;
	wire [22:0] psdram_MemAdr;
	reg  [15:0] psdram_MemDataIn;
	wire [15:0] psdram_MemDataOut;
	
	// PSDRAM Signal for vga display
	wire vga_MemOE;
	wire vga_MemWR;
	wire vga_RamCE;
	wire vga_RamLB;
	wire vga_RamUB;
	wire [22:0] vga_MemAdr;
	reg  [15:0] vga_ReceivedData;
	
	
	// ******************* PSDRAM MUX ********************** //
	
	
	//Write
	assign MemDB = (!PsdramState) ? 16'bz :
						(psdram_MemWR == 0) ? psdram_MemDataOut : 16'bz;
						
	//Read
	always @(*) begin
		if(!PsdramState) begin
			vga_ReceivedData = MemDB;			
		end
		else begin
			if(MemWR == 1)
				psdram_MemDataIn = MemDB;
			else
				psdram_MemDataIn = 16'bz;
		end
	end
		
	always @(*) begin
		if(!PsdramState) begin   // PsdramState == 0 이면 vga모듈의 신호가 PSDRAM으로 전달된다.
			MemOE  <= vga_MemOE;
			MemWR  <= vga_MemWR;
			RamCE  <= vga_RamCE;
			RamLB  <= vga_RamLB;
			RamUB  <= vga_RamUB;
			MemAdr <= vga_MemAdr;
			Digit  <= vga_Digit;
			Led	 <= 8'h0F;
		end
		else begin					 // PsdramState == 1 이면 Uart_Data_Save모듈의 신호가 PSDRAM으로 전달된다.
			MemOE  <= psdram_MemOE;
			MemWR  <= psdram_MemWR;
			RamCE  <= psdram_RamCE;
			RamLB  <= psdram_RamLB;
			RamUB  <= psdram_RamUB;
			MemAdr <= psdram_MemAdr;
			Digit  <= psdram_Digit;
			Led 	 <= 8'hF0;
		end		
	end
		
	VGA VGA (
    .clk				(clk), 
    .reset			(reset), 
    .hsync			(Hsync), 
    .vsync			(Vsync), 
	 .vgaRed			(vgaRed), 
    .vgaGreen		(vgaGreen), 
    .vgaBlue		(vgaBlue), 
	 .MemOE			(vga_MemOE),
	 .MemWR			(vga_MemWR),
	 .RamCE			(vga_RamCE),		
	 .RamLB			(vga_RamLB),
	 .RamUB			(vga_RamUB),
	 .MemAdr			(vga_MemAdr),
	 .MemDataIn		(vga_ReceivedData),
    .Digit			(vga_Digit)
    );
	 		
	psdram Uart_Data_Save(
		.clk					(clk),
		.SideSwitch			(SideSwitch),
		.BtnSwitch			(BtnSwitch),
//		.Led					(Led),
		.nMemOE				(psdram_MemOE),
		.nMemWR				(psdram_MemWR),		
		.nRamCE				(psdram_RamCE),
		.nRamLB				(psdram_RamLB),
		.nRamUB				(psdram_RamUB),
		
		.MemAdr				(psdram_MemAdr),		
		.MemDataIn			(psdram_MemDataIn),
		.MemDataOut			(psdram_MemDataOut),				
		.ReceivedData		(ReceivedData),
		.ValidData			(ValidData),
		.Digit				(psdram_Digit),
		
		.RamADV				(RamADV),		
		.RamClk				(RamClk),
		.RamCRE				(RamCRE),
		.RamWait				(RamWait)
	);
	
	uart uart0(
     .CLK					(clk), // The master clock for this module
     .RST					(BtnSwitch[0]), // Synchronous reset.
//	  .LEDS					(Led),
     .RXD					(RXD), // Incoming serial line
     .TXD					(TXD), // Outgoing serial line
     .ValidData			(ValidData), // Indicated that a byte has been received.
     .ReceivedData		(ReceivedData)// Byte received
    );
	
		
	SevenSegment SevenSegment (
    .i_clk					(clk), 
    .i_Digit				(Digit), 
    .i_Seg_DP_Switch		( {4{SideSwitch[7]}} ), 
    .o_ControlLed			(AnodeControl), 
    .o_SegA					(SegA), 
    .o_SegB					(SegB), 
    .o_SegC					(SegC), 
    .o_SegD					(SegD), 
    .o_SegE					(SegE), 
    .o_SegF					(SegF), 
    .o_SegG					(SegG), 
    .o_Seg_DP				(Seg_DP)
    );

endmodule
