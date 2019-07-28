/*
	clk: clock signal
	we: write enable
	re: read enable
*/
module fifo (
	input wire clk,
	input wire we,
	input wire [DATA_WIDTH-1:0] data_in,
	output wire full,
	input wire re,
	output reg [DATA_WIDTH-1:0] data_out,
	output reg empty
);
	parameter DATA_WIDTH = 8;
	parameter ADDRESS_WIDTH = 8;

	reg [DATA_WIDTH-1:0] buffer [2**ADDRESS_WIDTH-1:0];
	reg [DATA_WIDTH-1:0] buffer_next = 0;

	reg [ADDRESS_WIDTH-1:0] index_write = 0;
	reg [ADDRESS_WIDTH-1:0] index_read = 0;
	wire [ADDRESS_WIDTH-1:0] index_write_next = index_write + 1;
	wire [ADDRESS_WIDTH-1:0] index_read_next = index_read + 1;

	wire empty_internal = index_read == index_write;
	assign full = index_write_next == index_read;

	always @(posedge clk) begin
		data_out <= buffer[index_read];
		empty <= empty_internal;

		if (we & ~full) begin
			index_write <= index_write_next;
			buffer[index_write] <= data_in;
		end

		if (re & ~empty_internal) begin
			index_read <= index_read_next;
		end
	end
endmodule
