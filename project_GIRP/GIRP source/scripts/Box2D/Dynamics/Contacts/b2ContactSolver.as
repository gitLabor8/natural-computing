package Box2D.Dynamics.Contacts
{
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Collision.b2Manifold;
   import Box2D.Collision.b2ManifoldPoint;
   import Box2D.Collision.b2WorldManifold;
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2Settings;
   import Box2D.Common.b2internal;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2Fixture;
   import Box2D.Dynamics.b2TimeStep;
   
   use namespace b2internal;
   
   public class b2ContactSolver
   {
      
      private static var s_worldManifold:b2WorldManifold = new b2WorldManifold();
      
      private static var s_psm:b2PositionSolverManifold = new b2PositionSolverManifold();
       
      
      private var m_step:b2TimeStep;
      
      private var m_allocator;
      
      b2internal var m_constraints:Vector.<b2ContactConstraint>;
      
      private var m_constraintCount:int;
      
      public function b2ContactSolver()
      {
         m_step = new b2TimeStep();
         m_constraints = new Vector.<b2ContactConstraint>();
         super();
      }
      
      public function Initialize(param1:b2TimeStep, param2:Vector.<b2Contact>, param3:int, param4:*) : void
      {
         var _loc42_:* = null;
         var _loc51_:int = 0;
         var _loc50_:* = null;
         var _loc54_:* = null;
         var _loc28_:* = null;
         var _loc29_:* = null;
         var _loc21_:* = null;
         var _loc23_:* = null;
         var _loc26_:Number = NaN;
         var _loc34_:Number = NaN;
         var _loc60_:* = null;
         var _loc38_:* = null;
         var _loc8_:* = null;
         var _loc27_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc48_:Number = NaN;
         var _loc47_:Number = NaN;
         var _loc45_:Number = NaN;
         var _loc44_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc36_:* = null;
         var _loc49_:* = 0;
         var _loc30_:* = null;
         var _loc11_:* = null;
         var _loc19_:* = NaN;
         var _loc20_:* = NaN;
         var _loc59_:* = NaN;
         var _loc61_:* = NaN;
         var _loc53_:Number = NaN;
         var _loc55_:Number = NaN;
         var _loc40_:Number = NaN;
         var _loc57_:Number = NaN;
         var _loc58_:* = NaN;
         var _loc56_:Number = NaN;
         var _loc52_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc33_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc41_:* = null;
         var _loc39_:* = null;
         var _loc16_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc37_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc46_:Number = NaN;
         var _loc43_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc7_:* = NaN;
         m_step.Set(param1);
         m_allocator = param4;
         m_constraintCount = param3;
         while(m_constraints.length < m_constraintCount)
         {
            m_constraints[m_constraints.length] = new b2ContactConstraint();
         }
         _loc51_ = 0;
         while(_loc51_ < param3)
         {
            _loc42_ = param2[_loc51_];
            _loc28_ = _loc42_.m_fixtureA;
            _loc29_ = _loc42_.m_fixtureB;
            _loc21_ = _loc28_.m_shape;
            _loc23_ = _loc29_.m_shape;
            _loc26_ = _loc21_.m_radius;
            _loc34_ = _loc23_.m_radius;
            _loc60_ = _loc28_.m_body;
            _loc38_ = _loc29_.m_body;
            _loc8_ = _loc42_.GetManifold();
            _loc27_ = b2Settings.b2MixFriction(_loc28_.GetFriction(),_loc29_.GetFriction());
            _loc14_ = b2Settings.b2MixRestitution(_loc28_.GetRestitution(),_loc29_.GetRestitution());
            _loc6_ = _loc60_.m_linearVelocity.x;
            _loc10_ = _loc60_.m_linearVelocity.y;
            _loc48_ = _loc38_.m_linearVelocity.x;
            _loc47_ = _loc38_.m_linearVelocity.y;
            _loc45_ = _loc60_.m_angularVelocity;
            _loc44_ = _loc38_.m_angularVelocity;
            b2Settings.b2Assert(_loc8_.m_pointCount > 0);
            s_worldManifold.Initialize(_loc8_,_loc60_.m_xf,_loc26_,_loc38_.m_xf,_loc34_);
            _loc13_ = s_worldManifold.m_normal.x;
            _loc15_ = s_worldManifold.m_normal.y;
            _loc36_ = m_constraints[_loc51_];
            _loc36_.bodyA = _loc60_;
            _loc36_.bodyB = _loc38_;
            _loc36_.manifold = _loc8_;
            _loc36_.normal.x = _loc13_;
            _loc36_.normal.y = _loc15_;
            _loc36_.pointCount = _loc8_.m_pointCount;
            _loc36_.friction = _loc27_;
            _loc36_.restitution = _loc14_;
            _loc36_.localPlaneNormal.x = _loc8_.m_localPlaneNormal.x;
            _loc36_.localPlaneNormal.y = _loc8_.m_localPlaneNormal.y;
            _loc36_.localPoint.x = _loc8_.m_localPoint.x;
            _loc36_.localPoint.y = _loc8_.m_localPoint.y;
            _loc36_.radius = _loc26_ + _loc34_;
            _loc36_.type = _loc8_.m_type;
            _loc49_ = uint(0);
            while(_loc49_ < _loc36_.pointCount)
            {
               _loc30_ = _loc8_.m_points[_loc49_];
               _loc11_ = _loc36_.points[_loc49_];
               _loc11_.normalImpulse = _loc30_.m_normalImpulse;
               _loc11_.tangentImpulse = _loc30_.m_tangentImpulse;
               _loc11_.localPoint.SetV(_loc30_.m_localPoint);
               var _loc62_:* = s_worldManifold.m_points[_loc49_].x - _loc60_.m_sweep.c.x;
               _loc11_.rA.x = _loc62_;
               _loc19_ = _loc62_;
               _loc62_ = s_worldManifold.m_points[_loc49_].y - _loc60_.m_sweep.c.y;
               _loc11_.rA.y = _loc62_;
               _loc20_ = _loc62_;
               _loc62_ = s_worldManifold.m_points[_loc49_].x - _loc38_.m_sweep.c.x;
               _loc11_.rB.x = _loc62_;
               _loc59_ = _loc62_;
               _loc62_ = s_worldManifold.m_points[_loc49_].y - _loc38_.m_sweep.c.y;
               _loc11_.rB.y = _loc62_;
               _loc61_ = _loc62_;
               _loc53_ = _loc19_ * _loc15_ - _loc20_ * _loc13_;
               _loc55_ = _loc59_ * _loc15_ - _loc61_ * _loc13_;
               _loc53_ = _loc53_ * _loc53_;
               _loc55_ = _loc55_ * _loc55_;
               _loc40_ = _loc60_.m_invMass + _loc38_.m_invMass + _loc60_.m_invI * _loc53_ + _loc38_.m_invI * _loc55_;
               _loc11_.normalMass = 1 / _loc40_;
               _loc57_ = _loc60_.m_mass * _loc60_.m_invMass + _loc38_.m_mass * _loc38_.m_invMass;
               _loc57_ = _loc57_ + (_loc60_.m_mass * _loc60_.m_invI * _loc53_ + _loc38_.m_mass * _loc38_.m_invI * _loc55_);
               _loc11_.equalizedMass = 1 / _loc57_;
               _loc58_ = _loc15_;
               _loc56_ = -_loc13_;
               _loc52_ = _loc19_ * _loc56_ - _loc20_ * _loc58_;
               _loc12_ = _loc59_ * _loc56_ - _loc61_ * _loc58_;
               _loc52_ = _loc52_ * _loc52_;
               _loc12_ = _loc12_ * _loc12_;
               _loc33_ = _loc60_.m_invMass + _loc38_.m_invMass + _loc60_.m_invI * _loc52_ + _loc38_.m_invI * _loc12_;
               _loc11_.tangentMass = 1 / _loc33_;
               _loc11_.velocityBias = 0;
               _loc22_ = _loc48_ + -_loc44_ * _loc61_ - _loc6_ - -_loc45_ * _loc20_;
               _loc24_ = _loc47_ + _loc44_ * _loc59_ - _loc10_ - _loc45_ * _loc19_;
               _loc17_ = _loc36_.normal.x * _loc22_ + _loc36_.normal.y * _loc24_;
               if(_loc17_ < -1)
               {
                  _loc11_.velocityBias = _loc11_.velocityBias + -_loc36_.restitution * _loc17_;
               }
               _loc49_++;
            }
            if(_loc36_.pointCount == 2)
            {
               _loc41_ = _loc36_.points[0];
               _loc39_ = _loc36_.points[1];
               _loc16_ = _loc60_.m_invMass;
               _loc35_ = _loc60_.m_invI;
               _loc18_ = _loc38_.m_invMass;
               _loc37_ = _loc38_.m_invI;
               _loc32_ = _loc41_.rA.x * _loc15_ - _loc41_.rA.y * _loc13_;
               _loc31_ = _loc41_.rB.x * _loc15_ - _loc41_.rB.y * _loc13_;
               _loc46_ = _loc39_.rA.x * _loc15_ - _loc39_.rA.y * _loc13_;
               _loc43_ = _loc39_.rB.x * _loc15_ - _loc39_.rB.y * _loc13_;
               _loc5_ = _loc16_ + _loc18_ + _loc35_ * _loc32_ * _loc32_ + _loc37_ * _loc31_ * _loc31_;
               _loc25_ = _loc16_ + _loc18_ + _loc35_ * _loc46_ * _loc46_ + _loc37_ * _loc43_ * _loc43_;
               _loc9_ = _loc16_ + _loc18_ + _loc35_ * _loc32_ * _loc46_ + _loc37_ * _loc31_ * _loc43_;
               _loc7_ = 100;
               if(_loc5_ * _loc5_ < _loc7_ * (_loc5_ * _loc25_ - _loc9_ * _loc9_))
               {
                  _loc36_.K.col1.Set(_loc5_,_loc9_);
                  _loc36_.K.col2.Set(_loc9_,_loc25_);
                  _loc36_.K.GetInverse(_loc36_.normalMass);
               }
               else
               {
                  _loc36_.pointCount = 1;
               }
            }
            _loc51_++;
         }
      }
      
      public function InitVelocityConstraints(param1:b2TimeStep) : void
      {
         var _loc10_:* = null;
         var _loc2_:* = null;
         var _loc15_:* = null;
         var _loc12_:int = 0;
         var _loc5_:* = null;
         var _loc22_:* = null;
         var _loc3_:* = null;
         var _loc13_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc20_:* = NaN;
         var _loc16_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc8_:int = 0;
         var _loc7_:int = 0;
         var _loc6_:* = null;
         var _loc17_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc4_:* = null;
         _loc12_ = 0;
         while(_loc12_ < m_constraintCount)
         {
            _loc5_ = m_constraints[_loc12_];
            _loc22_ = _loc5_.bodyA;
            _loc3_ = _loc5_.bodyB;
            _loc13_ = _loc22_.m_invMass;
            _loc18_ = _loc22_.m_invI;
            _loc14_ = _loc3_.m_invMass;
            _loc23_ = _loc3_.m_invI;
            _loc9_ = _loc5_.normal.x;
            _loc11_ = _loc5_.normal.y;
            _loc20_ = _loc11_;
            _loc16_ = -_loc9_;
            if(param1.warmStarting)
            {
               _loc7_ = _loc5_.pointCount;
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  _loc6_ = _loc5_.points[_loc8_];
                  _loc6_.normalImpulse = _loc6_.normalImpulse * param1.dtRatio;
                  _loc6_.tangentImpulse = _loc6_.tangentImpulse * param1.dtRatio;
                  _loc17_ = _loc6_.normalImpulse * _loc9_ + _loc6_.tangentImpulse * _loc20_;
                  _loc19_ = _loc6_.normalImpulse * _loc11_ + _loc6_.tangentImpulse * _loc16_;
                  _loc22_.m_angularVelocity = _loc22_.m_angularVelocity - _loc18_ * (_loc6_.rA.x * _loc19_ - _loc6_.rA.y * _loc17_);
                  _loc22_.m_linearVelocity.x = _loc22_.m_linearVelocity.x - _loc13_ * _loc17_;
                  _loc22_.m_linearVelocity.y = _loc22_.m_linearVelocity.y - _loc13_ * _loc19_;
                  _loc3_.m_angularVelocity = _loc3_.m_angularVelocity + _loc23_ * (_loc6_.rB.x * _loc19_ - _loc6_.rB.y * _loc17_);
                  _loc3_.m_linearVelocity.x = _loc3_.m_linearVelocity.x + _loc14_ * _loc17_;
                  _loc3_.m_linearVelocity.y = _loc3_.m_linearVelocity.y + _loc14_ * _loc19_;
                  _loc8_++;
               }
            }
            else
            {
               _loc7_ = _loc5_.pointCount;
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  _loc4_ = _loc5_.points[_loc8_];
                  _loc4_.normalImpulse = 0;
                  _loc4_.tangentImpulse = 0;
                  _loc8_++;
               }
            }
            _loc12_++;
         }
      }
      
      public function SolveVelocityConstraints() : void
      {
         var _loc41_:int = 0;
         var _loc1_:* = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc54_:Number = NaN;
         var _loc56_:Number = NaN;
         var _loc48_:Number = NaN;
         var _loc46_:Number = NaN;
         var _loc29_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc31_:Number = NaN;
         var _loc49_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc38_:Number = NaN;
         var _loc39_:Number = NaN;
         var _loc50_:* = null;
         var _loc43_:* = null;
         var _loc44_:int = 0;
         var _loc34_:* = null;
         var _loc57_:* = null;
         var _loc25_:* = null;
         var _loc33_:Number = NaN;
         var _loc32_:Number = NaN;
         var _loc55_:* = null;
         var _loc51_:* = null;
         var _loc8_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc53_:* = NaN;
         var _loc52_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc19_:int = 0;
         var _loc37_:* = null;
         var _loc36_:* = null;
         var _loc30_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc47_:* = NaN;
         var _loc45_:* = NaN;
         var _loc42_:Number = NaN;
         var _loc40_:Number = NaN;
         var _loc35_:* = NaN;
         var _loc9_:* = NaN;
         var _loc7_:* = NaN;
         _loc44_ = 0;
         while(_loc44_ < m_constraintCount)
         {
            _loc34_ = m_constraints[_loc44_];
            _loc57_ = _loc34_.bodyA;
            _loc25_ = _loc34_.bodyB;
            _loc33_ = _loc57_.m_angularVelocity;
            _loc32_ = _loc25_.m_angularVelocity;
            _loc55_ = _loc57_.m_linearVelocity;
            _loc51_ = _loc25_.m_linearVelocity;
            _loc8_ = _loc57_.m_invMass;
            _loc21_ = _loc57_.m_invI;
            _loc10_ = _loc25_.m_invMass;
            _loc23_ = _loc25_.m_invI;
            _loc4_ = _loc34_.normal.x;
            _loc5_ = _loc34_.normal.y;
            _loc53_ = _loc5_;
            _loc52_ = -_loc4_;
            _loc16_ = _loc34_.friction;
            _loc41_ = 0;
            while(_loc41_ < _loc34_.pointCount)
            {
               _loc1_ = _loc34_.points[_loc41_];
               _loc48_ = _loc51_.x - _loc32_ * _loc1_.rB.y - _loc55_.x + _loc33_ * _loc1_.rA.y;
               _loc46_ = _loc51_.y + _loc32_ * _loc1_.rB.x - _loc55_.y - _loc33_ * _loc1_.rA.x;
               _loc27_ = _loc48_ * _loc53_ + _loc46_ * _loc52_;
               _loc6_ = _loc1_.tangentMass * -_loc27_;
               _loc31_ = _loc16_ * _loc1_.normalImpulse;
               _loc49_ = b2Math.Clamp(_loc1_.tangentImpulse + _loc6_,-_loc31_,_loc31_);
               _loc6_ = _loc49_ - _loc1_.tangentImpulse;
               _loc20_ = _loc6_ * _loc53_;
               _loc22_ = _loc6_ * _loc52_;
               _loc55_.x = _loc55_.x - _loc8_ * _loc20_;
               _loc55_.y = _loc55_.y - _loc8_ * _loc22_;
               _loc33_ = _loc33_ - _loc21_ * (_loc1_.rA.x * _loc22_ - _loc1_.rA.y * _loc20_);
               _loc51_.x = _loc51_.x + _loc10_ * _loc20_;
               _loc51_.y = _loc51_.y + _loc10_ * _loc22_;
               _loc32_ = _loc32_ + _loc23_ * (_loc1_.rB.x * _loc22_ - _loc1_.rB.y * _loc20_);
               _loc1_.tangentImpulse = _loc49_;
               _loc41_++;
            }
            _loc19_ = _loc34_.pointCount;
            if(_loc34_.pointCount == 1)
            {
               _loc1_ = _loc34_.points[0];
               _loc48_ = _loc51_.x + -_loc32_ * _loc1_.rB.y - _loc55_.x - -_loc33_ * _loc1_.rA.y;
               _loc46_ = _loc51_.y + _loc32_ * _loc1_.rB.x - _loc55_.y - _loc33_ * _loc1_.rA.x;
               _loc29_ = _loc48_ * _loc4_ + _loc46_ * _loc5_;
               _loc6_ = -_loc1_.normalMass * (_loc29_ - _loc1_.velocityBias);
               _loc49_ = _loc1_.normalImpulse + _loc6_;
               _loc49_ = _loc49_ > 0?_loc49_:0;
               _loc6_ = _loc49_ - _loc1_.normalImpulse;
               _loc20_ = _loc6_ * _loc4_;
               _loc22_ = _loc6_ * _loc5_;
               _loc55_.x = _loc55_.x - _loc8_ * _loc20_;
               _loc55_.y = _loc55_.y - _loc8_ * _loc22_;
               _loc33_ = _loc33_ - _loc21_ * (_loc1_.rA.x * _loc22_ - _loc1_.rA.y * _loc20_);
               _loc51_.x = _loc51_.x + _loc10_ * _loc20_;
               _loc51_.y = _loc51_.y + _loc10_ * _loc22_;
               _loc32_ = _loc32_ + _loc23_ * (_loc1_.rB.x * _loc22_ - _loc1_.rB.y * _loc20_);
               _loc1_.normalImpulse = _loc49_;
            }
            else
            {
               _loc37_ = _loc34_.points[0];
               _loc36_ = _loc34_.points[1];
               _loc30_ = _loc37_.normalImpulse;
               _loc24_ = _loc36_.normalImpulse;
               _loc3_ = _loc51_.x - _loc32_ * _loc37_.rB.y - _loc55_.x + _loc33_ * _loc37_.rA.y;
               _loc2_ = _loc51_.y + _loc32_ * _loc37_.rB.x - _loc55_.y - _loc33_ * _loc37_.rA.x;
               _loc14_ = _loc51_.x - _loc32_ * _loc36_.rB.y - _loc55_.x + _loc33_ * _loc36_.rA.y;
               _loc15_ = _loc51_.y + _loc32_ * _loc36_.rB.x - _loc55_.y - _loc33_ * _loc36_.rA.x;
               _loc47_ = Number(_loc3_ * _loc4_ + _loc2_ * _loc5_);
               _loc45_ = Number(_loc14_ * _loc4_ + _loc15_ * _loc5_);
               _loc42_ = _loc47_ - _loc37_.velocityBias;
               _loc40_ = _loc45_ - _loc36_.velocityBias;
               _loc50_ = _loc34_.K;
               _loc42_ = _loc42_ - (_loc50_.col1.x * _loc30_ + _loc50_.col2.x * _loc24_);
               _loc40_ = _loc40_ - (_loc50_.col1.y * _loc30_ + _loc50_.col2.y * _loc24_);
               _loc35_ = 0.001;
               _loc50_ = _loc34_.normalMass;
               _loc9_ = Number(-(_loc50_.col1.x * _loc42_ + _loc50_.col2.x * _loc40_));
               _loc7_ = Number(-(_loc50_.col1.y * _loc42_ + _loc50_.col2.y * _loc40_));
               if(_loc9_ >= 0 && _loc7_ >= 0)
               {
                  _loc18_ = _loc9_ - _loc30_;
                  _loc17_ = _loc7_ - _loc24_;
                  _loc28_ = _loc18_ * _loc4_;
                  _loc26_ = _loc18_ * _loc5_;
                  _loc38_ = _loc17_ * _loc4_;
                  _loc39_ = _loc17_ * _loc5_;
                  _loc55_.x = _loc55_.x - _loc8_ * (_loc28_ + _loc38_);
                  _loc55_.y = _loc55_.y - _loc8_ * (_loc26_ + _loc39_);
                  _loc33_ = _loc33_ - _loc21_ * (_loc37_.rA.x * _loc26_ - _loc37_.rA.y * _loc28_ + _loc36_.rA.x * _loc39_ - _loc36_.rA.y * _loc38_);
                  _loc51_.x = _loc51_.x + _loc10_ * (_loc28_ + _loc38_);
                  _loc51_.y = _loc51_.y + _loc10_ * (_loc26_ + _loc39_);
                  _loc32_ = _loc32_ + _loc23_ * (_loc37_.rB.x * _loc26_ - _loc37_.rB.y * _loc28_ + _loc36_.rB.x * _loc39_ - _loc36_.rB.y * _loc38_);
                  _loc37_.normalImpulse = _loc9_;
                  _loc36_.normalImpulse = _loc7_;
               }
               else
               {
                  _loc9_ = Number(-_loc37_.normalMass * _loc42_);
                  _loc7_ = 0;
                  _loc47_ = 0;
                  _loc45_ = Number(_loc34_.K.col1.y * _loc9_ + _loc40_);
                  if(_loc9_ >= 0 && _loc45_ >= 0)
                  {
                     _loc18_ = _loc9_ - _loc30_;
                     _loc17_ = _loc7_ - _loc24_;
                     _loc28_ = _loc18_ * _loc4_;
                     _loc26_ = _loc18_ * _loc5_;
                     _loc38_ = _loc17_ * _loc4_;
                     _loc39_ = _loc17_ * _loc5_;
                     _loc55_.x = _loc55_.x - _loc8_ * (_loc28_ + _loc38_);
                     _loc55_.y = _loc55_.y - _loc8_ * (_loc26_ + _loc39_);
                     _loc33_ = _loc33_ - _loc21_ * (_loc37_.rA.x * _loc26_ - _loc37_.rA.y * _loc28_ + _loc36_.rA.x * _loc39_ - _loc36_.rA.y * _loc38_);
                     _loc51_.x = _loc51_.x + _loc10_ * (_loc28_ + _loc38_);
                     _loc51_.y = _loc51_.y + _loc10_ * (_loc26_ + _loc39_);
                     _loc32_ = _loc32_ + _loc23_ * (_loc37_.rB.x * _loc26_ - _loc37_.rB.y * _loc28_ + _loc36_.rB.x * _loc39_ - _loc36_.rB.y * _loc38_);
                     _loc37_.normalImpulse = _loc9_;
                     _loc36_.normalImpulse = _loc7_;
                  }
                  else
                  {
                     _loc9_ = 0;
                     _loc7_ = Number(-_loc36_.normalMass * _loc40_);
                     _loc47_ = Number(_loc34_.K.col2.x * _loc7_ + _loc42_);
                     _loc45_ = 0;
                     if(_loc7_ >= 0 && _loc47_ >= 0)
                     {
                        _loc18_ = _loc9_ - _loc30_;
                        _loc17_ = _loc7_ - _loc24_;
                        _loc28_ = _loc18_ * _loc4_;
                        _loc26_ = _loc18_ * _loc5_;
                        _loc38_ = _loc17_ * _loc4_;
                        _loc39_ = _loc17_ * _loc5_;
                        _loc55_.x = _loc55_.x - _loc8_ * (_loc28_ + _loc38_);
                        _loc55_.y = _loc55_.y - _loc8_ * (_loc26_ + _loc39_);
                        _loc33_ = _loc33_ - _loc21_ * (_loc37_.rA.x * _loc26_ - _loc37_.rA.y * _loc28_ + _loc36_.rA.x * _loc39_ - _loc36_.rA.y * _loc38_);
                        _loc51_.x = _loc51_.x + _loc10_ * (_loc28_ + _loc38_);
                        _loc51_.y = _loc51_.y + _loc10_ * (_loc26_ + _loc39_);
                        _loc32_ = _loc32_ + _loc23_ * (_loc37_.rB.x * _loc26_ - _loc37_.rB.y * _loc28_ + _loc36_.rB.x * _loc39_ - _loc36_.rB.y * _loc38_);
                        _loc37_.normalImpulse = _loc9_;
                        _loc36_.normalImpulse = _loc7_;
                     }
                     else
                     {
                        _loc9_ = 0;
                        _loc7_ = 0;
                        _loc47_ = _loc42_;
                        _loc45_ = _loc40_;
                        if(_loc47_ >= 0 && _loc45_ >= 0)
                        {
                           _loc18_ = _loc9_ - _loc30_;
                           _loc17_ = _loc7_ - _loc24_;
                           _loc28_ = _loc18_ * _loc4_;
                           _loc26_ = _loc18_ * _loc5_;
                           _loc38_ = _loc17_ * _loc4_;
                           _loc39_ = _loc17_ * _loc5_;
                           _loc55_.x = _loc55_.x - _loc8_ * (_loc28_ + _loc38_);
                           _loc55_.y = _loc55_.y - _loc8_ * (_loc26_ + _loc39_);
                           _loc33_ = _loc33_ - _loc21_ * (_loc37_.rA.x * _loc26_ - _loc37_.rA.y * _loc28_ + _loc36_.rA.x * _loc39_ - _loc36_.rA.y * _loc38_);
                           _loc51_.x = _loc51_.x + _loc10_ * (_loc28_ + _loc38_);
                           _loc51_.y = _loc51_.y + _loc10_ * (_loc26_ + _loc39_);
                           _loc32_ = _loc32_ + _loc23_ * (_loc37_.rB.x * _loc26_ - _loc37_.rB.y * _loc28_ + _loc36_.rB.x * _loc39_ - _loc36_.rB.y * _loc38_);
                           _loc37_.normalImpulse = _loc9_;
                           _loc36_.normalImpulse = _loc7_;
                        }
                     }
                  }
               }
            }
            _loc57_.m_angularVelocity = _loc33_;
            _loc25_.m_angularVelocity = _loc32_;
            _loc44_++;
         }
      }
      
      public function FinalizeVelocityConstraints() : void
      {
         var _loc6_:int = 0;
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:int = 0;
         var _loc4_:* = null;
         var _loc5_:* = null;
         _loc6_ = 0;
         while(_loc6_ < m_constraintCount)
         {
            _loc1_ = m_constraints[_loc6_];
            _loc2_ = _loc1_.manifold;
            _loc3_ = 0;
            while(_loc3_ < _loc1_.pointCount)
            {
               _loc4_ = _loc2_.m_points[_loc3_];
               _loc5_ = _loc1_.points[_loc3_];
               _loc4_.m_normalImpulse = _loc5_.normalImpulse;
               _loc4_.m_tangentImpulse = _loc5_.tangentImpulse;
               _loc3_++;
            }
            _loc6_++;
         }
      }
      
      public function SolvePositionConstraints(param1:Number) : Boolean
      {
         var _loc10_:int = 0;
         var _loc3_:* = null;
         var _loc22_:* = null;
         var _loc2_:* = null;
         var _loc12_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc6_:* = null;
         var _loc8_:int = 0;
         var _loc7_:* = null;
         var _loc11_:* = null;
         var _loc5_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc15_:* = 0;
         _loc10_ = 0;
         while(_loc10_ < m_constraintCount)
         {
            _loc3_ = m_constraints[_loc10_];
            _loc22_ = _loc3_.bodyA;
            _loc2_ = _loc3_.bodyB;
            _loc12_ = _loc22_.m_mass * _loc22_.m_invMass;
            _loc18_ = _loc22_.m_mass * _loc22_.m_invI;
            _loc13_ = _loc2_.m_mass * _loc2_.m_invMass;
            _loc23_ = _loc2_.m_mass * _loc2_.m_invI;
            s_psm.Initialize(_loc3_);
            _loc6_ = s_psm.m_normal;
            _loc8_ = 0;
            while(_loc8_ < _loc3_.pointCount)
            {
               _loc7_ = _loc3_.points[_loc8_];
               _loc11_ = s_psm.m_points[_loc8_];
               _loc5_ = s_psm.m_separations[_loc8_];
               _loc14_ = _loc11_.x - _loc22_.m_sweep.c.x;
               _loc16_ = _loc11_.y - _loc22_.m_sweep.c.y;
               _loc20_ = _loc11_.x - _loc2_.m_sweep.c.x;
               _loc21_ = _loc11_.y - _loc2_.m_sweep.c.y;
               _loc15_ = Number(_loc15_ < _loc5_?_loc15_:Number(_loc5_));
               _loc4_ = b2Math.Clamp(param1 * (_loc5_ + 0.005),-0.2,0);
               _loc9_ = -_loc7_.equalizedMass * _loc4_;
               _loc17_ = _loc9_ * _loc6_.x;
               _loc19_ = _loc9_ * _loc6_.y;
               _loc22_.m_sweep.c.x = _loc22_.m_sweep.c.x - _loc12_ * _loc17_;
               _loc22_.m_sweep.c.y = _loc22_.m_sweep.c.y - _loc12_ * _loc19_;
               _loc22_.m_sweep.a = _loc22_.m_sweep.a - _loc18_ * (_loc14_ * _loc19_ - _loc16_ * _loc17_);
               _loc22_.SynchronizeTransform();
               _loc2_.m_sweep.c.x = _loc2_.m_sweep.c.x + _loc13_ * _loc17_;
               _loc2_.m_sweep.c.y = _loc2_.m_sweep.c.y + _loc13_ * _loc19_;
               _loc2_.m_sweep.a = _loc2_.m_sweep.a + _loc23_ * (_loc20_ * _loc19_ - _loc21_ * _loc17_);
               _loc2_.SynchronizeTransform();
               _loc8_++;
            }
            _loc10_++;
         }
         return _loc15_ > -1.5 * 0.005;
      }
   }
}
