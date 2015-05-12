`timescale 1ns / 1ps


module psdram #(
	parameter TRUE  = 1,
	parameter FALSE = 0,
	
	parameter MAX_SIZE = 23'h400000,
	
	parameter STANDBY = 3'b000,
	parameter UART_WRITE = 3'b001,
	parameter CHECK_DATA = 3'b010,
	parameter MEMORY_CLEAR = 3'b011,

	parameter STATE0 = 4'b0000,
	parameter STATE1 = 4'b0001,
	parameter STATE2 = 4'b0010,
	parameter STATE3 = 4'b0011,
	parameter STATE4 = 4'b0100,
	parameter STATE5 = 4'b0101,
	parameter STATE6 = 4'b0110,
	parameter STATE7 = 4'b0111
)
(
	input	       clk,				// 50 MHz input
	input  [7:0] SideSwitch,
	input  [3:0] BtnSwitch,
	output [7:0] Led,
	
	// PSDRAM
	output reg nRamCE,			// chip enable
	output reg nMemOE,			// output enable
	output reg nMemWR,			// write enable
	output reg nRamLB, 			// lower byte
	output reg nRamUB, 			// upper byte
	output reg [23:1] MemAdr,
	input  	  [15:0] MemDataIn,
	output 	  [15:0] MemDataOut,	
	
	// UART로부터 받은 데이터
	input 		  ValidData,		// RS232로 데이터가 들어왔음을 알림. Active High
	input  [7:0]  ReceivedData,	// 들어온 데이터
	
	// 7-Segment
	output reg [15:0] Digit,
	
	// 사용하지 않는 신호
	output	 	  RamADV,			// Address valid, active Low	
	output	     RamClk,			// clock
	output	  	  RamCRE,			// Control Register Enable	
	input			  RamWait			// wait. Disregard this signal in async/page mode
   );
	
	// ********** READ/WRITE 동작을 위한 선언 *********//
	
	reg   [2:0]  Transaction;
	reg	[3:0]  NextPhase, CurrentPhase; // 현재, 다음 상태		
	
	reg	[15:0] DataLatch; // PSDRAM에서 읽고 쓰는 데이터를 임시저장.
	
	// UART WRITE
	reg   		 DataWriteComplete; // 쓰기동작이 완료되면 1로 설정된다.
	reg   [23:0] UsedAdrCnt;		  // 사용된 Adr의 수. 다음에 데이터가 저장될 주소.
	reg 	[1:0]	 nBE_Write;			  // Byte Enable. Upper에 저장할지 Lower에 저장할지를 표시
	
	// Memory Clear
	reg   [23:0] CurrentAdr;		  //Data Read시 사용.
	
	// *********************************************//
	

	
	initial begin		
		MemAdr = 0;
		nRamCE = 1;		// Deactivate
		nMemOE = 1;		// Deactivate
		nMemWR = 1;		// Deactivate
		nRamLB = 1;		// Deactivate
		nRamUB = 1; 	// Deactivate
		
		Transaction  = STANDBY;
		CurrentPhase = STATE0;
		NextPhase    = STATE0;		
		Digit        = 16'h1234;
		DataLatch    = 16'h1234;
		
		//Write
		UsedAdrCnt = 0;			// 다음에 데이터가 저장될 주소의 오프셋을 가진다.
		nBE_Write = 2'b10;		// 데이터가 Upper/Lower 중 어디에 저장될지 표시
		DataWriteComplete = 0;  // 데이터 저장이 완료되면 1로 증가
		
		//Memory Clear
		CurrentAdr = 0;
	end

	always @(posedge clk) begin
		if (Transaction == STANDBY)
			CurrentPhase <= STATE0;
		else
			CurrentPhase <= NextPhase;
	end
	
	// Check Transaction selction
	always @(posedge clk)
	begin
		if(BtnSwitch[0]==TRUE || DataWriteComplete == TRUE) begin 
			Transaction <= STANDBY;	
		end
		else begin
			if(BtnSwitch[1]==TRUE) begin Transaction <= CHECK_DATA; end   // DipSwitch 값을 오프셋으로 
			if(BtnSwitch[2]==TRUE) begin Transaction <= MEMORY_CLEAR; end // PSDRAM을 DipSwtich의 값으로 채우고 UsedAdrCnt을 0으로 설정
			if(ValidData == TRUE) begin Transaction <= UART_WRITE; end 	  // RS232로 받은 데이터를 PSDRAM에 저장.		
		end
	end

	always @(negedge clk) begin

			if (Transaction == STANDBY) 
				begin
					nRamCE <= 1;		// Deactivate
					nMemOE <= 1;		// Deactivate
					nMemWR <= 1;		// Deactivate
					nRamLB <= 1;		// Deactivate
					nRamUB <= 1; 		// Deactivate
					MemAdr <= 0;
					NextPhase <= STATE0;
					
					if(ValidData == 0)
						DataWriteComplete <= 0;
					
					CurrentAdr <= 0;
				end // end of STANDBY
				
			if (Transaction == UART_WRITE) begin
				Digit <= DataLatch;
				
				case(CurrentPhase)
					STATE0 : begin
						MemAdr <= UsedAdrCnt;
						
						nRamCE <= 0;
						nMemOE <= 1;
						nMemWR <= 0;
						{nRamUB, nRamLB} <= nBE_Write;
						
						// nBE_Write <= ~nBE_Write; 이 형태로 사용했을 시에 nBE_Write에 값이 정상적으로 들어가지 않음
						nBE_Write[0] <= ~nBE_Write[0];
						nBE_Write[1] <= ~nBE_Write[1];
						
						DataLatch <= (ReceivedData << 8) + ReceivedData;//DATA
						
						NextPhase <= STATE1;
					end
					STATE1 : begin NextPhase <= STATE2; end // Delay(60ns)
					STATE2 : begin NextPhase <= STATE3; end // 
					STATE3 : begin NextPhase <= STATE4; end //
					STATE4 : begin
						
						// 상/하위 바이트 모두 쓰여지면 주소 1 증가
						if({nRamUB, nRamLB} == 2'b01) begin 						
							UsedAdrCnt <= UsedAdrCnt + 1;						
						end

						nRamCE <= 1;
						nMemWR <= 1;
						nRamUB <= 1;
						nRamLB <= 1;
						
						NextPhase <= STATE5;
					end
					STATE5 : begin // Delay 20ns
						NextPhase <= STATE6; 
					end
					STATE6 : begin 
						DataWriteComplete <= 1; // 쓰기동작 완료를 알려 STANDBY 상태로 넘어간다.
					end
					
					endcase
				
			end // end of UART_WRITE
			
			if(Transaction == CHECK_DATA) begin
				Digit <= DataLatch;
				case(CurrentPhase)
					STATE0 :
						begin
							MemAdr <= SideSwitch;
							nRamCE <= 0;
							nMemOE <= 0;
							nMemWR <= 1;
							{nRamUB, nRamLB} <= 2'b00;
					
							NextPhase <= STATE1;
						end
					STATE1 : begin NextPhase <= STATE2; end	// +60ns delay
					STATE2 : begin NextPhase <= STATE3; end	// 
					STATE3 : begin NextPhase <= STATE4; end	// 
					STATE4 : begin					
						DataLatch <= MemDataIn;
						
						nRamCE <= 1;
						nMemOE <= 1;					
						nRamUB <= 1;
						nRamLB <= 1;
						
						NextPhase <= STATE5;						
					end
					STATE5 : begin
						NextPhase <= STATE0;					
					end					
					
				endcase
			end // end of CHECK_DATA
			
			if(Transaction == MEMORY_CLEAR) begin
				Digit <= DataLatch;
				
				case(CurrentPhase)
					STATE0 : 
						begin
							UsedAdrCnt <= 0;
							CurrentAdr <= 0;
							nBE_Write <= 2'b10;
							
							NextPhase <= STATE1;					
						end
					STATE1 :
						begin
							MemAdr <= CurrentAdr;
							nRamCE <= 0;
							nMemOE <= 1;
							nMemWR <= 0;
							{nRamUB, nRamLB} <= 2'b00;
							DataLatch <= {SideSwitch, SideSwitch};
							
							NextPhase <= STATE2;
						end
					STATE2 : begin NextPhase <= STATE3; end // +60ns delay
					STATE3 : begin NextPhase <= STATE4; end //
					STATE4 : begin NextPhase <= STATE5; end //
					STATE5 : 
						begin
							if(CurrentAdr < MAX_SIZE) begin
								CurrentAdr <= CurrentAdr + 1;
								NextPhase <= STATE1;
							end
							else
								NextPhase <= STATE6;
								
							nRamCE <= 1;
							nMemOE <= 1;
							nMemWR <= 1;
							{nRamUB, nRamLB} <= 2'b11;
						end
					STATE6 : 
						begin
							DataLatch <= 16'hABCD;
							DataWriteComplete <= 1;
							
							NextPhase <= STATE0;
						end
					endcase			
				end // end of MEMORY_CLEAR
	end
	
	assign Led = 8'b00110011;
	
	assign MemDataOut = DataLatch;
	
	assign RamCRE = 0;		// Never write to configuation register
	assign RamADV = 0;		// Make address signals always valid.	
	assign RamClk = 0;		// Use only async/page mode.	

endmodule


