library ieee;
use ieee.std_logic_1164.all, ieee.numeric_std.all;

entity top_lev is
port(TXD,clk: in std_logic;
     btn : in std_logic_vector(1 downto 0);
     RXD,RTS,CTS : out std_logic);
end top_lev;

architecture top_lev_crt of top_lev is
component clk_div
    port(clk :in std_logic;
         div :out std_logic);
end component;

component debounce
    port(clk : in std_logic;
         btn : in std_logic;
         dbnc : out std_logic);
end component;

component sender
    port(btn,clk,en,rdy,rst : in std_logic;
         char : out std_logic_vector(7 downto 0);
         send : out std_logic);
end component;

component UART
port(
    clk, en, send, rx, rst      : in std_logic;
    charSend                    : in std_logic_vector (7 downto 0);
    ready, tx, newChar          : out std_logic;
    charRec                     : out std_logic_vector (7 downto 0));
end component;

signal dbout1,dbout2,clk_out,red_out,send_out : std_logic;
signal char_out : std_logic_vector(7 downto 0);

begin

dbnc1 : debounce
    port map(clk=>clk,
             btn=>btn(0),
             dbnc=>dbout1);
             
dbnc2 : debounce
     port map(clk=>clk,
              btn=>btn(1),
              dbnc=>dbout2);
clk_divider : clk_div
    port map(clk=>clk,
             div=>clk_out);

send : sender
port map(btn=>dbout2,
         clk=>clk,
         en=>clk_out,
         rdy=>red_out,
         rst=>dbout1,
         char=>char_out,
         send=>send_out);
uart_blk : UART
port map(charSend=>char_out,
         clk=>clk,
         en=>clk_out,
         rst=>dbout1,
         rx=>TXD,
         send=>send_out,
         ready=>red_out,
         tx=>RXD);
cts<='0';rts<='0'; --not sure what to set them to
end top_lev_crt;






