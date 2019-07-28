`include "../uart_tx/uart_tx.v"
`include "../uart_rx/uart_rx.v"
`include "../fifo/fifo.v"

module uart_converter (
	input CLK,
	output USBPU,

	input PIN_1,	// RX
	output PIN_2	// TX
);
	assign USBPU = 0;

	wire [7:0] fifo_in;
	wire [7:0] fifo_out;
	wire fifo_full;
	wire fifo_empty;
	wire fifo_write;
	reg fifo_read;

	fifo buffer(
			.clk(CLK),
			.data_in(fifo_in),
			.data_out(fifo_out),
			.full(fifo_full),
			.empty(fifo_empty),
			.we(fifo_write),
			.re(fifo_read)
		);

	always @(posedge CLK) begin
		fifo_read <= 1'b0;
		tx_send <= 1'b0;

		if (~fifo_empty & ~tx_active & ~fifo_read & ~tx_send) begin
			fifo_read <= 1'b1;
			tx_send <= 1'b1;
		end

		if (fifo_read) begin
		end
	end

	wire tx_active;
	reg tx_send = 1'b0;

	uart_tx #(.CLKDIV(64)) tx(
		.clk(CLK),
		.data(fifo_out),
		.tx(PIN_2),
		.send(tx_send),
		.active(tx_active)
		);

	uart_rx #(.CLKDIV(32)) rx(
		.clk(CLK),
		.data(fifo_in),
		.rx(PIN_1),
		.recv(fifo_write)
		);
endmodule
