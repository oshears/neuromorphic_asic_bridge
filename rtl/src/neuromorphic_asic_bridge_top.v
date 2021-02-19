`timescale 1ns / 1ps
module neuromorphic_asic_bridge_top
#(
parameter C_S_AXI_ACLK_FREQ_HZ = 100000000,
parameter C_S_AXI_DATA_WIDTH = 32,
parameter C_S_AXI_ADDR_WIDTH = 9 
)
(
    // char_pwm_gen
    pwm_clk, // 100MHz pwm clock input 
    digit,

    // axi_cfg_regs
    S_AXI_ACLK,     
    S_AXI_ARESETN,  
    S_AXI_AWADDR,   
    S_AXI_AWVALID,  
    S_AXI_AWREADY,  
    S_AXI_ARADDR,   
    S_AXI_ARVALID,  
    S_AXI_ARREADY,  
    S_AXI_WDATA,    
    S_AXI_WSTRB,    
    S_AXI_WVALID,   
    S_AXI_WREADY,   
    S_AXI_RDATA,    
    S_AXI_RRESP,    
    S_AXI_RVALID,   
    S_AXI_RREADY,   
    S_AXI_BRESP,    
    S_AXI_BVALID,   
    S_AXI_BREADY,   

    // asic_output_analyzer

    //XADC
    VN,
    VP,

    //Analog Signal Control
    XADC_MUXADDR,

    // led outputs
    leds    
);



input pwm_clk;

input S_AXI_ACLK;   
input S_AXI_ARESETN;
input [C_S_AXI_ADDR_WIDTH - 1:0] S_AXI_AWADDR; 
input S_AXI_AWVALID;
input [C_S_AXI_ADDR_WIDTH - 1:0] S_AXI_ARADDR; 
input S_AXI_ARVALID;
input [C_S_AXI_DATA_WIDTH - 1:0] S_AXI_WDATA;  
input [(C_S_AXI_DATA_WIDTH/8)-1:0] S_AXI_WSTRB;  
input S_AXI_WVALID; 
input S_AXI_RREADY; 
input S_AXI_BREADY; 

// XADC Inputs
input VN, VP;

output [15:0] digit;

output S_AXI_AWREADY; 
output S_AXI_ARREADY; 
output S_AXI_WREADY;  
output [C_S_AXI_DATA_WIDTH - 1:0] S_AXI_RDATA;
output [1:0] S_AXI_RRESP;
output S_AXI_RVALID;  
output [1:0] S_AXI_BRESP;
output S_AXI_BVALID;  

output [7:0] leds;

output [3:0] XADC_MUXADDR;

wire [1:0] char_select;
wire [1:0] network_output;
wire [31:0] debug;
wire [15:0] direct_ctrl;

wire BUSY;
wire [15:0] DO;
wire DRDY;
wire EOS;

// XADC Outputs
wire [6:0] DADDR;
wire DEN;
wire [15:0] DI;
wire DWE;
wire RESET;

wire [15:0] digit_temp;

wire char_pwm_gen_clk_out;

wire [11:0] MEASURED_AUX0;
wire [11:0] MEASURED_AUX1;
wire [11:0] MEASURED_AUX2;
wire [11:0] MEASURED_AUX3;

wire [4:0] XADC_MUXADDR_local;

wire [31:0] pwm_clk_div;

wire [31:0] pwm_blk_duty_cycle;
wire pwm_blk_clk_out_i;
wire [31:0] pwm_clk_counter;

assign XADC_MUXADDR[0] = debug[4] ? ((XADC_MUXADDR_local[1:0] == 2'b00) ? 1'b1 : 1'b0): XADC_MUXADDR_local[0];
assign XADC_MUXADDR[1] = debug[4] ? ((XADC_MUXADDR_local[1:0] == 2'b01) ? 1'b1 : 1'b0): XADC_MUXADDR_local[1];
assign XADC_MUXADDR[2] = debug[4] ? ((XADC_MUXADDR_local[1:0] == 2'b10) ? 1'b1 : 1'b0): XADC_MUXADDR_local[2];
assign XADC_MUXADDR[3] = debug[4] ? ((XADC_MUXADDR_local[1:0] == 2'b11) ? 1'b1 : 1'b0): debug[5];

assign RESET = ~S_AXI_ARESETN;

assign leds[0] = debug[0] ? (digit[0]) : (debug[1] ? (direct_ctrl[0] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : ((network_output == 2'b00) ? 1'b1 : 1'b0));
assign leds[1] = debug[0] ? (digit[1]) : (debug[1] ? (direct_ctrl[1] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : ((network_output == 2'b01) ? 1'b1 : 1'b0));
assign leds[2] = debug[0] ? (digit[2]) : (debug[1] ? (direct_ctrl[2] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : ((network_output == 2'b10) ? 1'b1 : 1'b0));
assign leds[3] = debug[0] ? (digit[3]) : (debug[1] ? (direct_ctrl[3] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : ((network_output == 2'b11) ? 1'b1 : 1'b0));
assign leds[4] = debug[0] ? (digit[4]) : (debug[1] ? (direct_ctrl[4] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : (1'b0));
assign leds[5] = debug[0] ? (digit[5]) : (debug[1] ? (direct_ctrl[5] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : (1'b0));
assign leds[6] = debug[0] ? (digit[6]) : (debug[1] ? (direct_ctrl[6] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : (1'b0));
assign leds[7] = debug[0] ? (digit[7]) : (debug[1] ? (direct_ctrl[7] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : (1'b0));

assign digit[0] = debug[6] ? pwm_blk_clk_out_i : (debug[2] ? (direct_ctrl[0] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : digit_temp[0]);
assign digit[1] = debug[2] ? (direct_ctrl[1] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : digit_temp[1];
assign digit[2] = debug[2] ? (direct_ctrl[2] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : digit_temp[2];
assign digit[3] = debug[2] ? (direct_ctrl[3] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : digit_temp[3];
assign digit[4] = debug[2] ? (direct_ctrl[4] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : digit_temp[4];
assign digit[5] = debug[2] ? (direct_ctrl[5] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : digit_temp[5];
assign digit[6] = debug[2] ? (direct_ctrl[6] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : digit_temp[6];
assign digit[7] = debug[2] ? (direct_ctrl[7] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : digit_temp[7];
assign digit[8] = debug[2] ? (direct_ctrl[8] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : digit_temp[8];
assign digit[9] = debug[2] ? (direct_ctrl[9] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : digit_temp[9];
assign digit[10] = debug[2] ? (direct_ctrl[10] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : digit_temp[10];
assign digit[11] = debug[2] ? (direct_ctrl[11] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : digit_temp[11];
assign digit[12] = debug[2] ? (direct_ctrl[12] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : digit_temp[12];
assign digit[13] = debug[2] ? (direct_ctrl[13] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : digit_temp[13];
assign digit[14] = debug[2] ? (direct_ctrl[14] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : digit_temp[14];
assign digit[15] = debug[2] ? (direct_ctrl[15] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : digit_temp[15];

char_pwm_gen char_pwm_gen(
    .clk(pwm_clk),
    .rst(RESET),
    .char_select(char_select),
    .digit(digit_temp),
    .slow_clk_en(debug[3]),
    .clk_out(char_pwm_gen_clk_out),
    .clk_div(pwm_clk_div)
    );

pwm_blk
#(
    .COUNTER_WIDTH(32)
)
pwm_blk
(
    .clk(pwm_clk),
    .rst(RESET),
    .duty_cycle(pwm_blk_duty_cycle),
    .clk_div(pwm_clk_div),
    .clk_out(pwm_blk_clk_out_i),
    .pwm_clk_counter(pwm_clk_counter)
);

axi_cfg_regs 
#(
    C_S_AXI_ACLK_FREQ_HZ,
    C_S_AXI_DATA_WIDTH,
    C_S_AXI_ADDR_WIDTH
)
axi_cfg_regs
(
    // Character Selection
    .char_select(char_select),
    // Network Output
    .network_output(network_output),
    .MEASURED_AUX0(MEASURED_AUX0),
    .MEASURED_AUX1(MEASURED_AUX1),
    .MEASURED_AUX2(MEASURED_AUX2),
    .MEASURED_AUX3(MEASURED_AUX3),
    // Debug Register Output
    .debug(debug),
    // Direct Control Output
    .direct_ctrl(direct_ctrl),
    // Clock Divider Output
    .pwm_clk_div(pwm_clk_div),
    // PWM Block Duty Cycle Control
    .pwm_blk_duty_cycle(pwm_blk_duty_cycle),
    // PWM Block Clock Counter
    .pwm_clk_counter(pwm_clk_counter),
    //AXI Signals
    .S_AXI_ACLK(S_AXI_ACLK),     
    .S_AXI_ARESETN(S_AXI_ARESETN),  
    .S_AXI_AWADDR(S_AXI_AWADDR),   
    .S_AXI_AWVALID(S_AXI_AWVALID),  
    .S_AXI_AWREADY(S_AXI_AWREADY),  
    .S_AXI_ARADDR(S_AXI_ARADDR),   
    .S_AXI_ARVALID(S_AXI_ARVALID),  
    .S_AXI_ARREADY(S_AXI_ARREADY),  
    .S_AXI_WDATA(S_AXI_WDATA),    
    .S_AXI_WSTRB(S_AXI_WSTRB),    
    .S_AXI_WVALID(S_AXI_WVALID),   
    .S_AXI_WREADY(S_AXI_WREADY),   
    .S_AXI_RDATA(S_AXI_RDATA),    
    .S_AXI_RRESP(S_AXI_RRESP),    
    .S_AXI_RVALID(S_AXI_RVALID),   
    .S_AXI_RREADY(S_AXI_RREADY),   
    .S_AXI_BRESP(S_AXI_BRESP),    
    .S_AXI_BVALID(S_AXI_BVALID),   
    .S_AXI_BREADY(S_AXI_BREADY)   
);

xadc_interface xadc_interface(
    .clk(S_AXI_ACLK), 
    .rst(RESET),
    .network_output(network_output),
    .DADDR(DADDR),
    .DEN(DEN),
    .DI(DI),
    .DWE(DWE),
    .BUSY(BUSY),
    .DO(DO),
    .DRDY(DRDY),
    .EOS(EOS),
    .MEASURED_AUX0(MEASURED_AUX0),
    .MEASURED_AUX1(MEASURED_AUX1),
    .MEASURED_AUX2(MEASURED_AUX2),
    .MEASURED_AUX3(MEASURED_AUX3)
);

XADC #(// Initializing the XADC Control Registers
    .INIT_40(16'hB903), // Multiplexer Input on VP/VN Channel, 256 sample averaging and settling (acquisition) time 
    .INIT_41(16'h20F0),// Continuous Seq Mode, Calibrate ADC and Supply Sensor
    .INIT_42(16'h3F00),// Set DCLK divides
    .INIT_49(16'h000F),// CHSEL2 - enable aux analog channels 0 - 3
    .INIT_4B(16'h000F), // enable averaging
    .INIT_4F(16'h000F), // enable settling time
    .SIM_MONITOR_FILE("design.txt"),// Analog Stimulus file for simulation
    .SIM_DEVICE("ZYNQ")
)
XADC_INST (// Connect up instance IO. See UG480 for port descriptions
    .CONVST (1'b0),// not used
    .CONVSTCLK  (1'b0), // not used
    .DADDR  (DADDR),
    .DCLK   (S_AXI_ACLK),
    .DEN    (DEN),
    .DI     (DI),
    .DWE    (DWE),
    .RESET  (RESET),
    .BUSY   (BUSY),
    .DO     (DO),
    .DRDY   (DRDY),
    .EOS    (EOS),
    .VP     (VP),
    .VN     (VN),
    .VAUXP(16'b0),
    .VAUXN(16'b0),
    .ALM(),
    .CHANNEL(),
    .EOC(),
    .JTAGBUSY(),
    .JTAGLOCKED(),
    .JTAGMODIFIED(),
    .MUXADDR(XADC_MUXADDR_local),
    .OT()
);



endmodule