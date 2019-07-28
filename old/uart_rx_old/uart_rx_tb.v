`timescale 1ns/1ps
`include "uart_tx/uart_tx.v"

module tb ();
	initial begin
		$dumpfile("uart_rx/uart_rx_tb.vcd");
		$dumpvars(0, tb);
	end

	reg clk = 1'b0;
	reg send = 1'b0;
	wire sent;

	wire serial;

	reg [7:0] data = 8'h5C;

	initial begin
		#20
		send = 1;
	end

	always @(posedge sent) begin
		data <= data + 1;
	end

	initial begin
		repeat(4000) #0.5 clk = !clk;
		$finish;
	end

	uart_tx #(8, 8) tx(
		.data(data),
		.clk(clk),
		.send(send),
		.sent(sent),
		.tx(serial)
		);

	wire [7:0] data2;
	wire rdy;

	uart_rx #(8, 8) rx(
		.clk(clk),
		.rx(serial),
		.data(data2),
		.recv(rdy)
		);

	uart_tx #(8, 8) tx2(
		.data(data2),
		.clk(clk),
		.send(rdy)
		);
endmodule
