`timescale 1ns / 1ps
module pmod_dac_test_block_tb;
// Inputs
reg clk;
reg rst;

wire dac_cs_n;
wire dac_ldac_n;
wire dac_din;
wire dac_sclk;

wire [3:0] leds;

pmod_dac_test_block #(16) uut
(
    // Inputs
    .clk(clk),
    .rst(rst),

    // PMOD DAC Outputs
    .dac_cs_n(dac_cs_n),
    .dac_ldac_n(dac_ldac_n),
    .dac_din(dac_din),
    .dac_sclk(dac_sclk),

    // LED Outputs
    .leds(leds)
);

// Create 100Mhz clock
initial begin
clk = 0;
forever #1 clk = ~clk;
end 

initial begin
    rst = 1;
    #10;
    rst = 0;

    #100;

    $finish;

end

endmodule