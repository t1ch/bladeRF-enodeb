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
  type fsm_tx_t is (IDLE,CONFIGURED,
                    RUNNING);

  type state_tx_t is record
    fsm : fsm_tx_t;
    ready_for_packet : std_logic;
    message_length : integer;
    read_dwords : integer;
    data : std_logic_vector(31 downto 0);
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
  rv.fsm := IDLE ;
  rv.ready_for_packet := '0' ;
  rv.timer := 0;
  rv.transport_block_dwords := 0;
  rv.read_dwords := 0;
  rv.data := (others => '0');
  return rv ;
end function ;

begin

tx_packet_ready <= '1' when (current_tx_state.ready_for_packet = '1' ) else '0' ;
tx_leds <= "011" when (current_tx_state.fsm = IDLE) else
           "101" when (current_tx_state.fsm = WAIT_FOR_SOP) else
           "001" when (current_tx_state.fsm = READ_TRANSPORT_BLOCK) else
           "000" when (current_tx_state.fsm = DONE) else
           "010" when (current_tx_state.fsm = ERR) else
           "111";

tx_state_comb : process(all)
begin
  future_tx_state <= current_tx_state;
  future_tx_state.ready_for_packet <= '0';
  case current_tx_state.fsm is

    when IDLE =>
        future_tx_state.fsm <= WAIT_FOR_SOP;
        future_tx_state.ready_for_packet <= '1';

    when WAIT_FOR_SOP =>
      if(tx_packet_control.pkt_sop = '1' and tx_packet_control.data_valid = '1') then
        future_tx_state.read_dwords <= current_tx_state.read_dwords + 1;
        future_tx_state.transport_block_dwords <= to_integer(unsigned(tx_packet_control.data));
        future_tx_state.ready_for_packet <= '1';
        future_tx_state.fsm <= READ_TRANSPORT_BLOCK;
      else
        future_tx_state.ready_for_packet <= '1';
      end if;

    when READ_TRANSPORT_BLOCK =>
      future_tx_state.ready_for_packet <= '1';
      if(tx_packet_control.pkt_eop = '0' and tx_packet_control.data_valid = '1') then
        future_tx_state.data <= tx_packet_control.data ;
        future_tx_state.read_dwords <= current_tx_state.read_dwords + 1;
      end if ;

      if(tx_packet_control.pkt_eop = '1') then
        future_tx_state.ready_for_packet <= '0';
        future_tx_state.fsm <= FINISH_TRANSPORT_BLOCK;
      end if;

    when FINISH_TRANSPORT_BLOCK =>
      if(current_tx_state.data = "00000000000000000000000000001101") then
        future_tx_state.fsm <= DONE;
      else
        future_tx_state.fsm <= ERR;
      end if;

    when DONE =>
      future_tx_state.fsm <= DONE;
    when ERR =>
      future_tx_state.fsm <= ERR;
  end case;

end process tx_state_comb;

tx_sync_proc : process(tx_clock, tx_reset)
begin
  if( tx_reset = '1' ) then
    current_tx_state <= NULL_TX_STATE ;
  elsif( rising_edge(tx_clock) ) then
    current_tx_state <= future_tx_state ;
  end if ;
end process tx_sync_proc;


end simple;
