`timescale 1ns/1ps
module tb ();
	initial begin
		$dumpfile("uart_tx/uart_tx_tb.vcd");
		$dumpvars(0, tx);
	end

	reg clk = 1'b0;
	reg send = 1'b0;
	wire sent;

	reg [7:0] data = 8'h5C;

	initial begin
		send = 1;
	end

	always @(posedge sent) begin
		data <= data + 1;
	end

	initial begin
		repeat(1000) #0.5 clk = !clk;
		$finish;
	end

	uart_tx #(.CLKDIV(16)) tx(
		.data(data),
		.clk(clk),
		.send(send),
		.sent(sent)
		);
endmodule
