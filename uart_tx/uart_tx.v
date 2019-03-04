module uart_tx (
	input wire clk,
	input wire [WIDTH-1:0] data,
	input wire send,
	output reg active = 0,
	output reg sent,
	output wire tx
);
	parameter WIDTH = 8;
	parameter CLKDIV = 16;


	// [(stop bit/sentinel), (data[WIDTH]), (start bit)]
	reg [WIDTH + 1:0] buffer = 0;

	reg [$clog2(CLKDIV) - 1:0] counter = 0;

	assign tx = (active_internal) ? buffer[0] : 1'b1;
	wire active_internal = buffer != 0;

	always @(posedge clk) begin
		counter <= counter + 1;

		if(!active && send) begin
			buffer <= {1'b1, data, 1'b0};
			counter <= 0;
		end

		if (counter == (CLKDIV - 1)) begin
			counter <= 0;
			buffer <= buffer >> 1;
		end
	end
	
	always @(negedge clk) begin
		sent <= !active_internal & active;
		active <= active_internal;
	end

endmodule
