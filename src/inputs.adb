with STM32.Board; use STM32.Board;
with HAL.Touch_Panel; use HAL.Touch_Panel;

package body Inputs is

   procedure Update_Pressed_Keys(Keys : in out Keys_List) is
      State : constant TP_State := Touch_Panel.Get_All_Touch_Points;
   begin
      Keys := (others => False);
      for I in State'First .. State'Last loop
         Keys(Get_Key(State(I).X, State(I).Y)) := True;
      end loop;
   end Update_Pressed_Keys;
   
   function Get_Key(X : Position_X; Y : Position_Y) return Integer is
   begin
      return Layout((Y - Position_Y'First) / 40, X / 40);
   end Get_Key;

end Inputs;
