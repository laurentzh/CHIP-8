package types is

type Nibble is mod 16 with Size => 4;
type Byte is mod 256 with Size => 8;
type Word is mod 65536 with Size => 16;

subtype Address is Integer range 0 .. 4095;
type Memory is array (Address) of Byte;

end types;
