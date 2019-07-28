`include "../misc/shift_delay.v"

module vga_controller (
	input wire clk_px,

	input wire i_red,
	input wire i_green,
	input wire i_blue,

	output wire [10:0] o_pos_h,
	output wire [9:0] o_pos_v,

	output wire o_frame_start,
	output wire o_line_start,

	output wire o_in_frame,

	output reg o_red,
	output reg o_green,
	output reg o_blue,

	output wire o_hsync,
	output wire o_vsync
);
	/*
		how many cycles the external image generator needs to generate i_red/green/blue from o_pos_h/v, plus one for the internal register
		purely combinatorial logic (eg. i_red = o_pos_h[0]) would be PIXEL_CYCLES = 0
		a single stage pipeline (eg. reg i_red; always @(posedge clk_px) i_red = o_pos_h[0];) would be PIXEL_CYCLES = 1 etc
	*/
	parameter PIXEL_DELAY = 0;

	parameter H_RES = 800;		// horizontal video size (pixels)
	parameter H_FP = 40;		// horizontal front porch (pixels)
	parameter H_SP = 128;		// horizontal sync pulse (pixels)
	parameter H_BP = 88;		// horizontal back porch (pixels)
	localparam H_TOTAL = H_RES + H_FP + H_SP + H_BP;

	parameter V_RES = 600;		// vertical video size (lines)
	parameter V_FP = 1;		// horizontal front porch (lines)
	parameter V_SP = 4;		// horizontal sync pulse (lines)
	parameter V_BP = 23;		// horizontal back porch (lines)
	localparam V_TOTAL = V_RES + V_FP + V_SP + V_BP;

	/* -------------------------------------------------------------------------- */

	reg [$clog2(H_TOTAL)-1:0] r_pos_h = 0;
	reg [$clog2(V_TOTAL)-1:0] r_pos_v = 0;
	assign o_pos_h = r_pos_h;
	assign o_pos_v = r_pos_v;

	reg r_frame_start = 1;
	reg r_line_start = 1;
	assign o_frame_start = r_frame_start;
	assign o_line_start = r_line_start;

	always @(posedge clk_px) begin
		r_frame_start <= 0;
		r_line_start <= 0;

		r_pos_h <= r_pos_h + 1;
		if (r_pos_h == (H_TOTAL - 1)) begin
			r_pos_h <= 0;
			r_line_start <= 1;

			r_pos_v <= r_pos_v + 1;
			if (r_pos_v == (V_TOTAL - 1)) begin
				r_pos_v <= 0;
				r_frame_start <= 1;
			end
		end
	end

	wire w_in_frame = (r_pos_h < H_RES) & (r_pos_v < V_RES);
	assign o_in_frame = w_in_frame;

	/* -------------------------------------------------------------------------- */

	wire w_hsync = ~(
					(r_pos_h >= (H_RES + H_FP)) &
					(r_pos_h < (H_RES + H_FP + H_SP)));
	wire w_vsync = ~(
					(r_pos_v >= (V_RES + V_FP)) &
					(r_pos_v < (V_RES + V_FP + V_SP)));

	shift_delay #(PIXEL_DELAY + 1) hsync_delay(
		.clk(clk_px),
		.in(w_hsync),
		.out(o_hsync)
		);

	shift_delay #(PIXEL_DELAY + 1) vsync_delay(
		.clk(clk_px),
		.in(w_vsync),
		.out(o_vsync)
		);

	/* -------------------------------------------------------------------------- */

	wire w_in_frame_output;

	shift_delay #(PIXEL_DELAY) in_frame_delay(
		.clk(clk_px),
		.in(w_in_frame),
		.out(w_in_frame_output)
		);

	always @(posedge clk_px) begin
		o_red <= i_red & w_in_frame_output;
		o_green <= i_green & w_in_frame_output;
		o_blue <= i_blue & w_in_frame_output;
	end

endmodule
