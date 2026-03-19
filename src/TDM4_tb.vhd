--+----------------------------------------------------------------------------
--| 
--| COPYRIGHT 2017 United States Air Force Academy All rights reserved.
--| 
--| United States Air Force Academy     __  _______ ___    _________ 
--| Dept of Electrical &               / / / / ___//   |  / ____/   |
--| Computer Engineering              / / / /\__ \/ /| | / /_  / /| |
--| 2354 Fairchild Drive Ste 2F6     / /_/ /___/ / ___ |/ __/ / ___ |
--| USAF Academy, CO 80840           \____//____/_/  |_/_/   /_/  |_|
--| 
--| ---------------------------------------------------------------------------
--|
--| FILENAME      : TDM4_tb.vhd (TEST BENCH)
--| AUTHOR(S)     : Capt Phillip Warner, Capt Dan Johnson, **Your Name**
--| CREATED       : 03/2017 Last modified on 06/24/2020
--| DESCRIPTION   : This file tests the 4 to 1 TDM.
--|
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std, unisim
--|    Files     : TDM4.vhd
--|
--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TDM4_tb is
end TDM4_tb;

architecture test_bench of TDM4_tb is 	

    component TDM4 is
        generic ( k_width : natural := 4);
        Port ( i_clk    : in  STD_LOGIC;
               i_reset  : in  STD_LOGIC;
               i_D3     : in  STD_LOGIC_VECTOR (k_width - 1 downto 0);
               i_D2     : in  STD_LOGIC_VECTOR (k_width - 1 downto 0);
               i_D1     : in  STD_LOGIC_VECTOR (k_width - 1 downto 0);
               i_D0     : in  STD_LOGIC_VECTOR (k_width - 1 downto 0);
               o_data   : out STD_LOGIC_VECTOR (k_width - 1 downto 0);
               o_sel_n  : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    -- Clock
    constant k_clock_period : time := 20 ns;

    -- Constants
    constant k_IO_WIDTH : natural := 4;

    -- Signals
    signal w_clk   : std_logic := '0';
    signal w_reset : std_logic := '0';

    signal w_D3, w_D2, w_D1, w_D0 : std_logic_vector(k_IO_WIDTH-1 downto 0);

    signal w_data  : std_logic_vector(k_IO_WIDTH-1 downto 0);
    signal w_sel_n : std_logic_vector(3 downto 0);

begin

    -- DUT
    uut_inst : TDM4 
    generic map ( k_width => k_IO_WIDTH )
    port map ( 
        i_clk   => w_clk,
        i_reset => w_reset,
        i_D3    => w_D3,
        i_D2    => w_D2,
        i_D1    => w_D1,
        i_D0    => w_D0,
        o_data  => w_data,
        o_sel_n => w_sel_n
    );

    -- Clock process
    clk_process : process
    begin
        while true loop
            w_clk <= '0';
            wait for k_clock_period/2;
            w_clk <= '1';
            wait for k_clock_period/2;
        end loop;
    end process;

    -- Test process
    test_process : process 
    begin
        -- assign test values to data inputs
           w_D3 <= "1000";
           w_D2 <= "0100";
           w_D1 <= "0010";
           w_D0 <= "0001";

        -- reset
        w_reset <= '1';
        wait for k_clock_period;
        w_reset <= '0';

        -- let it run
        wait for 160 ns;

        wait;
    end process;

end test_bench;