`timescale 1ns / 1ps
module xadc_interface
(
   clk, 
   rst,
   network_output,

   //XADC Interface Signals
   DADDR,
   DEN,
   DI,
   DWE,
   BUSY,
   DO,
   DRDY,
   EOS,
   MEASURED_AUX0,
   MEASURED_AUX1,
   MEASURED_AUX2,
   MEASURED_AUX3
);

input clk;
input rst;

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

output reg [11:0] MEASURED_AUX0 = 0;
output reg [11:0] MEASURED_AUX1 = 0;
output reg [11:0] MEASURED_AUX2 = 0;
output reg [11:0] MEASURED_AUX3 = 0;

localparam VAUXP0_ADDR = 7'h10;
localparam VAUXP1_ADDR = 7'h11;
localparam VAUXP2_ADDR = 7'h12;
localparam VAUXP3_ADDR = 7'h13;
// localparam VAUXP0_ADDR = 7'h20;
// localparam VAUXP1_ADDR = 7'h21;
// localparam VAUXP2_ADDR = 7'h22;
// localparam VAUXP3_ADDR = 7'h23;

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

reg MEASURED_AUX0_valid = 0;
reg MEASURED_AUX1_valid = 0;
reg MEASURED_AUX2_valid = 0;
reg MEASURED_AUX3_valid = 0;
reg network_output_valid = 0;
reg max_value_valid = 0;

always @(posedge clk, posedge rst)
begin
    if (rst)
        current_state <= reset;
    else
        current_state <= next_state;
end

always @(posedge clk, posedge rst)
begin
   if (rst)
      MEASURED_AUX0 = 0;
   else if (MEASURED_AUX0_valid)
      MEASURED_AUX0 = DO[15:4];
end

always @(posedge clk, posedge rst)
begin
   if (rst)
      MEASURED_AUX1 = 0;
   else if (MEASURED_AUX1_valid)
      MEASURED_AUX1 = DO[15:4];
end

always @(posedge clk, posedge rst)
begin
   if (rst)
      MEASURED_AUX2 = 0;
   else if (MEASURED_AUX2_valid)
      MEASURED_AUX2 = DO[15:4];
end

always @(posedge clk, posedge rst)
begin
   if (rst)
      MEASURED_AUX3 = 0;
   else if (MEASURED_AUX3_valid)
      MEASURED_AUX3 = DO[15:4];
end

always @(posedge clk, posedge rst)
begin
   if (rst)
      network_output = 0;
   else if (network_output_valid)
      network_output = temp_network_output_reg;
end

always @(posedge clk, posedge rst)
begin
   if (rst)
      max_value = 0;
   else if (max_value_valid)
      max_value = DO[15:4];
end


always @(current_state, EOS, DRDY)
begin
   next_state = current_state;
   case (current_state)
      reset:
      begin
         next_state = read_reg10;
      end
      read_reg10 : begin
         if (EOS) begin
            next_state   = reg10_waitdrdy;
         end
      end
      reg10_waitdrdy : 
      begin
         if (DRDY == 1)  	begin
            next_state = read_reg11;
         end
         else begin
            next_state = current_state;          
         end
      end
      read_reg11 : begin
         next_state   = reg11_waitdrdy;
      end
      reg11_waitdrdy : 
      begin
         if (DRDY ==1)  	begin
            next_state = read_reg12;
            end
         else begin
            next_state = current_state;          
         end
      end
      read_reg12 : begin
         next_state   = reg12_waitdrdy;
      end
      reg12_waitdrdy :
      begin
         if (DRDY ==1)  	begin
            next_state = read_reg13;
         end
         else begin
            next_state = current_state;          
         end
      end
      read_reg13 : begin
         next_state   = reg13_waitdrdy;
      end
      reg13_waitdrdy :
      begin
         if (DRDY ==1) begin
            next_state = read_reg10;
         end
         else begin
            next_state = current_state;          
         end
      end
      default:
         next_state = reset;
    endcase 
end

always @(posedge clk)
begin

   DEN = 0;
   DADDR = 0;
   MEASURED_AUX0_valid = 0;
   MEASURED_AUX1_valid = 0;
   MEASURED_AUX2_valid = 0;
   MEASURED_AUX3_valid = 0;
   network_output_valid = 0;
   max_value_valid = 0;

   case (current_state)
      read_reg10 : begin
         
         if (EOS) begin
            DADDR   = VAUXP0_ADDR;
            DEN = 1; // performing read
         end
         else
            network_output_valid = 1;
      end
      reg10_waitdrdy : 
      begin
         DEN = 0;
         if (DRDY == 1)  	begin
            MEASURED_AUX0_valid = 1; 
            max_value_valid = 1;
            temp_network_output_reg = 2'b00;
         end
      end
      read_reg11 : begin
         DADDR   = VAUXP1_ADDR;
         DEN = 1; // performing read
      end
      reg11_waitdrdy : 
      begin
         DEN = 0;
         if (DRDY ==1)  	begin
            MEASURED_AUX1_valid = 1;
            if (DO[15:4] > max_value)
            begin
               max_value_valid = 1;
               temp_network_output_reg = 2'b01;
            end
         end
      end
      read_reg12 : begin
         DADDR   = VAUXP2_ADDR;
         DEN = 1; // performing read
      end
      reg12_waitdrdy :
      begin
         DEN = 0;
         if (DRDY ==1)  	begin
            MEASURED_AUX2_valid = 1; 
            if (DO[15:4] > max_value)
            begin
               max_value_valid = 1;
               temp_network_output_reg = 2'b10;
            end
         end
      end
      read_reg13 : begin
         DADDR   = VAUXP3_ADDR;
         DEN = 1; // performing read
      end
      reg13_waitdrdy :
      begin
         DEN = 0;
         if (DRDY ==1) begin
            MEASURED_AUX3_valid = 1;
            if (DO[15:4] > max_value)
            begin
               DEN = 2'b0;
               max_value_valid = 1;
               temp_network_output_reg = 2'b11;
            end 
            DADDR   = 7'h00;
         end
      end
    endcase 
end

endmodule