package org.flixel.data
{
   import flash.events.KeyboardEvent;
   
   public class FlxInput
   {
       
      
      var _lookup:Object;
      
      var _map:Array;
      
      const _t:uint = 256;
      
      public function FlxInput()
      {
         super();
         _lookup = {};
         _map = new Array(256);
      }
      
      public function update() : void
      {
         var _loc1_:* = null;
         var _loc2_:uint = 0;
         while(_loc2_ < 256)
         {
            _loc1_ = _map[_loc2_++];
            if(_loc1_ != null)
            {
               if(_loc1_.last == -1 && _loc1_.current == -1)
               {
                  _loc1_.current = 0;
               }
               else if(_loc1_.last == 2 && _loc1_.current == 2)
               {
                  _loc1_.current = 1;
               }
               _loc1_.last = _loc1_.current;
            }
         }
      }
      
      public function reset() : void
      {
         var _loc1_:* = null;
         var _loc2_:uint = 0;
         while(_loc2_ < 256)
         {
            _loc1_ = _map[_loc2_++];
            if(_loc1_ != null)
            {
               this[_loc1_.name] = false;
               _loc1_.current = 0;
               _loc1_.last = 0;
            }
         }
      }
      
      public function pressed(param1:String) : Boolean
      {
         return this[param1];
      }
      
      public function justPressed(param1:String) : Boolean
      {
         return _map[_lookup[param1]].current == 2;
      }
      
      public function justReleased(param1:String) : Boolean
      {
         return _map[_lookup[param1]].current == -1;
      }
      
      public function handleKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:Object = _map[param1.keyCode];
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.current > 0)
         {
            _loc2_.current = 1;
         }
         else
         {
            _loc2_.current = 2;
         }
         this[_loc2_.name] = true;
      }
      
      public function handleKeyUp(param1:KeyboardEvent) : void
      {
         var _loc2_:Object = _map[param1.keyCode];
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.current > 0)
         {
            _loc2_.current = -1;
         }
         else
         {
            _loc2_.current = 0;
         }
         this[_loc2_.name] = false;
      }
      
      function addKey(param1:String, param2:uint) : void
      {
         _lookup[param1] = param2;
         _map[param2] = {
            "name":param1,
            "current":0,
            "last":0
         };
      }
   }
}
