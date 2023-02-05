library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;


library nuand;
    use nuand.fifo_readwrite_p.all;

entity enodeb_top is
  port (
    tx_clock           :   in  std_logic ;
--    tx_reset           :   in  std_logic ;
--    tx_enable          :   in  std_logic ;

--    packet_en          :   in  std_logic ;

--    tx_packet_control  :   in      packet_control_t ;
--    tx_packet_empty    :   in      std_logic ;
--    tx_packet_ready    :   out     std_logic ;
    tx_led_1           :   out     std_logic ;
    tx_led_2           :   out     std_logic ;
    tx_led_3           :   out     std_logic
  ) ;
end enodeb_top ;

architecture simple of enodeb_top is
  signal tx_led_reg_1  : std_logic;
  signal tx_led_reg_2  : std_logic;
  signal tx_led_reg_3  : std_logic;

begin
  blink_leds : process (tx_clock)
    variable counter : natural range 0 to 57_600_000 := 57_600_000;
  begin
    if (rising_edge(tx_clock)) then
        counter := counter - 1;
        if (counter = 0) then
            counter := 57_600_000;
        elsif (counter < 19_200_000) then
            tx_led_2 <= '0';
            tx_led_1 <= '1';
            tx_led_3 <= '1';
        elsif (counter < 38_400_000) then
            tx_led_2 <= '1';
            tx_led_1 <= '0';
            tx_led_3 <= '1';
        else
            tx_led_2 <= '1';
            tx_led_1 <= '1';
            tx_led_3 <= '0';
        end if;
    end if;
  end process;
end simple;
