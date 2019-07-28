module led_blink (
	input CLK,
	output USBPU,
	output LED
);
	assign USBPU = 0;

	reg [22:0] counter = 0;
	reg led = 0;

	always @(posedge CLK) begin
		counter <= counter + 1;
		if (led) begin
			if (counter == 2097152) begin
				led <= 0;
				counter <= 0;
			end
		end else begin
			if (counter == 1048576) begin
				led <= 1;
				counter <= 0;
			end
		end
	end

	assign LED = led;
endmodule
