LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

ENTITY RAM128_32 IS
	generic (
		D_Width: integer:=32;
		A_width: integer:=7
	);
	PORT
	(
		address	: IN STD_LOGIC_VECTOR (A_width-1 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (D_Width-1 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (D_Width-1 DOWNTO 0)
	);
END RAM128_32;

architecture RAM128_32_arch of RAM128_32 is
	type ram_type is array (0 to 2**A_width-1) of
		STD_LOGIC_VECTOR(D_Width-1 DOWNTO 0);
	signal ram: ram_type;
begin
	ram_proc : process(clock)
	begin
		if (rising_edge(clock)) then
			if (wren = '1') then
				ram(to_integer(unsigned(address))) <= data;
			end if;
		end if;
	end process;
	q <= ram(to_integer(unsigned(address)));
end architecture RAM128_32_arch;