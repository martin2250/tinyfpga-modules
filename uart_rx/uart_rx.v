module uart_rx (
	input wire clk,
	input wire rx,
	output reg [WIDTH-1:0] data = 0,
	output reg recv = 0
);
	parameter WIDTH = 8;
	parameter CLKDIV = 16;

	reg [WIDTH:0] buffer = {(WIDTH+1){1'b1}};
	reg [$clog2(CLKDIV) - 1:0] counter = 0;
	reg rx_buffer = 1;

	always @(posedge clk) begin
		counter <= counter + 1;

		// reset counter at every edge to sync with transmitter
		if (rx_buffer != rx)
			counter <= 0;
		rx_buffer <= rx;

		if (counter == (CLKDIV / 2)) begin
			buffer <= {rx, buffer[WIDTH:1]};
		end
	end

	always @(negedge clk) begin
		recv <= 0;

		// start bit received
		if (buffer[0] == 0) begin
			data <= buffer[WIDTH:1];
			recv <= 1;
			buffer <= {(WIDTH+1){1'b1}};
		end
	end

endmodule
