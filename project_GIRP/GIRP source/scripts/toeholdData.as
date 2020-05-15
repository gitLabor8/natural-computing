package
{
   import Box2D.Common.Math.b2Vec2;
   
   public class toeholdData
   {
       
      
      public var position:b2Vec2;
      
      public var type:Number;
      
      public function toeholdData(param1:b2Vec2, param2:Number)
      {
         super();
         type = new Number(param2);
         position = new b2Vec2();
         position.x = param1.x;
         position.y = param1.y;
      }
   }
}
