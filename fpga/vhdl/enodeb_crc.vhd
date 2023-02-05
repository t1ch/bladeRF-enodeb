library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library nuand;
use nuand.fifo_readwrite_p.all;

entity enodeb_crc is
  port (
    crc_clock                           : in std_logic;
    crc_reset                           : in std_logic;
    crc_valid                           : in std_logic;
    transport_block_packet_in           : in packet_control_t;
    transport_block_size                : in std_logic;
    crc_done                            : out std_logic
    );
end enodeb_crc;

architecture behavioral of enodeb_crc is

  type transport_block_state_t is (
    WAITING_FOR_TRANSPORT_BLOCK,
    START_OF_TRANSPORT_BLOCK,
    BODY_OF_TRANSPORT_BLOCK,
    END_OF_TRANSPORT_BLOCK
  );

  signal next_state: transport_block_state_t ;
begin
  process (crc_clock, crc_reset)
  begin
    if crc_reset = '1' then
      next_state <= WAITING_FOR_TRANSPORT_BLOCK;
    elsif rising_edge(crc_clock) then

    end if;
  end process;

end behavioral;
