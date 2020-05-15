package org.flixel.data
{
   import org.flixel.FlxG;
   
   public class FlxGamepad extends FlxInput
   {
       
      
      public var UP:Boolean;
      
      public var DOWN:Boolean;
      
      public var LEFT:Boolean;
      
      public var RIGHT:Boolean;
      
      public var A:Boolean;
      
      public var B:Boolean;
      
      public var X:Boolean;
      
      public var Y:Boolean;
      
      public var START:Boolean;
      
      public var SELECT:Boolean;
      
      public var L1:Boolean;
      
      public var L2:Boolean;
      
      public var R1:Boolean;
      
      public var R2:Boolean;
      
      public function FlxGamepad()
      {
         super();
      }
      
      public function bind(param1:String = null, param2:String = null, param3:String = null, param4:String = null, param5:String = null, param6:String = null, param7:String = null, param8:String = null, param9:String = null, param10:String = null, param11:String = null, param12:String = null, param13:String = null, param14:String = null) : void
      {
         if(param1 != null)
         {
            addKey("UP",FlxG.keys._lookup[param1]);
         }
         if(param2 != null)
         {
            addKey("DOWN",FlxG.keys._lookup[param2]);
         }
         if(param3 != null)
         {
            addKey("LEFT",FlxG.keys._lookup[param3]);
         }
         if(param4 != null)
         {
            addKey("RIGHT",FlxG.keys._lookup[param4]);
         }
         if(param5 != null)
         {
            addKey("A",FlxG.keys._lookup[param5]);
         }
         if(param6 != null)
         {
            addKey("B",FlxG.keys._lookup[param6]);
         }
         if(param7 != null)
         {
            addKey("X",FlxG.keys._lookup[param7]);
         }
         if(param8 != null)
         {
            addKey("Y",FlxG.keys._lookup[param8]);
         }
         if(param9 != null)
         {
            addKey("START",FlxG.keys._lookup[param9]);
         }
         if(param10 != null)
         {
            addKey("SELECT",FlxG.keys._lookup[param10]);
         }
         if(param11 != null)
         {
            addKey("L1",FlxG.keys._lookup[param11]);
         }
         if(param12 != null)
         {
            addKey("L2",FlxG.keys._lookup[param12]);
         }
         if(param13 != null)
         {
            addKey("R1",FlxG.keys._lookup[param13]);
         }
         if(param14 != null)
         {
            addKey("R2",FlxG.keys._lookup[param14]);
         }
      }
   }
}
