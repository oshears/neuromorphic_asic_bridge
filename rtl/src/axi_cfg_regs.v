`timescale 1ns / 1ps
module axi_cfg_regs
#(
parameter C_S_AXI_ACLK_FREQ_HZ = 100000000,
parameter C_S_AXI_DATA_WIDTH = 32,
parameter C_S_AXI_ADDR_WIDTH = 9 
)
(
    clk, 
    rst,
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
    char_select,
    network_output,
    xadc_config   
);


input clk;
input rst;
input [1:0] network_output;


input S_AXI_ACLK;   
input S_AXI_ARESETN;
input [C_S_AXI_ADDR_WIDTH - 1:0] S_AXI_AWADDR; 
input S_AXI_AWVALID;
input [C_S_AXI_ADDR_WIDTH - 1:0] S_AXI_ARADDR; 
input S_AXI_ARVALID;
input [C_S_AXI_DATA_WIDTH - 1:0] S_AXI_WDATA;  
input [(C_S_AXI_DATA_WIDTH/8 - 1):0] S_AXI_WSTRB;  
input S_AXI_WVALID; 
input S_AXI_RREADY; 
input S_AXI_BREADY; 

output reg S_AXI_AWREADY; 
output reg S_AXI_ARREADY; 
output reg S_AXI_WREADY;  
output reg [C_S_AXI_DATA_WIDTH - 1:0] S_AXI_RDATA;
output reg [1:0] S_AXI_RRESP;
output reg S_AXI_RVALID;  
output reg [1:0] S_AXI_BRESP;
output reg S_AXI_BVALID;  

output [1:0] char_select;
output [31:0] xadc_config;

reg [1:0] char_select_reg;
reg char_select_reg_addr_valid;
reg [1:0] network_output_reg;
reg network_output_reg_addr_valid;
reg [31:0] xadc_config_reg;
reg  xadc_config_reg_addr_valid;

reg [2:0] current_state;
reg [2:0] next_state;

reg [3:0] local_address = 0;
reg local_address_valid;

wire [1:0] combined_S_AXI_AWVALID_S_AXI_ARVALID;

reg write_enable_registers;
reg send_read_data_to_AXI;

wire Local_Reset;


parameter reset = 0, idle = 1, read_transaction_in_progress = 2, write_transaction_in_progress = 3, complete = 4;

assign Local_Reset = ~S_AXI_ARESETN;
assign combined_S_AXI_AWVALID_S_AXI_ARVALID = {S_AXI_AWVALID, S_AXI_ARVALID};
assign char_select = char_select_reg;
assign xadc_config = xadc_config_reg;

always @ (posedge S_AXI_ACLK or posedge Local_Reset) begin
    if (Local_Reset)
        current_state <= reset;
    else
        current_state <= next_state;

end

// main AXI state machine
always @ (current_state, combined_S_AXI_AWVALID_S_AXI_ARVALID, S_AXI_ARVALID, S_AXI_RREADY, S_AXI_AWVALID, S_AXI_WVALID, S_AXI_BREADY, local_address, local_address_valid) begin
    S_AXI_ARREADY = 0;
    S_AXI_RRESP = 2'b00;
    S_AXI_RVALID = 0;
    S_AXI_WREADY = 0;
    S_AXI_BRESP = 2'b00;
    S_AXI_BVALID = 0;
    S_AXI_WREADY = 0;
    S_AXI_AWREADY = 0;
    write_enable_registers = 0;
    send_read_data_to_AXI = 0;

    case (current_state)
        reset:
            next_state = idle;
        idle:
        begin
            case (combined_S_AXI_AWVALID_S_AXI_ARVALID)
                2'b01:
                    next_state = read_transaction_in_progress;
                2'b10:
                    next_state = write_transaction_in_progress;
            endcase
        end
        read_transaction_in_progress:
        begin
            next_state = read_transaction_in_progress;
            S_AXI_ARREADY = S_AXI_ARVALID;
            S_AXI_RVALID = 1;
            S_AXI_RRESP = 2'b00;
            send_read_data_to_AXI = 1;
            if (S_AXI_RREADY == 1) 
                next_state = complete;
        end
        write_transaction_in_progress:
        begin
            next_state = write_transaction_in_progress;
			write_enable_registers = 1;
            S_AXI_AWREADY = S_AXI_AWVALID;
            S_AXI_WREADY = S_AXI_WVALID;
            S_AXI_BRESP = 2'b00;
            S_AXI_BVALID = 1;
			if (S_AXI_BREADY == 1)
			    next_state = complete;
        end
        complete:
        begin
            case (combined_S_AXI_AWVALID_S_AXI_ARVALID) 
				2'b00:
                     next_state = idle;
				default:
                    next_state = complete;
			endcase;
        end
    endcase
end

// send data to AXI RDATA
always @(send_read_data_to_AXI, local_address, char_select_reg, network_output_reg, xadc_config_reg)
begin
    S_AXI_RDATA = 32'b0;

    if(local_address_valid == 1 && send_read_data_to_AXI == 1)
    begin
        case(local_address)
            0:
                S_AXI_RDATA = {30'b0,char_select_reg};
            4:
                S_AXI_RDATA = {30'b0,network_output_reg};
            8:
                S_AXI_RDATA = xadc_config_reg;
            default:
                S_AXI_RDATA = 32'b0;
        endcase;     
    end
end

// local address capture
always  @(posedge S_AXI_ACLK)
begin
    if (Local_Reset)
        local_address = 0;
    else
    begin
        if (local_address_valid == 1)
        begin
            case (combined_S_AXI_AWVALID_S_AXI_ARVALID)
                2'b10:
                    local_address = S_AXI_AWADDR[3:0];
                2'b01:     
                    local_address = S_AXI_ARADDR[3:0];
            endcase
        end
    end
end

// write data address analysis
always @(local_address,write_enable_registers)
begin
    char_select_reg_addr_valid = 0;
    network_output_reg_addr_valid = 0;
    xadc_config_reg_addr_valid = 0;
    local_address_valid = 1;

    if (write_enable_registers)
    begin
        case (local_address)
            0:
                char_select_reg_addr_valid = 1;
            4:
                network_output_reg_addr_valid = 1;
            8:
                xadc_config_reg_addr_valid = 1;
            default:
                local_address_valid = 0;
        endcase
    end
end

// char_select_reg
always @(posedge S_AXI_ACLK)
begin
    if (Local_Reset)
        char_select_reg = 0;
    else
    begin
        if(char_select_reg_addr_valid)
        char_select_reg = S_AXI_WDATA[1:0];
    end
end

// network_output_reg
always @(posedge S_AXI_ACLK)
begin
    network_output_reg = network_output;
end

// xadc_config_reg
always @(posedge S_AXI_ACLK)
begin
    if (Local_Reset)
        xadc_config_reg = 0;
    else
    begin
        if(xadc_config_reg_addr_valid)
        xadc_config_reg = S_AXI_WDATA;
    end
end

endmodule