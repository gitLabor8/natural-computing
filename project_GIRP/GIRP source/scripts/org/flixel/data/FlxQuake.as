package org.flixel.data
{
   import org.flixel.FlxG;
   
   public class FlxQuake
   {
       
      
      protected var _zoom:uint;
      
      protected var _intensity:Number;
      
      protected var _timer:Number;
      
      public var x:int;
      
      public var y:int;
      
      public function FlxQuake(param1:uint)
      {
         super();
         _zoom = param1;
         start(0);
      }
      
      public function start(param1:Number = 0.05, param2:Number = 0.5) : void
      {
         stop();
         _intensity = param1;
         _timer = param2;
      }
      
      public function stop() : void
      {
         x = 0;
         y = 0;
         _intensity = 0;
         _timer = 0;
      }
      
      public function update() : void
      {
         if(_timer > 0)
         {
            _timer = _timer - FlxG.elapsed;
            if(_timer <= 0)
            {
               _timer = 0;
               x = 0;
               y = 0;
            }
            else
            {
               x = (Math.random() * _intensity * FlxG.width * 2 - _intensity * FlxG.width) * _zoom;
               y = (Math.random() * _intensity * FlxG.height * 2 - _intensity * FlxG.height) * _zoom;
            }
         }
      }
   }
}
