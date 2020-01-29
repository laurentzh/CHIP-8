with BMP_Fonts;
with HAL.Bitmap; use HAL.Bitmap;
with HAL.Framebuffer; use HAL.Framebuffer;
with LCD_Std_Out;
with STM32.Board; use STM32.Board;

package body Gfx is
   
   procedure Initialize is
   begin
      -- Initialize LCD
      Display.Initialize;
      Display.Initialize_Layer(1, ARGB_8888);
      Display.Initialize_Layer(2, ARGB_8888);
      Display.Set_Orientation(Landscape);
      
      -- Set Background color
      LCD_Std_Out.Set_Font (BMP_Fonts.Font8x8);
      LCD_Std_Out.Current_Background_Color := Black;
    
      
      Clear_Layer(1);
      Clear_Layer(2);
      
      -- Apply color
      LCD_Std_Out.Clear_Screen;
   end;
   
   procedure Draw_Keyboard is
      Pt : constant Point := (0, 160);
      Rct : constant Rect := (Pt, 40, 40);
   begin
      Display.Hidden_Buffer(1).Set_Source(Red);
      Display.Hidden_Buffer(1).Fill_Rect(Rct);
      Display.Update_Layer(1, False);
   end;

   procedure Draw_Pixel(X : Integer; Y : Integer; Pixel : Boolean) is
      Color : constant Bitmap_Color := (if Pixel then White else Transparent);
      Pt : constant Point := (X * 5, Y * 5);
      Rct : constant Rect := (Pt, 5, 5);
   begin
      Display.Hidden_Buffer(2).Set_Source(Color);
      Display.Hidden_Buffer(2).Fill_Rect(Rct);
   end Draw_Pixel;
   
   procedure Clear_Layer(Layer : Integer) is
   begin
      Display.Hidden_Buffer(Layer).Set_Source(Transparent);
      Display.Hidden_Buffer(Layer).Fill;
      Display.Hidden_Buffer(Layer).Set_Source(White);
   end;
   
end Gfx;
