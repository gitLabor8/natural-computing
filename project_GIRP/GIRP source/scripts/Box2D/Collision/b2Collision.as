package Box2D.Collision
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2internal;
   
   use namespace b2internal;
   
   public class b2Collision
   {
      
      public static const b2_nullFeature:uint = 255;
      
      private static var s_incidentEdge:Vector.<ClipVertex> = MakeClipPointVector();
      
      private static var s_clipPoints1:Vector.<ClipVertex> = MakeClipPointVector();
      
      private static var s_clipPoints2:Vector.<ClipVertex> = MakeClipPointVector();
      
      private static var s_edgeAO:Vector.<int> = new Vector.<int>(1);
      
      private static var s_edgeBO:Vector.<int> = new Vector.<int>(1);
      
      private static var s_localTangent:b2Vec2 = new b2Vec2();
      
      private static var s_localNormal:b2Vec2 = new b2Vec2();
      
      private static var s_planePoint:b2Vec2 = new b2Vec2();
      
      private static var s_normal:b2Vec2 = new b2Vec2();
      
      private static var s_tangent:b2Vec2 = new b2Vec2();
      
      private static var s_tangent2:b2Vec2 = new b2Vec2();
      
      private static var s_v11:b2Vec2 = new b2Vec2();
      
      private static var s_v12:b2Vec2 = new b2Vec2();
      
      private static var b2CollidePolyTempVec:b2Vec2 = new b2Vec2();
       
      
      public function b2Collision()
      {
         super();
      }
      
      public static function ClipSegmentToLine(param1:Vector.<ClipVertex>, param2:Vector.<ClipVertex>, param3:b2Vec2, param4:Number) : int
      {
         var _loc6_:* = null;
         var _loc13_:Number = NaN;
         var _loc7_:* = null;
         var _loc5_:* = null;
         var _loc10_:int = 0;
         _loc6_ = param2[0];
         var _loc11_:b2Vec2 = _loc6_.v;
         _loc6_ = param2[1];
         var _loc12_:b2Vec2 = _loc6_.v;
         var _loc9_:Number = param3.x * _loc11_.x + param3.y * _loc11_.y - param4;
         var _loc8_:Number = param3.x * _loc12_.x + param3.y * _loc12_.y - param4;
         if(_loc9_ <= 0)
         {
            _loc10_++;
            param1[_loc10_].Set(param2[0]);
         }
         if(_loc8_ <= 0)
         {
            _loc10_++;
            param1[_loc10_].Set(param2[1]);
         }
         if(_loc9_ * _loc8_ < 0)
         {
            _loc13_ = _loc9_ / (_loc9_ - _loc8_);
            _loc6_ = param1[_loc10_];
            _loc7_ = _loc6_.v;
            _loc7_.x = _loc11_.x + _loc13_ * (_loc12_.x - _loc11_.x);
            _loc7_.y = _loc11_.y + _loc13_ * (_loc12_.y - _loc11_.y);
            _loc6_ = param1[_loc10_];
            if(_loc9_ > 0)
            {
               _loc5_ = param2[0];
               _loc6_.id = _loc5_.id;
            }
            else
            {
               _loc5_ = param2[1];
               _loc6_.id = _loc5_.id;
            }
            _loc10_++;
         }
         return _loc10_;
      }
      
      public static function EdgeSeparation(param1:b2PolygonShape, param2:b2Transform, param3:int, param4:b2PolygonShape, param5:b2Transform) : Number
      {
         var _loc22_:* = null;
         var _loc18_:* = null;
         var _loc19_:int = 0;
         var _loc10_:Number = NaN;
         var _loc24_:int = param1.m_vertexCount;
         var _loc7_:Vector.<b2Vec2> = param1.m_vertices;
         var _loc25_:Vector.<b2Vec2> = param1.m_normals;
         var _loc23_:int = param4.m_vertexCount;
         var _loc6_:Vector.<b2Vec2> = param4.m_vertices;
         _loc22_ = param2.R;
         _loc18_ = _loc25_[param3];
         var _loc15_:Number = _loc22_.col1.x * _loc18_.x + _loc22_.col2.x * _loc18_.y;
         var _loc13_:Number = _loc22_.col1.y * _loc18_.x + _loc22_.col2.y * _loc18_.y;
         _loc22_ = param5.R;
         var _loc8_:Number = _loc22_.col1.x * _loc15_ + _loc22_.col1.y * _loc13_;
         var _loc9_:Number = _loc22_.col2.x * _loc15_ + _loc22_.col2.y * _loc13_;
         var _loc14_:* = 0;
         var _loc17_:* = 1.79769313486232e308;
         _loc19_ = 0;
         while(_loc19_ < _loc23_)
         {
            _loc18_ = _loc6_[_loc19_];
            _loc10_ = _loc18_.x * _loc8_ + _loc18_.y * _loc9_;
            if(_loc10_ < _loc17_)
            {
               _loc17_ = _loc10_;
               _loc14_ = _loc19_;
            }
            _loc19_++;
         }
         _loc18_ = _loc7_[param3];
         _loc22_ = param2.R;
         var _loc20_:Number = param2.position.x + (_loc22_.col1.x * _loc18_.x + _loc22_.col2.x * _loc18_.y);
         var _loc21_:Number = param2.position.y + (_loc22_.col1.y * _loc18_.x + _loc22_.col2.y * _loc18_.y);
         _loc18_ = _loc6_[_loc14_];
         _loc22_ = param5.R;
         var _loc11_:Number = param5.position.x + (_loc22_.col1.x * _loc18_.x + _loc22_.col2.x * _loc18_.y);
         var _loc12_:Number = param5.position.y + (_loc22_.col1.y * _loc18_.x + _loc22_.col2.y * _loc18_.y);
         _loc11_ = _loc11_ - _loc20_;
         _loc12_ = _loc12_ - _loc21_;
         var _loc16_:Number = _loc11_ * _loc15_ + _loc12_ * _loc13_;
         return _loc16_;
      }
      
      public static function FindMaxSeparation(param1:Vector.<int>, param2:b2PolygonShape, param3:b2Transform, param4:b2PolygonShape, param5:b2Transform) : Number
      {
         var _loc17_:* = null;
         var _loc22_:* = null;
         var _loc19_:int = 0;
         var _loc9_:Number = NaN;
         var _loc8_:* = 0;
         var _loc12_:* = NaN;
         var _loc11_:int = 0;
         var _loc23_:int = param2.m_vertexCount;
         var _loc24_:Vector.<b2Vec2> = param2.m_normals;
         _loc22_ = param5.R;
         _loc17_ = param4.m_centroid;
         var _loc16_:Number = param5.position.x + (_loc22_.col1.x * _loc17_.x + _loc22_.col2.x * _loc17_.y);
         var _loc15_:Number = param5.position.y + (_loc22_.col1.y * _loc17_.x + _loc22_.col2.y * _loc17_.y);
         _loc22_ = param3.R;
         _loc17_ = param2.m_centroid;
         _loc16_ = _loc16_ - (param3.position.x + (_loc22_.col1.x * _loc17_.x + _loc22_.col2.x * _loc17_.y));
         _loc15_ = _loc15_ - (param3.position.y + (_loc22_.col1.y * _loc17_.x + _loc22_.col2.y * _loc17_.y));
         var _loc7_:Number = _loc16_ * param3.R.col1.x + _loc15_ * param3.R.col1.y;
         var _loc6_:Number = _loc16_ * param3.R.col2.x + _loc15_ * param3.R.col2.y;
         var _loc13_:* = 0;
         var _loc18_:* = -1.79769313486232e308;
         _loc19_ = 0;
         while(_loc19_ < _loc23_)
         {
            _loc17_ = _loc24_[_loc19_];
            _loc9_ = _loc17_.x * _loc7_ + _loc17_.y * _loc6_;
            if(_loc9_ > _loc18_)
            {
               _loc18_ = _loc9_;
               _loc13_ = _loc19_;
            }
            _loc19_++;
         }
         var _loc20_:Number = EdgeSeparation(param2,param3,_loc13_,param4,param5);
         var _loc10_:int = _loc13_ - 1 >= 0?_loc13_ - 1:Number(_loc23_ - 1);
         var _loc14_:Number = EdgeSeparation(param2,param3,_loc10_,param4,param5);
         var _loc25_:int = _loc13_ + 1 < _loc23_?_loc13_ + 1:0;
         var _loc21_:Number = EdgeSeparation(param2,param3,_loc25_,param4,param5);
         if(_loc14_ > _loc20_ && _loc14_ > _loc21_)
         {
            _loc11_ = -1;
            _loc8_ = _loc10_;
            _loc12_ = _loc14_;
         }
         else if(_loc21_ > _loc20_)
         {
            _loc11_ = 1;
            _loc8_ = _loc25_;
            _loc12_ = _loc21_;
         }
         else
         {
            param1[0] = _loc13_;
            return _loc20_;
         }
         while(true)
         {
            if(_loc11_ == -1)
            {
               _loc13_ = int(_loc8_ - 1 >= 0?_loc8_ - 1:Number(_loc23_ - 1));
            }
            else
            {
               _loc13_ = int(_loc8_ + 1 < _loc23_?_loc8_ + 1:0);
            }
            _loc20_ = EdgeSeparation(param2,param3,_loc13_,param4,param5);
            if(_loc20_ > _loc12_)
            {
               _loc8_ = _loc13_;
               _loc12_ = _loc20_;
               continue;
            }
            break;
         }
         param1[0] = _loc8_;
         return _loc12_;
      }
      
      public static function FindIncidentEdge(param1:Vector.<ClipVertex>, param2:b2PolygonShape, param3:b2Transform, param4:int, param5:b2PolygonShape, param6:b2Transform) : void
      {
         var _loc16_:* = null;
         var _loc13_:* = null;
         var _loc14_:int = 0;
         var _loc12_:Number = NaN;
         var _loc15_:* = null;
         var _loc18_:int = param2.m_vertexCount;
         var _loc23_:Vector.<b2Vec2> = param2.m_normals;
         var _loc17_:int = param5.m_vertexCount;
         var _loc8_:Vector.<b2Vec2> = param5.m_vertices;
         var _loc19_:Vector.<b2Vec2> = param5.m_normals;
         _loc16_ = param3.R;
         _loc13_ = _loc23_[param4];
         var _loc9_:* = Number(_loc16_.col1.x * _loc13_.x + _loc16_.col2.x * _loc13_.y);
         var _loc10_:Number = _loc16_.col1.y * _loc13_.x + _loc16_.col2.y * _loc13_.y;
         _loc16_ = param6.R;
         var _loc21_:Number = _loc16_.col1.x * _loc9_ + _loc16_.col1.y * _loc10_;
         _loc10_ = _loc16_.col2.x * _loc9_ + _loc16_.col2.y * _loc10_;
         _loc9_ = _loc21_;
         var _loc7_:* = 0;
         var _loc11_:* = 1.79769313486232e308;
         _loc14_ = 0;
         while(_loc14_ < _loc17_)
         {
            _loc13_ = _loc19_[_loc14_];
            _loc12_ = _loc9_ * _loc13_.x + _loc10_ * _loc13_.y;
            if(_loc12_ < _loc11_)
            {
               _loc11_ = _loc12_;
               _loc7_ = _loc14_;
            }
            _loc14_++;
         }
         var _loc22_:* = _loc7_;
         var _loc20_:int = _loc22_ + 1 < _loc17_?_loc22_ + 1:0;
         _loc15_ = param1[0];
         _loc13_ = _loc8_[_loc22_];
         _loc16_ = param6.R;
         _loc15_.v.x = param6.position.x + (_loc16_.col1.x * _loc13_.x + _loc16_.col2.x * _loc13_.y);
         _loc15_.v.y = param6.position.y + (_loc16_.col1.y * _loc13_.x + _loc16_.col2.y * _loc13_.y);
         _loc15_.id.features.referenceEdge = param4;
         _loc15_.id.features.incidentEdge = _loc22_;
         _loc15_.id.features.incidentVertex = 0;
         _loc15_ = param1[1];
         _loc13_ = _loc8_[_loc20_];
         _loc16_ = param6.R;
         _loc15_.v.x = param6.position.x + (_loc16_.col1.x * _loc13_.x + _loc16_.col2.x * _loc13_.y);
         _loc15_.v.y = param6.position.y + (_loc16_.col1.y * _loc13_.x + _loc16_.col2.y * _loc13_.y);
         _loc15_.id.features.referenceEdge = param4;
         _loc15_.id.features.incidentEdge = _loc20_;
         _loc15_.id.features.incidentVertex = 1;
      }
      
      private static function MakeClipPointVector() : Vector.<ClipVertex>
      {
         var _loc1_:Vector.<ClipVertex> = new Vector.<ClipVertex>(2);
         _loc1_[0] = new ClipVertex();
         _loc1_[1] = new ClipVertex();
         return _loc1_;
      }
      
      public static function CollidePolygons(param1:b2Manifold, param2:b2PolygonShape, param3:b2Transform, param4:b2PolygonShape, param5:b2Transform) : void
      {
         var _loc36_:* = null;
         var _loc33_:* = null;
         var _loc34_:* = null;
         var _loc38_:* = null;
         var _loc43_:* = null;
         var _loc14_:* = 0;
         var _loc25_:* = 0;
         var _loc10_:* = NaN;
         _loc10_ = 0.98;
         var _loc12_:* = NaN;
         _loc12_ = 0.001;
         var _loc41_:* = null;
         var _loc16_:* = null;
         var _loc7_:int = 0;
         var _loc37_:int = 0;
         var _loc32_:Number = NaN;
         var _loc39_:* = null;
         var _loc22_:Number = NaN;
         var _loc26_:Number = NaN;
         param1.m_pointCount = 0;
         var _loc15_:Number = param2.m_radius + param4.m_radius;
         var _loc28_:int = 0;
         s_edgeAO[0] = _loc28_;
         var _loc17_:Number = FindMaxSeparation(s_edgeAO,param2,param3,param4,param5);
         _loc28_ = s_edgeAO[0];
         if(_loc17_ > _loc15_)
         {
            return;
         }
         var _loc27_:int = 0;
         s_edgeBO[0] = _loc27_;
         var _loc13_:Number = FindMaxSeparation(s_edgeBO,param4,param5,param2,param3);
         _loc27_ = s_edgeBO[0];
         if(_loc13_ > _loc15_)
         {
            return;
         }
         if(_loc13_ > 0.98 * _loc17_ + 0.001)
         {
            _loc33_ = param4;
            _loc34_ = param2;
            _loc38_ = param5;
            _loc43_ = param3;
            _loc14_ = _loc27_;
            param1.m_type = 4;
            _loc25_ = uint(1);
         }
         else
         {
            _loc33_ = param2;
            _loc34_ = param4;
            _loc38_ = param3;
            _loc43_ = param5;
            _loc14_ = _loc28_;
            param1.m_type = 2;
            _loc25_ = uint(0);
         }
         var _loc29_:Vector.<ClipVertex> = s_incidentEdge;
         FindIncidentEdge(_loc29_,_loc33_,_loc38_,_loc14_,_loc34_,_loc43_);
         var _loc44_:int = _loc33_.m_vertexCount;
         var _loc8_:Vector.<b2Vec2> = _loc33_.m_vertices;
         var _loc18_:b2Vec2 = _loc8_[_loc14_];
         if(_loc14_ + 1 < _loc44_)
         {
            _loc16_ = _loc8_[int(_loc14_ + 1)];
         }
         else
         {
            _loc16_ = _loc8_[0];
         }
         var _loc11_:b2Vec2 = s_localTangent;
         _loc11_.Set(_loc16_.x - _loc18_.x,_loc16_.y - _loc18_.y);
         _loc11_.Normalize();
         var _loc21_:b2Vec2 = s_localNormal;
         _loc21_.x = _loc11_.y;
         _loc21_.y = -_loc11_.x;
         var _loc35_:b2Vec2 = s_planePoint;
         _loc35_.Set(0.5 * (_loc18_.x + _loc16_.x),0.5 * (_loc18_.y + _loc16_.y));
         var _loc42_:b2Vec2 = s_tangent;
         _loc41_ = _loc38_.R;
         _loc42_.x = _loc41_.col1.x * _loc11_.x + _loc41_.col2.x * _loc11_.y;
         _loc42_.y = _loc41_.col1.y * _loc11_.x + _loc41_.col2.y * _loc11_.y;
         var _loc6_:b2Vec2 = s_tangent2;
         _loc6_.x = -_loc42_.x;
         _loc6_.y = -_loc42_.y;
         var _loc9_:b2Vec2 = s_normal;
         _loc9_.x = _loc42_.y;
         _loc9_.y = -_loc42_.x;
         var _loc19_:b2Vec2 = s_v11;
         var _loc20_:b2Vec2 = s_v12;
         _loc19_.x = _loc38_.position.x + (_loc41_.col1.x * _loc18_.x + _loc41_.col2.x * _loc18_.y);
         _loc19_.y = _loc38_.position.y + (_loc41_.col1.y * _loc18_.x + _loc41_.col2.y * _loc18_.y);
         _loc20_.x = _loc38_.position.x + (_loc41_.col1.x * _loc16_.x + _loc41_.col2.x * _loc16_.y);
         _loc20_.y = _loc38_.position.y + (_loc41_.col1.y * _loc16_.x + _loc41_.col2.y * _loc16_.y);
         var _loc24_:Number = _loc9_.x * _loc19_.x + _loc9_.y * _loc19_.y;
         var _loc40_:Number = -_loc42_.x * _loc19_.x - _loc42_.y * _loc19_.y + _loc15_;
         var _loc45_:Number = _loc42_.x * _loc20_.x + _loc42_.y * _loc20_.y + _loc15_;
         var _loc30_:Vector.<ClipVertex> = s_clipPoints1;
         var _loc31_:Vector.<ClipVertex> = s_clipPoints2;
         _loc7_ = ClipSegmentToLine(_loc30_,_loc29_,_loc6_,_loc40_);
         if(_loc7_ < 2)
         {
            return;
         }
         _loc7_ = ClipSegmentToLine(_loc31_,_loc30_,_loc42_,_loc45_);
         if(_loc7_ < 2)
         {
            return;
         }
         param1.m_localPlaneNormal.SetV(_loc21_);
         param1.m_localPoint.SetV(_loc35_);
         var _loc23_:int = 0;
         _loc37_ = 0;
         while(_loc37_ < 2)
         {
            _loc36_ = _loc31_[_loc37_];
            _loc32_ = _loc9_.x * _loc36_.v.x + _loc9_.y * _loc36_.v.y - _loc24_;
            if(_loc32_ <= _loc15_)
            {
               _loc39_ = param1.m_points[_loc23_];
               _loc41_ = _loc43_.R;
               _loc22_ = _loc36_.v.x - _loc43_.position.x;
               _loc26_ = _loc36_.v.y - _loc43_.position.y;
               _loc39_.m_localPoint.x = _loc22_ * _loc41_.col1.x + _loc26_ * _loc41_.col1.y;
               _loc39_.m_localPoint.y = _loc22_ * _loc41_.col2.x + _loc26_ * _loc41_.col2.y;
               _loc39_.m_id.Set(_loc36_.id);
               _loc39_.m_id.features.flip = _loc25_;
               _loc23_++;
            }
            _loc37_++;
         }
         param1.m_pointCount = _loc23_;
      }
      
      public static function CollideCircles(param1:b2Manifold, param2:b2CircleShape, param3:b2Transform, param4:b2CircleShape, param5:b2Transform) : void
      {
         var _loc12_:* = null;
         var _loc8_:* = null;
         param1.m_pointCount = 0;
         _loc12_ = param3.R;
         _loc8_ = param2.m_p;
         var _loc9_:Number = param3.position.x + (_loc12_.col1.x * _loc8_.x + _loc12_.col2.x * _loc8_.y);
         var _loc15_:Number = param3.position.y + (_loc12_.col1.y * _loc8_.x + _loc12_.col2.y * _loc8_.y);
         _loc12_ = param5.R;
         _loc8_ = param4.m_p;
         var _loc11_:Number = param5.position.x + (_loc12_.col1.x * _loc8_.x + _loc12_.col2.x * _loc8_.y);
         var _loc10_:Number = param5.position.y + (_loc12_.col1.y * _loc8_.x + _loc12_.col2.y * _loc8_.y);
         var _loc7_:Number = _loc11_ - _loc9_;
         var _loc6_:Number = _loc10_ - _loc15_;
         var _loc13_:Number = _loc7_ * _loc7_ + _loc6_ * _loc6_;
         var _loc14_:Number = param2.m_radius + param4.m_radius;
         if(_loc13_ > _loc14_ * _loc14_)
         {
            return;
         }
         param1.m_type = 1;
         param1.m_localPoint.SetV(param2.m_p);
         param1.m_localPlaneNormal.SetZero();
         param1.m_pointCount = 1;
         param1.m_points[0].m_localPoint.SetV(param4.m_p);
         param1.m_points[0].m_id.key = 0;
      }
      
      public static function CollidePolygonAndCircle(param1:b2Manifold, param2:b2PolygonShape, param3:b2Transform, param4:b2CircleShape, param5:b2Transform) : void
      {
         var _loc12_:* = null;
         var _loc18_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc21_:* = null;
         var _loc26_:* = null;
         var _loc33_:Number = NaN;
         var _loc22_:int = 0;
         var _loc25_:Number = NaN;
         var _loc30_:Number = NaN;
         var _loc28_:Number = NaN;
         param1.m_pointCount = 0;
         _loc26_ = param5.R;
         _loc21_ = param4.m_p;
         var _loc9_:Number = param5.position.x + (_loc26_.col1.x * _loc21_.x + _loc26_.col2.x * _loc21_.y);
         var _loc11_:Number = param5.position.y + (_loc26_.col1.y * _loc21_.x + _loc26_.col2.y * _loc21_.y);
         _loc18_ = _loc9_ - param3.position.x;
         _loc17_ = _loc11_ - param3.position.y;
         _loc26_ = param3.R;
         var _loc32_:Number = _loc18_ * _loc26_.col1.x + _loc17_ * _loc26_.col1.y;
         var _loc31_:Number = _loc18_ * _loc26_.col2.x + _loc17_ * _loc26_.col2.y;
         var _loc27_:* = 0;
         var _loc16_:* = -1.79769313486232e308;
         var _loc29_:Number = param2.m_radius + param4.m_radius;
         var _loc23_:int = param2.m_vertexCount;
         var _loc8_:Vector.<b2Vec2> = param2.m_vertices;
         var _loc24_:Vector.<b2Vec2> = param2.m_normals;
         _loc22_ = 0;
         while(_loc22_ < _loc23_)
         {
            _loc21_ = _loc8_[_loc22_];
            _loc18_ = _loc32_ - _loc21_.x;
            _loc17_ = _loc31_ - _loc21_.y;
            _loc21_ = _loc24_[_loc22_];
            _loc25_ = _loc21_.x * _loc18_ + _loc21_.y * _loc17_;
            if(_loc25_ > _loc29_)
            {
               return;
            }
            if(_loc25_ > _loc16_)
            {
               _loc16_ = _loc25_;
               _loc27_ = _loc22_;
            }
            _loc22_++;
         }
         var _loc19_:* = _loc27_;
         var _loc20_:int = _loc19_ + 1 < _loc23_?_loc19_ + 1:0;
         var _loc6_:b2Vec2 = _loc8_[_loc19_];
         var _loc7_:b2Vec2 = _loc8_[_loc20_];
         if(_loc16_ < Number.MIN_VALUE)
         {
            param1.m_pointCount = 1;
            param1.m_type = 2;
            param1.m_localPlaneNormal.SetV(_loc24_[_loc27_]);
            param1.m_localPoint.x = 0.5 * (_loc6_.x + _loc7_.x);
            param1.m_localPoint.y = 0.5 * (_loc6_.y + _loc7_.y);
            param1.m_points[0].m_localPoint.SetV(param4.m_p);
            param1.m_points[0].m_id.key = 0;
            return;
         }
         var _loc15_:Number = (_loc32_ - _loc6_.x) * (_loc7_.x - _loc6_.x) + (_loc31_ - _loc6_.y) * (_loc7_.y - _loc6_.y);
         var _loc14_:Number = (_loc32_ - _loc7_.x) * (_loc6_.x - _loc7_.x) + (_loc31_ - _loc7_.y) * (_loc6_.y - _loc7_.y);
         if(_loc15_ <= 0)
         {
            if((_loc32_ - _loc6_.x) * (_loc32_ - _loc6_.x) + (_loc31_ - _loc6_.y) * (_loc31_ - _loc6_.y) > _loc29_ * _loc29_)
            {
               return;
            }
            param1.m_pointCount = 1;
            param1.m_type = 2;
            param1.m_localPlaneNormal.x = _loc32_ - _loc6_.x;
            param1.m_localPlaneNormal.y = _loc31_ - _loc6_.y;
            param1.m_localPlaneNormal.Normalize();
            param1.m_localPoint.SetV(_loc6_);
            param1.m_points[0].m_localPoint.SetV(param4.m_p);
            param1.m_points[0].m_id.key = 0;
         }
         else if(_loc14_ <= 0)
         {
            if((_loc32_ - _loc7_.x) * (_loc32_ - _loc7_.x) + (_loc31_ - _loc7_.y) * (_loc31_ - _loc7_.y) > _loc29_ * _loc29_)
            {
               return;
            }
            param1.m_pointCount = 1;
            param1.m_type = 2;
            param1.m_localPlaneNormal.x = _loc32_ - _loc7_.x;
            param1.m_localPlaneNormal.y = _loc31_ - _loc7_.y;
            param1.m_localPlaneNormal.Normalize();
            param1.m_localPoint.SetV(_loc7_);
            param1.m_points[0].m_localPoint.SetV(param4.m_p);
            param1.m_points[0].m_id.key = 0;
         }
         else
         {
            _loc30_ = 0.5 * (_loc6_.x + _loc7_.x);
            _loc28_ = 0.5 * (_loc6_.y + _loc7_.y);
            _loc16_ = Number((_loc32_ - _loc30_) * _loc24_[_loc19_].x + (_loc31_ - _loc28_) * _loc24_[_loc19_].y);
            if(_loc16_ > _loc29_)
            {
               return;
            }
            param1.m_pointCount = 1;
            param1.m_type = 2;
            param1.m_localPlaneNormal.x = _loc24_[_loc19_].x;
            param1.m_localPlaneNormal.y = _loc24_[_loc19_].y;
            param1.m_localPlaneNormal.Normalize();
            param1.m_localPoint.Set(_loc30_,_loc28_);
            param1.m_points[0].m_localPoint.SetV(param4.m_p);
            param1.m_points[0].m_id.key = 0;
         }
      }
      
      public static function TestOverlap(param1:b2AABB, param2:b2AABB) : Boolean
      {
         var _loc4_:b2Vec2 = param2.lowerBound;
         var _loc3_:b2Vec2 = param1.upperBound;
         var _loc8_:Number = _loc4_.x - _loc3_.x;
         var _loc7_:Number = _loc4_.y - _loc3_.y;
         _loc4_ = param1.lowerBound;
         _loc3_ = param2.upperBound;
         var _loc6_:Number = _loc4_.x - _loc3_.x;
         var _loc5_:Number = _loc4_.y - _loc3_.y;
         if(_loc8_ > 0 || _loc7_ > 0)
         {
            return false;
         }
         if(_loc6_ > 0 || _loc5_ > 0)
         {
            return false;
         }
         return true;
      }
   }
}
