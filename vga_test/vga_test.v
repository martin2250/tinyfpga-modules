`include "pll.v"
`include "../vga_controller/vga_controller.v"

module vga_test (
	input CLK,
	output USBPU,

	output PIN_14,	// RED
	output PIN_15,	// GREEN
	output PIN_16,	// BLUE
	output PIN_17,	// HSYNC
	output PIN_18	// VSYNC
);
	assign USBPU = 0;

	wire clk_px;	// pixel clock
	pll pll_inst(
		.clock_in(CLK),
		.clock_out(clk_px)
		);

	wire [10:0] pos_h;
	wire [9:0] pos_v;

	//wire red = (pos_h == 0) | (pos_h == 799);
	//wire green = (pos_v == 0) | (pos_v == 599);
	wire red = pos_h[1:0] == 0;
	wire green = pos_h[2:0] == 0;
	wire blue = pos_h[3:0] == 0; // ^ pos_v[1];

	vga_controller #(.PIXEL_DELAY(0)) controller(
		.clk_px(clk_px),

		.o_red(PIN_14),
		.o_green(PIN_15),
		.o_blue(PIN_16),

		.o_hsync(PIN_17),
		.o_vsync(PIN_18),

		.o_pos_h(pos_h),
		.o_pos_v(pos_v),

		.i_red(red),
		.i_green(green),
		.i_blue(blue)
		);
endmodule
