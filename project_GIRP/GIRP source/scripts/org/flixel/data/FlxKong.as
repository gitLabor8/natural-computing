package org.flixel.data
{
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.net.URLRequest;
   
   public class FlxKong extends Sprite
   {
       
      
      public var API;
      
      public function FlxKong()
      {
         super();
         API = null;
      }
      
      public function init() : void
      {
         var _loc4_:Object = LoaderInfo(root.loaderInfo).parameters;
         var _loc1_:String = _loc4_.api_path || "http://www.kongregate.com/flash/API_AS3_Local.swf";
         var _loc3_:URLRequest = new URLRequest(_loc1_);
         var _loc2_:Loader = new Loader();
         _loc2_.contentLoaderInfo.addEventListener("complete",APILoaded);
         _loc2_.load(_loc3_);
         this.addChild(_loc2_);
      }
      
      protected function APILoaded(param1:Event) : void
      {
         API = param1.target.content;
         API.services.connect();
      }
   }
}
