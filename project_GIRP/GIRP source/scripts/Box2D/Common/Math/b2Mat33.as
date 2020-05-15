package Box2D.Common.Math
{
   public class b2Mat33
   {
       
      
      public var col1:b2Vec3;
      
      public var col2:b2Vec3;
      
      public var col3:b2Vec3;
      
      public function b2Mat33(param1:b2Vec3 = null, param2:b2Vec3 = null, param3:b2Vec3 = null)
      {
         col1 = new b2Vec3();
         col2 = new b2Vec3();
         col3 = new b2Vec3();
         super();
         if(!param1 && !param2 && !param3)
         {
            col1.SetZero();
            col2.SetZero();
            col3.SetZero();
         }
         else
         {
            col1.SetV(param1);
            col2.SetV(param2);
            col3.SetV(param3);
         }
      }
      
      public function SetVVV(param1:b2Vec3, param2:b2Vec3, param3:b2Vec3) : void
      {
         col1.SetV(param1);
         col2.SetV(param2);
         col3.SetV(param3);
      }
      
      public function Copy() : b2Mat33
      {
         return new b2Mat33(col1,col2,col3);
      }
      
      public function SetM(param1:b2Mat33) : void
      {
         col1.SetV(param1.col1);
         col2.SetV(param1.col2);
         col3.SetV(param1.col3);
      }
      
      public function AddM(param1:b2Mat33) : void
      {
         col1.x = col1.x + param1.col1.x;
         col1.y = col1.y + param1.col1.y;
         col1.z = col1.z + param1.col1.z;
         col2.x = col2.x + param1.col2.x;
         col2.y = col2.y + param1.col2.y;
         col2.z = col2.z + param1.col2.z;
         col3.x = col3.x + param1.col3.x;
         col3.y = col3.y + param1.col3.y;
         col3.z = col3.z + param1.col3.z;
      }
      
      public function SetIdentity() : void
      {
         col1.x = 1;
         col2.x = 0;
         col3.x = 0;
         col1.y = 0;
         col2.y = 1;
         col3.y = 0;
         col1.z = 0;
         col2.z = 0;
         col3.z = 1;
      }
      
      public function SetZero() : void
      {
         col1.x = 0;
         col2.x = 0;
         col3.x = 0;
         col1.y = 0;
         col2.y = 0;
         col3.y = 0;
         col1.z = 0;
         col2.z = 0;
         col3.z = 0;
      }
      
      public function Solve22(param1:b2Vec2, param2:Number, param3:Number) : b2Vec2
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
      
      public function Solve33(param1:b2Vec3, param2:Number, param3:Number, param4:Number) : b2Vec3
      {
         var _loc12_:Number = col1.x;
         var _loc7_:Number = col1.y;
         var _loc6_:Number = col1.z;
         var _loc8_:Number = col2.x;
         var _loc9_:Number = col2.y;
         var _loc14_:Number = col2.z;
         var _loc10_:Number = col3.x;
         var _loc11_:Number = col3.y;
         var _loc13_:Number = col3.z;
         var _loc5_:Number = _loc12_ * (_loc9_ * _loc13_ - _loc14_ * _loc11_) + _loc7_ * (_loc14_ * _loc10_ - _loc8_ * _loc13_) + _loc6_ * (_loc8_ * _loc11_ - _loc9_ * _loc10_);
         if(_loc5_ != 0)
         {
            _loc5_ = 1 / _loc5_;
         }
         param1.x = _loc5_ * (param2 * (_loc9_ * _loc13_ - _loc14_ * _loc11_) + param3 * (_loc14_ * _loc10_ - _loc8_ * _loc13_) + param4 * (_loc8_ * _loc11_ - _loc9_ * _loc10_));
         param1.y = _loc5_ * (_loc12_ * (param3 * _loc13_ - param4 * _loc11_) + _loc7_ * (param4 * _loc10_ - param2 * _loc13_) + _loc6_ * (param2 * _loc11_ - param3 * _loc10_));
         param1.z = _loc5_ * (_loc12_ * (_loc9_ * param4 - _loc14_ * param3) + _loc7_ * (_loc14_ * param2 - _loc8_ * param4) + _loc6_ * (_loc8_ * param3 - _loc9_ * param2));
         return param1;
      }
   }
}
