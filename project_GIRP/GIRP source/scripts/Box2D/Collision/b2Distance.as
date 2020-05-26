package Box2D.Collision
{
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2Settings;
   import Box2D.Common.b2internal;
   
   use namespace b2internal;
   
   public class b2Distance
   {
      
      private static var b2_gjkCalls:int;
      
      private static var b2_gjkIters:int;
      
      private static var b2_gjkMaxIters:int;
      
      private static var s_simplex:b2Simplex = new b2Simplex();
      
      private static var s_saveA:Vector.<int> = new Vector.<int>(3);
      
      private static var s_saveB:Vector.<int> = new Vector.<int>(3);
       
      
      public function b2Distance()
      {
         super();
      }
      
      public static function Distance(param1:b2DistanceOutput, param2:b2SimplexCache, param3:b2DistanceInput) : void
      {
         var _loc8_:int = 0;
         _loc8_ = 20;
         var _loc19_:int = 0;
         var _loc24_:* = null;
         var _loc13_:* = null;
         var _loc23_:* = null;
         var _loc14_:Boolean = false;
         var _loc22_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc7_:* = null;
         b2_gjkCalls = b2_gjkCalls + 1;
         var _loc11_:b2DistanceProxy = param3.proxyA;
         var _loc12_:b2DistanceProxy = param3.proxyB;
         var _loc20_:b2Transform = param3.transformA;
         var _loc21_:b2Transform = param3.transformB;
         var _loc10_:b2Simplex = s_simplex;
         _loc10_.ReadCache(param2,_loc11_,_loc20_,_loc12_,_loc21_);
         var _loc6_:Vector.<b2SimplexVertex> = _loc10_.m_vertices;
         var _loc4_:Vector.<int> = s_saveA;
         var _loc5_:Vector.<int> = s_saveB;
         var _loc9_:int = 0;
         var _loc17_:b2Vec2 = _loc10_.GetClosestPoint();
         var _loc16_:* = Number(_loc17_.LengthSquared());
         var _loc15_:* = _loc16_;
         var _loc25_:int = 0;
         while(_loc25_ < 20)
         {
            _loc9_ = _loc10_.m_count;
            _loc19_ = 0;
            while(_loc19_ < _loc9_)
            {
               _loc4_[_loc19_] = _loc6_[_loc19_].indexA;
               _loc5_[_loc19_] = _loc6_[_loc19_].indexB;
               _loc19_++;
            }
            switch(int(_loc10_.m_count) - 1)
            {
               case 0:
                  break;
               case 1:
                  _loc10_.Solve2();
                  break;
               case 2:
                  _loc10_.Solve3();
            }
            if(_loc10_.m_count != 3)
            {
               _loc24_ = _loc10_.GetClosestPoint();
               _loc15_ = Number(_loc24_.LengthSquared());
               if(_loc15_ > _loc16_)
               {
               }
               _loc16_ = _loc15_;
               _loc13_ = _loc10_.GetSearchDirection();
               if(_loc13_.LengthSquared() >= Number.MIN_VALUE * Number.MIN_VALUE)
               {
                  _loc23_ = _loc6_[_loc10_.m_count];
                  _loc23_.indexA = _loc11_.GetSupport(b2Math.MulTMV(_loc20_.R,_loc13_.GetNegative()));
                  _loc23_.wA = b2Math.MulX(_loc20_,_loc11_.GetVertex(_loc23_.indexA));
                  _loc23_.indexB = _loc12_.GetSupport(b2Math.MulTMV(_loc21_.R,_loc13_));
                  _loc23_.wB = b2Math.MulX(_loc21_,_loc12_.GetVertex(_loc23_.indexB));
                  _loc23_.w = b2Math.SubtractVV(_loc23_.wB,_loc23_.wA);
                  _loc25_++;
                  b2_gjkIters = b2_gjkIters + 1;
                  _loc14_ = false;
                  _loc19_ = 0;
                  while(_loc19_ < _loc9_)
                  {
                     if(_loc23_.indexA == _loc4_[_loc19_] && _loc23_.indexB == _loc5_[_loc19_])
                     {
                        _loc14_ = true;
                        break;
                     }
                     _loc19_++;
                  }
                  if(!_loc14_)
                  {
                     _loc10_.m_count = _loc10_.m_count + 1;
                     continue;
                  }
                  break;
               }
               break;
            }
            break;
         }
         b2_gjkMaxIters = b2Math.Max(b2_gjkMaxIters,_loc25_);
         _loc10_.GetWitnessPoints(param1.pointA,param1.pointB);
         param1.distance = b2Math.SubtractVV(param1.pointA,param1.pointB).Length();
         param1.iterations = _loc25_;
         _loc10_.WriteCache(param2);
         if(param3.useRadii)
         {
            _loc22_ = _loc11_.m_radius;
            _loc18_ = _loc12_.m_radius;
            if(param1.distance > _loc22_ + _loc18_ && param1.distance > Number.MIN_VALUE)
            {
               param1.distance = param1.distance - (_loc22_ + _loc18_);
               _loc7_ = b2Math.SubtractVV(param1.pointB,param1.pointA);
               _loc7_.Normalize();
               param1.pointA.x = param1.pointA.x + _loc22_ * _loc7_.x;
               param1.pointA.y = param1.pointA.y + _loc22_ * _loc7_.y;
               param1.pointB.x = param1.pointB.x - _loc18_ * _loc7_.x;
               param1.pointB.y = param1.pointB.y - _loc18_ * _loc7_.y;
            }
            else
            {
               _loc24_ = new b2Vec2();
               _loc24_.x = 0.5 * (param1.pointA.x + param1.pointB.x);
               _loc24_.y = 0.5 * (param1.pointA.y + param1.pointB.y);
               var _loc26_:* = _loc24_.x;
               param1.pointB.x = _loc26_;
               param1.pointA.x = _loc26_;
               _loc26_ = _loc24_.y;
               param1.pointB.y = _loc26_;
               param1.pointA.y = _loc26_;
               param1.distance = 0;
            }
         }
      }
   }
}
