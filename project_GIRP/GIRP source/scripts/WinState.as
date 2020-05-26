package
{
   import org.flixel.FlxG;
   import org.flixel.FlxSave;
   import org.flixel.FlxSprite;
   import org.flixel.FlxState;
   import org.flixel.FlxText;
   
   public class WinState extends FlxState
   {
       
      
      private var _timer:Number;
      
      private var WinGfx:Class;
      
      private var _played:Boolean;
      
      private var save:FlxSave;
      
      private var _hiScore:Number;
      
      private var _hiScoreText:FlxText;
      
      public function WinState(param1:Number)
      {
         WinGfx = Win_png$3f429544579aaed724378cc69c9b44ca1412345751;
         super();
         _timer = 0;
         _played = false;
         var _loc2_:FlxSprite = new FlxSprite(0,0,WinGfx);
         add(_loc2_);
         _hiScoreText = new FlxText(5,176,200,"NEW HIGH SCORE: " + param1.toFixed(1) + " SECONDS",true);
         _hiScoreText.setFormat("NES",8,16777215,"left",0);
         _hiScoreText.shadow = 1;
         add(_hiScoreText);
         save = new FlxSave();
         save.bind("highScore");
         if(save.read("highScore"))
         {
            _hiScore = save.read("highScore") as Number;
         }
         else
         {
            _hiScore = 0;
         }
         if(param1 == _hiScore)
         {
            _hiScoreText.text = "NEW RECORD: " + Math.floor(param1 / 60) + "m" + (param1 % 60).toFixed(1) + "s";
         }
         else
         {
            _hiScoreText.text = "YOUR TIME:" + Math.floor(param1 / 60) + "m" + (param1 % 60).toFixed(1) + "s";
         }
         FlxG.playMusic(Assets.AmbientSnd,0.4,689953);
         FlxG.music.fadeIn(2);
         var _loc3_:FlxText = new FlxText(5,200,155,"",true);
         _loc3_.setFormat("NES",8,16777215,"left",0);
         _loc3_.shadow = 40;
         var _loc4_:Array = new Array("Two carrots","Seagull eggs","A potato","A bible","Rubber grapes","A chick tract","A clove cigarette","An old hamburger","Smelly socks","Packing peanuts","Three bricks","A cinderblock","Philosophical Quarterly","Fosters lager","A pocket protector","A glass terrarium","An ornamental ashtray","A chip \'n dip","Nothing at all","A banana peel","A graphing calculator","A sequinned skirt","A Nagel print","A Newton\'s cradle","One boxing glove","A rotten egg","A neck pillow","Antibacterial gel","A rubber bat","A copy of Wisden","Malibu rum","A raw fish","A lump of coal","A knitted sweater","Another box","A carabiner","A pair of Crocs","A blank cassette","A Terry-towel hat","A skeleton","A life jacket","Some vegemite","A cold cup of tea","A glass horse","An old boot","A lava lamp","A glass marble","A buck fifty","A stick of butter","A paper aeroplane","A cat-hair necklace","A scratchy sweater","Plastic pearls","An oyster shucker","A jar of bees","A can of Old Spice","A Bon Jovi poster","Ball in a cup","23 Pogs","A Tamagotchi","Pizza pockets","Raisins","A Hacky-sack","A roller-blade","Mineral oil","A mood ring","Live scorpions","Unpaid parking tickets","An oil burner","Moldy tomatoes","Bedbugs","A pumpkin","A jockstrap","A bar of carob","Alfalfa sprouts","A shoe horn","A magic 8-ball","100 rubber bands","A small cactus","A thumb tack","Four crab sticks","Graph paper","A protractor","A chewed pencil","An exploding golfball","A tiedyed scarf","75ml of Malibu","Cheese twists","A fake rubber vomit","A whoopee cushion","Aluminium foil","A whiffle ball","Liverwurst","Coral earrings","Lawn bowls","A toilet brush","A tray table","123 acorns","Plastic cufflinks","A purple tie pin","A punctured volleyball","A vintage coke bottle","A wig","A banana peeler","A Hawaiian shirt","Marzipan fruits","A pop tart","A french-fry holder","A skull ring","A pocket protector","Rubber gloves","A pair of crocs","A yellow crayon","A snowglobe","A porcelain snail","A dead beetle","Baby seagulls","A rubber duck","A shower cap","Shoe covers","A polyester valance","A cherry pitter","A tongue depressor","An unspeakable horror","A bad smell","A cobweb","A bird\'s nest","A blister pack","A cigarette","Baby wipes","Worm casserole","Bird belongings","Patch Adams DVD","A broken mirror","An inverted horseshoe","A 3-leaf clover","An copy of Aquaman","Grape kool-aid","Spam email","A fanny pack","Edible underwear","A snuggie","A temporary tattoo","Lip gloss","A glue stick","A branded yoyo","A letter opener","A condolences card","A stick of gum");
         _loc3_.text = "Inside the box:\n\n" + _loc4_[Math.floor(Math.random() * _loc4_.length)];
         add(_loc3_);
      }
      
      override public function update() : void
      {
         if(!_played)
         {
            FlxG.play(Assets.WinSnd,1,false);
            _played = true;
         }
         _timer = _timer + FlxG.elapsed;
         super.update();
         if(_timer > 1 && FlxG.keys.SPACE)
         {
            Restart();
         }
      }
      
      private function Restart() : void
      {
         FlxG.fade.start(4278190080,1,onFade);
      }
      
      private function onFade() : void
      {
         FlxG.state = new PlayState();
      }
   }
}
