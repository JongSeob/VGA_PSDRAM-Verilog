`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:14:54 03/27/2015 
// Design Name: 
// Module Name:    SevenSegment 
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
module SevenSegment(
	input 		 i_clk,
	input [15:0] i_Digit,
	input  [3:0] i_Seg_DP_Switch,
	
	output reg [3:0] o_ControlLed,
	
	output o_SegA,
	output o_SegB,
	output o_SegC,	
	output o_SegD,
	output o_SegE,
	output o_SegF,	
	output o_SegG,	
	output o_Seg_DP 
   );
	
	wire DownClk;
	wire [6:0] Display;
	
	reg [1:0] TmpCnt = 2'b00;
	reg [3:0] Value = 4'h0;
	
	// DownClk�� 1/4 ���� �ȴ�.
	always @(posedge DownClk)
	begin
		case(TmpCnt)
			0 :	begin o_ControlLed <= 4'b1110; 	TmpCnt <= TmpCnt + 1; Value <= i_Digit;  end
			1 :	begin o_ControlLed <= 4'b1101;	TmpCnt <= TmpCnt + 1; Value <= (i_Digit>>4) ; end
			2 :	begin o_ControlLed <= 4'b1011;	TmpCnt <= TmpCnt + 1; Value <= (i_Digit>>8) ; end
			3 :	begin o_ControlLed <= 4'b0111;	TmpCnt <= TmpCnt + 1; Value <= (i_Digit>>12); end
		endcase
	end
	
	// 7 ���׸�Ʈ ���ڴ��� ����ȭ. 4��Ʈ �Է��� �޾� 7 ���׸�Ʈ�� ����� ���� ����Ѵ�.
	SegmentDecoder SegmentDecoder(Display, Value);
	
	// ���ֱ�
	CounterRefresh divide_Clk_50Mhz_To_240hz(DownClk, i_clk);	// input = 50MHz. output=60Hz*4
	
	// ���ڵ��� ��� Display�� �� Seg�� ������.
	assign	o_SegA = Display[6];
	assign	o_SegB = Display[5];
	assign	o_SegC = Display[4];
	assign	o_SegD = Display[3];
	assign	o_SegE = Display[2];
	assign	o_SegF = Display[1];
	assign	o_SegG = Display[0];
	
	assign	o_Seg_DP = (TmpCnt == 1) ? i_Seg_DP_Switch[0] :
							  (TmpCnt == 2) ? i_Seg_DP_Switch[1] :
							  (TmpCnt == 3) ? i_Seg_DP_Switch[2] :
							  (TmpCnt == 0) ? i_Seg_DP_Switch[3] : 1;

endmodule

// 7���׸�Ʈ ���ڴ�
// input : Data. 1���� ���׸�Ʈ ��ġ�� ����� 4��Ʈ ��
// output : Dsiplay. �Էµ� 4��Ʈ ���� �´� ���ڸ� ����ϱ� ���� 7 ���׸�Ʈ�� �� LED�� �����ϴ� ���
module	SegmentDecoder(Display, Data );
	output	reg [6:0] Display;
	input		[3:0] Data;
	
	//								  abc defg	
	parameter	BLANK		= 7'b111_1111;
	parameter	ZERO		= 7'b000_0001;
	parameter	ONE		= 7'b100_1111;
	parameter	TWO		= 7'b001_0010;
	parameter	THREE		= 7'b000_0110;
	parameter	FOUR		= 7'b100_1100;
	parameter	FIVE		= 7'b010_0100;
	parameter	SIX		= 7'b010_0000;
	parameter	SEVEN		= 7'b000_1111;
	parameter	EIGHT		= 7'b000_0000;
	parameter	NINE		= 7'b000_0100;
	parameter	TEN 		= 7'b000_1000;
	parameter	ELEVEN	= 7'b110_0000;
	parameter	TWELVE	= 7'b011_0001;
	parameter	THIRTEEN	= 7'b100_0010;
	parameter	FOURTEEN	= 7'b011_0000;	
	parameter	FIFTEEN	= 7'b011_1000;	

	always @(Data)
		case (Data)
			0:	Display = ZERO;
			1:	Display = ONE;
			2:	Display = TWO;
			3:	Display = THREE;
			4: Display = FOUR;
			5:	Display = FIVE;
			6:	Display = SIX;
			7:	Display = SEVEN;
			8:	Display = EIGHT;
			9:	Display = NINE;
			10:Display = TEN;
			11:Display = ELEVEN;
			12:Display = TWELVE;
			13:Display = THIRTEEN;
			14:Display = FOURTEEN;
			15:Display = FIFTEEN;
			default:	Display = BLANK;	// use when you want to display just upto 9
		endcase		
endmodule

// FPGA�� ���ԵǴ� clk(50Mhz)�� �Է��� �޾� 7 ���׸�Ʈ�� �ֳ�� ���� ������ �����ϴ� Ŭ��(OutClk)�� ����� ����.
// �Է� : clk(50Mhz ����)
// ��� : OutClk. 7 ���׸�Ʈ�� �ֳ�� ���� ������ �����Ѵ�. ž ��⿡�� �̸� ������� �ֳ�� ���� ��ȣ�� �����Ѵ�.
//       (DESIRED_FREQ * 4) * 2 = 50 * 10^6 / x. =====> 4 digit�� ���������� ��,�ҵ��ؾ� �ϹǷ� *4, 
//			�� ����� ������ �� ��ŭ�� Ŭ���� ���� �������� ����� ��ȭ��Ű�� �ʴٰ� ������ ���� Ŭ���� ������ ����� ���¸� ��۸��ϴ� ������� Ŭ���� �����Ѵ�. 
//			1���� Ŭ�� �ֱ�� 2���� ��, �� ����� ��ƾ� �ϹǷ� *2
module	CounterRefresh(
	output reg OutClk,
	input		  InClk
	);
	
	reg	[19:0]	q;
	
	parameter DESIRED_FREQ = 60*4;	// 60Hz for each digit. 45Hz �����̸� flickering �����ȴٰ� ��.
	
	initial	begin q <=0; OutClk<=0; end
	
	always @(posedge InClk)	begin
		 if(q > 20'h196e6) 	// =6104166=(50*10^6 /(DESIRED_FREQ*2)). DESIRED_FREQ=60*4; No Flickering.
			begin	OutClk <= ~OutClk; q <= 20'h00000; end
	    else
			begin q <= q +1; end
	end
endmodule
