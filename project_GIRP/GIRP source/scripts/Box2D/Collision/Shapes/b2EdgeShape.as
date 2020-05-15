package Box2D.Collision.Shapes
{
   import Box2D.Collision.b2AABB;
   import Box2D.Collision.b2RayCastInput;
   import Box2D.Collision.b2RayCastOutput;
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2internal;
   
   use namespace b2internal;
   
   public class b2EdgeShape extends b2Shape
   {
       
      
      private var s_supportVec:b2Vec2;
      
      b2internal var m_v1:b2Vec2;
      
      b2internal var m_v2:b2Vec2;
      
      b2internal var m_coreV1:b2Vec2;
      
      b2internal var m_coreV2:b2Vec2;
      
      b2internal var m_length:Number;
      
      b2internal var m_normal:b2Vec2;
      
      b2internal var m_direction:b2Vec2;
      
      b2internal var m_cornerDir1:b2Vec2;
      
      b2internal var m_cornerDir2:b2Vec2;
      
      b2internal var m_cornerConvex1:Boolean;
      
      b2internal var m_cornerConvex2:Boolean;
      
      b2internal var m_nextEdge:b2EdgeShape;
      
      b2internal var m_prevEdge:b2EdgeShape;
      
      public function b2EdgeShape(param1:b2Vec2, param2:b2Vec2)
      {
         s_supportVec = new b2Vec2();
         m_v1 = new b2Vec2();
         m_v2 = new b2Vec2();
         m_coreV1 = new b2Vec2();
         m_coreV2 = new b2Vec2();
         m_normal = new b2Vec2();
         m_direction = new b2Vec2();
         m_cornerDir1 = new b2Vec2();
         m_cornerDir2 = new b2Vec2();
         super();
         m_type = 2;
         m_prevEdge = null;
         m_nextEdge = null;
         m_v1 = param1;
         m_v2 = param2;
         m_direction.Set(m_v2.x - m_v1.x,m_v2.y - m_v1.y);
         m_length = m_direction.Normalize();
         m_normal.Set(m_direction.y,-m_direction.x);
         m_coreV1.Set(-0.04 * (m_normal.x - m_direction.x) + m_v1.x,-0.04 * (m_normal.y - m_direction.y) + m_v1.y);
         m_coreV2.Set(-0.04 * (m_normal.x + m_direction.x) + m_v2.x,-0.04 * (m_normal.y + m_direction.y) + m_v2.y);
         m_cornerDir1 = m_normal;
         m_cornerDir2.Set(-m_normal.x,-m_normal.y);
      }
      
      override public function TestPoint(param1:b2Transform, param2:b2Vec2) : Boolean
      {
         return false;
      }
      
      override public function RayCast(param1:b2RayCastOutput, param2:b2RayCastInput, param3:b2Transform) : Boolean
      {
         var _loc13_:* = null;
         var _loc9_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc14_:Number = param2.p2.x - param2.p1.x;
         var _loc15_:Number = param2.p2.y - param2.p1.y;
         _loc13_ = param3.R;
         var _loc11_:Number = param3.position.x + (_loc13_.col1.x * m_v1.x + _loc13_.col2.x * m_v1.y);
         var _loc12_:Number = param3.position.y + (_loc13_.col1.y * m_v1.x + _loc13_.col2.y * m_v1.y);
         var _loc7_:Number = param3.position.y + (_loc13_.col1.y * m_v2.x + _loc13_.col2.y * m_v2.y) - _loc12_;
         var _loc6_:Number = -(param3.position.x + (_loc13_.col1.x * m_v2.x + _loc13_.col2.x * m_v2.y) - _loc11_);
         var _loc17_:Number = 100 * Number.MIN_VALUE;
         var _loc10_:Number = -(_loc14_ * _loc7_ + _loc15_ * _loc6_);
         if(_loc10_ > _loc17_)
         {
            _loc9_ = param2.p1.x - _loc11_;
            _loc8_ = param2.p1.y - _loc12_;
            _loc5_ = _loc9_ * _loc7_ + _loc8_ * _loc6_;
            if(0 <= _loc5_ && _loc5_ <= param2.maxFraction * _loc10_)
            {
               _loc4_ = -_loc14_ * _loc8_ + _loc15_ * _loc9_;
               if(-_loc17_ * _loc10_ <= _loc4_ && _loc4_ <= _loc10_ * (1 + _loc17_))
               {
                  _loc5_ = _loc5_ / _loc10_;
                  param1.fraction = _loc5_;
                  _loc16_ = Math.sqrt(_loc7_ * _loc7_ + _loc6_ * _loc6_);
                  param1.normal.x = _loc7_ / _loc16_;
                  param1.normal.y = _loc6_ / _loc16_;
                  return true;
               }
            }
         }
         return false;
      }
      
      override public function ComputeAABB(param1:b2AABB, param2:b2Transform) : void
      {
         var _loc6_:b2Mat22 = param2.R;
         var _loc3_:Number = param2.position.x + (_loc6_.col1.x * m_v1.x + _loc6_.col2.x * m_v1.y);
         var _loc4_:Number = param2.position.y + (_loc6_.col1.y * m_v1.x + _loc6_.col2.y * m_v1.y);
         var _loc5_:Number = param2.position.x + (_loc6_.col1.x * m_v2.x + _loc6_.col2.x * m_v2.y);
         var _loc7_:Number = param2.position.y + (_loc6_.col1.y * m_v2.x + _loc6_.col2.y * m_v2.y);
         if(_loc3_ < _loc5_)
         {
            param1.lowerBound.x = _loc3_;
            param1.upperBound.x = _loc5_;
         }
         else
         {
            param1.lowerBound.x = _loc5_;
            param1.upperBound.x = _loc3_;
         }
         if(_loc4_ < _loc7_)
         {
            param1.lowerBound.y = _loc4_;
            param1.upperBound.y = _loc7_;
         }
         else
         {
            param1.lowerBound.y = _loc7_;
            param1.upperBound.y = _loc4_;
         }
      }
      
      override public function ComputeMass(param1:b2MassData, param2:Number) : void
      {
         param1.mass = 0;
         param1.center.SetV(m_v1);
         param1.I = 0;
      }
      
      override public function ComputeSubmergedArea(param1:b2Vec2, param2:Number, param3:b2Transform, param4:b2Vec2) : Number
      {
         var _loc7_:b2Vec2 = new b2Vec2(param1.x * param2,param1.y * param2);
         var _loc5_:b2Vec2 = b2Math.MulX(param3,m_v1);
         var _loc9_:b2Vec2 = b2Math.MulX(param3,m_v2);
         var _loc6_:Number = b2Math.Dot(param1,_loc5_) - param2;
         var _loc8_:Number = b2Math.Dot(param1,_loc9_) - param2;
         if(_loc6_ > 0)
         {
            if(_loc8_ > 0)
            {
               return 0;
            }
            _loc5_.x = -_loc8_ / (_loc6_ - _loc8_) * _loc5_.x + _loc6_ / (_loc6_ - _loc8_) * _loc9_.x;
            _loc5_.y = -_loc8_ / (_loc6_ - _loc8_) * _loc5_.y + _loc6_ / (_loc6_ - _loc8_) * _loc9_.y;
         }
         else if(_loc8_ > 0)
         {
            _loc9_.x = -_loc8_ / (_loc6_ - _loc8_) * _loc5_.x + _loc6_ / (_loc6_ - _loc8_) * _loc9_.x;
            _loc9_.y = -_loc8_ / (_loc6_ - _loc8_) * _loc5_.y + _loc6_ / (_loc6_ - _loc8_) * _loc9_.y;
         }
         param4.x = (_loc7_.x + _loc5_.x + _loc9_.x) / 3;
         param4.y = (_loc7_.y + _loc5_.y + _loc9_.y) / 3;
         return 0.5 * ((_loc5_.x - _loc7_.x) * (_loc9_.y - _loc7_.y) - (_loc5_.y - _loc7_.y) * (_loc9_.x - _loc7_.x));
      }
      
      public function GetLength() : Number
      {
         return m_length;
      }
      
      public function GetVertex1() : b2Vec2
      {
         return m_v1;
      }
      
      public function GetVertex2() : b2Vec2
      {
         return m_v2;
      }
      
      public function GetCoreVertex1() : b2Vec2
      {
         return m_coreV1;
      }
      
      public function GetCoreVertex2() : b2Vec2
      {
         return m_coreV2;
      }
      
      public function GetNormalVector() : b2Vec2
      {
         return m_normal;
      }
      
      public function GetDirectionVector() : b2Vec2
      {
         return m_direction;
      }
      
      public function GetCorner1Vector() : b2Vec2
      {
         return m_cornerDir1;
      }
      
      public function GetCorner2Vector() : b2Vec2
      {
         return m_cornerDir2;
      }
      
      public function Corner1IsConvex() : Boolean
      {
         return m_cornerConvex1;
      }
      
      public function Corner2IsConvex() : Boolean
      {
         return m_cornerConvex2;
      }
      
      public function GetFirstVertex(param1:b2Transform) : b2Vec2
      {
         var _loc2_:b2Mat22 = param1.R;
         return new b2Vec2(param1.position.x + (_loc2_.col1.x * m_coreV1.x + _loc2_.col2.x * m_coreV1.y),param1.position.y + (_loc2_.col1.y * m_coreV1.x + _loc2_.col2.y * m_coreV1.y));
      }
      
      public function GetNextEdge() : b2EdgeShape
      {
         return m_nextEdge;
      }
      
      public function GetPrevEdge() : b2EdgeShape
      {
         return m_prevEdge;
      }
      
      public function Support(param1:b2Transform, param2:Number, param3:Number) : b2Vec2
      {
         var _loc7_:b2Mat22 = param1.R;
         var _loc4_:Number = param1.position.x + (_loc7_.col1.x * m_coreV1.x + _loc7_.col2.x * m_coreV1.y);
         var _loc5_:Number = param1.position.y + (_loc7_.col1.y * m_coreV1.x + _loc7_.col2.y * m_coreV1.y);
         var _loc6_:Number = param1.position.x + (_loc7_.col1.x * m_coreV2.x + _loc7_.col2.x * m_coreV2.y);
         var _loc8_:Number = param1.position.y + (_loc7_.col1.y * m_coreV2.x + _loc7_.col2.y * m_coreV2.y);
         if(_loc4_ * param2 + _loc5_ * param3 > _loc6_ * param2 + _loc8_ * param3)
         {
            s_supportVec.x = _loc4_;
            s_supportVec.y = _loc5_;
         }
         else
         {
            s_supportVec.x = _loc6_;
            s_supportVec.y = _loc8_;
         }
         return s_supportVec;
      }
      
      b2internal function SetPrevEdge(param1:b2EdgeShape, param2:b2Vec2, param3:b2Vec2, param4:Boolean) : void
      {
         m_prevEdge = param1;
         m_coreV1 = param2;
         m_cornerDir1 = param3;
         m_cornerConvex1 = param4;
      }
      
      b2internal function SetNextEdge(param1:b2EdgeShape, param2:b2Vec2, param3:b2Vec2, param4:Boolean) : void
      {
         m_nextEdge = param1;
         m_coreV2 = param2;
         m_cornerDir2 = param3;
         m_cornerConvex2 = param4;
      }
   }
}
