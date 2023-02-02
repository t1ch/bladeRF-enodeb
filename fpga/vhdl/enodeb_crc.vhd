library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity enodeb_crc is
  port (
    crc_clock                           : in std_logic;
    crc_reset                           : in std_logic;
    crc_valid                           : in std_logic:
    transport_block_packet_in           : in packet_control_t;
    transport_block_size                : in std_logic;
    crc_done                            : out std_logic;

    );
end enodeb_crc;

architecture behavioral of enodeb_crc is

  type transport_block_state_t is (
    START_OF_TRANSPORT_BLOCK
    BODY_OF_TRANSPORT_BLOCK
    END_OF_TRANSPORT_BLOCK
  )
  signal next_state: transport_block_state_t ;
begin
  process (crc_clock, crc_reset)
  begin
    if rst = '1' then
      next_state <= (others => '0');
    elsif rising_edge(crc_clock) then
      if
      packet_out.data <= packet_in.data;
      packet_out.data_valid <= packet_in.data_valid;
      next_state <= packet_in.pkt_core_id;
    end if;
  end process;
  packet_out.pkt_core_id <= next_state;
  packet_out.pkt_flags <= packet_in.pkt_flags;
  packet_out.pkt_sop <= packet_in.pkt_sop;
  packet_out.pkt_eop <= packet_in.pkt_eop;
end behavioral;
