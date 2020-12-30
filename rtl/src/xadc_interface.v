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

output reg [1:0] network_output;

output reg [6:0] DADDR;
output DEN;
output reg [15:0] DI;
output DWE;

reg [1:0] den_reg;
reg [1:0] dwe_reg;
assign DEN = den_reg[0];
assign DWE = dwe_reg[0];

reg [11:0] MEASURED_AUX0;
reg [11:0] MEASURED_AUX1;
reg [11:0] MEASURED_AUX2;
reg [11:0] MEASURED_AUX3;

reg [31:0] counter;

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

reg [3:0] next_state;
reg [3:0] current_state;

reg [11:0] max_value;
reg [1:0] temp_network_output_reg;


always @(posedge clk)
begin
    if (rst)
    begin
        counter = 0;
        den_reg = 0;
        dwe_reg = 0;
        temp_network_output_reg = 0;
        network_output = 0;
        MEASURED_AUX0 = 0;
        MEASURED_AUX1 = 0;
        MEASURED_AUX2 = 0;
        MEASURED_AUX3 = 0;
        max_value = 0;
        DADDR = 0;
        DI = 0;
    end
    else
        counter = counter + 1;
end

always @(posedge clk)
begin
    if (rst)
        current_state <= reset;
    else
        current_state <= next_state;
end

always @(clk)
begin
    case (current_state)
        reset:
            // next_state <= init_read;
         next_state <= read_reg10;
         /*
        init_read : begin
            DADDR <= 7'h40;
            den_reg <= 2'h2; // performing read
            if (BUSY == 0 ) next_state <= read_waitdrdy;
            else next_state <= current_state;
            end
        read_waitdrdy : 
            if (EOS ==1)  	begin
               next_state <= read_reg10;
            end
            else begin
               den_reg <= { 1'b0, den_reg[1] } ;
               dwe_reg <= { 1'b0, dwe_reg[1] } ;
               next_state <= current_state;                
            end
         */
        read_reg10 : begin
            network_output = temp_network_output_reg;
            if (EOS) begin
               DADDR   <= 7'h10;
               den_reg <= 2'h2; // performing read
               next_state   <= reg10_waitdrdy;
            end
         end
         reg10_waitdrdy : 
            if (DRDY ==1)  	begin
               MEASURED_AUX0 <= DO[15:4]; 
               max_value <= DO[15:4];
               temp_network_output_reg = 2'b00;
               next_state <= read_reg11;
            end
            else begin
               den_reg <= { 1'b0, den_reg[1] } ;
               dwe_reg <= { 1'b0, dwe_reg[1] } ;      
               next_state <= current_state;          
            end
         read_reg11 : begin
            DADDR   <= 7'h11;
            den_reg <= 2'h2; // performing read
            next_state   <= reg11_waitdrdy;
         end
         reg11_waitdrdy : 
            if (DRDY ==1)  	begin
               MEASURED_AUX1 <= DO[15:4];
               if (DO[15:4] > max_value)
               begin
                  max_value = DO[15:4];
                  temp_network_output_reg = 2'b01;
               end
               next_state <= read_reg12;
               end
            else begin
               den_reg <= { 1'b0, den_reg[1] } ;
               dwe_reg <= { 1'b0, dwe_reg[1] } ;      
               next_state <= current_state;          
            end
         read_reg12 : begin
            DADDR   <= 7'h12;
            den_reg <= 2'h2; // performing read
            next_state   <= reg12_waitdrdy;
            end
         reg12_waitdrdy : 
            if (DRDY ==1)  	begin
               MEASURED_AUX2 <= DO[15:4]; 
               if (DO[15:4] > max_value)
               begin
                  max_value = DO[15:4];
                  temp_network_output_reg = 2'b10;
               end
               next_state <= read_reg13;
               end
            else begin
               den_reg <= { 1'b0, den_reg[1] } ;
               dwe_reg <= { 1'b0, dwe_reg[1] } ;      
               next_state <= current_state;          
            end
         read_reg13 : begin
            DADDR   <= 7'h13;
            den_reg <= 2'h2; // performing read
            next_state   <= reg13_waitdrdy;
            end
         reg13_waitdrdy :
            if (DRDY ==1)  	begin
               MEASURED_AUX3 <= DO[15:4];
               if (DO[15:4] > max_value)
               begin
                  max_value = DO[15:4];
                  temp_network_output_reg = 2'b11;
               end 
               next_state <= read_reg10;
               DADDR   <= 7'h00;
            end
            else begin
               den_reg <= { 1'b0, den_reg[1] } ;
               dwe_reg <= { 1'b0, dwe_reg[1] } ;      
               next_state <= current_state;          
            end
    endcase 
end

endmodule