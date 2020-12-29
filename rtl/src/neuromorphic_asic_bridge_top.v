module neuromorphic_asic_bridge_top
(
    clk, // clock input 
    rst,

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

    // xadc signals
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
input pwm_clk;

input S_AXI_ACLK;   
input S_AXI_ARESETN;
input [31:0] S_AXI_AWADDR; 
input S_AXI_AWVALID;
input [31:0] S_AXI_ARADDR; 
input S_AXI_ARVALID;
input [31:0] S_AXI_WDATA;  
input [3:0] S_AXI_WSTRB;  
input S_AXI_WVALID; 
input S_AXI_RREADY; 
input S_AXI_BREADY; 

// XADC Inputs
input BUSY;
input [4:0] CHANNEL;
input [15:0] DO;
input DRDY;
input EOC;
input EOS;
input [4:0] MUXADDR;

output [15:0] digit;

output S_AXI_AWREADY; 
output S_AXI_ARREADY; 
output S_AXI_WREADY;  
output [31:0] S_AXI_RDATA;
output [1:0] S_AXI_RRESP;
output S_AXI_RVALID;  
output [1:0] S_AXI_BRESP;
output S_AXI_BVALID;  

// XADC Outputs
output CONVST;
output CONVSTCLK;
output [6:0] DADDR;
output DCLK;
output DEN;
output [15:0] DI;
output DWE;
output RESET;

wire [1:0] char_select;
wire [1:0] network_output;
wire [31:0] xadc_config;

assign RESET = rst;

char_pwm_gen char_pwm_gen(
    .clk(pwm_clk),
    .char_select(char_select),
    .digit(digit)
    );

axi_cfg_regs axi_cfg_regs(
    // System Signals
    .clk(clk),
    .rst(rst),
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
    .clk(clk), 
    .rst(rst),
    .xadc_config(xadc_config),
    .network_output(network_output),
    .CONVST(CONVST),
    .CONVSTCLK(CONVSTCLK),
    .DADDR(DADDR),
    .DCLK(DCLK),
    .DEN(DEN),
    .DI(DI),
    .DWE(DWE),
    .BUSY(BUSY),
    .CHANNEL(CHANNEL),
    .DO(DO),
    .DRDY(DRDY),
    .EOC(EOC),
    .EOS(EOS),
    .MUXADDR(MUXADDR)
);

endmodule