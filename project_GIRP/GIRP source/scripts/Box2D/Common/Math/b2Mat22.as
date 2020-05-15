package Box2D.Common.Math
{
   public class b2Mat22
   {
       
      
      public var col1:b2Vec2;
      
      public var col2:b2Vec2;
      
      public function b2Mat22()
      {
         col1 = new b2Vec2();
         col2 = new b2Vec2();
         super();
         var _loc1_:int = 1;
         col2.y = _loc1_;
         col1.x = _loc1_;
      }
      
      public static function FromAngle(param1:Number) : b2Mat22
      {
         var _loc2_:b2Mat22 = new b2Mat22();
         _loc2_.Set(param1);
         return _loc2_;
      }
      
      public static function FromVV(param1:b2Vec2, param2:b2Vec2) : b2Mat22
      {
         var _loc3_:b2Mat22 = new b2Mat22();
         _loc3_.SetVV(param1,param2);
         return _loc3_;
      }
      
      public function Set(param1:Number) : void
      {
         var _loc3_:Number = Math.cos(param1);
         var _loc2_:Number = Math.sin(param1);
         col1.x = _loc3_;
         col2.x = -_loc2_;
         col1.y = _loc2_;
         col2.y = _loc3_;
      }
      
      public function SetVV(param1:b2Vec2, param2:b2Vec2) : void
      {
         col1.SetV(param1);
         col2.SetV(param2);
      }
      
      public function Copy() : b2Mat22
      {
         var _loc1_:b2Mat22 = new b2Mat22();
         _loc1_.SetM(this);
         return _loc1_;
      }
      
      public function SetM(param1:b2Mat22) : void
      {
         col1.SetV(param1.col1);
         col2.SetV(param1.col2);
      }
      
      public function AddM(param1:b2Mat22) : void
      {
         col1.x = col1.x + param1.col1.x;
         col1.y = col1.y + param1.col1.y;
         col2.x = col2.x + param1.col2.x;
         col2.y = col2.y + param1.col2.y;
      }
      
      public function SetIdentity() : void
      {
         col1.x = 1;
         col2.x = 0;
         col1.y = 0;
         col2.y = 1;
      }
      
      public function SetZero() : void
      {
         col1.x = 0;
         col2.x = 0;
         col1.y = 0;
         col2.y = 0;
      }
      
      public function GetAngle() : Number
      {
         return Math.atan2(col1.y,col1.x);
      }
      
      public function GetInverse(param1:b2Mat22) : b2Mat22
      {
         var _loc6_:Number = col1.x;
         var _loc4_:Number = col2.x;
         var _loc5_:Number = col1.y;
         var _loc2_:Number = col2.y;
         var _loc3_:Number = _loc6_ * _loc2_ - _loc4_ * _loc5_;
         if(_loc3_ != 0)
         {
            _loc3_ = 1 / _loc3_;
         }
         param1.col1.x = _loc3_ * _loc2_;
         param1.col2.x = -_loc3_ * _loc4_;
         param1.col1.y = -_loc3_ * _loc5_;
         param1.col2.y = _loc3_ * _loc6_;
         return param1;
      }
      
      public function Solve(param1:b2Vec2, param2:Number, param3:Number) : b2Vec2
      {
         var _loc8_:Number = col1.x;
         var _loc6_:Number = col2.x;
         var _loc5_:Number = col1.y;
         var _loc7_:Number = col2.y;
         var _loc4_:Number = _loc8_ * _loc7_ - _loc6_ * _loc5_;
         if(_loc4_ != 0)
         {
            _loc4_ = 1 / _loc4_;
         }
         param1.x = _loc4_ * (_loc7_ * param2 - _loc6_ * param3);
         param1.y = _loc4_ * (_loc8_ * param3 - _loc5_ * param2);
         return param1;
      }
      
      public function Abs() : void
      {
         col1.Abs();
         col2.Abs();
      }
   }
}
