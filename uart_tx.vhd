Library IEEE;
use ieee.std_logic_1164.all,ieee.numeric_std.all;

entity uart_tx is
port(clk,en,send,rst :in std_logic;
     char :in std_logic_vector(7 downto 0);
     ready,tx :out std_logic);
end uart_tx;

architecture uart_test of uart_tx is
type state_type is (IDLE,START,D);
signal P : state_type :=IDLE;
signal creg : std_logic_vector(7 downto 0);
signal count : std_logic_vector(2 downto 0);
begin
    sync: process(clk)
    begin
    if(rising_edge(clk)) then
        if(rst='1') then
            P<=IDLE;
            tx<='1';
            creg<="00000000";
            count<="000";
            ready<='1';
        elsif(en='1') then
        case P is
            When IDLE =>       
               if(send='1') then
                    tx<='0';
                    ready<='0';                
                    creg<=char; 
                    P<=start;
               else 
                ready<='1';
                tx<='1'; 
              end if;
            when START =>    
               count<="000";
               tx<=creg(0);
               creg<='0' & creg(7 downto 1);
               P<=D;
            when D=>
               if (unsigned(count)<7) then
                    tx<=creg(0);
                       count<=std_logic_vector(unsigned(count)+1);
                    P<=D;
                    creg<='0' & creg(7 downto 1);
               else
                    tx<='1';
                    P<=IDLE;
               end if;    
                     
     when others=>
            P<=IDLE;
    end case;
    end if;
    end if;
    end process sync;
end architecture;
     
     