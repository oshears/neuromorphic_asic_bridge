`timescale 1ns / 1ps
module pmod_dac_test_block
#(
    parameter RESOLUTION = 16,
    parameter WAIT_TIME = 5000000
)
(
    // Inputs
    input wire clk,
    input wire rst,

    // PMOD DAC Outputs
    output reg dac_cs_n,
    output reg dac_ldac_n,
    output wire dac_din,
    output wire dac_sclk,

    // LED Outputs
    output wire [3:0] leds,

    // PMOD TEST Outputs
    output wire pmod_out
);

// Controller States
// CS must be enabled to send data
// 16 Clock Pulses + 16 Bits of Data (SPI Mode 0)
// MSB is last bit out
// CS brought high transfers data from shift register to serial input register if LDAC is high
// Pulsing LDAC low then high will asynchronously transfer all data into the DAC register (and onto the SMA connector)
// Can hold LDAC low while bringing CS pin high to directly transfer data from shift register to the DAC register
localparam IDLE_STATE = 0, ENABLE_STATE = 1, DATA_TRANSFER_STATE = 2, DATA_LOAD_STATE = 3, WAIT_STATE = 4;

reg [2:0] current_state = IDLE_STATE;
reg [2:0] next_state = IDLE_STATE;

reg [4:0] data_counter = 0;
reg data_counter_en = 0;
reg data_counter_rst = 0;
reg shift_dout_en = 0;
reg load_shift_dout = 0;

//reg [RESOLUTION - 1 : 0] dout_i;

reg dac_dout_value_cntr_en = 0;
reg [15:0] dac_dout_value_cntr = 16'h0000;

reg [31:0] wait_cntr = 0;
reg wait_cntr_en = 0;
reg wait_cntr_rst = 0;

reg [5:0] slow_clk_cntr = 0;

reg [15:0] dout = 0;

// Wait for 2s
wire wait_cntr_done = (wait_cntr == WAIT_TIME);
wire data_cntr_done = (data_counter == 5'h0F);
wire data_ldac_cntr_done = (data_counter == 5'h11);

assign pmod_out = rst;

wire slow_clk;
//assign slow_clk = slow_clk_cntr[5];

// Output Assignments
assign dac_din = dout[RESOLUTION - 1] || dac_cs_n;
assign dac_sclk = slow_clk;// || ~data_counter_en;

assign leds = dac_dout_value_cntr[15:12];

/*
always @(posedge clk) begin
    slow_clk_cntr <= slow_clk_cntr + 1;
end
*/

always @(negedge slow_clk, posedge rst) begin
    if (wait_cntr_rst || rst) begin
        wait_cntr <= 0;
    end
    else if (wait_cntr_en) begin
        wait_cntr <= wait_cntr + 1;
    end
end

// Data Out Register
// always @(posedge clk, posedge rst) begin
//     if (rst) 
//         dout_i <= 0;
//     else if (load_din)
//         dout_i <= din; 
// end
always @(negedge slow_clk, posedge rst) begin
    if (rst)
        dac_dout_value_cntr <= 0;
    else if (dac_dout_value_cntr_en)
        dac_dout_value_cntr <= dac_dout_value_cntr + 16'h1000;
end

// shift register
always @(negedge slow_clk, posedge rst) begin
    if (rst)
        dout <= 0;
    else if (load_shift_dout)
        dout <= dac_dout_value_cntr;
    else if (shift_dout_en)
        dout <= {dout[RESOLUTION - 2 : 0],dout[15]};
end

// Controller
always @(negedge slow_clk, posedge rst) begin
    if (rst)
        current_state <= IDLE_STATE;
    else
        current_state <= next_state;
end

always @(
    current_state,
    wait_cntr,
    wait_cntr_done,
    data_cntr_done,
    data_ldac_cntr_done
)
begin
    data_counter_en = 0;
    data_counter_rst = 0;
    dac_cs_n = 1;
    dac_ldac_n = 1;
    shift_dout_en = 0;
    load_shift_dout = 0;
    dac_dout_value_cntr_en = 0;
    wait_cntr_en = 0;
    wait_cntr_rst = 0;

    next_state = current_state;
    
    case (current_state)
        IDLE_STATE:
        begin
            next_state = ENABLE_STATE;
            
            load_shift_dout = 1;
        end 
        ENABLE_STATE:
        begin
            dac_cs_n = 0;
            // dac_ldac_n = 0;
            data_counter_rst = 1;
            shift_dout_en = 1;
            
            next_state = DATA_TRANSFER_STATE;
        end
        DATA_TRANSFER_STATE:
        begin
            data_counter_en = 1;
            
            if (data_cntr_done) begin
                shift_dout_en = 0;
                dac_cs_n = 0;
                next_state = DATA_LOAD_STATE; 
            end
            else begin
                dac_cs_n = 0;
                shift_dout_en = 1;
            end
        end
        DATA_LOAD_STATE:
        begin
            data_counter_en = 1;
            if (data_ldac_cntr_done) begin
                data_counter_en = 0;
                dac_ldac_n = 0;
                wait_cntr_rst = 1;
                next_state = WAIT_STATE;
            end
        end
        WAIT_STATE:
        begin
            wait_cntr_en = 1;
            // WAIT for 0.5s
            if (wait_cntr_done) begin
            // DEBUG VALUE
            // if (wait_cntr == 32'h0000_0010) begin
                dac_dout_value_cntr_en = 1;
                next_state = IDLE_STATE;
            end
        end
        default:
            next_state = IDLE_STATE; 
    endcase
end

always @(posedge slow_clk, posedge rst) begin
    if (data_counter_rst || rst)
        data_counter <= 0;
    else if (data_counter_en)
        data_counter <= data_counter + 1; 
end


//vio_0 U_VIO
//(
//    .clk(slow_clk),
//    .probe_in0(dac_sclk),
//    .probe_out0()
//);
ila_0 ila
(
.clk(clk),
.probe0(dac_cs_n),
.probe1(dac_ldac_n),
.probe2(dac_din),
.probe3(dac_sclk),
.probe4(pmod_out),
.probe5(dac_dout_value_cntr),
.probe6(wait_cntr),
.probe7(current_state),
.probe8(data_cntr_done),
.probe9(wait_cntr_done)
);

// 5 MHz Clock
clk_wiz_0 clk_div
(
.clk_in1(clk),
.clk_out1(slow_clk),
.reset(rst),
.locked()
);

endmodule