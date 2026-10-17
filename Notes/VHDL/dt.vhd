-- an array contains mult elements of the same type. when an array object is declared, an existing data type must be used

type INT_ARRAY is array (integer range <>) of integer;
variable INT_TABLE: INT_ARRAY(0 to 9);
variable LOC_BUS: std_ulogic_vector(7 downto 0);

type atype is array (natural range<>) of integer;
subtype abtype is atype(0 to 63);

variable a1: atype (0 to 100);
variable a2: abtype;

constant a3: atype := (1=> 10, 2=>20,3)