`timescale 1ns/1ps

module tb ();
	initial begin
		$dumpfile("fifo_tb.vcd");
		$dumpvars(0, tb);
	end

	reg clk = 0;
	reg [7:0] data_in = 0;

	initial begin

	end

	always @(posedge clk) begin
		data_in <= data_in + 1;
	end

	initial begin
		repeat(40000) #0.5 clk = !clk;
		$finish;
	end

	fifo fifo_inst(
		.clk(clk),
		.data_in(data_in),
		.we(1'b1)
		);
endmodule
