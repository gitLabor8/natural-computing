package org.flixel
{
   import flash.net.SharedObject;
   
   public class FlxSave
   {
       
      
      public var data:Object;
      
      public var name:String;
      
      protected var _so:SharedObject;
      
      public function FlxSave()
      {
         super();
         name = null;
         _so = null;
         data = null;
      }
      
      public function bind(param1:String) : Boolean
      {
         name = null;
         _so = null;
         data = null;
         name = param1;
         try
         {
            _so = SharedObject.getLocal(name);
         }
         catch(e:Error)
         {
            FlxG.log("WARNING: There was a problem binding to\nthe shared object data from FlxSave.");
            name = null;
            _so = null;
            data = null;
            var _loc3_:Boolean = false;
            return _loc3_;
         }
         data = _so.data;
         return true;
      }
      
      public function write(param1:String, param2:Object, param3:uint = 0) : Boolean
      {
         if(_so == null)
         {
            FlxG.log("WARNING: You must call FlxSave.bind()\nbefore calling FlxSave.write().");
            return false;
         }
         data[param1] = param2;
         return forceSave(param3);
      }
      
      public function read(param1:String) : Object
      {
         if(_so == null)
         {
            FlxG.log("WARNING: You must call FlxSave.bind()\nbefore calling FlxSave.read().");
            return null;
         }
         return data[param1];
      }
      
      public function forceSave(param1:uint = 0) : Boolean
      {
         if(_so == null)
         {
            FlxG.log("WARNING: You must call FlxSave.bind()\nbefore calling FlxSave.forceSave().");
            return false;
         }
         var _loc2_:Object = null;
         try
         {
            _loc2_ = _so.flush(param1);
         }
         catch(e:Error)
         {
            FlxG.log("WARNING: There was a problem flushing\nthe shared object data from FlxSave.");
            var _loc4_:Boolean = false;
            return _loc4_;
         }
         return _loc2_ == "flushed";
      }
      
      public function erase(param1:uint = 0) : Boolean
      {
         if(_so == null)
         {
            FlxG.log("WARNING: You must call FlxSave.bind()\nbefore calling FlxSave.erase().");
            return false;
         }
         _so.clear();
         return forceSave(param1);
      }
   }
}
