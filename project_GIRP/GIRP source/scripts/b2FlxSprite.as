package
{
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2FixtureDef;
   import Box2D.Dynamics.b2World;
   import org.flixel.FlxSprite;
   
   public class b2FlxSprite extends FlxSprite
   {
       
      
      private var ratio:Number = 32;
      
      public var _fixDef:b2FixtureDef;
      
      public var _bodyDef:b2BodyDef;
      
      public var _obj:b2Body;
      
      private var _world:b2World;
      
      public var _friction:Number = 0.8;
      
      public var _restitution:Number = 0.3;
      
      public var _density:Number = 0.7;
      
      public var _angle:Number = 0;
      
      public var _type:uint;
      
      public function b2FlxSprite(param1:Number, param2:Number, param3:Number, param4:Number, param5:b2World)
      {
         _type = b2Body.b2_dynamicBody;
         super(param1,param2);
         width = param3;
         height = param4;
         _world = param5;
      }
      
      override public function update() : void
      {
         x = _obj.GetPosition().x * ratio - width / 2;
         y = _obj.GetPosition().y * ratio - height / 2;
         angle = _obj.GetAngle() * (180 / 3.14159265358979);
         super.update();
      }
      
      public function createBody(param1:Number) : void
      {
         var _loc2_:b2PolygonShape = new b2PolygonShape();
         _loc2_.SetAsBox(width / 2 / ratio,height / 2 / ratio);
         _fixDef = new b2FixtureDef();
         _fixDef.filter.categoryBits = 8;
         _fixDef.filter.maskBits = 65535 - param1;
         _fixDef.density = _density;
         _fixDef.restitution = _restitution;
         _fixDef.friction = _friction;
         _fixDef.shape = _loc2_;
         _bodyDef = new b2BodyDef();
         _bodyDef.position.Set((x + width / 2) / ratio,(y + height / 2) / ratio);
         _bodyDef.angle = _angle * (3.14159265358979 / 180);
         _bodyDef.type = _type;
         _obj = _world.CreateBody(_bodyDef);
         _obj.CreateFixture(_fixDef);
      }
   }
}
