with Interfaces; use Interfaces;

package Types is

   subtype Byte is Unsigned_8;
   subtype Word is Unsigned_16;

   subtype Address is Word range 0 .. 4095;
   type Memory is array (Address) of Byte;

   subtype Rom_Address is Word range 16#200# .. 16#FFF#;
   type Rom is array (Rom_Address) of Byte;

   type Registers is array (0 .. 15) of Byte;
   -- Width: 64 -- Height: 32
   type Screen_Array is array (0 .. 31, 0 .. 63) of Boolean;
   type Keys_List is array (0 .. 15) of Boolean;

end Types;
