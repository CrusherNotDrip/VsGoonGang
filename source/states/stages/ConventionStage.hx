package states.stages;

class ConventionStage extends BaseStage
{
	var skibid:FlxSprite = null;
	var backshotter:FlxSprite = null;

	override public function create():Void
	{
		var back:FlxSprite = new FlxSprite(25, 100).loadGraphic(Paths.image('convention/back'));
		back.antialiasing = ClientPrefs.data.antialiasing;
		back.active = false;
		add(back);

		var banner:FlxSprite = new FlxSprite(25, 115).loadGraphic(Paths.image('convention/banner'));
		banner.antialiasing = ClientPrefs.data.antialiasing;
		banner.active = false;
		add(banner);

		skibid = new FlxSprite(2400, 1250);
		skibid.frames = Paths.getSparrowAtlas('convention/skibidfunkin456');
		skibid.animation.addByPrefix('dance', 'BF idle dance', 24, true);
		skibid.animation.play('dance');
		skibid.antialiasing = ClientPrefs.data.antialiasing;
		add(skibid);

		backshotter = new FlxSprite(1258, 1324);
		backshotter.frames = Paths.getSparrowAtlas('convention/FNFBACKSHOTTER87');
		backshotter.animation.addByPrefix('dance', 'BF idle dance', 24, true);
		backshotter.animation.play('dance');
		backshotter.antialiasing = ClientPrefs.data.antialiasing;
		backshotter.flipX = true;
		add(backshotter);

		var booths:FlxSprite = new FlxSprite(25, 100).loadGraphic(Paths.image('convention/booths'));
		booths.antialiasing = ClientPrefs.data.antialiasing;
		booths.active = false;
		add(booths);
	}

	#if VIDEOS_ALLOWED
	override public function createPost():Void
	{
		if (isStoryMode && songName == 'im-edging')
		{
			game.startCallback = () ->
			{
				game.startVideo('goonCUTSCENE');
			}
		}
	}
	#end

	override public function beatHit():Void
	{
		for (gooner in [skibid, backshotter])
		{
			gooner.animation.play('dance');
		}
	}
}
