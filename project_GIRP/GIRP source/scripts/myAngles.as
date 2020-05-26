package
{
   public class myAngles
   {
       
      
      public var elbowAngle:Number;
      
      public var shoulderAngle:Number;
      
      public var achieved:Boolean = false;
      
      public var distanceSquared:Number = 999;
      
      public function myAngles(param1:Number, param2:Number, param3:Boolean, param4:Number)
      {
         super();
         elbowAngle = new Number(param1);
         shoulderAngle = new Number(param2);
         achieved = new Boolean(param3);
         distanceSquared = new Number(param4);
      }
   }
}
