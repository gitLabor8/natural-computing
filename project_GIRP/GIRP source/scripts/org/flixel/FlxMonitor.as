package org.flixel
{
   public class FlxMonitor
   {
       
      
      protected var _size:uint;
      
      protected var _itr:uint;
      
      protected var _data:Array;
      
      public function FlxMonitor(param1:uint, param2:Number = 0)
      {
         super();
         _size = param1;
         if(_size <= 0)
         {
            _size = 1;
         }
         _itr = 0;
         _data = new Array(_size);
         var _loc3_:uint = 0;
         while(_loc3_ < _size)
         {
            _data[_loc3_++] = param2;
         }
      }
      
      public function add(param1:Number) : void
      {
         _itr = Number(_itr) + 1;
         _data[Number(_itr)] = param1;
         if(_itr >= _size)
         {
            _itr = 0;
         }
      }
      
      public function average() : Number
      {
         var _loc1_:* = 0;
         var _loc2_:uint = 0;
         while(_loc2_ < _size)
         {
            _loc1_ = Number(_loc1_ + _data[_loc2_++]);
         }
         return _loc1_ / _size;
      }
   }
}
