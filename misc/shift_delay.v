module shift_delay (
	input wire clk,
	input wire in,
	output wire out
	);
	parameter CYCLES = 1;
	parameter DEFAULT = 1'b0;

	generate
		if (CYCLES > 0) begin

			reg [CYCLES - 1:0] buffer = {CYCLES{DEFAULT}};

			assign out = buffer[CYCLES - 1];

			always @(posedge clk) begin
				buffer = {buffer[CYCLES - 2:0], in};
			end

		end else begin
			assign out = in;
		end
	endgenerate
endmodule
