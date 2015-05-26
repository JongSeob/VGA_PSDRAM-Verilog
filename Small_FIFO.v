`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:49:16 03/23/2015 
// Design Name: 
// Module Name:    FIFO 
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

`define BUF_WIDTH 9    // no. of bits to be used in pointer
`define BUF_SIZE  400 // size of buffer to be designated by pointer

module fifo( 
	input clk, rst, wr_en, rd_en,  	// reset, system clock, write enable and read enable.
	input half_clk,
	input  	  [15:0] buf_in, 			// data input to be pushed to buffer
	output reg [15:0] buf_out, 		// port to output the data using pop.
	output reg buf_empty, buf_full, 	// buffer empty and full indication
	output reg [`BUF_WIDTH -1: 0] fifo_counter, // number of data pushed in to buffer
	output reg read_available
	);

	reg [`BUF_WIDTH -1:0] rd_ptr, wr_ptr;           	// pointer to read and write addresses  
	reg [15:0]            buf_mem[`BUF_SIZE -1 : 0];
	
	// Empty, Full flag
	always @(fifo_counter)
	begin
		buf_empty = (fifo_counter == 0);
		buf_full  = (fifo_counter == `BUF_SIZE);
	end
	
	// Read FIFO Counter
	always @(posedge half_clk or posedge rst)
	begin
		if( rst )
			 fifo_counter <= 0;

		else if( (!buf_full && wr_en) && ( !buf_empty && rd_en ) )
			 fifo_counter <= fifo_counter;

		else if( !buf_full && wr_en )
			 fifo_counter <= fifo_counter + 1;

		else if( !buf_empty && rd_en )
			 fifo_counter <= fifo_counter - 1;
		else
			fifo_counter <= fifo_counter;
	end
	
	// Read operation
	always @( posedge half_clk or posedge rst)
	begin
		if( rst )
			buf_out <= 0;
		else
		begin
			if( rd_en && !buf_empty ) begin
				buf_out <= buf_mem[rd_ptr];			
				read_available <= 1;
			end
			else begin
				buf_out <= buf_out;
				read_available <= 0;
			end

		end
	end
	
	// Write operation
	always @(posedge clk)
	begin
		if( wr_en && !buf_full )
			buf_mem[ wr_ptr ] <= buf_in;
		else
			buf_mem[ wr_ptr ] <= buf_mem[ wr_ptr ];
	end
	
	// Read Pointer
	always@(posedge half_clk or posedge rst)
	begin
		if( rst )
			rd_ptr <= 0;
		else
		begin
			if( !buf_empty && rd_en ) rd_ptr <= ( rd_ptr == (`BUF_SIZE-1) ) ? 0 : rd_ptr + 1;
			else rd_ptr <= rd_ptr;
		end
	end
	
	// Write Pointer
	always@(posedge clk or posedge rst)
	begin
		if( rst )
			wr_ptr <= 0;
		else
		begin
			if( !buf_full && wr_en )  wr_ptr <= ( wr_ptr == (`BUF_SIZE-1) ) ? 0 : wr_ptr + 1;
			else  wr_ptr <= wr_ptr;
		end

	end
	
	endmodule
