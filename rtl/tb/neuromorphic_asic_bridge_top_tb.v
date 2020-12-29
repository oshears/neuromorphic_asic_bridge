`timescale 1ns / 1ps
module neuromorphic_asic_bridge_top_tb;
// Inputs
reg clk;
reg rst;
reg pwm_clk;
wire [15:0] digit;

wire S_AXI_ACLK;

reg [3:0] VAUXP, VAUXN;
   
reg S_AXI_ARESETN;
reg [31:0] S_AXI_AWADDR; 
reg S_AXI_AWVALID;
reg [31:0] S_AXI_ARADDR; 
reg S_AXI_ARVALID;
reg [31:0] S_AXI_WDATA;  
reg [3:0] S_AXI_WSTRB;  
reg S_AXI_WVALID; 
reg S_AXI_RREADY; 
reg S_AXI_BREADY; 
wire S_AXI_AWREADY; 
wire S_AXI_ARREADY; 
wire S_AXI_WREADY;  
wire [31:0] S_AXI_RDATA;
wire [1:0] S_AXI_RRESP;
wire S_AXI_RVALID;  
wire [1:0] S_AXI_BRESP;
wire S_AXI_BVALID;  

integer i = 0;


neuromorphic_asic_bridge_top uut(
.clk(clk), 
.rst(rst),
.pwm_clk(pwm_clk), 
.digit(digit),
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
.S_AXI_BREADY(S_AXI_BREADY), 
.VAUXP(VAUXP),
.VAUXN(VAUXN)
);

// Create 100Mhz clock
initial begin
pwm_clk = 0;
forever #10 pwm_clk = ~pwm_clk;
end 

initial begin
clk = 0;
forever #1 clk = ~clk;
end 

assign S_AXI_ACLK = clk;

initial begin
    S_AXI_ARESETN = 0;
    S_AXI_AWADDR = 0;
    S_AXI_AWVALID = 0;
    S_AXI_ARADDR = 0;
    S_AXI_ARVALID = 0;
    S_AXI_WDATA = 0;
    S_AXI_WSTRB = 0;
    S_AXI_WVALID = 0;
    S_AXI_RREADY = 0;
    S_AXI_BREADY = 0;

    rst = 1;
    #20;

    rst = 0;
    S_AXI_ARESETN = 1;
    #10;

    /* Write Reg Tests */
    S_AXI_AWADDR = 32'h0000;
    S_AXI_AWVALID = 1'b1;
    S_AXI_WVALID = 1;
    S_AXI_WDATA = 32'hDEADBEEF;
    S_AXI_BREADY = 1'b1;
    #10;
    S_AXI_WVALID = 0;
    S_AXI_AWVALID = 0;
    #10;

    S_AXI_AWADDR = 32'h0004;
    S_AXI_AWVALID = 1'b1;
    S_AXI_WVALID = 1;
    S_AXI_WDATA = 32'hDEADBEEF;
    S_AXI_BREADY = 1'b1;
    #10;
    S_AXI_WVALID = 0;
    S_AXI_AWVALID = 0;
    #10;

    S_AXI_AWADDR = 32'h0008;
    S_AXI_AWVALID = 1'b1;
    S_AXI_WVALID = 1;
    S_AXI_WDATA = 32'hDEADBEEF;
    S_AXI_BREADY = 1'b1;
    #10;
    S_AXI_WVALID = 0;
    S_AXI_AWVALID = 0;
    #10;

    /* Read Reg Tests */
    S_AXI_ARADDR = 32'h0000;
    S_AXI_ARVALID = 1'b1;
    S_AXI_BREADY = 1'b1;
    S_AXI_RREADY = 1'b1;
    #10;
    S_AXI_ARVALID = 0;
    S_AXI_RREADY = 0;
    #10;

    S_AXI_ARADDR = 32'h0004;
    S_AXI_ARVALID = 1'b1;
    S_AXI_BREADY = 1'b1;
    S_AXI_RREADY = 1'b1;
    #10;
    S_AXI_ARVALID = 0;
    S_AXI_RREADY = 0;
    #10;

    S_AXI_ARADDR = 32'h0008;
    S_AXI_ARVALID = 1'b1;
    S_AXI_BREADY = 1'b1;
    S_AXI_RREADY = 1'b1;
    #10;
    S_AXI_ARVALID = 0;
    S_AXI_RREADY = 0;
    #10;

    // Wait for network outputs to cycle
    for (i = 0; i < 4; i = i + 1)
    begin
        #200;
        @(posedge S_AXI_ACLK);
        S_AXI_ARADDR = 32'h0004;
        S_AXI_ARVALID = 1'b1;
        S_AXI_BREADY = 1'b1;
        S_AXI_RREADY = 1'b1;
        @(posedge S_AXI_ACLK);
        S_AXI_ARVALID = 0;
        S_AXI_RREADY = 0;
        @(posedge S_AXI_RVALID);
        $display("%t : Read Data is: %h",$time,S_AXI_RDATA);
    end

    $finish;

end

endmodule