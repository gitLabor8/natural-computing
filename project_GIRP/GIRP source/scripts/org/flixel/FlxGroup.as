package org.flixel
{
   public class FlxGroup extends FlxObject
   {
      
      public static const ASCENDING:int = -1;
      
      public static const DESCENDING:int = 1;
       
      
      public var members:Array;
      
      protected var _last:FlxPoint;
      
      protected var _first:Boolean;
      
      protected var _sortIndex:String;
      
      protected var _sortOrder:int;
      
      public function FlxGroup()
      {
         super();
         _group = true;
         solid = false;
         members = [];
         _last = new FlxPoint();
         _first = true;
      }
      
      public function add(param1:FlxObject, param2:Boolean = false) : FlxObject
      {
         if(members.indexOf(param1) < 0)
         {
            members[members.length] = param1;
         }
         if(param2)
         {
            param1.scrollFactor = scrollFactor;
         }
         return param1;
      }
      
      public function replace(param1:FlxObject, param2:FlxObject) : FlxObject
      {
         var _loc3_:int = members.indexOf(param1);
         if(_loc3_ < 0 || _loc3_ >= members.length)
         {
            return null;
         }
         members[_loc3_] = param2;
         return param2;
      }
      
      public function remove(param1:FlxObject, param2:Boolean = false) : FlxObject
      {
         var _loc3_:int = members.indexOf(param1);
         if(_loc3_ < 0 || _loc3_ >= members.length)
         {
            return null;
         }
         if(param2)
         {
            members.splice(_loc3_,1);
         }
         else
         {
            members[_loc3_] = null;
         }
         return param1;
      }
      
      public function sort(param1:String = "y", param2:int = -1) : void
      {
         _sortIndex = param1;
         _sortOrder = param2;
         members.sort(sortHandler);
      }
      
      public function getFirstAvail() : FlxObject
      {
         var _loc1_:* = null;
         var _loc3_:uint = 0;
         var _loc2_:uint = members.length;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = members[_loc3_++] as FlxObject;
            if(_loc1_ != null && !_loc1_.exists)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function getFirstNull() : int
      {
         var _loc2_:uint = 0;
         var _loc1_:uint = members.length;
         while(_loc2_ < _loc1_)
         {
            if(members[_loc2_] == null)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function resetFirstAvail(param1:Number = 0, param2:Number = 0) : Boolean
      {
         var _loc3_:FlxObject = getFirstAvail();
         if(_loc3_ == null)
         {
            return false;
         }
         _loc3_.reset(param1,param2);
         return true;
      }
      
      public function getFirstExtant() : FlxObject
      {
         var _loc1_:* = null;
         var _loc3_:uint = 0;
         var _loc2_:uint = members.length;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = members[_loc3_++] as FlxObject;
            if(_loc1_ != null && _loc1_.exists)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function getFirstAlive() : FlxObject
      {
         var _loc1_:* = null;
         var _loc3_:uint = 0;
         var _loc2_:uint = members.length;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = members[_loc3_++] as FlxObject;
            if(_loc1_ != null && _loc1_.exists && !_loc1_.dead)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function getFirstDead() : FlxObject
      {
         var _loc1_:* = null;
         var _loc3_:uint = 0;
         var _loc2_:uint = members.length;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = members[_loc3_++] as FlxObject;
            if(_loc1_ != null && _loc1_.dead)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function countLiving() : int
      {
         var _loc2_:* = null;
         var _loc1_:int = -1;
         var _loc4_:uint = 0;
         var _loc3_:uint = members.length;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = members[_loc4_++] as FlxObject;
            if(_loc2_ != null)
            {
               if(_loc1_ < 0)
               {
                  _loc1_ = 0;
               }
               if(_loc2_.exists && !_loc2_.dead)
               {
                  _loc1_++;
               }
            }
         }
         return _loc1_;
      }
      
      public function countDead() : int
      {
         var _loc2_:* = null;
         var _loc1_:int = -1;
         var _loc4_:uint = 0;
         var _loc3_:uint = members.length;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = members[_loc4_++] as FlxObject;
            if(_loc2_ != null)
            {
               if(_loc1_ < 0)
               {
                  _loc1_ = 0;
               }
               if(_loc2_.dead)
               {
                  _loc1_++;
               }
            }
         }
         return _loc1_;
      }
      
      public function countOnScreen() : int
      {
         var _loc2_:* = null;
         var _loc1_:int = -1;
         var _loc4_:uint = 0;
         var _loc3_:uint = members.length;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = members[_loc4_++] as FlxObject;
            if(_loc2_ != null)
            {
               if(_loc1_ < 0)
               {
                  _loc1_ = 0;
               }
               if(_loc2_.onScreen())
               {
                  _loc1_++;
               }
            }
         }
         return _loc1_;
      }
      
      public function getRandom() : FlxObject
      {
         var _loc1_:uint = 0;
         var _loc2_:FlxObject = null;
         var _loc3_:uint = members.length;
         var _loc4_:uint = FlxU.random() * _loc3_;
         while(_loc2_ == null && _loc1_ < members.length)
         {
            _loc2_ = members[++_loc4_ % _loc3_] as FlxObject;
            _loc1_++;
         }
         return _loc2_;
      }
      
      protected function saveOldPosition() : void
      {
         if(_first)
         {
            _first = false;
            _last.x = 0;
            _last.y = 0;
            return;
         }
         _last.x = x;
         _last.y = y;
      }
      
      protected function updateMembers() : void
      {
         var _loc3_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc2_:* = null;
         var _loc1_:Boolean = false;
         if(x != _last.x || y != _last.y)
         {
            _loc1_ = true;
            _loc3_ = x - _last.x;
            _loc5_ = y - _last.y;
         }
         var _loc6_:uint = 0;
         var _loc4_:uint = members.length;
         while(_loc6_ < _loc4_)
         {
            _loc2_ = members[_loc6_++] as FlxObject;
            if(_loc2_ != null && _loc2_.exists)
            {
               if(_loc1_)
               {
                  if(_loc2_._group)
                  {
                     _loc2_.reset(_loc2_.x + _loc3_,_loc2_.y + _loc5_);
                  }
                  else
                  {
                     _loc2_.x = _loc2_.x + _loc3_;
                     _loc2_.y = _loc2_.y + _loc5_;
                  }
               }
               if(_loc2_.active)
               {
                  _loc2_.update();
               }
               if(_loc1_ && _loc2_.solid)
               {
                  _loc2_.colHullX.width = _loc2_.colHullX.width + (_loc3_ > 0?_loc3_:Number(-_loc3_));
                  if(_loc3_ < 0)
                  {
                     _loc2_.colHullX.x = _loc2_.colHullX.x + _loc3_;
                  }
                  _loc2_.colHullY.x = x;
                  _loc2_.colHullY.height = _loc2_.colHullY.height + (_loc5_ > 0?_loc5_:Number(-_loc5_));
                  if(_loc5_ < 0)
                  {
                     _loc2_.colHullY.y = _loc2_.colHullY.y + _loc5_;
                  }
                  _loc2_.colVector.x = _loc2_.colVector.x + _loc3_;
                  _loc2_.colVector.y = _loc2_.colVector.y + _loc5_;
               }
            }
         }
      }
      
      override public function update() : void
      {
         saveOldPosition();
         updateMotion();
         updateMembers();
         updateFlickering();
      }
      
      protected function renderMembers() : void
      {
         var _loc1_:* = null;
         var _loc3_:uint = 0;
         var _loc2_:uint = members.length;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = members[_loc3_++] as FlxObject;
            if(_loc1_ != null && _loc1_.exists && _loc1_.visible)
            {
               _loc1_.render();
            }
         }
      }
      
      override public function render() : void
      {
         renderMembers();
      }
      
      protected function killMembers() : void
      {
         var _loc1_:* = null;
         var _loc3_:uint = 0;
         var _loc2_:uint = members.length;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = members[_loc3_++] as FlxObject;
            if(_loc1_ != null)
            {
               _loc1_.kill();
            }
         }
      }
      
      override public function kill() : void
      {
         killMembers();
         super.kill();
      }
      
      protected function destroyMembers() : void
      {
         var _loc1_:* = null;
         var _loc3_:uint = 0;
         var _loc2_:uint = members.length;
         while(_loc3_ < _loc2_)
         {
            _loc1_ = members[_loc3_++] as FlxObject;
            if(_loc1_ != null)
            {
               _loc1_.destroy();
            }
         }
         members.length = 0;
      }
      
      override public function destroy() : void
      {
         destroyMembers();
         super.destroy();
      }
      
      override public function reset(param1:Number, param2:Number) : void
      {
         var _loc5_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc4_:* = null;
         saveOldPosition();
         super.reset(param1,param2);
         var _loc3_:Boolean = false;
         if(x != _last.x || y != _last.y)
         {
            _loc3_ = true;
            _loc5_ = x - _last.x;
            _loc7_ = y - _last.y;
         }
         var _loc8_:uint = 0;
         var _loc6_:uint = members.length;
         while(_loc8_ < _loc6_)
         {
            _loc4_ = members[_loc8_++] as FlxObject;
            if(_loc4_ != null && _loc4_.exists)
            {
               if(_loc3_)
               {
                  if(_loc4_._group)
                  {
                     _loc4_.reset(_loc4_.x + _loc5_,_loc4_.y + _loc7_);
                  }
                  else
                  {
                     _loc4_.x = _loc4_.x + _loc5_;
                     _loc4_.y = _loc4_.y + _loc7_;
                     if(solid)
                     {
                        _loc4_.colHullX.width = _loc4_.colHullX.width + (_loc5_ > 0?_loc5_:Number(-_loc5_));
                        if(_loc5_ < 0)
                        {
                           _loc4_.colHullX.x = _loc4_.colHullX.x + _loc5_;
                        }
                        _loc4_.colHullY.x = x;
                        _loc4_.colHullY.height = _loc4_.colHullY.height + (_loc7_ > 0?_loc7_:Number(-_loc7_));
                        if(_loc7_ < 0)
                        {
                           _loc4_.colHullY.y = _loc4_.colHullY.y + _loc7_;
                        }
                        _loc4_.colVector.x = _loc4_.colVector.x + _loc5_;
                        _loc4_.colVector.y = _loc4_.colVector.y + _loc7_;
                     }
                  }
               }
            }
         }
      }
      
      protected function sortHandler(param1:FlxObject, param2:FlxObject) : int
      {
         if(param1[_sortIndex] < param2[_sortIndex])
         {
            return _sortOrder;
         }
         if(param1[_sortIndex] > param2[_sortIndex])
         {
            return -_sortOrder;
         }
         return 0;
      }
   }
}
