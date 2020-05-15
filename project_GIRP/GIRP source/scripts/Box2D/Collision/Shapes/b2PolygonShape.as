package Box2D.Collision.Shapes
{
   import Box2D.Collision.b2AABB;
   import Box2D.Collision.b2OBB;
   import Box2D.Collision.b2RayCastInput;
   import Box2D.Collision.b2RayCastOutput;
   import Box2D.Common.Math.b2Mat22;
   import Box2D.Common.Math.b2Math;
   import Box2D.Common.Math.b2Transform;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2Settings;
   import Box2D.Common.b2internal;
   
   use namespace b2internal;
   
   public class b2PolygonShape extends b2Shape
   {
      
      private static var s_mat:b2Mat22 = new b2Mat22();
       
      
      b2internal var m_centroid:b2Vec2;
      
      b2internal var m_vertices:Vector.<b2Vec2>;
      
      b2internal var m_normals:Vector.<b2Vec2>;
      
      b2internal var m_vertexCount:int;
      
      public function b2PolygonShape()
      {
         super();
         m_type = 1;
         m_centroid = new b2Vec2();
         m_vertices = new Vector.<b2Vec2>();
         m_normals = new Vector.<b2Vec2>();
      }
      
      public static function AsArray(param1:Array, param2:Number) : b2PolygonShape
      {
         var _loc3_:b2PolygonShape = new b2PolygonShape();
         _loc3_.SetAsArray(param1,param2);
         return _loc3_;
      }
      
      public static function AsVector(param1:Vector.<b2Vec2>, param2:Number) : b2PolygonShape
      {
         var _loc3_:b2PolygonShape = new b2PolygonShape();
         _loc3_.SetAsVector(param1,param2);
         return _loc3_;
      }
      
      public static function AsBox(param1:Number, param2:Number) : b2PolygonShape
      {
         var _loc3_:b2PolygonShape = new b2PolygonShape();
         _loc3_.SetAsBox(param1,param2);
         return _loc3_;
      }
      
      public static function AsOrientedBox(param1:Number, param2:Number, param3:b2Vec2 = null, param4:Number = 0.0) : b2PolygonShape
      {
         var _loc5_:b2PolygonShape = new b2PolygonShape();
         _loc5_.SetAsOrientedBox(param1,param2,param3,param4);
         return _loc5_;
      }
      
      public static function AsEdge(param1:b2Vec2, param2:b2Vec2) : b2PolygonShape
      {
         var _loc3_:b2PolygonShape = new b2PolygonShape();
         _loc3_.SetAsEdge(param1,param2);
         return _loc3_;
      }
      
      public static function ComputeCentroid(param1:Vector.<b2Vec2>, param2:uint) : b2Vec2
      {
         var _loc12_:int = 0;
         var _loc8_:* = null;
         var _loc6_:* = null;
         var _loc5_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc7_:b2Vec2 = new b2Vec2();
         var _loc14_:* = 0;
         var _loc13_:* = 0;
         var _loc16_:* = 0;
         var _loc10_:* = 0.333333333333333;
         _loc12_ = 0;
         while(_loc12_ < param2)
         {
            _loc8_ = param1[_loc12_];
            _loc6_ = _loc12_ + 1 < param2?param1[int(_loc12_ + 1)]:param1[0];
            _loc5_ = _loc8_.x - _loc13_;
            _loc4_ = _loc8_.y - _loc16_;
            _loc9_ = _loc6_.x - _loc13_;
            _loc11_ = _loc6_.y - _loc16_;
            _loc3_ = _loc5_ * _loc11_ - _loc4_ * _loc9_;
            _loc15_ = 0.5 * _loc3_;
            _loc14_ = Number(_loc14_ + _loc15_);
            _loc7_.x = _loc7_.x + _loc15_ * _loc10_ * (_loc13_ + _loc8_.x + _loc6_.x);
            _loc7_.y = _loc7_.y + _loc15_ * _loc10_ * (_loc16_ + _loc8_.y + _loc6_.y);
            _loc12_++;
         }
         _loc7_.x = _loc7_.x * (1 / _loc14_);
         _loc7_.y = _loc7_.y * (1 / _loc14_);
         return _loc7_;
      }
      
      b2internal static function ComputeOBB(param1:b2OBB, param2:Vector.<b2Vec2>, param3:int) : void
      {
         var _loc21_:int = 0;
         var _loc4_:* = null;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:* = NaN;
         var _loc22_:* = NaN;
         var _loc25_:* = NaN;
         var _loc12_:* = NaN;
         var _loc10_:* = NaN;
         var _loc20_:int = 0;
         var _loc19_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc23_:* = null;
         var _loc24_:Vector.<b2Vec2> = new Vector.<b2Vec2>(param3 + 1);
         _loc21_ = 0;
         while(_loc21_ < param3)
         {
            _loc24_[_loc21_] = param2[_loc21_];
            _loc21_++;
         }
         _loc24_[param3] = _loc24_[0];
         var _loc11_:* = 1.79769313486232e308;
         _loc21_ = 1;
         while(_loc21_ <= param3)
         {
            _loc4_ = _loc24_[int(_loc21_ - 1)];
            _loc16_ = _loc24_[_loc21_].x - _loc4_.x;
            _loc17_ = _loc24_[_loc21_].y - _loc4_.y;
            _loc13_ = Math.sqrt(_loc16_ * _loc16_ + _loc17_ * _loc17_);
            _loc16_ = _loc16_ / _loc13_;
            _loc17_ = _loc17_ / _loc13_;
            _loc5_ = -_loc17_;
            _loc6_ = _loc16_;
            _loc22_ = 1.79769313486232e308;
            _loc25_ = 1.79769313486232e308;
            _loc12_ = -1.79769313486232e308;
            _loc10_ = -1.79769313486232e308;
            _loc20_ = 0;
            while(_loc20_ < param3)
            {
               _loc19_ = _loc24_[_loc20_].x - _loc4_.x;
               _loc18_ = _loc24_[_loc20_].y - _loc4_.y;
               _loc14_ = _loc16_ * _loc19_ + _loc17_ * _loc18_;
               _loc15_ = _loc5_ * _loc19_ + _loc6_ * _loc18_;
               if(_loc14_ < _loc22_)
               {
                  _loc22_ = _loc14_;
               }
               if(_loc15_ < _loc25_)
               {
                  _loc25_ = _loc15_;
               }
               if(_loc14_ > _loc12_)
               {
                  _loc12_ = _loc14_;
               }
               if(_loc15_ > _loc10_)
               {
                  _loc10_ = _loc15_;
               }
               _loc20_++;
            }
            _loc7_ = (_loc12_ - _loc22_) * (_loc10_ - _loc25_);
            if(_loc7_ < 0.95 * _loc11_)
            {
               _loc11_ = _loc7_;
               param1.R.col1.x = _loc16_;
               param1.R.col1.y = _loc17_;
               param1.R.col2.x = _loc5_;
               param1.R.col2.y = _loc6_;
               _loc9_ = 0.5 * (_loc22_ + _loc12_);
               _loc8_ = 0.5 * (_loc25_ + _loc10_);
               _loc23_ = param1.R;
               param1.center.x = _loc4_.x + (_loc23_.col1.x * _loc9_ + _loc23_.col2.x * _loc8_);
               param1.center.y = _loc4_.y + (_loc23_.col1.y * _loc9_ + _loc23_.col2.y * _loc8_);
               param1.extents.x = 0.5 * (_loc12_ - _loc22_);
               param1.extents.y = 0.5 * (_loc10_ - _loc25_);
            }
            _loc21_++;
         }
      }
      
      override public function Copy() : b2Shape
      {
         var _loc1_:b2PolygonShape = new b2PolygonShape();
         _loc1_.Set(this);
         return _loc1_;
      }
      
      override public function Set(param1:b2Shape) : void
      {
         var _loc2_:* = null;
         var _loc3_:int = 0;
         super.Set(param1);
         if(param1 is b2PolygonShape)
         {
            _loc2_ = param1 as b2PolygonShape;
            m_centroid.SetV(_loc2_.m_centroid);
            m_vertexCount = _loc2_.m_vertexCount;
            Reserve(m_vertexCount);
            _loc3_ = 0;
            while(_loc3_ < m_vertexCount)
            {
               m_vertices[_loc3_].SetV(_loc2_.m_vertices[_loc3_]);
               m_normals[_loc3_].SetV(_loc2_.m_normals[_loc3_]);
               _loc3_++;
            }
         }
      }
      
      public function SetAsArray(param1:Array, param2:Number = 0) : void
      {
         var _loc3_:Vector.<b2Vec2> = new Vector.<b2Vec2>();
         var _loc6_:int = 0;
         var _loc5_:* = param1;
         for each(var _loc4_ in param1)
         {
            _loc3_.push(_loc4_);
         }
         SetAsVector(_loc3_,param2);
      }
      
      public function SetAsVector(param1:Vector.<b2Vec2>, param2:Number = 0) : void
      {
         var _loc6_:int = 0;
         var _loc5_:* = 0;
         var _loc4_:int = 0;
         var _loc3_:* = null;
         if(param2 == 0)
         {
            param2 = param1.length;
         }
         b2Settings.b2Assert(2 <= param2);
         m_vertexCount = param2;
         Reserve(param2);
         _loc6_ = 0;
         while(_loc6_ < m_vertexCount)
         {
            m_vertices[_loc6_].SetV(param1[_loc6_]);
            _loc6_++;
         }
         _loc6_ = 0;
         while(_loc6_ < m_vertexCount)
         {
            _loc5_ = _loc6_;
            _loc4_ = _loc6_ + 1 < m_vertexCount?_loc6_ + 1:0;
            _loc3_ = b2Math.SubtractVV(m_vertices[_loc4_],m_vertices[_loc5_]);
            b2Settings.b2Assert(_loc3_.LengthSquared() > Number.MIN_VALUE);
            m_normals[_loc6_].SetV(b2Math.CrossVF(_loc3_,1));
            m_normals[_loc6_].Normalize();
            _loc6_++;
         }
         m_centroid = ComputeCentroid(m_vertices,m_vertexCount);
      }
      
      public function SetAsBox(param1:Number, param2:Number) : void
      {
         m_vertexCount = 4;
         Reserve(4);
         m_vertices[0].Set(-param1,-param2);
         m_vertices[1].Set(param1,-param2);
         m_vertices[2].Set(param1,param2);
         m_vertices[3].Set(-param1,param2);
         m_normals[0].Set(0,-1);
         m_normals[1].Set(1,0);
         m_normals[2].Set(0,1);
         m_normals[3].Set(-1,0);
         m_centroid.SetZero();
      }
      
      public function SetAsOrientedBox(param1:Number, param2:Number, param3:b2Vec2 = null, param4:Number = 0.0) : void
      {
         var _loc6_:int = 0;
         m_vertexCount = 4;
         Reserve(4);
         m_vertices[0].Set(-param1,-param2);
         m_vertices[1].Set(param1,-param2);
         m_vertices[2].Set(param1,param2);
         m_vertices[3].Set(-param1,param2);
         m_normals[0].Set(0,-1);
         m_normals[1].Set(1,0);
         m_normals[2].Set(0,1);
         m_normals[3].Set(-1,0);
         m_centroid = param3;
         var _loc5_:b2Transform = new b2Transform();
         _loc5_.position = param3;
         _loc5_.R.Set(param4);
         _loc6_ = 0;
         while(_loc6_ < m_vertexCount)
         {
            m_vertices[_loc6_] = b2Math.MulX(_loc5_,m_vertices[_loc6_]);
            m_normals[_loc6_] = b2Math.MulMV(_loc5_.R,m_normals[_loc6_]);
            _loc6_++;
         }
      }
      
      public function SetAsEdge(param1:b2Vec2, param2:b2Vec2) : void
      {
         m_vertexCount = 2;
         Reserve(2);
         m_vertices[0].SetV(param1);
         m_vertices[1].SetV(param2);
         m_centroid.x = 0.5 * (param1.x + param2.x);
         m_centroid.y = 0.5 * (param1.y + param2.y);
         m_normals[0] = b2Math.CrossVF(b2Math.SubtractVV(param2,param1),1);
         m_normals[0].Normalize();
         m_normals[1].x = -m_normals[0].x;
         m_normals[1].y = -m_normals[0].y;
      }
      
      override public function TestPoint(param1:b2Transform, param2:b2Vec2) : Boolean
      {
         var _loc8_:* = null;
         var _loc9_:int = 0;
         var _loc6_:Number = NaN;
         var _loc5_:b2Mat22 = param1.R;
         var _loc7_:Number = param2.x - param1.position.x;
         var _loc10_:Number = param2.y - param1.position.y;
         var _loc4_:Number = _loc7_ * _loc5_.col1.x + _loc10_ * _loc5_.col1.y;
         var _loc3_:Number = _loc7_ * _loc5_.col2.x + _loc10_ * _loc5_.col2.y;
         _loc9_ = 0;
         while(_loc9_ < m_vertexCount)
         {
            _loc8_ = m_vertices[_loc9_];
            _loc7_ = _loc4_ - _loc8_.x;
            _loc10_ = _loc3_ - _loc8_.y;
            _loc8_ = m_normals[_loc9_];
            _loc6_ = _loc8_.x * _loc7_ + _loc8_.y * _loc10_;
            if(_loc6_ > 0)
            {
               return false;
            }
            _loc9_++;
         }
         return true;
      }
      
      override public function RayCast(param1:b2RayCastOutput, param2:b2RayCastInput, param3:b2Transform) : Boolean
      {
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc16_:* = null;
         var _loc10_:* = null;
         var _loc11_:int = 0;
         var _loc7_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc5_:* = 0;
         var _loc12_:Number = param2.maxFraction;
         _loc18_ = param2.p1.x - param3.position.x;
         _loc19_ = param2.p1.y - param3.position.y;
         _loc16_ = param3.R;
         var _loc13_:Number = _loc18_ * _loc16_.col1.x + _loc19_ * _loc16_.col1.y;
         var _loc17_:Number = _loc18_ * _loc16_.col2.x + _loc19_ * _loc16_.col2.y;
         _loc18_ = param2.p2.x - param3.position.x;
         _loc19_ = param2.p2.y - param3.position.y;
         _loc16_ = param3.R;
         var _loc15_:Number = _loc18_ * _loc16_.col1.x + _loc19_ * _loc16_.col1.y;
         var _loc14_:Number = _loc18_ * _loc16_.col2.x + _loc19_ * _loc16_.col2.y;
         var _loc9_:Number = _loc15_ - _loc13_;
         var _loc8_:Number = _loc14_ - _loc17_;
         var _loc4_:* = -1;
         _loc11_ = 0;
         while(_loc11_ < m_vertexCount)
         {
            _loc10_ = m_vertices[_loc11_];
            _loc18_ = _loc10_.x - _loc13_;
            _loc19_ = _loc10_.y - _loc17_;
            _loc10_ = m_normals[_loc11_];
            _loc7_ = _loc10_.x * _loc18_ + _loc10_.y * _loc19_;
            _loc6_ = _loc10_.x * _loc9_ + _loc10_.y * _loc8_;
            if(_loc6_ == 0)
            {
               if(_loc7_ < 0)
               {
                  return false;
               }
            }
            else if(_loc6_ < 0 && _loc7_ < _loc5_ * _loc6_)
            {
               _loc5_ = Number(_loc7_ / _loc6_);
               _loc4_ = _loc11_;
            }
            else if(_loc6_ > 0 && _loc7_ < _loc12_ * _loc6_)
            {
               _loc12_ = _loc7_ / _loc6_;
            }
            if(_loc12_ < _loc5_ - Number.MIN_VALUE)
            {
               return false;
            }
            _loc11_++;
         }
         if(_loc4_ >= 0)
         {
            param1.fraction = _loc5_;
            _loc16_ = param3.R;
            _loc10_ = m_normals[_loc4_];
            param1.normal.x = _loc16_.col1.x * _loc10_.x + _loc16_.col2.x * _loc10_.y;
            param1.normal.y = _loc16_.col1.y * _loc10_.x + _loc16_.col2.y * _loc10_.y;
            return true;
         }
         return false;
      }
      
      override public function ComputeAABB(param1:b2AABB, param2:b2Transform) : void
      {
         var _loc11_:int = 0;
         var _loc4_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc7_:b2Mat22 = param2.R;
         var _loc10_:b2Vec2 = m_vertices[0];
         var _loc5_:Number = param2.position.x + (_loc7_.col1.x * _loc10_.x + _loc7_.col2.x * _loc10_.y);
         var _loc9_:Number = param2.position.y + (_loc7_.col1.y * _loc10_.x + _loc7_.col2.y * _loc10_.y);
         var _loc8_:* = _loc5_;
         var _loc6_:* = _loc9_;
         _loc11_ = 1;
         while(_loc11_ < m_vertexCount)
         {
            _loc10_ = m_vertices[_loc11_];
            _loc4_ = param2.position.x + (_loc7_.col1.x * _loc10_.x + _loc7_.col2.x * _loc10_.y);
            _loc3_ = param2.position.y + (_loc7_.col1.y * _loc10_.x + _loc7_.col2.y * _loc10_.y);
            _loc5_ = _loc5_ < _loc4_?_loc5_:Number(_loc4_);
            _loc9_ = _loc9_ < _loc3_?_loc9_:Number(_loc3_);
            _loc8_ = Number(_loc8_ > _loc4_?_loc8_:Number(_loc4_));
            _loc6_ = Number(_loc6_ > _loc3_?_loc6_:Number(_loc3_));
            _loc11_++;
         }
         param1.lowerBound.x = _loc5_ - m_radius;
         param1.lowerBound.y = _loc9_ - m_radius;
         param1.upperBound.x = _loc8_ + m_radius;
         param1.upperBound.y = _loc6_ + m_radius;
      }
      
      override public function ComputeMass(param1:b2MassData, param2:Number) : void
      {
         var _loc23_:int = 0;
         var _loc5_:* = null;
         var _loc4_:* = null;
         var _loc19_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc24_:* = NaN;
         var _loc25_:* = NaN;
         var _loc8_:* = NaN;
         var _loc21_:* = NaN;
         var _loc6_:* = NaN;
         var _loc22_:* = NaN;
         var _loc20_:Number = NaN;
         var _loc17_:Number = NaN;
         if(m_vertexCount == 2)
         {
            param1.center.x = 0.5 * (m_vertices[0].x + m_vertices[1].x);
            param1.center.y = 0.5 * (m_vertices[0].y + m_vertices[1].y);
            param1.mass = 0;
            param1.I = 0;
            return;
         }
         var _loc14_:* = 0;
         var _loc13_:* = 0;
         var _loc12_:* = 0;
         var _loc9_:* = 0;
         var _loc11_:* = 0;
         var _loc16_:* = 0;
         var _loc26_:* = 0.333333333333333;
         _loc23_ = 0;
         while(_loc23_ < m_vertexCount)
         {
            _loc5_ = m_vertices[_loc23_];
            _loc4_ = _loc23_ + 1 < m_vertexCount?m_vertices[int(_loc23_ + 1)]:m_vertices[0];
            _loc19_ = _loc5_.x - _loc11_;
            _loc18_ = _loc5_.y - _loc16_;
            _loc7_ = _loc4_.x - _loc11_;
            _loc10_ = _loc4_.y - _loc16_;
            _loc3_ = _loc19_ * _loc10_ - _loc18_ * _loc7_;
            _loc15_ = 0.5 * _loc3_;
            _loc12_ = Number(_loc12_ + _loc15_);
            _loc14_ = Number(_loc14_ + _loc15_ * _loc26_ * (_loc11_ + _loc5_.x + _loc4_.x));
            _loc13_ = Number(_loc13_ + _loc15_ * _loc26_ * (_loc16_ + _loc5_.y + _loc4_.y));
            _loc24_ = _loc11_;
            _loc25_ = _loc16_;
            _loc8_ = _loc19_;
            _loc21_ = _loc18_;
            _loc6_ = _loc7_;
            _loc22_ = _loc10_;
            _loc20_ = _loc26_ * (0.25 * (_loc8_ * _loc8_ + _loc6_ * _loc8_ + _loc6_ * _loc6_) + (_loc24_ * _loc8_ + _loc24_ * _loc6_)) + 0.5 * _loc24_ * _loc24_;
            _loc17_ = _loc26_ * (0.25 * (_loc21_ * _loc21_ + _loc22_ * _loc21_ + _loc22_ * _loc22_) + (_loc25_ * _loc21_ + _loc25_ * _loc22_)) + 0.5 * _loc25_ * _loc25_;
            _loc9_ = Number(_loc9_ + _loc3_ * (_loc20_ + _loc17_));
            _loc23_++;
         }
         param1.mass = param2 * _loc12_;
         _loc14_ = Number(_loc14_ * (1 / _loc12_));
         _loc13_ = Number(_loc13_ * (1 / _loc12_));
         param1.center.Set(_loc14_,_loc13_);
         param1.I = param2 * _loc9_;
      }
      
      override public function ComputeSubmergedArea(param1:b2Vec2, param2:Number, param3:b2Transform, param4:b2Vec2) : Number
      {
         var _loc22_:int = 0;
         var _loc14_:* = false;
         var _loc12_:* = null;
         var _loc5_:* = null;
         var _loc13_:Number = NaN;
         var _loc15_:b2Vec2 = b2Math.MulTMV(param3.R,param1);
         var _loc25_:Number = param2 - b2Math.Dot(param1,param3.position);
         var _loc17_:Vector.<Number> = new Vector.<Number>();
         var _loc11_:int = 0;
         var _loc21_:int = -1;
         var _loc19_:int = -1;
         var _loc24_:* = false;
         _loc22_ = 0;
         while(_loc22_ < m_vertexCount)
         {
            _loc17_[_loc22_] = b2Math.Dot(_loc15_,m_vertices[_loc22_]) - _loc25_;
            _loc14_ = _loc17_[_loc22_] < -Number.MIN_VALUE;
            if(_loc22_ > 0)
            {
               if(_loc14_)
               {
                  if(!_loc24_)
                  {
                     _loc21_ = _loc22_ - 1;
                     _loc11_++;
                  }
               }
               else if(_loc24_)
               {
                  _loc19_ = _loc22_ - 1;
                  _loc11_++;
               }
            }
            _loc24_ = _loc14_;
            _loc22_++;
         }
         switch(int(_loc11_))
         {
            case 0:
               if(_loc24_)
               {
                  _loc12_ = new b2MassData();
                  ComputeMass(_loc12_,1);
                  param4.SetV(b2Math.MulX(param3,_loc12_.center));
                  return _loc12_.mass;
               }
               return 0;
            case 1:
               if(_loc21_ == -1)
               {
                  _loc21_ = m_vertexCount - 1;
               }
               else
               {
                  _loc19_ = m_vertexCount - 1;
               }
         }
      }
      
      public function GetVertexCount() : int
      {
         return m_vertexCount;
      }
      
      public function GetVertices() : Vector.<b2Vec2>
      {
         return m_vertices;
      }
      
      public function GetNormals() : Vector.<b2Vec2>
      {
         return m_normals;
      }
      
      public function GetSupport(param1:b2Vec2) : int
      {
         var _loc5_:int = 0;
         var _loc4_:Number = NaN;
         var _loc3_:* = 0;
         var _loc2_:* = Number(m_vertices[0].x * param1.x + m_vertices[0].y * param1.y);
         _loc5_ = 1;
         while(_loc5_ < m_vertexCount)
         {
            _loc4_ = m_vertices[_loc5_].x * param1.x + m_vertices[_loc5_].y * param1.y;
            if(_loc4_ > _loc2_)
            {
               _loc3_ = _loc5_;
               _loc2_ = _loc4_;
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function GetSupportVertex(param1:b2Vec2) : b2Vec2
      {
         var _loc5_:int = 0;
         var _loc4_:Number = NaN;
         var _loc3_:* = 0;
         var _loc2_:* = Number(m_vertices[0].x * param1.x + m_vertices[0].y * param1.y);
         _loc5_ = 1;
         while(_loc5_ < m_vertexCount)
         {
            _loc4_ = m_vertices[_loc5_].x * param1.x + m_vertices[_loc5_].y * param1.y;
            if(_loc4_ > _loc2_)
            {
               _loc3_ = _loc5_;
               _loc2_ = _loc4_;
            }
            _loc5_++;
         }
         return m_vertices[_loc3_];
      }
      
      private function Validate() : Boolean
      {
         return false;
      }
      
      private function Reserve(param1:int) : void
      {
         var _loc2_:int = 0;
         _loc2_ = m_vertices.length;
         while(_loc2_ < param1)
         {
            m_vertices[_loc2_] = new b2Vec2();
            m_normals[_loc2_] = new b2Vec2();
            _loc2_++;
         }
      }
   }
}
