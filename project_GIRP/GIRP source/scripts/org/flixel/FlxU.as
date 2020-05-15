package org.flixel
{
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   
   public class FlxU
   {
      
      static var roundingError:Number = 1.0E-7;
      
      public static var quadTree:FlxQuadTree;
       
      
      public function FlxU()
      {
         super();
      }
      
      public static function openURL(param1:String) : void
      {
      }
      
      public static function abs(param1:Number) : Number
      {
         return param1 > 0?param1:Number(-param1);
      }
      
      public static function floor(param1:Number) : Number
      {
         var _loc2_:Number = int(param1);
         return param1 > 0?_loc2_:Number(_loc2_ != param1?_loc2_ - 1:Number(_loc2_));
      }
      
      public static function ceil(param1:Number) : Number
      {
         var _loc2_:Number = int(param1);
         return param1 > 0?_loc2_ != param1?_loc2_ + 1:Number(_loc2_):Number(_loc2_);
      }
      
      public static function min(param1:Number, param2:Number) : Number
      {
         return param1 <= param2?param1:Number(param2);
      }
      
      public static function max(param1:Number, param2:Number) : Number
      {
         return param1 >= param2?param1:Number(param2);
      }
      
      public static function random(param1:Number = NaN) : Number
      {
         if(isNaN(param1))
         {
            return Math.random();
         }
         if(param1 == 0)
         {
            param1 = Number.MIN_VALUE;
         }
         if(param1 >= 1)
         {
            if(param1 % 1 == 0)
            {
               param1 = param1 / 3.14159265358979;
            }
            param1 = param1 % 1;
         }
         else if(param1 < 0)
         {
            param1 = param1 % 1 + 1;
         }
         return 69621 * (int(param1 * 2147483647)) % 2147483647 / 2147483647;
      }
      
      public static function startProfile() : uint
      {
         return getTimer();
      }
      
      public static function endProfile(param1:uint, param2:String = "Profiler", param3:Boolean = true) : uint
      {
         var _loc4_:uint = getTimer();
         if(param3)
         {
            FlxG.log(param2 + ": " + (_loc4_ - param1) / 1000 + "s");
         }
         return _loc4_;
      }
      
      public static function rotatePoint(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:FlxPoint = null) : FlxPoint
      {
         var _loc11_:* = 0;
         var _loc10_:* = 0;
         var _loc7_:Number = param5 * -0.017453293;
         while(_loc7_ < -3.14159265)
         {
            _loc7_ = _loc7_ + 6.28318531;
         }
         while(_loc7_ > 3.14159265)
         {
            _loc7_ = _loc7_ - 6.28318531;
         }
         if(_loc7_ < 0)
         {
            _loc11_ = Number(1.27323954 * _loc7_ + 0.405284735 * _loc7_ * _loc7_);
            if(_loc11_ < 0)
            {
               _loc11_ = Number(0.225 * (_loc11_ * -_loc11_ - _loc11_) + _loc11_);
            }
            else
            {
               _loc11_ = Number(0.225 * (_loc11_ * _loc11_ - _loc11_) + _loc11_);
            }
         }
         else
         {
            _loc11_ = Number(1.27323954 * _loc7_ - 0.405284735 * _loc7_ * _loc7_);
            if(_loc11_ < 0)
            {
               _loc11_ = Number(0.225 * (_loc11_ * -_loc11_ - _loc11_) + _loc11_);
            }
            else
            {
               _loc11_ = Number(0.225 * (_loc11_ * _loc11_ - _loc11_) + _loc11_);
            }
         }
         _loc7_ = _loc7_ + 1.57079632;
         if(_loc7_ > 3.14159265)
         {
            _loc7_ = _loc7_ - 6.28318531;
         }
         if(_loc7_ < 0)
         {
            _loc10_ = Number(1.27323954 * _loc7_ + 0.405284735 * _loc7_ * _loc7_);
            if(_loc10_ < 0)
            {
               _loc10_ = Number(0.225 * (_loc10_ * -_loc10_ - _loc10_) + _loc10_);
            }
            else
            {
               _loc10_ = Number(0.225 * (_loc10_ * _loc10_ - _loc10_) + _loc10_);
            }
         }
         else
         {
            _loc10_ = Number(1.27323954 * _loc7_ - 0.405284735 * _loc7_ * _loc7_);
            if(_loc10_ < 0)
            {
               _loc10_ = Number(0.225 * (_loc10_ * -_loc10_ - _loc10_) + _loc10_);
            }
            else
            {
               _loc10_ = Number(0.225 * (_loc10_ * _loc10_ - _loc10_) + _loc10_);
            }
         }
         var _loc8_:Number = param1 - param3;
         var _loc9_:Number = param4 - param2;
         if(param6 == null)
         {
            param6 = new FlxPoint();
         }
         param6.x = param3 + _loc10_ * _loc8_ - _loc11_ * _loc9_;
         param6.y = param4 - _loc11_ * _loc8_ - _loc10_ * _loc9_;
         return param6;
      }
      
      public static function getAngle(param1:Number, param2:Number) : Number
      {
         var _loc4_:* = 0.7853981625;
         var _loc5_:Number = 3 * _loc4_;
         var _loc3_:Number = param2 < 0?-param2:Number(param2);
         var _loc6_:* = 0;
         if(param1 >= 0)
         {
            _loc6_ = Number(_loc4_ - _loc4_ * ((param1 - _loc3_) / (param1 + _loc3_)));
         }
         else
         {
            _loc6_ = Number(_loc5_ - _loc4_ * ((param1 + _loc3_) / (_loc3_ - param1)));
         }
         return (param2 < 0?-_loc6_:Number(_loc6_)) * 57.2957796;
      }
      
      public static function getColor(param1:uint, param2:uint, param3:uint, param4:Number = 1.0) : uint
      {
         return ((param4 > 1?param4:Number(param4 * 255)) & 255) << 24 | (param1 & 255) << 16 | (param2 & 255) << 8 | param3 & 255;
      }
      
      public static function getColorHSB(param1:Number, param2:Number, param3:Number, param4:Number = 1.0) : uint
      {
         var _loc5_:* = NaN;
         var _loc7_:* = NaN;
         var _loc6_:* = NaN;
         var _loc10_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         if(param2 == 0)
         {
            _loc5_ = param3;
            _loc7_ = param3;
            _loc6_ = param3;
         }
         else
         {
            if(param1 == 360)
            {
               param1 = 0;
            }
            _loc10_ = param1 / 60;
            _loc8_ = param1 / 60 - _loc10_;
            _loc9_ = param3 * (1 - param2);
            _loc11_ = param3 * (1 - param2 * _loc8_);
            _loc12_ = param3 * (1 - param2 * (1 - _loc8_));
            switch(int(_loc10_))
            {
               case 0:
                  _loc5_ = param3;
                  _loc7_ = _loc12_;
                  _loc6_ = _loc9_;
                  break;
               case 1:
                  _loc5_ = _loc11_;
                  _loc7_ = param3;
                  _loc6_ = _loc9_;
                  break;
               case 2:
                  _loc5_ = _loc9_;
                  _loc7_ = param3;
                  _loc6_ = _loc12_;
                  break;
               case 3:
                  _loc5_ = _loc9_;
                  _loc7_ = _loc11_;
                  _loc6_ = param3;
                  break;
               case 4:
                  _loc5_ = _loc12_;
                  _loc7_ = _loc9_;
                  _loc6_ = param3;
                  break;
               case 5:
                  _loc5_ = param3;
                  _loc7_ = _loc9_;
                  _loc6_ = _loc11_;
            }
         }
         return ((param4 > 1?param4:Number(param4 * 255)) & 255) << 24 | uint(_loc5_ * 255) << 16 | uint(_loc7_ * 255) << 8 | uint(_loc6_ * 255);
      }
      
      public static function getRGBA(param1:uint, param2:Array = null) : Array
      {
         if(param2 == null)
         {
            param2 = [];
         }
         param2[0] = param1 >> 16 & 255;
         param2[1] = param1 >> 8 & 255;
         param2[2] = param1 & 255;
         param2[3] = (param1 >> 24 & 255) / 255;
         return param2;
      }
      
      public static function getHSB(param1:uint, param2:Array = null) : Array
      {
         if(param2 == null)
         {
            param2 = [];
         }
         var _loc3_:Number = (param1 >> 16 & 255) / 255;
         var _loc7_:Number = (param1 >> 8 & 255) / 255;
         var _loc6_:Number = (param1 & 255) / 255;
         var _loc9_:Number = _loc3_ > _loc7_?_loc3_:Number(_loc7_);
         var _loc5_:Number = _loc9_ > _loc6_?_loc9_:Number(_loc6_);
         _loc9_ = _loc3_ > _loc7_?_loc7_:Number(_loc3_);
         var _loc8_:Number = _loc9_ > _loc6_?_loc6_:Number(_loc9_);
         var _loc4_:Number = _loc5_ - _loc8_;
         param2[2] = _loc5_;
         param2[1] = 0;
         param2[0] = 0;
         if(_loc5_ != 0)
         {
            param2[1] = _loc4_ / _loc5_;
         }
         if(param2[1] != 0)
         {
            if(_loc3_ == _loc5_)
            {
               param2[0] = (_loc7_ - _loc6_) / _loc4_;
            }
            else if(_loc7_ == _loc5_)
            {
               param2[0] = 2 + (_loc6_ - _loc3_) / _loc4_;
            }
            else if(_loc6_ == _loc5_)
            {
               param2[0] = 4 + (_loc3_ - _loc7_) / _loc4_;
            }
            var _loc10_:* = 0;
            var _loc11_:* = param2[_loc10_] * 60;
            param2[_loc10_] = _loc11_;
            if(param2[0] < 0)
            {
               _loc11_ = 0;
               _loc10_ = param2[_loc11_] + 360;
               param2[_loc11_] = _loc10_;
            }
         }
         param2[3] = (param1 >> 24 & 255) / 255;
         return param2;
      }
      
      public static function getClassName(param1:Object, param2:Boolean = false) : String
      {
         var _loc3_:String = getQualifiedClassName(param1);
         _loc3_ = _loc3_.replace("::",".");
         if(param2)
         {
            _loc3_ = _loc3_.substr(_loc3_.lastIndexOf(".") + 1);
         }
         return _loc3_;
      }
      
      public static function getClass(param1:String) : Class
      {
         return getDefinitionByName(param1) as Class;
      }
      
      public static function computeVelocity(param1:Number, param2:Number = 0, param3:Number = 0, param4:Number = 10000) : Number
      {
         var _loc5_:Number = NaN;
         if(param2 != 0)
         {
            param1 = Number(param1 + param2 * FlxG.elapsed);
         }
         else if(param3 != 0)
         {
            _loc5_ = param3 * FlxG.elapsed;
            if(param1 - _loc5_ > 0)
            {
               param1 = Number(param1 - _loc5_);
            }
            else if(param1 + _loc5_ < 0)
            {
               param1 = Number(param1 + _loc5_);
            }
            else
            {
               param1 = 0;
            }
         }
         if(param1 != 0 && param4 != 10000)
         {
            if(param1 > param4)
            {
               param1 = param4;
            }
            else if(param1 < -param4)
            {
               param1 = Number(-param4);
            }
         }
         return param1;
      }
      
      public static function setWorldBounds(param1:Number = 0, param2:Number = 0, param3:Number = 0, param4:Number = 0, param5:uint = 3) : void
      {
         if(FlxQuadTree.bounds == null)
         {
            FlxQuadTree.bounds = new FlxRect();
         }
         FlxQuadTree.bounds.x = param1;
         FlxQuadTree.bounds.y = param2;
         if(param3 > 0)
         {
            FlxQuadTree.bounds.width = param3;
         }
         if(param4 > 0)
         {
            FlxQuadTree.bounds.height = param4;
         }
         if(param5 > 0)
         {
            FlxQuadTree.divisions = param5;
         }
      }
      
      public static function overlap(param1:FlxObject, param2:FlxObject, param3:Function = null) : Boolean
      {
         if(param1 == null || !param1.exists || param2 == null || !param2.exists)
         {
            return false;
         }
         quadTree = new FlxQuadTree(FlxQuadTree.bounds.x,FlxQuadTree.bounds.y,FlxQuadTree.bounds.width,FlxQuadTree.bounds.height);
         quadTree.add(param1,0);
         if(param1 === param2)
         {
            return quadTree.overlap(false,param3);
         }
         quadTree.add(param2,1);
         return quadTree.overlap(true,param3);
      }
      
      public static function collide(param1:FlxObject, param2:FlxObject) : Boolean
      {
         if(param1 == null || !param1.exists || param2 == null || !param2.exists)
         {
            return false;
         }
         quadTree = new FlxQuadTree(FlxQuadTree.bounds.x,FlxQuadTree.bounds.y,FlxQuadTree.bounds.width,FlxQuadTree.bounds.height);
         quadTree.add(param1,0);
         var _loc5_:* = param1 === param2;
         if(!_loc5_)
         {
            quadTree.add(param2,1);
         }
         var _loc4_:Boolean = quadTree.overlap(!_loc5_,solveXCollision);
         var _loc3_:Boolean = quadTree.overlap(!_loc5_,solveYCollision);
         return _loc4_ || _loc3_;
      }
      
      public static function solveXCollision(param1:FlxObject, param2:FlxObject) : Boolean
      {
         var _loc15_:* = false;
         var _loc17_:* = false;
         var _loc19_:Number = NaN;
         var _loc24_:Boolean = false;
         var _loc31_:* = 0;
         var _loc30_:* = 0;
         var _loc16_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc20_:Number = param1.colVector.x;
         var _loc18_:Number = param2.colVector.x;
         if(_loc20_ == _loc18_)
         {
            return false;
         }
         param1.preCollide(param2);
         param2.preCollide(param1);
         var _loc13_:Boolean = false;
         var _loc12_:* = _loc20_ == 0;
         var _loc23_:* = _loc20_ < 0;
         var _loc11_:* = _loc20_ > 0;
         var _loc5_:* = _loc18_ == 0;
         var _loc10_:* = _loc18_ < 0;
         var _loc3_:* = _loc18_ > 0;
         var _loc7_:FlxRect = param1.colHullX;
         var _loc29_:FlxRect = param2.colHullX;
         var _loc8_:Array = param1.colOffsets;
         var _loc6_:Array = param2.colOffsets;
         var _loc9_:uint = _loc8_.length;
         var _loc4_:uint = _loc6_.length;
         _loc24_ = _loc12_ && _loc10_ || _loc11_ && _loc5_ || _loc11_ && _loc10_ || _loc23_ && _loc10_ && (_loc20_ > 0?_loc20_:Number(-_loc20_)) < (_loc18_ > 0?_loc18_:Number(-_loc18_)) || _loc11_ && _loc3_ && (_loc20_ > 0?_loc20_:Number(-_loc20_)) > (_loc18_ > 0?_loc18_:Number(-_loc18_));
         if(!!_loc24_?!param1.collideRight || !param2.collideLeft:Boolean(!param1.collideLeft || !param2.collideRight))
         {
            return false;
         }
         _loc31_ = uint(0);
         while(_loc31_ < _loc9_)
         {
            _loc16_ = _loc8_[_loc31_].x;
            _loc27_ = _loc8_[_loc31_].y;
            _loc7_.x = _loc7_.x + _loc16_;
            _loc7_.y = _loc7_.y + _loc27_;
            _loc30_ = uint(0);
            while(_loc30_ < _loc4_)
            {
               _loc14_ = _loc6_[_loc30_].x;
               _loc25_ = _loc6_[_loc30_].y;
               _loc29_.x = _loc29_.x + _loc14_;
               _loc29_.y = _loc29_.y + _loc25_;
               if(_loc7_.x + _loc7_.width < _loc29_.x + roundingError || _loc7_.x + roundingError > _loc29_.x + _loc29_.width || _loc7_.y + _loc7_.height < _loc29_.y + roundingError || _loc7_.y + roundingError > _loc29_.y + _loc29_.height)
               {
                  _loc29_.x = _loc29_.x - _loc14_;
                  _loc29_.y = _loc29_.y - _loc25_;
                  _loc30_++;
               }
               else
               {
                  if(_loc24_)
                  {
                     if(_loc23_)
                     {
                        _loc26_ = _loc7_.x + param1.colHullY.width;
                     }
                     else
                     {
                        _loc26_ = _loc7_.x + _loc7_.width;
                     }
                     if(_loc10_)
                     {
                        _loc28_ = _loc29_.x;
                     }
                     else
                     {
                        _loc28_ = _loc29_.x + _loc29_.width - param2.colHullY.width;
                     }
                  }
                  else
                  {
                     if(_loc10_)
                     {
                        _loc26_ = -_loc29_.x - param2.colHullY.width;
                     }
                     else
                     {
                        _loc26_ = -_loc29_.x - _loc29_.width;
                     }
                     if(_loc23_)
                     {
                        _loc28_ = -_loc7_.x;
                     }
                     else
                     {
                        _loc28_ = -_loc7_.x - _loc7_.width + param1.colHullY.width;
                     }
                  }
                  _loc19_ = _loc26_ - _loc28_;
                  _loc15_ = Boolean(param1.fixed);
                  _loc17_ = Boolean(param2.fixed);
                  if(_loc15_ && _loc17_)
                  {
                     if(_loc15_)
                     {
                        _loc15_ = param1.colVector.x == 0 && _loc20_ == 0;
                     }
                     if(_loc17_)
                     {
                        _loc17_ = param2.colVector.x == 0 && _loc18_ == 0;
                     }
                  }
                  if(_loc19_ == 0 || !_loc15_ && (_loc19_ > 0?_loc19_:Number(-_loc19_)) > _loc7_.width * 0.8 || !_loc17_ && (_loc19_ > 0?_loc19_:Number(-_loc19_)) > _loc29_.width * 0.8)
                  {
                     _loc29_.x = _loc29_.x - _loc14_;
                     _loc29_.y = _loc29_.y - _loc25_;
                     _loc30_++;
                  }
                  else
                  {
                     _loc13_ = true;
                     _loc21_ = param2.velocity.x;
                     _loc22_ = param1.velocity.x;
                     if(!_loc15_ && _loc17_)
                     {
                        if(param1._group)
                        {
                           param1.reset(param1.x - _loc19_,param1.y);
                        }
                        else
                        {
                           param1.x = param1.x - _loc19_;
                        }
                     }
                     else if(_loc15_ && !_loc17_)
                     {
                        if(param2._group)
                        {
                           param2.reset(param2.x + _loc19_,param2.y);
                        }
                        else
                        {
                           param2.x = param2.x + _loc19_;
                        }
                     }
                     else if(!_loc15_ && !_loc17_)
                     {
                        _loc19_ = _loc19_ / 2;
                        if(param1._group)
                        {
                           param1.reset(param1.x - _loc19_,param1.y);
                        }
                        else
                        {
                           param1.x = param1.x - _loc19_;
                        }
                        if(param2._group)
                        {
                           param2.reset(param2.x + _loc19_,param2.y);
                        }
                        else
                        {
                           param2.x = param2.x + _loc19_;
                        }
                        _loc21_ = _loc21_ * 0.5;
                        _loc22_ = _loc22_ * 0.5;
                     }
                     if(_loc24_)
                     {
                        param1.hitRight(param2,_loc21_);
                        param2.hitLeft(param1,_loc22_);
                     }
                     else
                     {
                        param1.hitLeft(param2,_loc21_);
                        param2.hitRight(param1,_loc22_);
                     }
                     if(!_loc15_ && _loc19_ != 0)
                     {
                        if(_loc24_)
                        {
                           _loc7_.width = _loc7_.width - _loc19_;
                        }
                        else
                        {
                           _loc7_.x = _loc7_.x - _loc19_;
                           _loc7_.width = _loc7_.width + _loc19_;
                        }
                        param1.colHullY.x = param1.colHullY.x - _loc19_;
                     }
                     if(!_loc17_ && _loc19_ != 0)
                     {
                        if(_loc24_)
                        {
                           _loc29_.x = _loc29_.x + _loc19_;
                           _loc29_.width = _loc29_.width - _loc19_;
                        }
                        else
                        {
                           _loc29_.width = _loc29_.width + _loc19_;
                        }
                        param2.colHullY.x = param2.colHullY.x + _loc19_;
                     }
                     _loc29_.x = _loc29_.x - _loc14_;
                     _loc29_.y = _loc29_.y - _loc25_;
                     _loc30_++;
                  }
               }
            }
            _loc7_.x = _loc7_.x - _loc16_;
            _loc7_.y = _loc7_.y - _loc27_;
            _loc31_++;
         }
         return _loc13_;
      }
      
      public static function solveYCollision(param1:FlxObject, param2:FlxObject) : Boolean
      {
         var _loc15_:* = false;
         var _loc17_:* = false;
         var _loc19_:Number = NaN;
         var _loc24_:Boolean = false;
         var _loc31_:* = 0;
         var _loc30_:* = 0;
         var _loc16_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc20_:Number = param1.colVector.y;
         var _loc18_:Number = param2.colVector.y;
         if(_loc20_ == _loc18_)
         {
            return false;
         }
         param1.preCollide(param2);
         param2.preCollide(param1);
         var _loc13_:Boolean = false;
         var _loc12_:* = _loc20_ == 0;
         var _loc23_:* = _loc20_ < 0;
         var _loc11_:* = _loc20_ > 0;
         var _loc5_:* = _loc18_ == 0;
         var _loc10_:* = _loc18_ < 0;
         var _loc3_:* = _loc18_ > 0;
         var _loc7_:FlxRect = param1.colHullY;
         var _loc29_:FlxRect = param2.colHullY;
         var _loc8_:Array = param1.colOffsets;
         var _loc6_:Array = param2.colOffsets;
         var _loc9_:uint = _loc8_.length;
         var _loc4_:uint = _loc6_.length;
         _loc24_ = _loc12_ && _loc10_ || _loc11_ && _loc5_ || _loc11_ && _loc10_ || _loc23_ && _loc10_ && (_loc20_ > 0?_loc20_:Number(-_loc20_)) < (_loc18_ > 0?_loc18_:Number(-_loc18_)) || _loc11_ && _loc3_ && (_loc20_ > 0?_loc20_:Number(-_loc20_)) > (_loc18_ > 0?_loc18_:Number(-_loc18_));
         if(!!_loc24_?!param1.collideBottom || !param2.collideTop:Boolean(!param1.collideTop || !param2.collideBottom))
         {
            return false;
         }
         _loc31_ = uint(0);
         while(_loc31_ < _loc9_)
         {
            _loc16_ = _loc8_[_loc31_].x;
            _loc27_ = _loc8_[_loc31_].y;
            _loc7_.x = _loc7_.x + _loc16_;
            _loc7_.y = _loc7_.y + _loc27_;
            _loc30_ = uint(0);
            while(_loc30_ < _loc4_)
            {
               _loc14_ = _loc6_[_loc30_].x;
               _loc25_ = _loc6_[_loc30_].y;
               _loc29_.x = _loc29_.x + _loc14_;
               _loc29_.y = _loc29_.y + _loc25_;
               if(_loc7_.x + _loc7_.width < _loc29_.x + roundingError || _loc7_.x + roundingError > _loc29_.x + _loc29_.width || _loc7_.y + _loc7_.height < _loc29_.y + roundingError || _loc7_.y + roundingError > _loc29_.y + _loc29_.height)
               {
                  _loc29_.x = _loc29_.x - _loc14_;
                  _loc29_.y = _loc29_.y - _loc25_;
                  _loc30_++;
               }
               else
               {
                  if(_loc24_)
                  {
                     if(_loc23_)
                     {
                        _loc26_ = _loc7_.y + param1.colHullX.height;
                     }
                     else
                     {
                        _loc26_ = _loc7_.y + _loc7_.height;
                     }
                     if(_loc10_)
                     {
                        _loc28_ = _loc29_.y;
                     }
                     else
                     {
                        _loc28_ = _loc29_.y + _loc29_.height - param2.colHullX.height;
                     }
                  }
                  else
                  {
                     if(_loc10_)
                     {
                        _loc26_ = -_loc29_.y - param2.colHullX.height;
                     }
                     else
                     {
                        _loc26_ = -_loc29_.y - _loc29_.height;
                     }
                     if(_loc23_)
                     {
                        _loc28_ = -_loc7_.y;
                     }
                     else
                     {
                        _loc28_ = -_loc7_.y - _loc7_.height + param1.colHullX.height;
                     }
                  }
                  _loc19_ = _loc26_ - _loc28_;
                  _loc15_ = Boolean(param1.fixed);
                  _loc17_ = Boolean(param2.fixed);
                  if(_loc15_ && _loc17_)
                  {
                     if(_loc15_)
                     {
                        _loc15_ = param1.colVector.x == 0 && _loc20_ == 0;
                     }
                     if(_loc17_)
                     {
                        _loc17_ = param2.colVector.x == 0 && _loc18_ == 0;
                     }
                  }
                  if(_loc19_ == 0 || !_loc15_ && (_loc19_ > 0?_loc19_:Number(-_loc19_)) > _loc7_.height * 0.8 || !_loc17_ && (_loc19_ > 0?_loc19_:Number(-_loc19_)) > _loc29_.height * 0.8)
                  {
                     _loc29_.x = _loc29_.x - _loc14_;
                     _loc29_.y = _loc29_.y - _loc25_;
                     _loc30_++;
                  }
                  else
                  {
                     _loc13_ = true;
                     _loc21_ = param2.velocity.y;
                     _loc22_ = param1.velocity.y;
                     if(!_loc15_ && _loc17_)
                     {
                        if(param1._group)
                        {
                           param1.reset(param1.x,param1.y - _loc19_);
                        }
                        else
                        {
                           param1.y = param1.y - _loc19_;
                        }
                     }
                     else if(_loc15_ && !_loc17_)
                     {
                        if(param2._group)
                        {
                           param2.reset(param2.x,param2.y + _loc19_);
                        }
                        else
                        {
                           param2.y = param2.y + _loc19_;
                        }
                     }
                     else if(!_loc15_ && !_loc17_)
                     {
                        _loc19_ = _loc19_ / 2;
                        if(param1._group)
                        {
                           param1.reset(param1.x,param1.y - _loc19_);
                        }
                        else
                        {
                           param1.y = param1.y - _loc19_;
                        }
                        if(param2._group)
                        {
                           param2.reset(param2.x,param2.y + _loc19_);
                        }
                        else
                        {
                           param2.y = param2.y + _loc19_;
                        }
                        _loc21_ = _loc21_ * 0.5;
                        _loc22_ = _loc22_ * 0.5;
                     }
                     if(_loc24_)
                     {
                        param1.hitBottom(param2,_loc21_);
                        param2.hitTop(param1,_loc22_);
                     }
                     else
                     {
                        param1.hitTop(param2,_loc21_);
                        param2.hitBottom(param1,_loc22_);
                     }
                     if(!_loc15_ && _loc19_ != 0)
                     {
                        if(_loc24_)
                        {
                           _loc7_.y = _loc7_.y - _loc19_;
                           if(_loc17_ && param2.moves)
                           {
                              _loc21_ = param2.colVector.x;
                              param1.x = param1.x + _loc21_;
                              _loc7_.x = _loc7_.x + _loc21_;
                              param1.colHullX.x = param1.colHullX.x + _loc21_;
                           }
                        }
                        else
                        {
                           _loc7_.y = _loc7_.y - _loc19_;
                           _loc7_.height = _loc7_.height + _loc19_;
                        }
                     }
                     if(!_loc17_ && _loc19_ != 0)
                     {
                        if(_loc24_)
                        {
                           _loc29_.y = _loc29_.y + _loc19_;
                           _loc29_.height = _loc29_.height - _loc19_;
                        }
                        else
                        {
                           _loc29_.height = _loc29_.height + _loc19_;
                           if(_loc15_ && param1.moves)
                           {
                              _loc22_ = param1.colVector.x;
                              param2.x = param2.x + _loc22_;
                              _loc29_.x = _loc29_.x + _loc22_;
                              param2.colHullX.x = param2.colHullX.x + _loc22_;
                           }
                        }
                     }
                     _loc29_.x = _loc29_.x - _loc14_;
                     _loc29_.y = _loc29_.y - _loc25_;
                     _loc30_++;
                  }
               }
            }
            _loc7_.x = _loc7_.x - _loc16_;
            _loc7_.y = _loc7_.y - _loc27_;
            _loc31_++;
         }
         return _loc13_;
      }
   }
}
