library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;


library nuand;
    use nuand.fifo_readwrite_p.all;

entity enodeb_top is
  port (
    tx_clock                :   in      std_logic ;
    tx_reset                :   in      std_logic ;
    tx_packet_control       :   in      packet_control_t;
    tx_packet_empty         :   in      std_logic;
    tx_packet_ready         :   out     std_logic;
    tx_leds                 :   out     std_logic_vector( 2 downto 0)
  ) ;
end enodeb_top ;

architecture simple of enodeb_top is
  type fsm_tx_t is (RESET,WAIT_FOR_SOP,WAIT_FOR_EOP,EOP_FOUND,LAST);
  type state_tx_t is record
    fsm : fsm_tx_t;
    ready_for_packet : std_logic;
    timer : natural range 0 to 62500000 ;
  end record;
  signal current_tx_state, future_tx_state          :  state_tx_t ;
  attribute keep: boolean;
  attribute noprune: boolean;
  attribute preserve: boolean;
  attribute keep of current_tx_state : signal is true;
  attribute noprune of current_tx_state : signal is true;
  attribute preserve of current_tx_state : signal is true;

function NULL_TX_STATE return state_tx_t is
  variable rv : state_tx_t;
begin
  rv.fsm := RESET ;
  rv.ready_for_packet := '0' ;
  rv.timer := 0;
  return rv ;
end function ;

begin

tx_packet_ready <= '1' when (current_tx_state.ready_for_packet = '1' ) else '0' ;

tx_leds <= "000" when (current_tx_state.fsm = WAIT_FOR_EOP ) else
           "011" when (current_tx_state.fsm = WAIT_FOR_SOP) else
           "101" when (current_tx_state.fsm = EOP_FOUND) else
           "001" when (current_tx_state.fsm = LAST) else
           "111";

tx_state_comb : process(all)
begin
  future_tx_state <= current_tx_state;
  case current_tx_state.fsm is
    when RESET =>
      future_tx_state.fsm <= WAIT_FOR_SOP;
      future_tx_state.ready_for_packet <= '1';
    when WAIT_FOR_SOP =>
      if(tx_packet_control.pkt_sop = '1') then
        future_tx_state.ready_for_packet <= '1';
        future_tx_state.fsm <= WAIT_FOR_EOP;
      else
        future_tx_state.fsm <= WAIT_FOR_SOP;
        future_tx_state.ready_for_packet <= '1';
      end if;
    when WAIT_FOR_EOP =>
      if(tx_packet_control.pkt_eop = '1') then
        future_tx_state.ready_for_packet <= '1';
        future_tx_state.fsm <= EOP_FOUND;
      else
        future_tx_state.ready_for_packet <= '1';
        future_tx_state.fsm <= WAIT_FOR_EOP;
      end if;
    when EOP_FOUND =>
      future_tx_state.fsm <= LAST;
    when LAST =>
      future_tx_state.fsm <= RESET;
  end case;
end process tx_state_comb;


process(tx_clock, tx_reset)
begin
  if( tx_reset = '1' ) then
    current_tx_state <= NULL_TX_STATE ;
  elsif( rising_edge(tx_clock) ) then
    current_tx_state <= future_tx_state ;
  end if ;
end process ;

end simple;
