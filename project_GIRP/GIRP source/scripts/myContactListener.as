package
{
   import Box2D.Collision.b2Manifold;
   import Box2D.Dynamics.Contacts.b2Contact;
   import Box2D.Dynamics.b2ContactListener;
   import org.flixel.FlxG;
   
   public class myContactListener extends b2ContactListener
   {
       
      
      public function myContactListener()
      {
         super();
      }
      
      override public function BeginContact(param1:b2Contact) : void
      {
         var _loc3_:String = param1.GetFixtureB().GetBody().GetUserData() as String;
         var _loc2_:String = param1.GetFixtureA().GetBody().GetUserData() as String;
         var _loc4_:PlayState = FlxG.state as PlayState;
         if(_loc3_ == "floor")
         {
            if(_loc2_ == "player")
            {
               _loc4_.reset();
            }
         }
         if(_loc3_ == "bird")
         {
            if(_loc2_ == "player")
            {
               _loc4_._bird.goInvulnerable(2);
            }
         }
      }
      
      override public function PreSolve(param1:b2Contact, param2:b2Manifold) : void
      {
         var _loc4_:String = param1.GetFixtureB().GetBody().GetUserData() as String;
         var _loc3_:String = param1.GetFixtureA().GetBody().GetUserData() as String;
         var _loc5_:PlayState = FlxG.state as PlayState;
         if(_loc4_ == "bird")
         {
            if(_loc3_ == "player")
            {
               _loc5_.launchBird();
            }
         }
      }
   }
}
