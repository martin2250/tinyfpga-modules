/*
	clk: clock signal
	rx: serial input wire
	data: data received in last transaction
	recv:
*/
module uart_rx (
	input wire clk,
	input wire rx,
	output reg [WIDTH-1:0] data = 0,
	output reg recv = 0
);
	// number of bits per transfer
	parameter WIDTH = 8;
	// prescaler, baud_rate = freq(clk) / CLKDIV
	parameter CLKDIV = 16;

	// data buffer, also contains start bit
	reg [WIDTH:0] buffer = {(WIDTH+1){1'b1}};

	// prescale counter
	reg [$clog2(CLKDIV) - 1:0] counter = 0;
	// sample strobe, rx is sampled at rising edge of clk when sample_strobe is high
	wire sample_strobe = counter == (CLKDIV / 2);

	// state of rx input at last clock cycle
	// used to sync prescale counter to edges of rx
	reg rx_buffer = 1;


	always @(posedge clk) begin
		counter <= counter + 1;

		// reset prescale counter at every edge to sync with transmitter
		// reset prescale counter when CLKDIV is reached
		if ((rx_buffer != rx) | (counter == (CLKDIV - 1))) begin
			counter <= 0;
		end
		rx_buffer <= rx;

		// data was moved to data register, reset buffer
		if (recv) begin
			buffer <= {(WIDTH+1){1'b1}};
		end
		// sample rx
		else if (sample_strobe) begin
			buffer <= {rx, buffer[WIDTH:1]};
		end
	end

	always @(negedge clk) begin
		recv <= 0;

		// start bit at lsb of buffer
		if (buffer[0] == 0) begin
			data <= buffer[WIDTH:1];
			recv <= 1;
		end
	end
endmodule
