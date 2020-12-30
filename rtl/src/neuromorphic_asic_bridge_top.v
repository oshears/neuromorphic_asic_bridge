`timescale 1ns / 1ps
module neuromorphic_asic_bridge_top
#(
parameter C_FAMILY = "virtex7",
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
    VP, 
    VN
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
input [3:0] VAUXP, VAUXN;
input VP; 
input VN;

output [15:0] digit;

output S_AXI_AWREADY; 
output S_AXI_ARREADY; 
output S_AXI_WREADY;  
output [C_S_AXI_DATA_WIDTH - 1:0] S_AXI_RDATA;
output [1:0] S_AXI_RRESP;
output S_AXI_RVALID;  
output [1:0] S_AXI_BRESP;
output S_AXI_BVALID;  




wire [1:0] char_select;
wire [1:0] network_output;
wire [31:0] xadc_config;

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

wire [15:0] vauxp_active;
wire [15:0] vauxn_active;
assign vauxp_active = {12'h000, VAUXP[3:0]};
assign vauxn_active = {12'h000, VAUXN[3:0]};

assign RESET = ~S_AXI_ARESETN;

char_pwm_gen char_pwm_gen(
    .clk(pwm_clk),
    .char_select(char_select),
    .digit(digit)
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
    // XADC Configuration
    .xadc_config(xadc_config),
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
    .xadc_config(xadc_config),
    .network_output(network_output),
    .DADDR(DADDR),
    .DEN(DEN),
    .DI(DI),
    .DWE(DWE),
    .BUSY(BUSY),
    .DO(DO),
    .DRDY(DRDY),
    .EOS(EOS)
);

XADC #(// Initializing the XADC Control Registers
    .INIT_41(16'h2000),// Continuous Seq Mode
    .INIT_42(16'h0400),// Set DCLK divides
    .INIT_49(16'h000f),// CHSEL2 - enable aux analog channels 0 - 3
    .SIM_MONITOR_FILE("design.txt")// Analog Stimulus file for simulation
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
    .VAUXN  (vauxn_active ),
    .VAUXP  (vauxp_active ),
    .BUSY   (BUSY),
    .DO     (DO),
    .DRDY   (DRDY),
    .EOS    (EOS),
    .VP     (VP),
    .VN     (VN)
);



endmodule