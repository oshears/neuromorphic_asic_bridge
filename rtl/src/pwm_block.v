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

reg max_pwm_count = 0;

wire output_clk;
// wire pwm_clk_i;

assign clk_out = output_clk;
assign output_clk = (pwm_clk_counter > duty_cycle) ? 1'b0 : 1'b1;

// assign pwm_clk_i = pwm_clk_counter[clk_div[4:0]];

always @(clk_div) begin
    case(clk_div)
        5'h1F:
        begin
            max_pwm_count = 32'h8000_0000;
        end
        5'h1E:
        begin
            max_pwm_count = 32'h4000_0000;
        end
        5'h1D:
        begin
            max_pwm_count = 32'h2000_0000;
        end
        5'h1C:
        begin
            max_pwm_count = 32'h1000_0000;
        end
        5'h1B:
        begin
            max_pwm_count = 32'h0800_0000;
        end
        5'h1A:
        begin
            max_pwm_count = 32'h0400_0000;
        end
        5'h19:
        begin
            max_pwm_count = 32'h0200_0000;
        end
        5'h18:
        begin
            max_pwm_count = 32'h0100_0000;
        end
        5'h17:
        begin
            max_pwm_count = 32'h0080_0000;
        end
        5'h16:
        begin
            max_pwm_count = 32'h0040_0000;
        end
        5'h15:
        begin
            max_pwm_count = 32'h0020_0000;
        end
        5'h14:
        begin
            max_pwm_count = 32'h0010_0000;
        end
        5'h13:
        begin
            max_pwm_count = 32'h0008_0000;
        end
        5'h12:
        begin
            max_pwm_count = 32'h0004_0000;
        end
        5'h11:
        begin
            max_pwm_count = 32'h0002_0000;
        end
        5'h10:
        begin
            max_pwm_count = 32'h0001_0000;
        end
        5'h0F:
        begin
            max_pwm_count = 32'h0000_8000;
        end
        5'h0E:
        begin
            max_pwm_count = 32'h0000_4000;
        end
        5'h0D:
        begin
            max_pwm_count = 32'h0000_2000;
        end
        5'h0C:
        begin
            max_pwm_count = 32'h0000_1000;
        end
        5'h0B:
        begin
            max_pwm_count = 32'h0000_0800;
        end
        5'h0A:
        begin
            max_pwm_count = 32'h0000_0400;
        end
        5'h09:
        begin
            max_pwm_count = 32'h0000_0200;
        end
        5'h08:
        begin
            max_pwm_count = 32'h0000_0100;
        end
        5'h07:
        begin
            max_pwm_count = 32'h0000_0080;
        end
        5'h06:
        begin
            max_pwm_count = 32'h0000_0040;
        end
        5'h05:
        begin
            max_pwm_count = 32'h0000_0020;
        end
        5'h04:
        begin
            max_pwm_count = 32'h0000_0010;
        end
        5'h03:
        begin
            max_pwm_count = 32'h0000_0008;
        end
        5'h02:
        begin
            max_pwm_count = 32'h0000_0004;
        end
        5'h01:
        begin
            max_pwm_count = 32'h0000_0002;
        end
        5'h00:
        begin
            max_pwm_count = 32'h0000_0001;
        end
        default:
        begin
        end
    endcase
end

always @(posedge clk, posedge rst)
begin
    if(rst)
        pwm_clk_counter <= 0;
    else if (   pwm_clk_counter <= max_pwm_count )
        pwm_clk_counter <= pwm_clk_counter + 1;
    else
        pwm_clk_counter <= 0;
end

endmodule