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
    VAUXP,
    VAUXN,
    VN,
    VP,

    //Analog Signal Control
    VAUX_SEL,

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
input [15:0] VAUXP, VAUXN;
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

output [3:0] VAUX_SEL;

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

assign RESET = ~S_AXI_ARESETN;

assign leds[0] = debug[0] ? (digit[0]) : (debug[1] ? (direct_ctrl[0] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : ((network_output == 2'b00) ? 1'b1 : 1'b0));
assign leds[1] = debug[0] ? (digit[1]) : (debug[1] ? (direct_ctrl[1] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : ((network_output == 2'b01) ? 1'b1 : 1'b0));
assign leds[2] = debug[0] ? (digit[2]) : (debug[1] ? (direct_ctrl[2] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : ((network_output == 2'b10) ? 1'b1 : 1'b0));
assign leds[3] = debug[0] ? (digit[3]) : (debug[1] ? (direct_ctrl[3] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : ((network_output == 2'b11) ? 1'b1 : 1'b0));
assign leds[4] = debug[0] ? (digit[4]) : (debug[1] ? (direct_ctrl[4] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : (1'b0));
assign leds[5] = debug[0] ? (digit[5]) : (debug[1] ? (direct_ctrl[5] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : (1'b0));
assign leds[6] = debug[0] ? (digit[6]) : (debug[1] ? (direct_ctrl[6] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : (1'b0));
assign leds[7] = debug[0] ? (digit[7]) : (debug[1] ? (direct_ctrl[7] ? char_pwm_gen_clk_out : ~char_pwm_gen_clk_out) : (1'b0));

assign digit = debug[2] ? direct_ctrl : digit_temp;

char_pwm_gen char_pwm_gen(
    .clk(pwm_clk),
    .rst(RESET),
    .char_select(char_select),
    .digit(digit_temp),
    .slow_clk_en(debug[3]),
    .clk_out(char_pwm_gen_clk_out)
    );

axi_cfg_regs 
#(
    C_S_AXI_ACLK_FREQ_HZ,
    C_S_AXI_DATA_WIDTH,
    C_S_AXI_ADDR_WIDTH
)
axi_cfg_regs
(
    // System Signals
    .clk(S_AXI_ACLK),
    .rst(RESET),
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
    .MEASURED_AUX3(MEASURED_AUX3),
    .VAUX_SEL(VAUX_SEL)
);

XADC #(// Initializing the XADC Control Registers
    .INIT_40(16'h0000),
    .INIT_41(16'h2000),// Continuous Seq Mode
    .INIT_42(16'h0400),// Set DCLK divides
    .INIT_48(16'h0800),// CHSEL1 - enable aux analog channels 0 - 3
    .INIT_49(16'hffff),// CHSEL2 - enable aux analog channels 0 - 3
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
    .VAUXN  (VAUXN ),
    .VAUXP  (VAUXP ),
    .BUSY   (BUSY),
    .DO     (DO),
    .DRDY   (DRDY),
    .EOS    (EOS),
    .VP     (VP),
    .VN     (VN),
    .ALM(),
    .CHANNEL(),
    .EOC(),
    .JTAGBUSY(),
    .JTAGLOCKED(),
    .JTAGMODIFIED(),
    .MUXADDR(),
    .OT()
);



endmodule