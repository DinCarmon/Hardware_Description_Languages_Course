library ieee;
use ieee.std_logic_1164.all;

entity FSM is
generic (
   S_Width : integer := 2;
   S_A : std_logic_vector(S_Width-1 downto 0) := "00";
   S_B : std_logic_vector(S_Width-1 downto 0) := "01";
   S_C : std_logic_vector(S_Width-1 downto 0) := "10"
);
port (
   In1: in std_logic;
   RST: in std_logic; 
   CLK: in std_logic;
   Out1 : inout std_logic
);
end FSM;

architecture FSM_arch of FSM is
   signal CurrentState, NextState: std_logic_vector(S_Width-1 downto 0);
begin
   comb_proc: process(In1)
   begin
      if (RST = '0') then
         case(CurrentState) is
            when S_A =>
               if (In1 = '0') then
                  NextState <= S_A;
               else
                  NextState <= S_B;
               end if;
            when S_B =>
               if (In1 = '0') then
                  NextState <= S_C;
               else
                  NextState <= S_B;
               end if;
            when S_C =>
               if (In1 = '0') then
                  NextState <= S_C;
               else
                  NextState <= S_A;
               end if;
            when others =>
               NextState <= S_A;
         end case;
      end if;
   end process comb_proc;
   
   clk_proc : process (CLK, RST)
   begin
      if (RST = '1') then
         CurrentState <= S_A;
      elsif (rising_edge(clk)) then
         CurrentState <= NextState;
      end if;
   end process clk_proc;

   Out1 <= '1' when CurrentState = S_C else '0';
end architecture FSM_arch;