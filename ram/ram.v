/*
	clk: clock signal
	we: write enable
	re: read enable
*/
module ram (
	input wire clk,

	input wire w_enable,
	input wire [ADDRESS_WIDTH-1:0] w_address,
	input wire [DATA_WIDTH-1:0] w_data,

	input wire r_enable,
	input wire [ADDRESS_WIDTH-1:0] r_address,
	output reg [DATA_WIDTH-1:0] r_data
);
	parameter DATA_WIDTH = 8;
	parameter SIZE = 1024;

	localparam ADDRESS_WIDTH = $clog2(SIZE);

	reg [DATA_WIDTH-1:0] buffer [SIZE-1:0];

	initial $readmemh("ram.txt", buffer);

	always @(posedge clk) begin
		if (w_enable) begin
			buffer[w_address] <= w_data;
		end

		if (r_enable) begin
			r_data <= buffer[r_address];
		end
	end
endmodule
