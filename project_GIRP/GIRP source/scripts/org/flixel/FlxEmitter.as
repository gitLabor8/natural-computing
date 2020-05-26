package org.flixel
{
   import org.flixel.data.FlxParticle;
   
   public class FlxEmitter extends FlxGroup
   {
       
      
      public var minParticleSpeed:FlxPoint;
      
      public var maxParticleSpeed:FlxPoint;
      
      public var particleDrag:FlxPoint;
      
      public var minRotation:Number;
      
      public var maxRotation:Number;
      
      public var gravity:Number;
      
      public var on:Boolean;
      
      public var delay:Number;
      
      public var quantity:uint;
      
      public var justEmitted:Boolean;
      
      protected var _explode:Boolean;
      
      protected var _timer:Number;
      
      protected var _particle:uint;
      
      protected var _counter:uint;
      
      public function FlxEmitter(param1:Number = 0, param2:Number = 0)
      {
         super();
         x = param1;
         y = param2;
         width = 0;
         height = 0;
         minParticleSpeed = new FlxPoint(-100,-100);
         maxParticleSpeed = new FlxPoint(100,100);
         minRotation = -360;
         maxRotation = 360;
         gravity = 400;
         particleDrag = new FlxPoint();
         delay = 0;
         quantity = 0;
         _counter = 0;
         _explode = true;
         exists = false;
         on = false;
         justEmitted = false;
      }
      
      public function createSprites(param1:Class, param2:uint = 50, param3:uint = 16, param4:Boolean = true, param5:Number = 0, param6:Number = 0) : FlxEmitter
      {
         var _loc8_:* = 0;
         var _loc7_:* = null;
         var _loc11_:Number = NaN;
         var _loc10_:Number = NaN;
         members = [];
         var _loc9_:uint = 1;
         if(param4)
         {
            _loc7_ = new FlxSprite();
            _loc7_.loadGraphic(param1,true);
            _loc9_ = _loc7_.frames;
         }
         var _loc12_:uint = 0;
         while(_loc12_ < param2)
         {
            if(param5 > 0 && param6 > 0)
            {
               _loc7_ = new FlxParticle(param6) as FlxSprite;
            }
            else
            {
               _loc7_ = new FlxSprite();
            }
            if(param4)
            {
               _loc8_ = uint(FlxU.random() * _loc9_);
               if(param3 > 0)
               {
                  _loc7_.loadRotatedGraphic(param1,param3,_loc8_);
               }
               else
               {
                  _loc7_.loadGraphic(param1,true);
                  _loc7_.frame = _loc8_;
               }
            }
            else if(param3 > 0)
            {
               _loc7_.loadRotatedGraphic(param1,param3);
            }
            else
            {
               _loc7_.loadGraphic(param1);
            }
            if(param5 > 0)
            {
               _loc11_ = _loc7_.width;
               _loc10_ = _loc7_.height;
               _loc7_.width = _loc7_.width * param5;
               _loc7_.height = _loc7_.height * param5;
               _loc7_.offset.x = (_loc11_ - _loc7_.width) / 2;
               _loc7_.offset.y = (_loc10_ - _loc7_.height) / 2;
               _loc7_.solid = true;
            }
            else
            {
               _loc7_.solid = false;
            }
            _loc7_.exists = false;
            _loc7_.scrollFactor = scrollFactor;
            add(_loc7_);
            _loc12_++;
         }
         return this;
      }
      
      public function setSize(param1:uint, param2:uint) : void
      {
         width = param1;
         height = param2;
      }
      
      public function setXSpeed(param1:Number = 0, param2:Number = 0) : void
      {
         minParticleSpeed.x = param1;
         maxParticleSpeed.x = param2;
      }
      
      public function setYSpeed(param1:Number = 0, param2:Number = 0) : void
      {
         minParticleSpeed.y = param1;
         maxParticleSpeed.y = param2;
      }
      
      public function setRotation(param1:Number = 0, param2:Number = 0) : void
      {
         minRotation = param1;
         maxRotation = param2;
      }
      
      protected function updateEmitter() : void
      {
         var _loc2_:* = 0;
         var _loc1_:* = 0;
         if(_explode)
         {
            _timer = _timer + FlxG.elapsed;
            if(delay > 0 && _timer > delay)
            {
               kill();
               return;
            }
            if(on)
            {
               on = false;
               _loc2_ = uint(_particle);
               _loc1_ = uint(members.length);
               if(quantity > 0)
               {
                  _loc1_ = uint(quantity);
               }
               _loc1_ = uint(_loc1_ + _particle);
               while(_loc2_ < _loc1_)
               {
                  emitParticle();
                  _loc2_++;
               }
            }
            return;
         }
         if(!on)
         {
            return;
         }
         _timer = _timer + FlxG.elapsed;
         while(_timer > delay && (quantity <= 0 || _counter < quantity))
         {
            _timer = _timer - delay;
            emitParticle();
         }
      }
      
      override protected function updateMembers() : void
      {
         var _loc1_:* = null;
         var _loc3_:uint = 0;
         var _loc2_:uint = members.length;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = members[_loc3_++] as FlxObject;
            if(_loc1_ != null && _loc1_.exists && _loc1_.active)
            {
               _loc1_.update();
            }
         }
      }
      
      override public function update() : void
      {
         justEmitted = false;
         super.update();
         updateEmitter();
      }
      
      public function start(param1:Boolean = true, param2:Number = 0, param3:uint = 0) : void
      {
         if(members.length <= 0)
         {
            FlxG.log("WARNING: there are no sprites loaded in your emitter.\nAdd some to FlxEmitter.members or use FlxEmitter.createSprites().");
            return;
         }
         _explode = param1;
         if(!_explode)
         {
            _counter = 0;
         }
         if(!exists)
         {
            _particle = 0;
         }
         exists = true;
         visible = true;
         active = true;
         dead = false;
         on = true;
         _timer = 0;
         if(quantity == 0)
         {
            quantity = param3;
         }
         else if(param3 != 0)
         {
            quantity = param3;
         }
         if(param2 != 0)
         {
            delay = param2;
         }
         if(delay < 0)
         {
            delay = -delay;
         }
         if(delay == 0)
         {
            if(param1)
            {
               delay = 3;
            }
            else
            {
               delay = 0.1;
            }
         }
      }
      
      public function emitParticle() : void
      {
         _counter = Number(_counter) + 1;
         var _loc1_:FlxSprite = members[_particle] as FlxSprite;
         _loc1_.visible = true;
         _loc1_.exists = true;
         _loc1_.active = true;
         _loc1_.x = x - (_loc1_.width >> 1) + FlxU.random() * width;
         _loc1_.y = y - (_loc1_.height >> 1) + FlxU.random() * height;
         _loc1_.velocity.x = minParticleSpeed.x;
         if(minParticleSpeed.x != maxParticleSpeed.x)
         {
            _loc1_.velocity.x = _loc1_.velocity.x + FlxU.random() * (maxParticleSpeed.x - minParticleSpeed.x);
         }
         _loc1_.velocity.y = minParticleSpeed.y;
         if(minParticleSpeed.y != maxParticleSpeed.y)
         {
            _loc1_.velocity.y = _loc1_.velocity.y + FlxU.random() * (maxParticleSpeed.y - minParticleSpeed.y);
         }
         _loc1_.acceleration.y = gravity;
         _loc1_.angularVelocity = minRotation;
         if(minRotation != maxRotation)
         {
            _loc1_.angularVelocity = _loc1_.angularVelocity + FlxU.random() * (maxRotation - minRotation);
         }
         if(_loc1_.angularVelocity != 0)
         {
            _loc1_.angle = FlxU.random() * 360 - 180;
         }
         _loc1_.drag.x = particleDrag.x;
         _loc1_.drag.y = particleDrag.y;
         _particle = Number(_particle) + 1;
         if(_particle >= members.length)
         {
            _particle = 0;
         }
         _loc1_.onEmit();
         justEmitted = true;
      }
      
      public function stop(param1:Number = 3) : void
      {
         _explode = true;
         delay = param1;
         if(delay < 0)
         {
            delay = -param1;
         }
         on = false;
      }
      
      public function at(param1:FlxObject) : void
      {
         x = param1.x + param1.origin.x;
         y = param1.y + param1.origin.y;
      }
      
      override public function kill() : void
      {
         super.kill();
         on = false;
      }
   }
}
