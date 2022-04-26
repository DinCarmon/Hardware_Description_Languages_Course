library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

entity FIFO8x9 is
	generic (
		D_Width : integer:= 9;
		FIFO_Depth : integer:= 8
	);
   port(
      clk, rst:		in std_logic;
      RdPtrClr, WrPtrClr:	in std_logic;    
      RdInc, WrInc:	in std_logic;
      DataIn:	 in std_logic_vector(D_Width-1 downto 0);
      DataOut: out std_logic_vector(D_Width-1 downto 0);
      rden, wren: in std_logic
	);
end entity FIFO8x9;

architecture RTL of FIFO8x9 is
	--signal declarations
	type fifo_array is array(FIFO_Depth-1 downto 0) of std_logic_vector(D_Width-1 downto 0);  -- makes use of VHDL’s enumerated type
	signal fifo:  fifo_array;
	signal wrptr, rdptr: unsigned(integer(ceil(log2(real(FIFO_Depth))))-1 downto 0);
	signal en: std_logic_vector(D_Width-1 downto 0);
	signal dmuxout: std_logic_vector(D_Width-1 downto 0);

begin
	clk_process : process(clk)
	begin
		if (clk = '1' and rst = '0') then
			if (wren = '1') then
				fifo(to_integer(wrptr)) <= DataIn;
			end if;

			if (RdInc = '1') then
				rdptr <= rdptr + 1;
			end if;

			if (WrInc = '1') then
				wrptr <= wrptr + 1;
			end if;

			if (RdPtrClr = '1') then
				rdptr <= (others => '0');
			end if;

			if (WrPtrClr = '1') then
				wrptr <= (others => '0');
			end if;
		end if;
	end process clk_process;

	data_read: process(rden,rdptr)
	begin
		if rden = '1' then 
			DataOut <= fifo(to_integer(rdptr)); --load the fifo element specified by rdptr into the DataOut when rden is 1
		else 
			DataOut <= (others => 'Z'); --high impedance if read isnt enabled
		end if;
	end process;
end architecture RTL;