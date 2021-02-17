`timescale 1ns / 1ps
module char_pwm_gen
(
    clk, // 100MHz clock input 
    rst,
    char_select,
    digit,
    slow_clk_en,
    clk_out,
    clk_div
);

    //TODO: The clk might need to be divided down to 100MHz if it isn't set to this frequency already

    input clk;
    input rst;
    input [1:0] char_select;
    input slow_clk_en;
    input [31:0] clk_div;

    /*
    00 - A
    01 - J
    10 - N
    11 - X
    */
    output [15:0] digit;

    output clk_out;

    reg [31:0] slow_clk_counter = 0;

    wire output_clk;

    assign output_clk = slow_clk_en ? (
        ( clk_div[31] ? slow_clk_counter[31] :
        ( clk_div[30] ? slow_clk_counter[30] :
        ( clk_div[29] ? slow_clk_counter[29] :
        ( clk_div[28] ? slow_clk_counter[28] :
        ( clk_div[27] ? slow_clk_counter[27] :
        ( clk_div[26] ? slow_clk_counter[26] :
        ( clk_div[25] ? slow_clk_counter[25] :
        ( clk_div[24] ? slow_clk_counter[24] :
        ( clk_div[23] ? slow_clk_counter[23] :
        ( clk_div[22] ? slow_clk_counter[22] :
        ( clk_div[21] ? slow_clk_counter[21] :
        ( clk_div[20] ? slow_clk_counter[20] :
        ( clk_div[19] ? slow_clk_counter[19] :
        ( clk_div[18] ? slow_clk_counter[18] :
        ( clk_div[17] ? slow_clk_counter[17] :
        ( clk_div[16] ? slow_clk_counter[16] :
        ( clk_div[15] ? slow_clk_counter[15] :
        ( clk_div[14] ? slow_clk_counter[14] :
        ( clk_div[13] ? slow_clk_counter[13] :
        ( clk_div[12] ? slow_clk_counter[12] :
        ( clk_div[11] ? slow_clk_counter[11] :
        ( clk_div[10] ? slow_clk_counter[10] :
        ( clk_div[9] ? slow_clk_counter[9] :
        ( clk_div[8] ? slow_clk_counter[8] :
        ( clk_div[7] ? slow_clk_counter[7] :
        ( clk_div[6] ? slow_clk_counter[6] :
        ( clk_div[5] ? slow_clk_counter[5] :
        ( clk_div[4] ? slow_clk_counter[4] :
        ( clk_div[3] ? slow_clk_counter[3] :
        ( clk_div[2] ? slow_clk_counter[2] :
        ( clk_div[1] ? slow_clk_counter[1] :
        slow_clk_counter[0]))))))))))))))))))))))))))))))))
        : clk;

    assign clk_out = output_clk;

    // counter to slow down the clock by 1000000x
    always @(posedge clk, posedge rst)
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