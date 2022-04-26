LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity AAC2M2P1 is port (                 	
   CP: 	in std_logic; 	-- clock
   SR:  in std_logic;  -- Active low, synchronous reset
   P:    in std_logic_vector(3 downto 0);  -- Parallel input
   PE:   in std_logic;  -- Parallel Enable (Load)
   CEP: in std_logic;  -- Count enable parallel input
   CET:  in std_logic; -- Count enable trickle input
   Q:   out std_logic_vector(3 downto 0);            			
   TC:  out std_logic  -- Terminal Count
);            		
end AAC2M2P1;

architecture BINARY_COUNTER of AAC2M2P1 is
begin
   TC <= (and(Q)) and (CET); -- Terminal Count architecture

   clock_cycle : process(CP) -- all else architecture
   begin
         if (rising_edge(CP)) then
            if (SR = '1') then
               if (PE = '0') then -- loading
                  Q <= P;
               else
                  if (CEP = '1' and CET = '1') then -- counting
                     Q <= std_logic_vector(unsigned(Q) + 1);
                  end if;
               end if;
            else -- synchronous reset
               Q <= (others => '0');
            end if;
         end if;
   end process;


end BINARY_COUNTER;