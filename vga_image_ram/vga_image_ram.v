`include "pll.v"
`include "../ram/ram.v"
`include "../vga_controller/vga_controller.v"

module vga_image_ram (
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

	wire red, green, blue;

	vga_controller #(.PIXEL_DELAY(3)) controller(
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

	wire [$clog2(800*600/4)-1:0] pixel_index = ((pos_h) >> 1) + (800/2)*(pos_v >> 1);

	wire [15:0] pixel_16;
	ram #(
		.DATA_WIDTH(16),
		.SIZE(800*600/16/4)
		) image (
			.clk(clk_px),
			.r_address(pixel_index >> 4),
			.r_data(pixel_16),
			.r_enable(pixel_index[3:0] == 4'h0)
			);

	reg pixel = 0;
	reg [3:0] pixel_index_registererd = 0;

	always @(posedge clk_px) begin
		if (~pos_h[0]) begin
			pixel <= pixel_16[pixel_index_registererd];
			pixel_index_registererd = pixel_index;
		end
	end

	assign red = pixel;
	assign green = ~pixel;
	assign blue = pixel;
endmodule
