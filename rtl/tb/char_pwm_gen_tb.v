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
forever #1 clk = ~clk;
end 

initial begin

    for (char_select = 3'b000; char_select <= 3'b011; char_select = char_select + 3'b001)
	begin
        $display("\nValue of char_select is: %b", char_select);
        $display("Time %t",$time);
        #20;
    end

    $finish;

end

endmodule