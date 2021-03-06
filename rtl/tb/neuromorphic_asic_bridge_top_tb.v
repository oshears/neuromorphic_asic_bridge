`timescale 1ns / 1ps
module neuromorphic_asic_bridge_top_tb;
// Inputs
reg pwm_clk;
wire [15:0] digit;

reg S_AXI_ACLK;

reg VP, VN = 0;

wire [7:0] leds;
   
reg S_AXI_ARESETN = 0;
reg [8:0] S_AXI_AWADDR = 0; 
reg S_AXI_AWVALID = 0;
reg [8:0] S_AXI_ARADDR = 0; 
reg S_AXI_ARVALID = 0;
reg [31:0] S_AXI_WDATA = 0;  
reg [3:0] S_AXI_WSTRB = 0;  
reg S_AXI_WVALID = 0; 
reg S_AXI_RREADY = 0; 
reg S_AXI_BREADY = 0; 
wire S_AXI_AWREADY; 
wire S_AXI_ARREADY; 
wire S_AXI_WREADY;  
wire [31:0] S_AXI_RDATA;
wire [1:0] S_AXI_RRESP;
wire S_AXI_RVALID;  
wire [1:0] S_AXI_BRESP;
wire S_AXI_BVALID;  
wire [3:0] XADC_MUXADDR;

integer i = 0;
integer j = 0;

localparam CHAR_SELECT_REG = 0;
localparam NETWORK_OUTPUT_REG = 4;
localparam DIRECT_CTRL = 8;
localparam DEBUG_REG = 12;
localparam MEASURED_AUX0 = 16;
localparam MEASURED_AUX1 = 20;
localparam MEASURED_AUX2 = 24;
localparam MEASURED_AUX3 = 28;
localparam PWM_CLK_DIV_REG = 32;
localparam PWM_BLK_DUTY_CYCLE_REG = 36;
localparam PWM_BLK_CLK_CNTR_REG = 40;
localparam PMOD_DAC_REG = 44;

task AXI_WRITE( input [31:0] WRITE_ADDR, input [31:0] WRITE_DATA );
    begin
        @(posedge S_AXI_ACLK);
        S_AXI_AWADDR = WRITE_ADDR;
        S_AXI_AWVALID = 1'b1;
        S_AXI_WVALID = 1;
        S_AXI_WDATA = WRITE_DATA;
        S_AXI_BREADY = 1'b1;
        @(posedge S_AXI_WREADY);
        @(posedge S_AXI_ACLK);
        S_AXI_WVALID = 0;
        S_AXI_AWVALID = 0;
        S_AXI_BREADY = 1'b0;
        @(posedge S_AXI_ACLK);
        S_AXI_AWADDR = 32'h0;
        S_AXI_WDATA = 32'h0;
        $display("%t: Wrote Data: %h",$time,WRITE_DATA);
    end
endtask

task AXI_READ( input [31:0] READ_ADDR, input [31:0] EXPECT_DATA );
    begin
        @(posedge S_AXI_ACLK);
        S_AXI_ARADDR = READ_ADDR;
        S_AXI_ARVALID = 1'b1;
        @(posedge S_AXI_RVALID);
        @(posedge S_AXI_ACLK);
        S_AXI_ARVALID = 0;
        S_AXI_RREADY = 1'b1;
        if (EXPECT_DATA == S_AXI_RDATA) 
            $display("%t: Read Data: %h",$time,S_AXI_RDATA);
        else 
            $display("%t: ERROR: %h != %h",$time,S_AXI_RDATA,EXPECT_DATA);
        @(posedge S_AXI_ACLK);
        S_AXI_RREADY = 0;
        S_AXI_ARADDR = 32'h0;
    end
endtask

task WAIT( input [31:0] cycles);
    integer i;
    begin
        for (i = 0; i < cycles; i = i + 1)
            @(posedge S_AXI_ACLK);
    end
endtask



neuromorphic_asic_bridge_top uut(
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
.leds(leds),
.VP(VP),
.VN(VN),
.XADC_MUXADDR(XADC_MUXADDR)
);

// Create 100Mhz clock
initial begin
pwm_clk = 0;
forever #10 pwm_clk = ~pwm_clk;
end 

initial begin
S_AXI_ACLK = 0;
forever #10 S_AXI_ACLK = ~S_AXI_ACLK;
end 


initial begin
    WAIT(10);

    S_AXI_ARESETN = 1;

    WAIT(1);

    
    /* Write Reg Tests */
    for (i = 0; i < 44; i = i + 4)
    begin
        AXI_WRITE(i,32'hDEAD_BEEF);
    end
    
    /* Reset Debug Register */
    AXI_WRITE(32'hC,32'hC);

    /* Read Reg Tests */
    for (i = 0; i < 44; i = i + 4)
    begin
        AXI_READ(i,32'hDEAD_BEEF);
    end

    // Wait for network outputs to cycle
    for (i = 0; i < 4; i = i + 1)
    begin
        #200000;
        
        AXI_READ(9'h0004,32'hDEAD_BEEF);

        // Read AUX Regs
        for (j = 16; j < 32; j = j + 4)
        begin
            AXI_READ(j,32'hDEAD_BEEF);
        end

    end


    // Test Different Clock Frequencies
    // Enable Slow Clock
    AXI_WRITE(32'h0C,32'h08);
    for (i = 0; i < 32; i = i + 1)
    begin
        AXI_WRITE(32'h20,i);
        WAIT(64);
    end

    // Test PWM BLK
    $display("%t: Testing PWM Block",$time);
    // Configure DBG Register (Use HS Clock)
    AXI_WRITE(32'hC,32'hCC);
    
    for (i = 0; i < 8; i = i + 1)
    begin
        // Configure PWM DIV Register
        AXI_WRITE(32'h20,i);
        for (j = 0; j <= 2**i; j = j + 1)
        begin
            // Configure PWM Duty Cycle Register
            AXI_WRITE(32'h24,j);
            WAIT(64);
        end
        
    end

    // Test Slow Mode Config
    // PWM BLK Clock Out, Slow Clock Enable
    AXI_WRITE(32'h0C,32'h48);
    // PWM CLK Divider = ~1s
    AXI_WRITE(32'h20,32'h1A);
    // PWM Duty Cycle = 0%
    AXI_WRITE(32'h24,32'h0);
    WAIT(64);

    // Test PMOD DAC
    // Enable DAC Outputs
    AXI_WRITE(DEBUG_REG,32'h0100);
    // Send Data to DAC
    AXI_WRITE(PMOD_DAC_REG,32'h0003_ABCD);
    WAIT(64);

    // Test Slow Clock @ 1 MHz, 50% Duty Cycle
    $display("%t: Test Slow Clock @ 500kHz, 50% Duty Cycle",$time);
    // Enable Slow Clock
    AXI_WRITE(DEBUG_REG,32'h08);
    AXI_WRITE(PWM_CLK_DIV_REG,32'h00);
    // Duty Cycle 50%
    //AXI_WRITE(PWM_BLK_DUTY_CYCLE_REG,32'h00);
    WAIT(64);


    $finish;

end

endmodule