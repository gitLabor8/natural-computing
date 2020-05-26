package org.flixel.data
{
   import org.flixel.FlxObject;
   import org.flixel.FlxSprite;
   
   public class FlxParticle extends FlxSprite
   {
       
      
      protected var _bounce:Number;
      
      public function FlxParticle(param1:Number)
      {
         super();
         _bounce = param1;
      }
      
      override public function hitSide(param1:FlxObject, param2:Number) : void
      {
         velocity.x = -velocity.x * _bounce;
         if(angularVelocity != 0)
         {
            angularVelocity = -angularVelocity * _bounce;
         }
      }
      
      override public function hitBottom(param1:FlxObject, param2:Number) : void
      {
         onFloor = true;
         if((velocity.y > 0?velocity.y:Number(-velocity.y)) > _bounce * 100)
         {
            velocity.y = -velocity.y * _bounce;
            if(angularVelocity != 0)
            {
               angularVelocity = angularVelocity * -_bounce;
            }
         }
         else
         {
            angularVelocity = 0;
            super.hitBottom(param1,param2);
         }
         velocity.x = velocity.x * _bounce;
      }
   }
}
