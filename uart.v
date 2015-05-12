`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:54:48 10/18/2010 
// Design Name: 
// Module Name:    top 
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
module uart
#(
	parameter	RECEIVE_0 = 3'b000,
	parameter	RECEIVE_1 = 3'b001,
	parameter	RECEIVE_2 = 3'b010,

	parameter	SEND_0 = 3'b100,
	parameter	SEND_1 = 3'b101,
	parameter	SEND_2 = 3'b110,
	parameter	SEND_3 = 3'b111
 )
(
		input CLK,
		output TXD,
		output reg [7:0] LEDS,
		input RXD,
		input RST,
		output ValidData,
		output [7:0] ReceivedData
    );
	 
reg [7:0] dbInSig;	// UART의 입력. PC에서 보내온 데이터를 반향시켜 보낼 예정.
wire [7:0] dbOutSig;	// UART의 출력. PC에서 보내온 데이터를 읽어내는 포트. 
reg [7:0] dbInLatch;	// UART의 출력을 저장할 공간. LED에 연결되어 출력 결과를 육안으로 확인 가능.
reg rdaSig;				// Read Data Available : 수신 버퍼에 데이터가 들어왔음을 의미.
reg tbeSig;				// Transfer Bus Empty
reg rdSig=1;				// Read 신호
reg wrSig;				// Write 신호
reg peSig;				// 페이지 오류
reg feSig;				// 페리티 오류
reg oeSig;

reg [2:0] stRcvCur;		// 현재 Receive 상태
reg [2:0] stRcvNext;		// 다음 Receive 상태

reg [2:0] stSendCur;
reg [2:0] stSendNext;

reg send_rdy = 0;
	 
	Rs232RefComp rs232( .TXD(TXD),
							.RXD(RXD),
							.CLK(CLK),
							.DBIN(dbInSig),
							.DBOUT(dbOutSig),
							.RDA(rdaSig),
							.TBE(tbeSig),
							.RD(rdSig),
							.WR(wrSig),
							.PE(peSig),
							.FE(feSig),
							.OE(oeSig),
							.RST(RST));
			
always @(negedge CLK) begin
	if(RST == 1) begin
		stRcvCur <= RECEIVE_0;
		stSendCur <= SEND_0;
	end
	else begin
		stRcvCur <= stRcvNext;		
		stSendCur <= stSendNext;
	end
end		
	

always @(posedge CLK) begin
	case(stRcvCur)
		RECEIVE_0 : begin rdSig <= 0; stRcvNext <= RECEIVE_1; end
		RECEIVE_1 : 
			begin 
				if (rdaSig == 1) begin		// Read Data Available
					dbInLatch <= dbOutSig;	// Latch the read data
					LEDS		 <= dbOutSig;
					stRcvNext <= RECEIVE_2;
					send_rdy <= 1;
					end
				else
					stRcvNext <= RECEIVE_1;
			end	
		RECEIVE_2 : begin 
							rdSig <= 1; 
							
							if(rdaSig == 1)
								stRcvNext <= RECEIVE_2;
							else
								stRcvNext <= RECEIVE_0; 
						end	// Fluash Read Buffer
	endcase
	
	case(stSendCur)
		SEND_0 : 
			begin 
					dbInSig <= dbInLatch; 
					if(send_rdy == 1 && tbeSig == 1) begin 
						stSendNext <= SEND_1;
						send_rdy <= 0; 
					end 
					else stSendNext <= SEND_0; 
			end
		SEND_1 : begin stSendNext <= SEND_2; end
		SEND_2 : begin wrSig <= 1; stSendNext <= SEND_3; end
		SEND_3 : begin wrSig <= 0; stSendNext <= SEND_0; end
	endcase
	
end

assign ValidData = rdaSig;
assign ReceivedData = dbInLatch;


endmodule

