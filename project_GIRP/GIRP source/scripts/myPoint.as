package
{
   import Box2D.Common.Math.b2Vec2;
   
   public class myPoint
   {
       
      
      public var position:b2Vec2;
      
      public var angle:Number;
      
      public function myPoint(param1:b2Vec2, param2:Number)
      {
         super();
         position = new b2Vec2(param1.x,param1.y);
         angle = new Number(param2);
      }
   }
}
