library IEEE;
use ieee.std_logic_1164.all, ieee.numeric_std.all;

entity debounce is
port (clk : in std_logic;
      btn : in std_logic;
      dbnc : out std_logic);
end debounce;

architecture deb of debounce is
signal counter : std_logic_vector(22 downto 0);
signal btn_reg : std_logic_vector(1 downto 0);
begin

    process(clk)
    begin
    if(rising_edge(clk)) then
           btn_reg(0)<=btn; --bit 0 gets 1
           btn_reg(1)<=btn_reg(0);  --update bit 1 with bit 0 value  
            if(btn_reg(1)='1') then --if bit 1 is a 1 increment counter
               if(unsigned(counter)<2500000) then
                  counter<=std_logic_vector(unsigned(counter)+1);  
                    dbnc<='0';
                else
                    dbnc<='1';
                end if;
            else--btn(1)==0
                counter<=(others=>'0');
                dbnc<='0';
            end if;
         end if; --end if button pressed or not
    end process;
end deb;