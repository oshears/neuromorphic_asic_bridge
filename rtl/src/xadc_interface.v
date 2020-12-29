module xadc_interface
(
    clk, 
    rst,
    xadc_config,
    network_output,

    //XADC Interface Signals
    CONVST,
    CONVSTCLK,
    DADDR,
    DCLK,
    DEN,
    DI,
    DWE,
    RESET,
    BUSY,
    CHANNEL,
    DO,
    DRDY,
    EOC,
    EOS,
    MUXADDR
);

input clk;
input rst;
input [31:0] xadc_config;

input BUSY;
input [4:0] CHANNEL;
input [15:0] DO;
input DRDY;
input EOC;
input EOS;
input [4:0] MUXADDR;

output [1:0] network_output;

output reg CONVST;
output reg CONVSTCLK;
output reg [6:0] DADDR;
output reg DCLK;
output reg DEN;
output reg [15:0] DI;
output reg DWE;


reg [31:0] counter;

parameter reset = 0, config_reg_0 = 1, config_reg_1 = 2, config_reg_2 = 3, done = 4;

reg [2:0] next_state;
reg [2:0] current_state;


assign network_output = DO[1:0];

always @(posedge clk)
begin
    if (rst)
        counter = 0;
    else
        counter = counter + 1;
end

always @(posedge clk)
begin
    if (rst)
        current_state = reset;
    else
        current_state = next_state;
end

always @(counter)
begin
    CONVST = 0;
    CONVSTCLK = 0;
    DADDR = 0;
    DCLK = 0;
    DEN = 0;
    DI = 0;
    DWE = 0;

    case (current_state)
        reset:
            next_state = config_reg_0;
        config_reg_0:
        begin
            DADDR = 7'h40;
            DEN = 1;
            DI = 16'h0000;
            DWE = 1;

            if (counter > 20)
                next_state = config_reg_1;
        end
        config_reg_1:
        begin
            DADDR = 7'h41;
            DEN = 1;
            DI = 16'h0000;
            DWE = 1;

            if (counter > 40)
                next_state = config_reg_2;
        end
        config_reg_2:
        begin
            DADDR = 7'h42;
            DEN = 1;
            DI = 16'h0000;
            DWE = 1;

            if (counter > 60)
                next_state = done;
        end
        done:
        begin
            // Temperature Sensor
            DADDR = 7'h00;
            // V_P / V_N Measurement
            // DADDR = 7'h03;
            DEN = 1;
        end
    endcase 
end

endmodule