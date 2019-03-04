`include "uart_tx/uart_tx.v"
`include "uart_rx/uart_rx.v"

module top (
	input CLK,
	output USBPU,

	input PIN_1,	// RX
	output PIN_2	// TX
);
	assign USBPU = 0;

	wire [7:0] data;
	wire rdy;

	uart_tx #(.CLKDIV(16)) tx(
		.clk(CLK),
		.data(data),
		.tx(PIN_2),
		.send(rdy)
		);

	uart_rx #(.CLKDIV(32)) rx(
		.clk(CLK),
		.data(data),
		.rx(PIN_1),
		.recv(rdy)
		);
endmodule
