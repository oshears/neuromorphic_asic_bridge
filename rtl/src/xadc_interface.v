`timescale 1ns / 1ps
module xadc_interface
(
    clk, 
    rst,
    xadc_config,
    network_output,

    //XADC Interface Signals
    DADDR,
    DEN,
    DI,
    DWE,
    BUSY,
    DO,
    DRDY,
    EOS
);

input clk;
input rst;
input [31:0] xadc_config;

input BUSY;
input [15:0] DO;
input DRDY;
input EOS;

output reg [1:0] network_output = 0;

output reg [6:0] DADDR = 0;
output reg DEN;
output reg [15:0] DI = 0;
output DWE;

assign DWE = 0;

reg [11:0] MEASURED_AUX0 = 0;
reg [11:0] MEASURED_AUX1 = 0;
reg [11:0] MEASURED_AUX2 = 0;
reg [11:0] MEASURED_AUX3 = 0;


// parameter reset = 0, config_reg_0 = 1, config_reg_1 = 2, config_reg_2 = 3, done = 4;
parameter       reset       = 8'h00,
                read_reg10      = 8'h01,
                reg10_waitdrdy  = 8'h02,
                read_reg11      = 8'h03,
                reg11_waitdrdy  = 8'h04,
                read_reg12      = 8'h05,
                reg12_waitdrdy  = 8'h06,
                read_reg13      = 8'h07,
                reg13_waitdrdy  = 8'h08,
                init_read  = 8'h09,
                read_waitdrdy  = 8'h0A;

reg [3:0] next_state = 0;
reg [3:0] current_state = 0;

reg [11:0] max_value = 0;
reg [1:0] temp_network_output_reg = 0;


always @(posedge clk)
begin
    if (rst)
        current_state <= reset;
    else
        current_state <= next_state;
end

always @(EOS,DRDY,BUSY,DO,current_state,temp_network_output_reg,MEASURED_AUX0,MEASURED_AUX1,MEASURED_AUX2,MEASURED_AUX3)
begin
   
   case (current_state)
      reset:
      begin
         next_state <= read_reg10;
         DEN <= 0;
         DADDR = 0;
         MEASURED_AUX0 <= 0;
         MEASURED_AUX1 <= 0;
         MEASURED_AUX2 <= 0;
         MEASURED_AUX3 <= 0;
         temp_network_output_reg <= 0;
         max_value <= 0;
         network_output <= 0;
      end
      read_reg10 : begin
         network_output <= temp_network_output_reg;
         if (EOS) begin
            DADDR   <= 7'h10;
            DEN <= 1; // performing read
            next_state   <= reg10_waitdrdy;
         end
      end
      reg10_waitdrdy : 
      begin
         DEN <= 0;
         if (DRDY ==1)  	begin
            MEASURED_AUX0 <= DO[15:4]; 
            max_value <= DO[15:4];
            temp_network_output_reg <= 2'b00;
            next_state <= read_reg11;
         end
         else begin
            next_state <= current_state;          
         end
      end
      read_reg11 : begin
         DADDR   <= 7'h11;
         DEN <= 1; // performing read
         next_state   <= reg11_waitdrdy;
      end
      reg11_waitdrdy : 
      begin
         DEN = 0;
         if (DRDY ==1)  	begin
            MEASURED_AUX1 <= DO[15:4];
            if (DO[15:4] > max_value)
            begin
               max_value <= DO[15:4];
               temp_network_output_reg <= 2'b01;
            end
            next_state <= read_reg12;
            end
         else begin
            next_state <= current_state;          
         end
      end
      read_reg12 : begin
         DADDR   <= 7'h12;
         DEN <= 1; // performing read
         next_state   <= reg12_waitdrdy;
      end
      reg12_waitdrdy :
      begin
         DEN <= 0;
         if (DRDY ==1)  	begin
            MEASURED_AUX2 <= DO[15:4]; 
            if (DO[15:4] > max_value)
            begin
               max_value = DO[15:4];
               temp_network_output_reg <= 2'b10;
            end
            next_state <= read_reg13;
         end
         else begin
            next_state <= current_state;          
         end
      end
      read_reg13 : begin
         DADDR   <= 7'h13;
         DEN = 1; // performing read
         next_state   <= reg13_waitdrdy;
      end
      reg13_waitdrdy :
      begin
         DEN <= 0;
         if (DRDY ==1) begin
            MEASURED_AUX3 <= DO[15:4];
            
            if (DO[15:4] > max_value)
            begin
               DEN = 2'b0;
               max_value <= DO[15:4];
               temp_network_output_reg <= 2'b11;
            end 

            next_state <= read_reg10;
            DADDR   <= 7'h00;
         end
         else begin
            next_state <= current_state;          
         end
      end
      default:
         begin
            DEN <= 0;
            DADDR <= 0;
            next_state <= reset;
            MEASURED_AUX0 <= MEASURED_AUX0;
            MEASURED_AUX1 <= MEASURED_AUX1;
            MEASURED_AUX2 <= MEASURED_AUX2;
            MEASURED_AUX3 <= MEASURED_AUX3;
            temp_network_output_reg <= 0;
            max_value <= 0;
            network_output <= 0;
         end
    endcase 
end

endmodule