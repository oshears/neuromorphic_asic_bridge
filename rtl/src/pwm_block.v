`timescale 1ns / 1ps
module pwm_blk
#(
    parameter COUNTER_WIDTH = 32
)
(
    input wire clk,
    input wire rst,
    input wire [31:0] duty_cycle,
    input wire [31:0] clk_div,
    output wire clk_out,
    output reg [31:0] pwm_clk_counter = 0
);

wire output_clk;
// wire pwm_clk_i;

assign clk_out = output_clk;
assign output_clk = (pwm_clk_counter > duty_cycle) ? 1'b0 : 1'b1;

// assign pwm_clk_i = pwm_clk_counter[clk_div[4:0]];

always @(posedge clk, posedge rst)
begin
    if(rst)
        pwm_clk_counter <= 0;
    else if (   (clk_div[4:0] == 5'h1F && pwm_clk_counter <= 32'h8000_0000) ||
                (clk_div[4:0] == 5'h1E && pwm_clk_counter <= 32'h4000_0000) ||
                (clk_div[4:0] == 5'h1D && pwm_clk_counter <= 32'h2000_0000) ||
                (clk_div[4:0] == 5'h1C && pwm_clk_counter <= 32'h1000_0000) ||
                (clk_div[4:0] == 5'h1B && pwm_clk_counter <= 32'h0800_0000) ||
                (clk_div[4:0] == 5'h1A && pwm_clk_counter <= 32'h0400_0000) ||
                (clk_div[4:0] == 5'h19 && pwm_clk_counter <= 32'h0200_0000) ||
                (clk_div[4:0] == 5'h18 && pwm_clk_counter <= 32'h0100_0000) ||
                (clk_div[4:0] == 5'h17 && pwm_clk_counter <= 32'h0080_0000) ||
                (clk_div[4:0] == 5'h16 && pwm_clk_counter <= 32'h0040_0000) ||
                (clk_div[4:0] == 5'h15 && pwm_clk_counter <= 32'h0020_0000) ||
                (clk_div[4:0] == 5'h14 && pwm_clk_counter <= 32'h0010_0000) ||
                (clk_div[4:0] == 5'h13 && pwm_clk_counter <= 32'h0008_0000) ||
                (clk_div[4:0] == 5'h12 && pwm_clk_counter <= 32'h0004_0000) ||
                (clk_div[4:0] == 5'h11 && pwm_clk_counter <= 32'h0002_0000) ||
                (clk_div[4:0] == 5'h10 && pwm_clk_counter <= 32'h0001_0000) ||
                (clk_div[4:0] == 5'h0F && pwm_clk_counter <= 32'h0000_8000) ||
                (clk_div[4:0] == 5'h0E && pwm_clk_counter <= 32'h0000_4000) ||
                (clk_div[4:0] == 5'h0D && pwm_clk_counter <= 32'h0000_2000) ||
                (clk_div[4:0] == 5'h0C && pwm_clk_counter <= 32'h0000_1000) ||
                (clk_div[4:0] == 5'h0B && pwm_clk_counter <= 32'h0000_0800) ||
                (clk_div[4:0] == 5'h0A && pwm_clk_counter <= 32'h0000_0400) ||
                (clk_div[4:0] == 5'h09 && pwm_clk_counter <= 32'h0000_0200) ||
                (clk_div[4:0] == 5'h08 && pwm_clk_counter <= 32'h0000_0100) ||
                (clk_div[4:0] == 5'h07 && pwm_clk_counter <= 32'h0000_0080) ||
                (clk_div[4:0] == 5'h06 && pwm_clk_counter <= 32'h0000_0040) ||
                (clk_div[4:0] == 5'h05 && pwm_clk_counter <= 32'h0000_0020) ||
                (clk_div[4:0] == 5'h04 && pwm_clk_counter <= 32'h0000_0010) ||
                (clk_div[4:0] == 5'h03 && pwm_clk_counter <= 32'h0000_0008) ||
                (clk_div[4:0] == 5'h02 && pwm_clk_counter <= 32'h0000_0004) ||
                (clk_div[4:0] == 5'h01 && pwm_clk_counter <= 32'h0000_0002) ||
                (clk_div[4:0] == 5'h00 && pwm_clk_counter <= 32'h0000_0001) 
            )
        pwm_clk_counter <= pwm_clk_counter + 1;
    else
        pwm_clk_counter <= 0;
end

endmodule