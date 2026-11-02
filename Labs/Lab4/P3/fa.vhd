library ieee;
use ieee.std_logic_1164.all;

entity fa is
    port (
        a, b, cin : in std_logic;
        cout, sum : out std_logic
    );
end entity fa;

architecture dataflow of fa is
begin
    cout <= (a and b) or (a and cin) or (b and cin);
    sum <= a xor b xor cin;
end architecture dataflow;