package Box2D.Dynamics.Contacts
{
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2Settings;
   import Box2D.Common.b2internal;
   
   use namespace b2internal;
   
   class b2PositionSolverManifold
   {
      
      private static var circlePointA:b2Vec2 = new b2Vec2();
      
      private static var circlePointB:b2Vec2 = new b2Vec2();
       
      
      public var m_normal:b2Vec2;
      
      public var m_points:Vector.<b2Vec2>;
      
      public var m_separations:Vector.<Number>;
      
      function b2PositionSolverManifold()
      {
         var _loc1_:int = 0;
         super();
         m_normal = new b2Vec2();
         m_separations = new Vector.<Number>(2);
         m_points = new Vector.<b2Vec2>(2);
         _loc1_ = 0;
         while(_loc1_ < 2)
         {
            m_points[_loc1_] = new b2Vec2();
            _loc1_++;
         }
      }
      
      public function Initialize(param1:b2ContactConstraint) : void
      {
         var _loc8_:int = 0;
         var _loc6_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc13_:* = null;
         var _loc7_:* = null;
         var _loc14_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc2_:Number = NaN;
         b2Settings.b2Assert(param1.pointCount > 0);
         switch(int(param1.type) - 1)
         {
            case 0:
               _loc13_ = param1.bodyA.m_xf.R;
               _loc7_ = param1.localPoint;
               _loc12_ = param1.bodyA.m_xf.position.x + (_loc13_.col1.x * _loc7_.x + _loc13_.col2.x * _loc7_.y);
               _loc15_ = param1.bodyA.m_xf.position.y + (_loc13_.col1.y * _loc7_.x + _loc13_.col2.y * _loc7_.y);
               _loc13_ = param1.bodyB.m_xf.R;
               _loc7_ = param1.points[0].localPoint;
               _loc9_ = param1.bodyB.m_xf.position.x + (_loc13_.col1.x * _loc7_.x + _loc13_.col2.x * _loc7_.y);
               _loc10_ = param1.bodyB.m_xf.position.y + (_loc13_.col1.y * _loc7_.x + _loc13_.col2.y * _loc7_.y);
               _loc4_ = _loc9_ - _loc12_;
               _loc3_ = _loc10_ - _loc15_;
               _loc11_ = _loc4_ * _loc4_ + _loc3_ * _loc3_;
               if(_loc11_ > Number.MIN_VALUE * Number.MIN_VALUE)
               {
                  _loc2_ = Math.sqrt(_loc11_);
                  m_normal.x = _loc4_ / _loc2_;
                  m_normal.y = _loc3_ / _loc2_;
               }
               else
               {
                  m_normal.x = 1;
                  m_normal.y = 0;
               }
               m_points[0].x = 0.5 * (_loc12_ + _loc9_);
               m_points[0].y = 0.5 * (_loc15_ + _loc10_);
               m_separations[0] = _loc4_ * m_normal.x + _loc3_ * m_normal.y - param1.radius;
               break;
            case 1:
               _loc13_ = param1.bodyA.m_xf.R;
               _loc7_ = param1.localPlaneNormal;
               m_normal.x = _loc13_.col1.x * _loc7_.x + _loc13_.col2.x * _loc7_.y;
               m_normal.y = _loc13_.col1.y * _loc7_.x + _loc13_.col2.y * _loc7_.y;
               _loc13_ = param1.bodyA.m_xf.R;
               _loc7_ = param1.localPoint;
               _loc14_ = param1.bodyA.m_xf.position.x + (_loc13_.col1.x * _loc7_.x + _loc13_.col2.x * _loc7_.y);
               _loc16_ = param1.bodyA.m_xf.position.y + (_loc13_.col1.y * _loc7_.x + _loc13_.col2.y * _loc7_.y);
               _loc13_ = param1.bodyB.m_xf.R;
               _loc8_ = 0;
               while(_loc8_ < param1.pointCount)
               {
                  _loc7_ = param1.points[_loc8_].localPoint;
                  _loc6_ = param1.bodyB.m_xf.position.x + (_loc13_.col1.x * _loc7_.x + _loc13_.col2.x * _loc7_.y);
                  _loc5_ = param1.bodyB.m_xf.position.y + (_loc13_.col1.y * _loc7_.x + _loc13_.col2.y * _loc7_.y);
                  m_separations[_loc8_] = (_loc6_ - _loc14_) * m_normal.x + (_loc5_ - _loc16_) * m_normal.y - param1.radius;
                  m_points[_loc8_].x = _loc6_;
                  m_points[_loc8_].y = _loc5_;
                  _loc8_++;
               }
               break;
            default:
               _loc13_ = param1.bodyA.m_xf.R;
               _loc7_ = param1.localPlaneNormal;
               m_normal.x = _loc13_.col1.x * _loc7_.x + _loc13_.col2.x * _loc7_.y;
               m_normal.y = _loc13_.col1.y * _loc7_.x + _loc13_.col2.y * _loc7_.y;
               _loc13_ = param1.bodyA.m_xf.R;
               _loc7_ = param1.localPoint;
               _loc14_ = param1.bodyA.m_xf.position.x + (_loc13_.col1.x * _loc7_.x + _loc13_.col2.x * _loc7_.y);
               _loc16_ = param1.bodyA.m_xf.position.y + (_loc13_.col1.y * _loc7_.x + _loc13_.col2.y * _loc7_.y);
               _loc13_ = param1.bodyB.m_xf.R;
               _loc8_ = 0;
               while(_loc8_ < param1.pointCount)
               {
                  _loc7_ = param1.points[_loc8_].localPoint;
                  _loc6_ = param1.bodyB.m_xf.position.x + (_loc13_.col1.x * _loc7_.x + _loc13_.col2.x * _loc7_.y);
                  _loc5_ = param1.bodyB.m_xf.position.y + (_loc13_.col1.y * _loc7_.x + _loc13_.col2.y * _loc7_.y);
                  m_separations[_loc8_] = (_loc6_ - _loc14_) * m_normal.x + (_loc5_ - _loc16_) * m_normal.y - param1.radius;
                  m_points[_loc8_].x = _loc6_;
                  m_points[_loc8_].y = _loc5_;
                  _loc8_++;
               }
               break;
            case 3:
               _loc13_ = param1.bodyB.m_xf.R;
               _loc7_ = param1.localPlaneNormal;
               m_normal.x = _loc13_.col1.x * _loc7_.x + _loc13_.col2.x * _loc7_.y;
               m_normal.y = _loc13_.col1.y * _loc7_.x + _loc13_.col2.y * _loc7_.y;
               _loc13_ = param1.bodyB.m_xf.R;
               _loc7_ = param1.localPoint;
               _loc14_ = param1.bodyB.m_xf.position.x + (_loc13_.col1.x * _loc7_.x + _loc13_.col2.x * _loc7_.y);
               _loc16_ = param1.bodyB.m_xf.position.y + (_loc13_.col1.y * _loc7_.x + _loc13_.col2.y * _loc7_.y);
               _loc13_ = param1.bodyA.m_xf.R;
               _loc8_ = 0;
               while(_loc8_ < param1.pointCount)
               {
                  _loc7_ = param1.points[_loc8_].localPoint;
                  _loc6_ = param1.bodyA.m_xf.position.x + (_loc13_.col1.x * _loc7_.x + _loc13_.col2.x * _loc7_.y);
                  _loc5_ = param1.bodyA.m_xf.position.y + (_loc13_.col1.y * _loc7_.x + _loc13_.col2.y * _loc7_.y);
                  m_separations[_loc8_] = (_loc6_ - _loc14_) * m_normal.x + (_loc5_ - _loc16_) * m_normal.y - param1.radius;
                  m_points[_loc8_].Set(_loc6_,_loc5_);
                  _loc8_++;
               }
               m_normal.x = m_normal.x * -1;
               m_normal.y = m_normal.y * -1;
         }
      }
   }
}
