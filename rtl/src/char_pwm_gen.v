`timescale 1ns / 1ps
module char_pwm_gen
(
    clk, // 100MHz clock input 
    rst,
    char_select,
    digit,
    slow_clk_en,
    clk_out
);

    //TODO: The clk might need to be divided down to 100MHz if it isn't set to this frequency already

    input clk;
    input rst;
    input [1:0] char_select;
    input slow_clk_en;

    /*
    00 - A
    01 - J
    10 - N
    11 - X
    */
    output [15:0] digit;

    output clk_out;

    reg [19:0] slow_clk_counter = 0;

    wire output_clk;

    assign output_clk = slow_clk_en ? slow_clk_counter[19] : clk;

    assign clk_out = output_clk;

    // counter to slow down the clock by 1000000x
    always @(posedge clk)
    begin
        if(rst)
            slow_clk_counter <= 0;
        else
            slow_clk_counter <= slow_clk_counter + 1;
    end

    assign digit[0] = char_select != 2'b01 ? output_clk : ~output_clk;
    assign digit[1] = char_select == 2'b00 ? output_clk : ~output_clk;
    assign digit[2] = char_select == 2'b00 ? output_clk : ~output_clk;
    assign digit[3] = output_clk;

    assign digit[4] = char_select[0] ? output_clk : ~output_clk;
    assign digit[5] = char_select[1] ? output_clk : ~output_clk;
    assign digit[6] = char_select == 2'b11 ? output_clk : ~output_clk;
    assign digit[7] = char_select != 2'b11 ? output_clk : ~output_clk;

    assign digit[8] = char_select != 2'b11 ? output_clk : ~output_clk;
    assign digit[9] = (char_select == 2'b00 || char_select == 2'b11) ? output_clk : ~output_clk;
    assign digit[10] = char_select != 2'b01 ? output_clk : ~output_clk;
    assign digit[11] = char_select != 2'b11 ? output_clk : ~output_clk;

    assign digit[12] = char_select != 2'b01 ? output_clk : ~output_clk;
    assign digit[13] = char_select == 2'b01 ? output_clk : ~output_clk;
    assign digit[14] = char_select == 2'b01 ? output_clk : ~output_clk;
    assign digit[15] = char_select != 2'b01 ? output_clk : ~output_clk;

endmodule