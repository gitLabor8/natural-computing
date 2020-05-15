package
{
   import flash.display.BitmapData;
   import flash.filters.BlurFilter;
   import flash.filters.DisplacementMapFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import org.flixel.FlxG;
   
   public class Water
   {
       
      
      private var rect:Rectangle;
      
      private var point:Point;
      
      private var zeroPoint:Point;
      
      private var matrix:Matrix;
      
      private var matrix2:Matrix;
      
      private var transform:ColorTransform;
      
      private var displacementFilter:DisplacementMapFilter;
      
      public var displacementBitmap:BitmapData;
      
      private var blurFilter:BlurFilter;
      
      private var displacementIteration:int = 0;
      
      private var timer:Number = 0;
      
      private var oldO:Number = 0;
      
      public function Water(param1:Number)
      {
         rect = new Rectangle(0,0,323,26);
         point = new Point(0,160);
         zeroPoint = new Point(0,0);
         matrix = new Matrix();
         matrix2 = new Matrix();
         transform = new ColorTransform(1,1,1,0.3);
         displacementBitmap = new BitmapData(326,13,false,0);
         super();
         oldO = param1;
         matrix.scale(1,-1);
         matrix.translate(0,214);
         displacementFilter = new DisplacementMapFilter(displacementBitmap,zeroPoint,1,2,10,1,"clamp");
         displacementBitmap.perlinNoise(90,3,1,0,true,false,15,true,[1,1]);
         blurFilter = new BlurFilter(4,0);
      }
      
      public function updateRipple() : void
      {
         displacementIteration = Number(displacementIteration) + 1;
         displacementBitmap.perlinNoise(60,3,1,123,true,false,1,true,[new Point(1,displacementIteration / 5)]);
         if(displacementIteration == 16777215)
         {
            displacementIteration = 0;
         }
      }
      
      public function draw(param1:Number) : void
      {
         oldO = param1;
         matrix = new Matrix();
         matrix.scale(1,-1);
         matrix.translate(0,param1 + 118);
         rect = new Rectangle(0,0,323,13);
         var _loc2_:Rectangle = new Rectangle(3,0,323,5 + (120 - param1));
         if(_loc2_.height < 0)
         {
            _loc2_.height = 0;
         }
         if(_loc2_.width < 0)
         {
            _loc2_.width = 0;
         }
         point = new Point(0,118 + param1);
         var _loc3_:Point = new Point(0,131 + param1);
         Assets.reflection.fillRect(_loc2_,1716382975);
         Assets.reflection.fillRect(rect,2857233663);
         Assets.reflection.draw(FlxG.buffer,matrix,transform,"add",rect);
         Assets.reflection.applyFilter(Assets.reflection,rect,zeroPoint,displacementFilter);
         FlxG.buffer.copyPixels(Assets.reflection,_loc2_,point,null,null,true);
      }
   }
}
