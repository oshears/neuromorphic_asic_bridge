//`timescale 1ns / 1ps

module char_pwm_gen_tb;
// Inputs
reg clk;
reg [2:0] char_select;
wire digit;

char_pwm_gen char_pwm_gen(
.clk(clk), 
.char_select(char_select[1:0]), 
.digit(digit)
);

// Create 100Mhz clock
initial begin
clk = 0;
forever #500000000 clk = ~clk;
end 

initial begin

    // for (char_select = 0; char_select <= 3'b011; char_select = char_select + 1)
	// begin
        char_select = 3'b000;
        $display("\nValue of char_select is: %b", char_select);
        #4000000000;
        
        char_select = 3'b001;
        $display("\nValue of char_select is: %b", char_select);
        #4000000000;

        char_select = 3'b010;
        $display("\nValue of char_select is: %b", char_select);
        #4000000000;

        char_select = 3'b011;
        $display("\nValue of char_select is: %b", char_select);
        #4000000000;

    // end

    $finish;

end

endmodule