package org.flixel
{
   public class FlxPoint
   {
       
      
      public var x:Number;
      
      public var y:Number;
      
      public function FlxPoint(param1:Number = 0, param2:Number = 0)
      {
         super();
         x = param1;
         y = param2;
      }
      
      public function toString() : String
      {
         return FlxU.getClassName(this,true);
      }
   }
}
