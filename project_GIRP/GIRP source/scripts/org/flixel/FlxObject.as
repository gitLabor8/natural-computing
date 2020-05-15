package org.flixel
{
   import flash.geom.Point;
   
   public class FlxObject extends FlxRect
   {
      
      protected static const _pZero:FlxPoint = new FlxPoint();
       
      
      public var exists:Boolean;
      
      public var active:Boolean;
      
      public var visible:Boolean;
      
      protected var _solid:Boolean;
      
      protected var _fixed:Boolean;
      
      public var velocity:FlxPoint;
      
      public var acceleration:FlxPoint;
      
      public var drag:FlxPoint;
      
      public var maxVelocity:FlxPoint;
      
      public var angle:Number;
      
      public var angularVelocity:Number;
      
      public var angularAcceleration:Number;
      
      public var angularDrag:Number;
      
      public var maxAngular:Number;
      
      public var origin:FlxPoint;
      
      public var thrust:Number;
      
      public var maxThrust:Number;
      
      public var scrollFactor:FlxPoint;
      
      protected var _flicker:Boolean;
      
      protected var _flickerTimer:Number;
      
      public var health:Number;
      
      public var dead:Boolean;
      
      protected var _point:FlxPoint;
      
      protected var _rect:FlxRect;
      
      protected var _flashPoint:Point;
      
      public var moves:Boolean;
      
      public var colHullX:FlxRect;
      
      public var colHullY:FlxRect;
      
      public var colVector:FlxPoint;
      
      public var colOffsets:Array;
      
      var _group:Boolean;
      
      public var onFloor:Boolean;
      
      public var collideLeft:Boolean;
      
      public var collideRight:Boolean;
      
      public var collideTop:Boolean;
      
      public var collideBottom:Boolean;
      
      public function FlxObject(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0)
      {
         super(param1,param2,param3,param4);
         exists = true;
         active = true;
         visible = true;
         _solid = true;
         _fixed = false;
         moves = true;
         collideLeft = true;
         collideRight = true;
         collideTop = true;
         collideBottom = true;
         origin = new FlxPoint();
         velocity = new FlxPoint();
         acceleration = new FlxPoint();
         drag = new FlxPoint();
         maxVelocity = new FlxPoint(10000,10000);
         angle = 0;
         angularVelocity = 0;
         angularAcceleration = 0;
         angularDrag = 0;
         maxAngular = 10000;
         thrust = 0;
         scrollFactor = new FlxPoint(1,1);
         _flicker = false;
         _flickerTimer = -1;
         health = 1;
         dead = false;
         _point = new FlxPoint();
         _rect = new FlxRect();
         _flashPoint = new Point();
         colHullX = new FlxRect();
         colHullY = new FlxRect();
         colVector = new FlxPoint();
         colOffsets = new Array(new FlxPoint());
         _group = false;
      }
      
      public function destroy() : void
      {
      }
      
      public function get solid() : Boolean
      {
         return _solid;
      }
      
      public function set solid(param1:Boolean) : void
      {
         _solid = param1;
      }
      
      public function get fixed() : Boolean
      {
         return _fixed;
      }
      
      public function set fixed(param1:Boolean) : void
      {
         _fixed = param1;
      }
      
      public function refreshHulls() : void
      {
         colHullX.x = x;
         colHullX.y = y;
         colHullX.width = width;
         colHullX.height = height;
         colHullY.x = x;
         colHullY.y = y;
         colHullY.width = width;
         colHullY.height = height;
      }
      
      protected function updateMotion() : void
      {
         var _loc5_:Number = NaN;
         var _loc4_:* = null;
         var _loc2_:* = null;
         var _loc1_:Number = NaN;
         if(!moves)
         {
            return;
         }
         if(_solid)
         {
            refreshHulls();
         }
         onFloor = false;
         _loc5_ = (FlxU.computeVelocity(angularVelocity,angularAcceleration,angularDrag,maxAngular) - angularVelocity) / 2;
         angularVelocity = angularVelocity + _loc5_;
         angle = angle + angularVelocity * FlxG.elapsed;
         angularVelocity = angularVelocity + _loc5_;
         if(thrust != 0)
         {
            _loc4_ = FlxU.rotatePoint(-thrust,0,0,0,angle);
            _loc2_ = FlxU.rotatePoint(-maxThrust,0,0,0,angle);
            _loc1_ = _loc2_.x > 0?_loc2_.x:Number(-_loc2_.x);
            if(_loc1_ > (_loc2_.y > 0?_loc2_.y:Number(-_loc2_.y)))
            {
               _loc2_.y = _loc1_;
            }
            else
            {
               _loc1_ = _loc2_.y > 0?_loc2_.y:Number(-_loc2_.y);
            }
            var _loc7_:* = _loc1_ > 0?_loc1_:Number(-_loc1_);
            maxVelocity.y = _loc7_;
            maxVelocity.x = _loc7_;
         }
         else
         {
            _loc4_ = _pZero;
         }
         _loc5_ = (FlxU.computeVelocity(velocity.x,acceleration.x + _loc4_.x,drag.x,maxVelocity.x) - velocity.x) / 2;
         velocity.x = velocity.x + _loc5_;
         var _loc6_:Number = velocity.x * FlxG.elapsed;
         velocity.x = velocity.x + _loc5_;
         _loc5_ = (FlxU.computeVelocity(velocity.y,acceleration.y + _loc4_.y,drag.y,maxVelocity.y) - velocity.y) / 2;
         velocity.y = velocity.y + _loc5_;
         var _loc3_:Number = velocity.y * FlxG.elapsed;
         velocity.y = velocity.y + _loc5_;
         x = x + _loc6_;
         y = y + _loc3_;
         if(!_solid)
         {
            return;
         }
         colVector.x = _loc6_;
         colVector.y = _loc3_;
         colHullX.width = colHullX.width + (colVector.x > 0?colVector.x:Number(-colVector.x));
         if(colVector.x < 0)
         {
            colHullX.x = colHullX.x + colVector.x;
         }
         colHullY.x = x;
         colHullY.height = colHullY.height + (colVector.y > 0?colVector.y:Number(-colVector.y));
         if(colVector.y < 0)
         {
            colHullY.y = colHullY.y + colVector.y;
         }
      }
      
      protected function updateFlickering() : void
      {
         if(flickering())
         {
            if(_flickerTimer > 0)
            {
               _flickerTimer = _flickerTimer - FlxG.elapsed;
               if(_flickerTimer == 0)
               {
                  _flickerTimer = -1;
               }
            }
            if(_flickerTimer < 0)
            {
               flicker(-1);
            }
            else
            {
               _flicker = !_flicker;
               visible = !_flicker;
            }
         }
      }
      
      public function update() : void
      {
         updateMotion();
         updateFlickering();
      }
      
      public function render() : void
      {
      }
      
      public function overlaps(param1:FlxObject) : Boolean
      {
         getScreenXY(_point);
         var _loc3_:Number = _point.x;
         var _loc2_:Number = _point.y;
         param1.getScreenXY(_point);
         if(_point.x <= _loc3_ - param1.width || _point.x >= _loc3_ + width || _point.y <= _loc2_ - param1.height || _point.y >= _loc2_ + height)
         {
            return false;
         }
         return true;
      }
      
      public function overlapsPoint(param1:Number, param2:Number, param3:Boolean = false) : Boolean
      {
         param1 = param1 + FlxU.floor(FlxG.scroll.x);
         param2 = param2 + FlxU.floor(FlxG.scroll.y);
         getScreenXY(_point);
         if(param1 <= _point.x || param1 >= _point.x + width || param2 <= _point.y || param2 >= _point.y + height)
         {
            return false;
         }
         return true;
      }
      
      public function collide(param1:FlxObject = null) : Boolean
      {
         return FlxU.collide(this,param1 == null?this:param1);
      }
      
      public function preCollide(param1:FlxObject) : void
      {
      }
      
      public function hitLeft(param1:FlxObject, param2:Number) : void
      {
         hitSide(param1,param2);
      }
      
      public function hitRight(param1:FlxObject, param2:Number) : void
      {
         hitSide(param1,param2);
      }
      
      public function hitSide(param1:FlxObject, param2:Number) : void
      {
         if(!fixed || param1.fixed && (velocity.y != 0 || velocity.x != 0))
         {
            velocity.x = param2;
         }
      }
      
      public function hitTop(param1:FlxObject, param2:Number) : void
      {
         if(!fixed || param1.fixed && (velocity.y != 0 || velocity.x != 0))
         {
            velocity.y = param2;
         }
      }
      
      public function hitBottom(param1:FlxObject, param2:Number) : void
      {
         onFloor = true;
         if(!fixed || param1.fixed && (velocity.y != 0 || velocity.x != 0))
         {
            velocity.y = param2;
         }
      }
      
      public function hurt(param1:Number) : void
      {
         health = health - param1;
         if(health <= 0)
         {
            kill();
         }
      }
      
      public function kill() : void
      {
         exists = false;
         dead = true;
      }
      
      public function flicker(param1:Number = 1) : void
      {
         _flickerTimer = param1;
         if(_flickerTimer < 0)
         {
            _flicker = false;
            visible = true;
         }
      }
      
      public function flickering() : Boolean
      {
         return _flickerTimer >= 0;
      }
      
      public function getScreenXY(param1:FlxPoint = null) : FlxPoint
      {
         if(param1 == null)
         {
            param1 = new FlxPoint();
         }
         param1.x = FlxU.floor(x + FlxU.roundingError) + FlxU.floor(FlxG.scroll.x * scrollFactor.x);
         param1.y = FlxU.floor(y + FlxU.roundingError) + FlxU.floor(FlxG.scroll.y * scrollFactor.y);
         return param1;
      }
      
      public function onScreen() : Boolean
      {
         getScreenXY(_point);
         if(_point.x + width < 0 || _point.x > FlxG.width || _point.y + height < 0 || _point.y > FlxG.height)
         {
            return false;
         }
         return true;
      }
      
      public function reset(param1:Number, param2:Number) : void
      {
         x = param1;
         y = param2;
         exists = true;
         dead = false;
      }
      
      public function getBoundingColor() : uint
      {
         if(solid)
         {
            if(fixed)
            {
               return 2130768421;
            }
            return 2147418130;
         }
         return 2130743529;
      }
   }
}
