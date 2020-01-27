with Interfaces; use Interfaces;

package types is

   subtype Byte is Unsigned_8;
   subtype Word is Unsigned_16;

   subtype Address is Integer range 0 .. 4095;
   type Memory is array (Address) of Byte;

end types;
