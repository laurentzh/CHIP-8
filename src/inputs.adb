with STM32.Board; use STM32.Board;
with HAL.Touch_Panel; use HAL.Touch_Panel;

package body Inputs is

   procedure Update_Pressed_Keys(Keys : in out Keys_List) is
      State : constant TP_State := Touch_Panel.Get_All_Touch_Points;
   begin
      for I in State'First .. State'Last loop
         if State(I).X >= Position_X'First then
            Keys(Get_Key(State(I).X, Position_Y'Last - State(I).Y)) := True;
         end if;
      end loop;
   end Update_Pressed_Keys;
   
   function Get_Key(X : Position_X; Y : Position_Y) return Integer is
   begin
      return Layout((X - Position_X'First) / 40, Y / 40);
   end Get_Key;

end Inputs;
