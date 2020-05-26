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
   
   public class b2CircleShape extends b2Shape
   {
       
      
      b2internal var m_p:b2Vec2;
      
      public function b2CircleShape(param1:Number = 0)
      {
         m_p = new b2Vec2();
         super();
         m_type = 0;
         m_radius = param1;
      }
      
      override public function Copy() : b2Shape
      {
         var _loc1_:b2Shape = new b2CircleShape();
         _loc1_.Set(this);
         return _loc1_;
      }
      
      override public function Set(param1:b2Shape) : void
      {
         var _loc2_:* = null;
         super.Set(param1);
         if(param1 is b2CircleShape)
         {
            _loc2_ = param1 as b2CircleShape;
            m_p.SetV(_loc2_.m_p);
         }
      }
      
      override public function TestPoint(param1:b2Transform, param2:b2Vec2) : Boolean
      {
         var _loc3_:b2Mat22 = param1.R;
         var _loc5_:Number = param1.position.x + (_loc3_.col1.x * m_p.x + _loc3_.col2.x * m_p.y);
         var _loc4_:Number = param1.position.y + (_loc3_.col1.y * m_p.x + _loc3_.col2.y * m_p.y);
         _loc5_ = param2.x - _loc5_;
         _loc4_ = param2.y - _loc4_;
         return _loc5_ * _loc5_ + _loc4_ * _loc4_ <= m_radius * m_radius;
      }
      
      override public function RayCast(param1:b2RayCastOutput, param2:b2RayCastInput, param3:b2Transform) : Boolean
      {
         var _loc9_:b2Mat22 = param3.R;
         var _loc10_:Number = param3.position.x + (_loc9_.col1.x * m_p.x + _loc9_.col2.x * m_p.y);
         var _loc7_:Number = param3.position.y + (_loc9_.col1.y * m_p.x + _loc9_.col2.y * m_p.y);
         var _loc14_:Number = param2.p1.x - _loc10_;
         var _loc15_:Number = param2.p1.y - _loc7_;
         var _loc4_:Number = _loc14_ * _loc14_ + _loc15_ * _loc15_ - m_radius * m_radius;
         var _loc11_:Number = param2.p2.x - param2.p1.x;
         var _loc13_:Number = param2.p2.y - param2.p1.y;
         var _loc5_:Number = _loc14_ * _loc11_ + _loc15_ * _loc13_;
         var _loc12_:Number = _loc11_ * _loc11_ + _loc13_ * _loc13_;
         var _loc8_:Number = _loc5_ * _loc5_ - _loc12_ * _loc4_;
         if(_loc8_ < 0 || _loc12_ < Number.MIN_VALUE)
         {
            return false;
         }
         var _loc6_:Number = -(_loc5_ + Math.sqrt(_loc8_));
         if(0 <= _loc6_ && _loc6_ <= param2.maxFraction * _loc12_)
         {
            _loc6_ = _loc6_ / _loc12_;
            param1.fraction = _loc6_;
            param1.normal.x = _loc14_ + _loc6_ * _loc11_;
            param1.normal.y = _loc15_ + _loc6_ * _loc13_;
            param1.normal.Normalize();
            return true;
         }
         return false;
      }
      
      override public function ComputeAABB(param1:b2AABB, param2:b2Transform) : void
      {
         var _loc3_:b2Mat22 = param2.R;
         var _loc5_:Number = param2.position.x + (_loc3_.col1.x * m_p.x + _loc3_.col2.x * m_p.y);
         var _loc4_:Number = param2.position.y + (_loc3_.col1.y * m_p.x + _loc3_.col2.y * m_p.y);
         param1.lowerBound.Set(_loc5_ - m_radius,_loc4_ - m_radius);
         param1.upperBound.Set(_loc5_ + m_radius,_loc4_ + m_radius);
      }
      
      override public function ComputeMass(param1:b2MassData, param2:Number) : void
      {
         param1.mass = param2 * 3.14159265358979 * m_radius * m_radius;
         param1.center.SetV(m_p);
         param1.I = param1.mass * (0.5 * m_radius * m_radius + (m_p.x * m_p.x + m_p.y * m_p.y));
      }
      
      override public function ComputeSubmergedArea(param1:b2Vec2, param2:Number, param3:b2Transform, param4:b2Vec2) : Number
      {
         var _loc7_:b2Vec2 = b2Math.MulX(param3,m_p);
         var _loc9_:Number = -(b2Math.Dot(param1,_loc7_) - param2);
         if(_loc9_ < -m_radius + Number.MIN_VALUE)
         {
            return 0;
         }
         if(_loc9_ > m_radius)
         {
            param4.SetV(_loc7_);
            return 3.14159265358979 * m_radius * m_radius;
         }
         var _loc10_:Number = m_radius * m_radius;
         var _loc8_:Number = _loc9_ * _loc9_;
         var _loc6_:Number = _loc10_ * (Math.asin(_loc9_ / m_radius) + 3.14159265358979 / 2) + _loc9_ * Math.sqrt(_loc10_ - _loc8_);
         var _loc5_:Number = -0.666666666666667 * Math.pow(_loc10_ - _loc8_,1.5) / _loc6_;
         param4.x = _loc7_.x + param1.x * _loc5_;
         param4.y = _loc7_.y + param1.y * _loc5_;
         return _loc6_;
      }
      
      public function GetLocalPosition() : b2Vec2
      {
         return m_p;
      }
      
      public function SetLocalPosition(param1:b2Vec2) : void
      {
         m_p.SetV(param1);
      }
      
      public function GetRadius() : Number
      {
         return m_radius;
      }
      
      public function SetRadius(param1:Number) : void
      {
         m_radius = param1;
      }
   }
}
