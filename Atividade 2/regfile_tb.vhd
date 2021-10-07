library ieee;
use ieee.math_real.ceil;
use ieee.math_real.log2;
use ieee.numeric_bit.all;

entity regfile_tb is
end regfile_tb;

architecture tb of regfile_tb is
	component regfile is
		generic(
			regn     : natural := 32;
			wordSize : natural := 64 
		);
		port(
			clock        : in  bit;
			reset        : in  bit;
			regWrite     : in  bit;
			rr1, rr2, wr : in  bit_vector(natural(ceil(log2(real(regn))))-1 downto 0);
			d            : in  bit_vector(wordSize-1 downto 0); 
			q1, q2       : out bit_vector(wordSize-1 downto 0)
		);
	end component;
	
	constant n: natural := 4;
	constant wS: natural := 4;
	signal clock_in: bit := '0';
	signal reset_in: bit;
	signal regWrite_in: bit;
	signal rr1_in, rr2_in, wr_in: bit_vector(natural(ceil(log2(real(n))))-1 downto 0);
	signal d_in: bit_vector(wS-1 downto 0);
	signal q1_out, q2_out: bit_vector(wS-1 downto 0);
	
	constant clockPeriod: time := 2 ns; -- periodo do clock
	signal simulando : bit := '0';
begin
	DUT: regfile
	generic map(n, wS)
	port    map(clock_in, reset_in, regWrite_in, rr1_in, rr2_in, wr_in, d_in, q1_out, q2_out);
	
	clock_in <= (simulando and (not clock_in)) after clockPeriod/2;
	
	estimulos: process is
		type pattern_type is record 
			reset        : bit;
			regWrite     : bit;
			rr1, rr2, wr : bit_vector(natural(ceil(log2(real(n))))-1 downto 0);
			d            : bit_vector(wS-1 downto 0); 
			q1, q2       : bit_vector(wS-1 downto 0);
		end record;
		
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns: pattern_array := 
	   -- rst  regW   rr1   rr2	  wr    d       q1      q2
		(('1', '0',  "00", "10", "00", "0001", "0000", "0000"),
		 ('0', '1',  "00", "10", "00", "0001", "0001", "0000"),
		 ('0', '1',  "00", "01", "01", "0010", "0001", "0010"),
		 ('0', '1',  "10", "01", "10", "0011", "0011", "0010"),
		 ('0', '1',  "10", "11", "11", "0100", "0011", "0100"),
		 ('0', '0',  "00", "00", "00", "0100", "0001", "0001"),
		 ('1', '0',  "10", "10", "00", "1111", "0000", "0000"));
	begin
		assert false report "Testes iniciados" severity note;
		simulando <= '1'; -- Habilita clock
		
		for i in patterns'range loop
			reset_in    <= patterns(i).reset;
			regWrite_in <= patterns(i).regWrite;
			wr_in       <= patterns(i).wr;
			rr1_in      <= patterns(i).rr1;
			rr2_in      <= patterns(i).rr2;
			d_in        <= patterns(i).d;
			
			wait for 20 ns;
			
			assert q1_out = patterns(i).q1
			report "Erro no sinal q1 do teste " & integer'image(i)  
			severity error;
			
			assert q2_out = patterns(i).q2
			report "Erro no sinal q2 do teste " & integer'image(i)  
			severity error;
		end loop;
		assert false report "Testes concluidos" severity note;
		simulando <= '0'; -- Desabilita clock		
		wait;  -- para a execução do simulador, caso contrário este process é reexecutado indefinidamente.
	end process;
end tb;