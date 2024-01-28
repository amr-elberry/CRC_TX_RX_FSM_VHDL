
---------------------------------------------------------------------------------
--FSM_RX_CRC

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:57:54 10/30/2023 
-- Design Name: 
-- Module Name:    Rx_fsm - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Rx_fsm is
port(		rst,clk, tx_out         :in   std_logic;
		   Data_out          	   :out  std_logic_vector (5 downto 0));
end Rx_fsm;

architecture Behavioral of Rx_fsm is
----------------------------------------encoding------------------------------------------------------
   type state_type is (st0,st1,st2,st3,st4,st5,st6); 
   signal state, next_state : state_type; 
	signal parity            :std_logic;
   signal valid             :std_logic;	
	signal Data         		 :  std_logic_vector (5 downto 0);
------------------------------------------------------------------------------------------------------
begin

parity <= data(0) xor data(1) xor data(2) xor data(3);
data_out<=data;
---------------------------------------sequential part------------------------------------------------
process(clk)
begin
      if rising_edge(clk) then
         if (rst = '1') then
            state <= st0;
			
         else
            state <= next_state;
			
         end if;        
      end if;
end process;
-------------------------------------------------------------------------------------------------------
-----------------------------------------combinational part--------------------------------------------
process(state,parity,tx_out)
begin
	 case (state) is
	 
         when st0 =>
            if tx_out <= '0' then
               next_state <= st1;
				else 
					next_state <= st0;
            end if;
				data <="000000";
         when st1 =>
               next_state <= st2;
					data(0) <= tx_out;
					
         when st2 =>
               next_state <= st3;
					
				   data(1) <= tx_out;
         when st3 =>
               next_state <= st4;
				   data(2) <= tx_out;
         when st4 =>
               next_state <= st5;
				   data(3) <= tx_out;
         when st5 =>
               next_state <= st6;
				   data(4) <= tx_out;
					valid <= data(4) xnor parity ;
         when st6 =>
				if valid <= '1' and tx_out <= '1' then
					data(5) <= '1';
               next_state <= st0;
				else 
					next_state <= st0;
					data <= "111111";
				end if;
         when others =>
            next_state <= st0;
      end case;      
end process;
-------------------------------------------------------------------------------------------------------

end Behavioral;

