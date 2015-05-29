`timescale 1ns / 1ps

module uart#(
	// ���� �ӽ� : �б� ���� 3�ܰ� + ���� ���� 3�ܰ� 
	parameter	RECEIVE_0 = 3'b000,
					RECEIVE_1 = 3'b001,
					RECEIVE_2 = 3'b010,
					RECEIVE_3 = 3'b011,
					RECEIVE_4 = 3'b100,

	parameter	SEND_0 = 3'b000,
					SEND_1 = 3'b001,
					SEND_2 = 3'b010,
					SEND_3 = 3'b011,
					SEND_4 = 3'b100
)
(
	input	       clk,				// 50 MHz input
	input        RST,
	output [7:0] oLed,
	
	output TxD,
	input  RxD,
		
	output ValidData,
	output [7:0] ReceivedData
   );

	reg send_rdy = 0;

	///////////////////////////////////////////////////////////////////////////////////////////////////
	// Implementation of UART function 
	///////////////////////////////////////////////////////////////////////////////////////////////////
	reg  [7:0] dbInSig;		// Data Bus in.  UART�� �Է�. Blaze���� ���� ������.
	wire [7:0] dbOutSig;		// Data Bus out. UART�� ���. PC���� ������ �����͸� �о�� ��Ʈ. 
	reg  [7:0] dbOutLatch;	// UART�� ����� ������ ����. LED�� ����Ǿ� ��� ����� �������� Ȯ�� ����.
	reg 	rdaSig;				// Read Data Available : ���� ���ۿ� �����Ͱ� �������� �ǹ�.
	reg 	tbeSig;				// Transmit Buffer Empty
	reg 	rdSig=1;				// Read ��ȣ
	reg 	wrSig=0;				// Write ��ȣ
	wire 	peSig;				// Parity Error Flag
	wire 	feSig;				// Frame Error Flag
	wire 	oeSig;				// Overwrite Error Flag
	reg 	FlagPatityError;				// Parity Error Flag
	reg 	FlagFrameError;				// Frame Error Flag
	reg 	FlagOverrunError;				// Overwrite Error Flag
	reg	[15:0] CounterPE;				// Parity Error Counter
	reg 	[15:0] CounterFE;				// Frame Error Flag
	reg 	[15:0] CounterOE;				// Overwrite Error Flag
	reg	[15:0] CounterReceived;		// Number of data received	
	reg	[7:0]	CounterWait_rda;		// rda ��ȣ�� �������µ� �ɸ� �ð�	
	reg	[7:0]	CounterWait_tbe;		// tbe ��ȣ�� �����Ǵµ� �ɸ� �ð�	

	reg [2:0] stRcvCur , stRcvNext;
	reg [2:0] stSendCur, stSendNext;
	

	// ���Ź����� ������ ���� CounterReceived ī���Ͱ� 2���� �����ϴ� ������ ���¸ӽ� negedge�� �ذ�Ǿ���.
	always @(posedge clk) begin		
		if(RST == 1) begin
			stRcvCur  <= RECEIVE_0;
			stSendCur <= SEND_0;
		end
		else begin
			stRcvCur  <= stRcvNext;
			stSendCur <= stSendNext;
		end
	end
	
	always @(posedge rdaSig, posedge wrSig) begin
		if(rdaSig == 1) begin
			dbInSig  <= dbOutSig;
			send_rdy <= 1;
		end
		else if(wrSig == 1) 
			send_rdy <= 0;
	end	

	always @(posedge clk) begin		
		if (RST == 1) begin
			CounterPE <= 16'h0000;				// Parity Error Counter
			CounterFE <= 16'h0000;				// Frame Error Flag
			CounterOE <= 16'h0000;				// Overwrite Error Flag
			CounterReceived <= 16'h0000;		// Number of data received
		end
		else begin
			case(stRcvCur)
				RECEIVE_0 : begin rdSig <= 0;	stRcvNext <= RECEIVE_1; end
				RECEIVE_1 : 
					begin 
						if (rdaSig == 1'b1) 
							begin		// Check if receive buffer is valid. Data is availabe if rdaSig=1. 
								dbOutLatch <= dbOutSig;	// Latch the read data
								FlagPatityError <= peSig;	
								FlagFrameError <= feSig;	
								FlagOverrunError <= oeSig;	
								
								stRcvNext <= RECEIVE_2;
							end
						else
							stRcvNext <= RECEIVE_1;
					end	
				RECEIVE_2 : 
					begin 					// Flush the receive Buffer.
						rdSig <= 1'b1;			// �� ��ȣ�� UART�� ������ VHDL UART�� rdaSig�� �����ϴµ� �ð��� �ҿ�� �� �ִ�. �׷��� RECEIVE_3�� �߰��Ͽ���.
						if ( FlagPatityError == 1 || FlagFrameError ==1 || FlagOverrunError) begin
							if (peSig == 1)	CounterPE <= CounterPE +1;
							if (feSig == 1)	CounterFE <= CounterFE +1;
							if (oeSig == 1)	CounterOE <= CounterOE +1;
						end
						else begin
							stRcvNext <= RECEIVE_3;
						end
					end
				RECEIVE_3 :		//wait until rdaSig is gone.
					begin
						if ( rdaSig == 1'b1)	
							begin
								CounterWait_rda <= CounterWait_rda +1;	
								stRcvNext <= RECEIVE_3; 
							end
						else	
							begin
								CounterReceived <= CounterReceived +1;		// ī���Ͱ� 2���� �����ϴ� ������ ���¸ӽ� negedge�� �ذ�Ǿ���.									
								stRcvNext <= RECEIVE_0;
							end
					end	
			endcase

			case(stSendCur)
				SEND_0 : if( tbeSig == 1'b1 && send_rdy == 1'b1 )
								stSendNext <= SEND_1;
							else
								stSendNext <= SEND_0;					
				SEND_1 : wrSig <= 1;
				SEND_2 : wrSig <= 0;
				SEND_3 : stSendNext <= SEND_4; 
				SEND_4 : stSendNext <= SEND_0; 				
			endcase
		end
	end


	// ���� �� �ֿ� ���� ��ȣ ���� ���̱�
	assign	oLed[7] = FlagPatityError;				// Parity Error Flag
	assign	oLed[6] = FlagFrameError;				// Frame Error Flag
	assign	oLed[5] = FlagOverrunError;			// Overwrite Error Flag
	assign	oLed[4] = rdSig;
	assign	oLed[3] = wrSig;
	assign	oLed[2] = RxD;
	assign	oLed[1] = tbeSig;
	assign	oLed[0] = rdaSig;
	
	assign ValidData = rdaSig;
	assign ReceivedData = dbOutLatch;

	// VHDL ����� ����ȭ�Ͽ� �����Ѵ�.
	// SPEC of VHDL module : 9600bps, 8 data bits, 1 stop bit, odd parity 
	Rs232RefComp UART( 
							.RST(RST),					// Master Reset. Active High.  Input
							.CLK(clk),					// Master Clock. 50MHz. Input
							.TXD(TxD),					// Transmit Data. Output of UART
							.RXD(RxD),					// Receive Data. Input of UART
							// Dsta Input and Output
							.DBIN(dbInSig),			// Data Bus in.  Input
							.DBOUT(dbOutSig),			// Data Bus out. Output
							// Control pins for reading or writing 
							.RD(rdSig),					// Read Strobe.  Input. Active High. When it is high, receive buffer content is no longer valid.
							.WR(wrSig),					// Write Strobe.  Input. Active High.
							// Status bits
							.RDA(rdaSig),				// Read Data Available. Output. Active High.
							.TBE(tbeSig),				// Transmit Buffer Empty. Output. Active High. 
							// Error flags
							.PE(peSig),					// Parity Error Flag. Output. Active High.
							.FE(feSig),					// Frame Error Flag. Output. Active High. 
							.OE(oeSig));				// Overwrite Error Flag. Output. Active High.

endmodule
