library ieee;
use ieee.std_logic_1164.all, ieee.numeric_std.all;

entity clk_div is
port(clk :in std_logic;
    div :out std_logic);
end clk_div;

architecture clk of clk_div is
signal counter : std_logic_vector (25 downto 0) := (others => '0');
begin
    process(clk) 
    begin
        if(rising_edge(clk)) then
            if(unsigned(counter)<1085) then
                counter <= std_logic_vector(unsigned(counter)+1);
                div <= '1';
            else
                counter <= (others => '0');
                div <= '0';
            end if;  
              if (unsigned(counter) = 543) then
                 div <= '1';
                              
              else
                 div <= '0';
                              
              end if;
                         
      end if;
    end process;
end clk;