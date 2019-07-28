`timescale 1ns/1ps

module tb ();
	initial begin
		$dumpfile("vga_demo_tb.vcd");
		$dumpvars(0, tb);
	end

	reg clk = 1'b0;

	initial begin
		repeat(40000) #0.5 clk = !clk;
		$finish;
	end

	vga_controller_demo demo (.CLK(clk));
endmodule
