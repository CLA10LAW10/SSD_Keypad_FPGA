library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity single_pulse_detector is
    generic (
        detect_type : std_logic_vector(1 downto 0) := "00" -- edge detection type
    );
    port (
        clk          : in std_logic;
        rst          : in std_logic;
        input_signal : in std_logic;
        output_pulse : out std_logic);
end single_pulse_detector;

architecture Behavioral of single_pulse_detector is
    signal ff0 : std_logic;
    signal ff1 : std_logic;
begin

    process (clk, rst)
    begin
        if rst = '1' then
            ff0 <= '0';
            ff1 <= '0';
        elsif rising_edge(clk) then
            ff0 <= input_signal;
            ff1 <= ff0;
        end if;
    end process;

    with detect_type select output_pulse <=
        not ff1 and ff0 when "00", -- rising edge
        not ff0 and ff1 when "01", -- falling edge
        ff0 xor ff1 when "10",     -- both edges
        '0' when others;           -- none

end Behavioral;
-- LIBRARY IEEE;
-- USE IEEE.STD_LOGIC_1164.ALL;
-- USE IEEE.NUMERIC_STD.ALL;

-- ENTITY single_pulse_detector IS
--     PORT (
--         clk : IN STD_LOGIC;             -- Input clock
--         rst : IN STD_LOGIC;             -- Asynchronous active high reset
--         input_signal : IN STD_LOGIC;    -- Input signal to detect
--         output_pulse : OUT STD_LOGIC);  -- Detected single pulse
-- END single_pulse_detector;

-- ARCHITECTURE Behavioral OF single_pulse_detector IS

--     SIGNAL ff1 : STD_LOGIC; -- Input flip-flop
--     SIGNAL ff2 : STD_LOGIC; -- Input flip-flop

-- BEGIN

--     PROCESS (clk, rst)
--     BEGIN

--         IF rst = '1' THEN           -- Asynchronous active high reset
--             ff1 <= '0';             -- Clear input flipflop 1.
--             ff2 <= '0';             -- Clear input flipflop 2.
--         ELSIF rising_edge(clk) THEN
--             ff1 <= input_signal;    -- Store input value in 1st ff.
--             ff2 <= ff1;             -- Store 1st ff value in 2nd ff.

--         END IF;

--     END PROCESS;

--     output_pulse <= ff1 AND NOT ff2; -- Detect rising edge.

-- END Behavioral;