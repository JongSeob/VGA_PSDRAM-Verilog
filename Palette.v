`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:07:28 05/28/2015 
// Design Name: 
// Module Name:    Palette 
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
module Palette(
	input  [7:0] index,
	output reg [7:0] rgb
    );
	 
	 always @* begin
		case(index)
			8'h00 : rgb <= 8'h00; 
			8'h01 : rgb <= 8'h80; 
			8'h02 : rgb <= 8'h10; 
			8'h03 : rgb <= 8'h90; 
			8'h04 : rgb <= 8'h02; 
			8'h05 : rgb <= 8'h82; 
			8'h06 : rgb <= 8'h12; 
			8'h07 : rgb <= 8'hDB; 
			8'h08 : rgb <= 8'hDF; 
			8'h09 : rgb <= 8'hBB; 
			8'h0A : rgb <= 8'h26; 
			8'h0B : rgb <= 8'h27; 
			8'h0C : rgb <= 8'h28; 
			8'h0D : rgb <= 8'h29; 
			8'h0E : rgb <= 8'h2A; 
			8'h0F : rgb <= 8'h2B; 
			8'h10 : rgb <= 8'h2C; 
			8'h11 : rgb <= 8'h2D; 
			8'h12 : rgb <= 8'h2E; 
			8'h13 : rgb <= 8'h2F; 
			8'h14 : rgb <= 8'h30; 
			8'h15 : rgb <= 8'h31; 
			8'h16 : rgb <= 8'h32; 
			8'h17 : rgb <= 8'h33; 
			8'h18 : rgb <= 8'h34; 
			8'h19 : rgb <= 8'h35; 
			8'h1A : rgb <= 8'h36; 
			8'h1B : rgb <= 8'h37; 
			8'h1C : rgb <= 8'h38; 
			8'h1D : rgb <= 8'h39; 
			8'h1E : rgb <= 8'h3A; 
			8'h1F : rgb <= 8'h3B; 
			8'h20 : rgb <= 8'h3C; 
			8'h21 : rgb <= 8'h3D; 
			8'h22 : rgb <= 8'h3E; 
			8'h23 : rgb <= 8'h3F; 
			8'h24 : rgb <= 8'h40; 
			8'h25 : rgb <= 8'h41; 
			8'h26 : rgb <= 8'h42; 
			8'h27 : rgb <= 8'h43; 
			8'h28 : rgb <= 8'h40; // Check 
			8'h29 : rgb <= 8'h41; // Check 
			8'h2A : rgb <= 8'h42; // 
			8'h2B : rgb <= 8'h43; //
			8'h2C : rgb <= 8'h44; //
			8'h2D : rgb <= 8'h45; 
			8'h2E : rgb <= 8'h46; 
			8'h2F : rgb <= 8'h47; 
			8'h30 : rgb <= 8'h48; 
			8'h31 : rgb <= 8'h49; 
			8'h32 : rgb <= 8'h4A; 
			8'h33 : rgb <= 8'h4B; 
			8'h34 : rgb <= 8'h4C; 
			8'h35 : rgb <= 8'h4D; 
			8'h36 : rgb <= 8'h4E; 
			8'h37 : rgb <= 8'h4F; 
			8'h38 : rgb <= 8'h50; 
			8'h39 : rgb <= 8'h51; 
			8'h3A : rgb <= 8'h52; 
			8'h3B : rgb <= 8'h53; 
			8'h3C : rgb <= 8'h54; 
			8'h3D : rgb <= 8'h55; 
			8'h3E : rgb <= 8'h56; 
			8'h3F : rgb <= 8'h57; 
			8'h40 : rgb <= 8'h58; 
			8'h41 : rgb <= 8'h59; 
			8'h42 : rgb <= 8'h5A; 
			8'h43 : rgb <= 8'h5B; 
			8'h44 : rgb <= 8'h5C; 
			8'h45 : rgb <= 8'h5D; 
			8'h46 : rgb <= 8'h5E; 
			8'h47 : rgb <= 8'h5F; 
			8'h48 : rgb <= 8'h60; 
			8'h49 : rgb <= 8'h61; 
			8'h4A : rgb <= 8'h62; 
			8'h4B : rgb <= 8'h63; 
			8'h4C : rgb <= 8'h60; //
			8'h4D : rgb <= 8'h61; //
			8'h4E : rgb <= 8'h62; //
			8'h4F : rgb <= 8'h63; //
			8'h50 : rgb <= 8'h64; 
			8'h51 : rgb <= 8'h65; 
			8'h52 : rgb <= 8'h66; 
			8'h53 : rgb <= 8'h67; 
			8'h54 : rgb <= 8'h68; 
			8'h55 : rgb <= 8'h69; 
			8'h56 : rgb <= 8'h6A; 
			8'h57 : rgb <= 8'h6B; 
			8'h58 : rgb <= 8'h6C; 
			8'h59 : rgb <= 8'h6D; 
			8'h5A : rgb <= 8'h6E; 
			8'h5B : rgb <= 8'h6F; 
			8'h5C : rgb <= 8'h70; 
			8'h5D : rgb <= 8'h71; 
			8'h5E : rgb <= 8'h72; 
			8'h5F : rgb <= 8'h73; 
			8'h60 : rgb <= 8'h74; 
			8'h61 : rgb <= 8'h75; 
			8'h62 : rgb <= 8'h76; 
			8'h63 : rgb <= 8'h77; 
			8'h64 : rgb <= 8'h78; 
			8'h65 : rgb <= 8'h79; 
			8'h66 : rgb <= 8'h7A; 
			8'h67 : rgb <= 8'h7B; 
			8'h68 : rgb <= 8'h7C; 
			8'h69 : rgb <= 8'h7D; 
			8'h6A : rgb <= 8'h7E; 
			8'h6B : rgb <= 8'h7F; 
			8'h6C : rgb <= 8'hA0; 
			8'h6D : rgb <= 8'hA1; 
			8'h6E : rgb <= 8'hA2; 
			8'h6F : rgb <= 8'hA3; 
			8'h70 : rgb <= 8'hA0; //
			8'h71 : rgb <= 8'hA1; //
			8'h72 : rgb <= 8'hA2; //
			8'h73 : rgb <= 8'hA3; //
			8'h74 : rgb <= 8'hA4; 
			8'h75 : rgb <= 8'hA5; 
			8'h76 : rgb <= 8'hA6; 
			8'h77 : rgb <= 8'hA7; 
			8'h78 : rgb <= 8'hA8; 
			8'h79 : rgb <= 8'hA9; 
			8'h7A : rgb <= 8'hAA; 
			8'h7B : rgb <= 8'hAB; 
			8'h7C : rgb <= 8'hAC; 
			8'h7D : rgb <= 8'hAD; 
			8'h7E : rgb <= 8'hAE; 
			8'h7F : rgb <= 8'hAF; 
			8'h80 : rgb <= 8'hB0; 
			8'h81 : rgb <= 8'hB1; 
			8'h82 : rgb <= 8'hB2; 
			8'h83 : rgb <= 8'hB3; 
			8'h84 : rgb <= 8'hB4; 
			8'h85 : rgb <= 8'hB5; 
			8'h86 : rgb <= 8'hB6; 
			8'h87 : rgb <= 8'hB7; 
			8'h88 : rgb <= 8'hB8; 
			8'h89 : rgb <= 8'hB9; 
			8'h8A : rgb <= 8'hBA; 
			8'h8B : rgb <= 8'hBB; 
			8'h8C : rgb <= 8'hBC; 
			8'h8D : rgb <= 8'hBD; 
			8'h8E : rgb <= 8'hBE; 
			8'h8F : rgb <= 8'hBF; 
			8'h90 : rgb <= 8'hC0; 
			8'h91 : rgb <= 8'hC1; 
			8'h92 : rgb <= 8'hC2; 
			8'h93 : rgb <= 8'hC3; 
			8'h94 : rgb <= 8'hC0; //
			8'h95 : rgb <= 8'hC1; //
			8'h96 : rgb <= 8'hC2; //
			8'h97 : rgb <= 8'hC3; //
			8'h98 : rgb <= 8'hC4; 
			8'h99 : rgb <= 8'hC5; 
			8'h9A : rgb <= 8'hC6; 
			8'h9B : rgb <= 8'hC7; 
			8'h9C : rgb <= 8'hC8; 
			8'h9D : rgb <= 8'hC9; 
			8'h9E : rgb <= 8'hCA; 
			8'h9F : rgb <= 8'hCB; 
			8'hA0 : rgb <= 8'hCC; 
			8'hA1 : rgb <= 8'hCD; 
			8'hA2 : rgb <= 8'hCE; 
			8'hA3 : rgb <= 8'hCF; 
			8'hA4 : rgb <= 8'hD0; 
			8'hA5 : rgb <= 8'hD1; 
			8'hA6 : rgb <= 8'hD2; 
			8'hA7 : rgb <= 8'hD3; 
			8'hA8 : rgb <= 8'hD4; 
			8'hA9 : rgb <= 8'hD5; 
			8'hAA : rgb <= 8'hD6; 
			8'hAB : rgb <= 8'hD7; 
			8'hAC : rgb <= 8'hD8; 
			8'hAD : rgb <= 8'hD9; 
			8'hAE : rgb <= 8'hDA; 
			8'hAF : rgb <= 8'hDB; 
			8'hB0 : rgb <= 8'hDC; 
			8'hB1 : rgb <= 8'hDD; 
			8'hB2 : rgb <= 8'hDE; 
			8'hB3 : rgb <= 8'hDF; 
			8'hB4 : rgb <= 8'hE1; 
			8'hB5 : rgb <= 8'hE2; 
			8'hB6 : rgb <= 8'hE0; 
			8'hB7 : rgb <= 8'hE1; //
			8'hB8 : rgb <= 8'hE2; //
			8'hB9 : rgb <= 8'hE3; //
			8'hBA : rgb <= 8'hE4; 
			8'hBB : rgb <= 8'hE5; 
			8'hBC : rgb <= 8'hE6; 
			8'hBD : rgb <= 8'hE7; 
			8'hBE : rgb <= 8'hE8; 
			8'hBF : rgb <= 8'hE9; 
			8'hC0 : rgb <= 8'hEA; 
			8'hC1 : rgb <= 8'hEB; 
			8'hC2 : rgb <= 8'hEC; 
			8'hC3 : rgb <= 8'hED; 
			8'hC4 : rgb <= 8'hEE; 
			8'hC5 : rgb <= 8'hEF; 
			8'hC6 : rgb <= 8'hF0; 
			8'hC7 : rgb <= 8'hF1; 
			8'hC8 : rgb <= 8'hF2; 
			8'hC9 : rgb <= 8'hF3; 
			8'hCA : rgb <= 8'hF4; 
			8'hCB : rgb <= 8'hF5; 
			8'hCC : rgb <= 8'hF6; 
			8'hCD : rgb <= 8'hF7; 
			8'hCE : rgb <= 8'hF8; 
			8'hCF : rgb <= 8'hF9; 
			8'hD0 : rgb <= 8'hFA; 
			8'hD1 : rgb <= 8'hFB; 
			8'hD2 : rgb <= 8'hFD; 
			8'hD3 : rgb <= 8'hFE; 
			8'hD4 : rgb <= 8'hDB; //
			8'hD5 : rgb <= 8'hFB; //
			8'hD6 : rgb <= 8'h3F; //
			8'hD7 : rgb <= 8'h7F; //
			8'hD8 : rgb <= 8'h9F; 
			8'hD9 : rgb <= 8'hDF; //
			8'hDA : rgb <= 8'h0C; //
			8'hDB : rgb <= 8'h0D; 
			8'hDC : rgb <= 8'h0E; 
			8'hDD : rgb <= 8'h0F; 
			8'hDE : rgb <= 8'h10; //
			8'hDF : rgb <= 8'h11; 
			8'hE0 : rgb <= 8'h12; //
			8'hE1 : rgb <= 8'h13; 
			8'hE2 : rgb <= 8'h14; 
			8'hE3 : rgb <= 8'h15; 
			8'hE4 : rgb <= 8'h16; 
			8'hE5 : rgb <= 8'h17; 
			8'hE6 : rgb <= 8'h18; 
			8'hE7 : rgb <= 8'h19; 
			8'hE8 : rgb <= 8'h1A; 
			8'hE9 : rgb <= 8'h1B; 
			8'hEA : rgb <= 8'h1D; 
			8'hEB : rgb <= 8'h1E; 
			8'hEC : rgb <= 8'h20; 
			8'hED : rgb <= 8'h21; 
			8'hEE : rgb <= 8'h22; 
			8'hEF : rgb <= 8'h23; 
			8'hF0 : rgb <= 8'h20; //
			8'hF1 : rgb <= 8'h21; //
			8'hF2 : rgb <= 8'h22; //
			8'hF3 : rgb <= 8'h23; //
			8'hF4 : rgb <= 8'h24; 
			8'hF5 : rgb <= 8'h25; 
			8'hF6 : rgb <= 8'hFF; 
			8'hF7 : rgb <= 8'hB6; 
			8'hF8 : rgb <= 8'h92; 
			8'hF9 : rgb <= 8'hE0; 
			8'hFA : rgb <= 8'h1C; 
			8'hFB : rgb <= 8'hFC; 
			8'hFC : rgb <= 8'h03; 
			8'hFD : rgb <= 8'he3; 
			8'hFE : rgb <= 8'h1f; 
			8'hFF : rgb <= 8'hff; 			
		endcase

		
	 end


endmodule
