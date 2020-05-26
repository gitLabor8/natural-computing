package Box2D.Collision
{
   import Box2D.Collision.Shapes.b2CircleShape;
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Collision.Shapes.b2Shape;
   import Box2D.Common.Math.b2Vec2;
   import Box2D.Common.b2Settings;
   import Box2D.Common.b2internal;
   
   use namespace b2internal;
   
   public class b2DistanceProxy
   {
       
      
      public var m_vertices:Vector.<b2Vec2>;
      
      public var m_count:int;
      
      public var m_radius:Number;
      
      public function b2DistanceProxy()
      {
         super();
      }
      
      public function Set(param1:b2Shape) : void
      {
         var _loc3_:* = null;
         var _loc2_:* = null;
         switch(int(param1.GetType()))
         {
            case 0:
               _loc3_ = param1 as b2CircleShape;
               m_vertices = new Vector.<b2Vec2>(1,true);
               m_vertices[0] = _loc3_.m_p;
               m_count = 1;
               m_radius = _loc3_.m_radius;
               break;
            case 1:
               _loc2_ = param1 as b2PolygonShape;
               m_vertices = _loc2_.m_vertices;
               m_count = _loc2_.m_vertexCount;
               m_radius = _loc2_.m_radius;
         }
      }
      
      public function GetSupport(param1:b2Vec2) : Number
      {
         var _loc5_:int = 0;
         var _loc4_:Number = NaN;
         var _loc3_:* = 0;
         var _loc2_:* = Number(m_vertices[0].x * param1.x + m_vertices[0].y * param1.y);
         _loc5_ = 1;
         while(_loc5_ < m_count)
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
         while(_loc5_ < m_count)
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
      
      public function GetVertexCount() : int
      {
         return m_count;
      }
      
      public function GetVertex(param1:int) : b2Vec2
      {
         b2Settings.b2Assert(0 <= param1 && param1 < m_count);
         return m_vertices[param1];
      }
   }
}
