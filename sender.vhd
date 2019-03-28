library ieee;
use ieee.std_logic_1164.all, ieee.numeric_std.all;

entity sender is
port(btn,clk,en,rdy,rst : in std_logic;
     char : out std_logic_vector(7 downto 0);
     send : out std_logic);
end sender;

architecture send_test of sender is
type state_type is (IDLE,busyA,busyB,busyC);
signal N : state_type;
signal P: state_type :=IDLE; --initialized to IDLE
signal i : std_logic_vector(2 downto 0); --counts up to 5 cause FP183 is 5 characters
type id is array(0 to 4) of std_logic_vector(7 downto 0);
signal NETID : id := (X"66", X"70", X"31", X"38", X"33");
begin

    sync: process(clk,en)
    begin
        if(rising_edge(clk) and en='1') then
            if(rst='1') then
                P<=IDLE; 
                i<="000";
                char<="00000000";
                send<='0';
             end if;
             case P is
                when IDLE=>
                    if(rdy='1' and btn='1' and unsigned(i)<5) then
                       send<='1';
                       char<=NETID(to_integer(unsigned(i)));
                       i<=std_logic_vector(unsigned(i)+1);
                       P<=busyA; 
                    elsif(rdy='1' and btn='1' and unsigned(i)=5) then
                        i<="000";
                        P<=IDLE;
                    end if;
                When busyA=>
                    P<=busyB;
                When busyB=>
                    send<='0';
                    P<=busyC;
                When busyC=> 
                    if(rdy='1' and btn='0') then
                        P<=IDLE;
                    end if;
            end case;
         end if;
    end process sync;
    end send_test;

                
        