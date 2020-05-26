package
{
   import Box2D.Collision.Shapes.b2PolygonShape;
   import Box2D.Dynamics.b2Body;
   import Box2D.Dynamics.b2BodyDef;
   import Box2D.Dynamics.b2FixtureDef;
   import Box2D.Dynamics.b2World;
   import org.flixel.FlxGroup;
   import org.flixel.FlxSprite;
   import org.flixel.FlxText;
   
   public class Toehold extends FlxGroup
   {
       
      
      private var ratio:Number = 32;
      
      public var _sprite:FlxSprite;
      
      public var _fixDef:b2FixtureDef;
      
      public var _bodyDef:b2BodyDef;
      
      public var _obj:b2Body;
      
      public var _letter:String = "A";
      
      public var _hasLetter:Boolean;
      
      public var _letterVisible:Boolean;
      
      private var _textLabel:FlxText;
      
      private var _world:b2World;
      
      public var _enabled:Boolean;
      
      public var _friction:Number = 0.8;
      
      public var _restitution:Number = 0.3;
      
      public var _density:Number = 0.0;
      
      private const FREE:Number = 0;
      
      private const ASSIGNED:Number = 1;
      
      private const LOCKED:Number = 2;
      
      private const DISABLED:Number = 3;
      
      public var _angle:Number = 0;
      
      public var _type:uint;
      
      public var _ringType:Number;
      
      public var state:Number;
      
      public var limb:String;
      
      private var ImgRing:Class;
      
      public function Toehold(param1:Number, param2:Number, param3:b2World, param4:Number = 0, param5:String = "", param6:Number = 1)
      {
         _type = b2Body.b2_staticBody;
         ImgRing = rings_png$2b325011bd78d08e32521c01a108073c800246702;
         super();
         _ringType = param6;
         _sprite = new FlxSprite(param1,param2);
         _sprite.width = 16;
         _sprite.height = 16;
         _sprite.x = param1;
         _sprite.y = param2;
         _world = param3;
         _letter = new String(" ");
         createBody();
         state = param4;
         limb = param5;
         _enabled = true;
         _hasLetter = false;
         _letterVisible = false;
         _sprite.loadGraphic(ImgRing,true,false,16,16,true);
         _sprite.addAnimation("main",[0,1,2,3],0,false);
         _sprite.addAnimation("prize",[4],0,false);
         if(_ringType == 1)
         {
            _sprite.play("main");
            _sprite.frame = 0;
         }
         else if(_ringType == 2)
         {
            _sprite.play("prize");
         }
         add(_sprite);
         _textLabel = new FlxText(_sprite.x - 2,_sprite.y + 3,16,_letter,true);
         _textLabel.setFormat("NES",8,16777215,"center",0);
         _textLabel.font = "NES";
         add(_textLabel);
      }
      
      override public function update() : void
      {
         _sprite.x = _obj.GetPosition().x * ratio - _sprite.width / 2;
         _sprite.y = _obj.GetPosition().y * ratio - _sprite.height / 2;
         super.update();
      }
      
      public function setVisibleLetter(param1:Boolean) : void
      {
         _letterVisible = param1;
         if(param1)
         {
            _textLabel.text = _letter;
         }
         else
         {
            _textLabel.text = " ";
         }
      }
      
      public function setLetter(param1:String) : void
      {
         _letter = param1;
         if(_letterVisible)
         {
            _textLabel.text = param1;
         }
      }
      
      public function setFrame(param1:Number) : void
      {
         _sprite.frame = param1;
      }
      
      public function createBody() : void
      {
         var _loc1_:b2PolygonShape = new b2PolygonShape();
         _loc1_.SetAsBox(_sprite.width / 2 / ratio,_sprite.height / 2 / ratio);
         _fixDef = new b2FixtureDef();
         _fixDef.density = _density;
         _fixDef.restitution = _restitution;
         _fixDef.friction = _friction;
         _fixDef.shape = _loc1_;
         _fixDef.filter.categoryBits = 22;
         _fixDef.filter.maskBits = 65529;
         _fixDef.isSensor = true;
         _bodyDef = new b2BodyDef();
         _bodyDef.position.Set((_sprite.x + _sprite.width / 2) / ratio,(_sprite.y + _sprite.height / 2) / ratio);
         _bodyDef.angle = _angle * (3.14159265358979 / 180);
         _bodyDef.type = b2Body.b2_staticBody;
         _obj = _world.CreateBody(_bodyDef);
         _obj.CreateFixture(_fixDef);
      }
      
      override public function kill() : void
      {
         _world.DestroyBody(_obj);
         super.kill();
      }
   }
}
