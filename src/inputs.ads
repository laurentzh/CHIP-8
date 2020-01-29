with Types; use Types;

package Inputs is

   subtype Position_X is Integer range 0 .. 319;
   subtype Position_Y is Integer range 160 .. 239;
   
   type Layout_Array is array (0 .. 1, 0 .. 7) of Integer;
   Layout : constant Layout_Array := ((1, 2, 3, 16#C#, 7, 8, 9, 16#E#),
                                      (4, 5, 6, 16#D#, 16#A#, 0, 16#B#, 16#F#));
   
   procedure Update_Pressed_Keys(Keys : in out Keys_List);
   function Get_Key(X : Position_X; Y : Position_Y) return Integer;
   
end Inputs;
