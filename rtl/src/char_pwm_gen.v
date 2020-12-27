//`timescale 1ns / 1ps

module char_pwm_gen
(
    clk, // 100MHz clock input 
    char_select,
    digit
);

    input clk;
    input [1:0] char_select;

    /*
    00 - A
    01 - J
    10 - N
    11 - X
    */
    output [15:0] digit;

    assign digit[0] = char_select != 2'b01 ? clk : ~clk;
    assign digit[1] = char_select == 2'b00 ? clk : ~clk;
    assign digit[2] = char_select == 2'b00 ? clk : ~clk;
    assign digit[3] = clk;

    assign digit[4] = char_select[0] ? clk : ~clk;
    assign digit[5] = char_select[1] ? clk : ~clk;
    assign digit[6] = char_select == 2'b11 ? clk : ~clk;
    assign digit[7] = char_select != 2'b11 ? clk : ~clk;

    assign digit[8] = char_select != 2'b11 ? clk : ~clk;
    assign digit[9] = (char_select == 2'b00 || char_select == 2'b11) ? clk : ~clk;
    assign digit[10] = char_select != 2'b01 ? clk : ~clk;
    assign digit[11] = char_select != 2'b11 ? clk : ~clk;

    assign digit[12] = char_select != 2'b01 ? clk : ~clk;
    assign digit[13] = char_select == 2'b01 ? clk : ~clk;
    assign digit[14] = char_select == 2'b01 ? clk : ~clk;
    assign digit[15] = char_select != 2'b01 ? clk : ~clk;

endmodule