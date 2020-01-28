package Gfx is

   Screen_Width : constant Integer := 64;
   Screen_Height : constant Integer := 32;
   
   procedure Initialize;
   procedure Draw_Pixel(X : Integer; Y : Integer; Pixel : Boolean);
   procedure Clear;

end Gfx;
