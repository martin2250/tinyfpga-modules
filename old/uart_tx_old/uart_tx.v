/*
	clk: clock signal
	data: data to be transfered
	send: byte from data will be sent at the next rising edge of clk if no transaction is active and this line is set (can remain set)
	sent: set for one clock cycle when active goes low (changes on falling edge of clk)
	tx: serial output wire
*/
module uart_tx (
	input wire clk,
	input wire [WIDTH-1:0] data,
	input wire send,
	output reg sent,
	output wire tx
);
	// number of bits per transaction
	parameter WIDTH = 8;
	// prescaler, baud_rate = freq(clk) / CLKDIV
	parameter CLKDIV = 16;

	// data buffer
	// [(stop bit/sentinel), (data[WIDTH]), (start bit)]
	reg [WIDTH + 1:0] buffer = 0;

	// prescale counter
	reg [$clog2(CLKDIV) - 1:0] counter = 0;

	// tx line, lsb of buffer contains state
	assign tx = (active) ? buffer[0] : 1'b1;

	// active signal
	// buffer is only zero when stop bit was shifted out of the buffer
	wire active = buffer != 0;
	// active signal of last clock cycle, used to create "sent" flag
	reg active_internal = 0;

	always @(posedge clk) begin
		counter <= counter + 1;

		if (counter == (CLKDIV - 1)) begin
			counter <= 0;
			buffer <= buffer >> 1;
		end

		if(!active && send) begin
			buffer <= {1'b1, data, 1'b0};
			counter <= 0;
		end

		active_internal <= active;
	end

	always @(negedge clk) begin
		sent <= !active & active_internal;
	end

endmodule
