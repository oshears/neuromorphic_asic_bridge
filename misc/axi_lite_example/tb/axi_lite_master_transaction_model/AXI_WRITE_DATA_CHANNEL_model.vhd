library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AXI_WRITE_DATA_CHANNEL_model is
	PORT
		(
		-- User signals
		clk			: in  STD_LOGIC;
		resetn       : in STD_LOGIC;
		data          : in STD_LOGIC_VECTOR(31 downto 0);
		go          : in STD_LOGIC;
        done      : out STD_LOGIC;
		
		-- AXI write data channel signals
		WDATA			: out  STD_LOGIC_VECTOR(31 downto 0);
		WSTRB			: out  STD_LOGIC_VECTOR(3 downto 0);
		WVALID		: out  STD_LOGIC;
		WREADY		: in  STD_LOGIC
		);
end AXI_WRITE_DATA_CHANNEL_model;



architecture Behavioral of AXI_WRITE_DATA_CHANNEL_model is

type main_fsm_type is (reset, idle, running, complete);

signal current_state, next_state : main_fsm_type := reset;
signal output_data : std_logic;



begin

state_machine_update : process (clk)
begin
    if clk'event and clk = '1' then
        if resetn = '0' then
            current_state <= reset;
        else
            current_state <= next_state;
        end if;
    end if;
end process;


WDATA <= data when output_data = '1' else X"00000000";

state_machine_decisions : process (current_state, WREADY, go)

function to_hstring(slv: std_logic_vector) return string is
    constant hexlen : integer := (slv'length+3)/4;
    variable longslv : std_logic_vector(slv'length+3 downto 0) := (others => '0');
    variable hex : string(1 to hexlen);
    variable fourbit : std_logic_vector(3 downto 0);
begin
    longslv(slv'length-1 downto 0) := slv;
    for i in hexlen-1 downto 0 loop
        fourbit := longslv(i*4+3 downto i*4);
        case fourbit is
            when "0000" => hex(hexlen-i) := '0';
            when "0001" => hex(hexlen-i) := '1';
            when "0010" => hex(hexlen-i) := '2';
            when "0011" => hex(hexlen-i) := '3';
            when "0100" => hex(hexlen-i) := '4';
            when "0101" => hex(hexlen-i) := '5';
            when "0110" => hex(hexlen-i) := '6';
            when "0111" => hex(hexlen-i) := '7';
            when "1000" => hex(hexlen-i) := '8';
            when "1001" => hex(hexlen-i) := '9';
            when "1010" => hex(hexlen-i) := 'A';
            when "1011" => hex(hexlen-i) := 'B';
            when "1100" => hex(hexlen-i) := 'C';
            when "1101" => hex(hexlen-i) := 'D';
            when "1110" => hex(hexlen-i) := 'E';
            when "1111" => hex(hexlen-i) := 'F';
            when "ZZZZ" => hex(hexlen-i) := 'Z';
            when "UUUU" => hex(hexlen-i) := 'U';
            when "XXXX" => hex(hexlen-i) := 'X';
            when others => hex(hexlen-i) := '?';
        end case;
    end loop;
    return hex;
end function to_hstring;

begin
    WSTRB <= "0000";
    WVALID <= '0';
    output_data <= '0';
    done <= '0';
    
        
    case current_state is
        when reset =>
        next_state <= idle;
    
        when idle =>
            next_state <= idle;
            if go = '1' then
                next_state <= running;
            end if;
        
        when running =>
            output_data <= '1';
            WSTRB <= "1111";
            WVALID <= '1';
            if WREADY = '1' then
                report "Successfully wrote data: " & to_hstring(data) severity NOTE;
                next_state <= complete;
            else
                next_state <= running;
            end if;
                          
        when complete => 
            done <= '1';
            if go = '0' then
                next_state <= idle;
            else
                next_state <= complete;
            end if;
        
        when others =>
            next_state <= reset;
    end case;
end process;

end Behavioral;

