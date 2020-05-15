package Box2D.Collision
{
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2Settings;
   
   class b2Simplex
   {
       
      
      public var m_v1:b2SimplexVertex;
      
      public var m_v2:b2SimplexVertex;
      
      public var m_v3:b2SimplexVertex;
      
      public var m_vertices:Vector.<b2SimplexVertex>;
      
      public var m_count:int;
      
      function b2Simplex()
      {
         m_v1 = new b2SimplexVertex();
         m_v2 = new b2SimplexVertex();
         m_v3 = new b2SimplexVertex();
         m_vertices = new Vector.<b2SimplexVertex>(3);
         super();
         m_vertices[0] = m_v1;
         m_vertices[1] = m_v2;
         m_vertices[2] = m_v3;
      }
      
      public function ReadCache(param1:b2SimplexCache, param2:b2DistanceProxy, param3:b2Transform, param4:b2DistanceProxy, param5:b2Transform) : void
      {
         var _loc10_:* = null;
         var _loc11_:* = null;
         var _loc12_:int = 0;
         var _loc7_:* = null;
         var _loc8_:Number = NaN;
         var _loc6_:Number = NaN;
         b2Settings.b2Assert(0 <= param1.count && param1.count <= 3);
         m_count = param1.count;
         var _loc9_:Vector.<b2SimplexVertex> = m_vertices;
         _loc12_ = 0;
         while(_loc12_ < m_count)
         {
            _loc7_ = _loc9_[_loc12_];
            _loc7_.indexA = param1.indexA[_loc12_];
            _loc7_.indexB = param1.indexB[_loc12_];
            _loc10_ = param2.GetVertex(_loc7_.indexA);
            _loc11_ = param4.GetVertex(_loc7_.indexB);
            _loc7_.wA = b2Math.MulX(param3,_loc10_);
            _loc7_.wB = b2Math.MulX(param5,_loc11_);
            _loc7_.w = b2Math.SubtractVV(_loc7_.wB,_loc7_.wA);
            _loc7_.a = 0;
            _loc12_++;
         }
         if(m_count > 1)
         {
            _loc8_ = param1.metric;
            _loc6_ = GetMetric();
            if(_loc6_ < 0.5 * _loc8_ || 2 * _loc8_ < _loc6_ || _loc6_ < Number.MIN_VALUE)
            {
               m_count = 0;
            }
         }
         if(m_count == 0)
         {
            _loc7_ = _loc9_[0];
            _loc7_.indexA = 0;
            _loc7_.indexB = 0;
            _loc10_ = param2.GetVertex(0);
            _loc11_ = param4.GetVertex(0);
            _loc7_.wA = b2Math.MulX(param3,_loc10_);
            _loc7_.wB = b2Math.MulX(param5,_loc11_);
            _loc7_.w = b2Math.SubtractVV(_loc7_.wB,_loc7_.wA);
            m_count = 1;
         }
      }
      
      public function WriteCache(param1:b2SimplexCache) : void
      {
         var _loc3_:int = 0;
         param1.metric = GetMetric();
         param1.count = uint(m_count);
         var _loc2_:Vector.<b2SimplexVertex> = m_vertices;
         _loc3_ = 0;
         while(_loc3_ < m_count)
         {
            param1.indexA[_loc3_] = uint(_loc2_[_loc3_].indexA);
            param1.indexB[_loc3_] = uint(_loc2_[_loc3_].indexB);
            _loc3_++;
         }
      }
      
      public function GetSearchDirection() : b2Vec2
      {
         var _loc2_:* = null;
         var _loc1_:Number = NaN;
         switch(int(m_count) - 1)
         {
            case 0:
               return m_v1.w.GetNegative();
            case 1:
               _loc2_ = b2Math.SubtractVV(m_v2.w,m_v1.w);
               _loc1_ = b2Math.CrossVV(_loc2_,m_v1.w.GetNegative());
               if(_loc1_ > 0)
               {
                  return b2Math.CrossFV(1,_loc2_);
               }
               return b2Math.CrossVF(_loc2_,1);
         }
      }
      
      public function GetClosestPoint() : b2Vec2
      {
         switch(int(m_count))
         {
            case 0:
               b2Settings.b2Assert(false);
               return new b2Vec2();
            case 1:
               return m_v1.w;
            case 2:
               return new b2Vec2(m_v1.a * m_v1.w.x + m_v2.a * m_v2.w.x,m_v1.a * m_v1.w.y + m_v2.a * m_v2.w.y);
         }
      }
      
      public function GetWitnessPoints(param1:b2Vec2, param2:b2Vec2) : void
      {
         switch(int(m_count))
         {
            case 0:
               b2Settings.b2Assert(false);
               break;
            case 1:
               param1.SetV(m_v1.wA);
               param2.SetV(m_v1.wB);
               break;
            case 2:
               param1.x = m_v1.a * m_v1.wA.x + m_v2.a * m_v2.wA.x;
               param1.y = m_v1.a * m_v1.wA.y + m_v2.a * m_v2.wA.y;
               param2.x = m_v1.a * m_v1.wB.x + m_v2.a * m_v2.wB.x;
               param2.y = m_v1.a * m_v1.wB.y + m_v2.a * m_v2.wB.y;
               break;
            case 3:
               var _loc3_:* = m_v1.a * m_v1.wA.x + m_v2.a * m_v2.wA.x + m_v3.a * m_v3.wA.x;
               param1.x = _loc3_;
               param2.x = _loc3_;
               _loc3_ = m_v1.a * m_v1.wA.y + m_v2.a * m_v2.wA.y + m_v3.a * m_v3.wA.y;
               param1.y = _loc3_;
               param2.y = _loc3_;
         }
      }
      
      public function GetMetric() : Number
      {
         switch(int(m_count))
         {
            case 0:
               b2Settings.b2Assert(false);
               return 0;
            case 1:
               return 0;
            case 2:
               return b2Math.SubtractVV(m_v1.w,m_v2.w).Length();
            case 3:
               return b2Math.CrossVV(b2Math.SubtractVV(m_v2.w,m_v1.w),b2Math.SubtractVV(m_v3.w,m_v1.w));
         }
      }
      
      public function Solve2() : void
      {
         var _loc5_:b2Vec2 = m_v1.w;
         var _loc6_:b2Vec2 = m_v2.w;
         var _loc3_:b2Vec2 = b2Math.SubtractVV(_loc6_,_loc5_);
         var _loc2_:Number = -(_loc5_.x * _loc3_.x + _loc5_.y * _loc3_.y);
         if(_loc2_ <= 0)
         {
            m_v1.a = 1;
            m_count = 1;
            return;
         }
         var _loc4_:Number = _loc6_.x * _loc3_.x + _loc6_.y * _loc3_.y;
         if(_loc4_ <= 0)
         {
            m_v2.a = 1;
            m_count = 1;
            m_v1.Set(m_v2);
            return;
         }
         var _loc1_:Number = 1 / (_loc4_ + _loc2_);
         m_v1.a = _loc4_ * _loc1_;
         m_v2.a = _loc2_ * _loc1_;
         m_count = 2;
      }
      
      public function Solve3() : void
      {
         var _loc21_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc18_:b2Vec2 = m_v1.w;
         var _loc19_:b2Vec2 = m_v2.w;
         var _loc16_:b2Vec2 = m_v3.w;
         var _loc7_:b2Vec2 = b2Math.SubtractVV(_loc19_,_loc18_);
         var _loc11_:Number = b2Math.Dot(_loc18_,_loc7_);
         var _loc14_:Number = b2Math.Dot(_loc19_,_loc7_);
         var _loc8_:* = _loc14_;
         var _loc2_:Number = -_loc11_;
         var _loc5_:b2Vec2 = b2Math.SubtractVV(_loc16_,_loc18_);
         var _loc10_:Number = b2Math.Dot(_loc18_,_loc5_);
         var _loc3_:Number = b2Math.Dot(_loc16_,_loc5_);
         var _loc4_:* = _loc3_;
         var _loc6_:Number = -_loc10_;
         var _loc17_:b2Vec2 = b2Math.SubtractVV(_loc16_,_loc19_);
         var _loc25_:Number = b2Math.Dot(_loc19_,_loc17_);
         var _loc15_:Number = b2Math.Dot(_loc16_,_loc17_);
         var _loc1_:* = _loc15_;
         var _loc9_:Number = -_loc25_;
         var _loc13_:Number = b2Math.CrossVV(_loc7_,_loc5_);
         var _loc22_:Number = _loc13_ * b2Math.CrossVV(_loc19_,_loc16_);
         var _loc23_:Number = _loc13_ * b2Math.CrossVV(_loc16_,_loc18_);
         var _loc24_:Number = _loc13_ * b2Math.CrossVV(_loc18_,_loc19_);
         if(_loc2_ <= 0 && _loc6_ <= 0)
         {
            m_v1.a = 1;
            m_count = 1;
            return;
         }
         if(_loc8_ > 0 && _loc2_ > 0 && _loc24_ <= 0)
         {
            _loc21_ = 1 / (_loc8_ + _loc2_);
            m_v1.a = _loc8_ * _loc21_;
            m_v2.a = _loc2_ * _loc21_;
            m_count = 2;
            return;
         }
         if(_loc4_ > 0 && _loc6_ > 0 && _loc23_ <= 0)
         {
            _loc26_ = 1 / (_loc4_ + _loc6_);
            m_v1.a = _loc4_ * _loc26_;
            m_v3.a = _loc6_ * _loc26_;
            m_count = 2;
            m_v2.Set(m_v3);
            return;
         }
         if(_loc8_ <= 0 && _loc9_ <= 0)
         {
            m_v2.a = 1;
            m_count = 1;
            m_v1.Set(m_v2);
            return;
         }
         if(_loc4_ <= 0 && _loc1_ <= 0)
         {
            m_v3.a = 1;
            m_count = 1;
            m_v1.Set(m_v3);
            return;
         }
         if(_loc1_ > 0 && _loc9_ > 0 && _loc22_ <= 0)
         {
            _loc12_ = 1 / (_loc1_ + _loc9_);
            m_v2.a = _loc1_ * _loc12_;
            m_v3.a = _loc9_ * _loc12_;
            m_count = 2;
            m_v1.Set(m_v3);
            return;
         }
         var _loc20_:Number = 1 / (_loc22_ + _loc23_ + _loc24_);
         m_v1.a = _loc22_ * _loc20_;
         m_v2.a = _loc23_ * _loc20_;
         m_v3.a = _loc24_ * _loc20_;
         m_count = 3;
      }
   }
}
