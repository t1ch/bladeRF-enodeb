library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;


library nuand;
    use nuand.fifo_readwrite_p.all;

entity enodeb_top is
  port (
    tx_clock                :   in      std_logic ;
    tx_reset                :   in      std_logic;
    tx_packet_empty         :   in      std_logic;
    tx_packet_control       :   in      packet_control_t;
    tx_led_1                :   out     std_logic ;
    tx_led_2                :   out     std_logic ;
    tx_led_3                :   out     std_logic
  ) ;
end enodeb_top ;

architecture simple of enodeb_top is
  signal packet_counter : natural range 0 to 3 := 0;
begin

  blink_leds : process (tx_clock)
  begin
    if (rising_edge(tx_clock)) then
        if (packet_counter = 0) then
            tx_led_2 <= '1';
            tx_led_1 <= '1';
            tx_led_3 <= '1';
        elsif (packet_counter = 1) then
            tx_led_2 <= '0';
            tx_led_1 <= '1';
            tx_led_3 <= '1';
        elsif (packet_counter = 2) then
            tx_led_2 <= '0';
            tx_led_1 <= '0';
            tx_led_3 <= '1';
        elsif (packet_counter = 3) then
            tx_led_2 <= '0';
            tx_led_1 <= '0';
            tx_led_3 <= '0';
        end if;
    end if;
  end process;


  receive_packets : process(tx_clock)
  begin
    if (rising_edge(tx_clock)) then
      if tx_packet_empty = '0' then
        if(packet_counter = 3) then
          packet_counter <= 0;
        end if;
        if(tx_packet_control.data_valid = '1') then
        packet_counter <= packet_counter + 1;
        end if;
      end if;
    end if;
  end process;

end simple;
