`timescale 1ns / 1ps
module pmod_dac_block
#(
    parameter RESOLUTION = 16
)
(
    // SoC Inputs
    input wire clk,
    input wire rst,
    input [RESOLUTION - 1:0] din,
    input load_din,
    input start,

    // SoC Outputs
    output reg [RESOLUTION - 1:0] dout,

    // PMOD DAC Outputs
    output reg dac_cs_n,
    output reg dac_ldac_n,
    output wire dac_din,
    output wire dac_sclk
);

// Controller States
// CS must be enabled to send data
// 16 Clock Pulses + 16 Bits of Data (SPI Mode 0)
// MSB is last bit out
// CS brought high transfers data from shift register to serial input register if LDAC is high
// Pulsing LDAC low then high will asynchronously transfer all data into the DAC register (and onto the SMA connector)
// Can hold LDAC low while bringing CS pin high to directly transfer data from shift register to the DAC register
localparam IDLE_STATE = 0, ENABLE_STATE = 1, DATA_TRANSFER_STATE = 2;

reg [1:0] current_state = 0;
reg [1:0] next_state = 0;

reg [3:0] data_counter = 0;
reg data_counter_en = 0;
reg data_counter_rst = 0;
reg shift_dout_en = 0;

// Output Assignments
assign dac_din = dout[0];
assign dac_sclk = clk && data_counter_en;

// Data Out Register
always @(posedge clk, posedge rst) begin
    if (rst) 
        dout <= 0;
    else if (load_din)
        dout <= din; 
    else if (shift_dout_en)
        dout <= {dout[0],dout[RESOLUTION - 1 : 1]};
end

// Controller
always @(posedge clk, posedge rst) begin
    if (rst)
        current_state <= IDLE_STATE;
    else
        current_state <= next_state;
end

always @(
    current_state,
    data_counter,
    start
)
begin
    data_counter_en = 0;
    data_counter_rst = 0;
    dac_cs_n = 1;
    // dac_din = 0;
    dac_ldac_n = 1;
    // dac_sclk = 0;
    shift_dout_en = 0;

    case (current_state)
        IDLE_STATE:
        begin
            if (start)
                next_state = ENABLE_STATE;
        end 
        ENABLE_STATE:
        begin
            dac_cs_n = 0;
            dac_ldac_n = 0;
            data_counter_rst = 1;
            next_state = DATA_TRANSFER_STATE;
        end
        DATA_TRANSFER_STATE:
        begin
            dac_cs_n = 0;
            dac_ldac_n = 0;
            data_counter_en = 1;
            shift_dout_en = 1;
            if (data_counter == 4'hF) begin
                dac_cs_n = 1;
                next_state = IDLE_STATE; 
            end
        end
        default:
            next_state = IDLE_STATE; 
    endcase
end

always @(posedge clk) begin
    if (data_counter_en)
        data_counter = data_counter + 1; 
end


endmodule