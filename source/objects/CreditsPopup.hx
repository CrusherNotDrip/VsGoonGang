package objects;

class CreditsPopup extends FlxSpriteGroup
{
	public var song:String = 'Unknown';

	/**
	 * Sets the current time until this popup gets tweened and destroyed.
	 *
	 * If this isn't set than this will stay forever.
	 */
	public var disappearTime(default, set):Float;

	public var composer:String = null;
	public var originalComposer:String = null;
	public var originalMod:String = null;

	var disappearTmr:FlxTimer = null;

	final startX:Float = 5;

	var bg:FlxSprite = null;

	public function new(x:Float = 0, y:Float = 0, song:String = 'Unknown')
	{
		this.song = song;

		super(x, y, 0);

		antialiasing = ClientPrefs.data.antialiasing;

		var songFormatted:String = Paths.formatToSongPath(song);

		composer = getComposer(songFormatted);
		originalComposer = getOriginalComposer(songFormatted);
		originalMod = getOriginalMod(songFormatted);

		setupPopup();
	}

	function setupPopup():Void
	{
		bg = new FlxSprite().makeGraphic(350, 1, FlxColor.BLACK);
		bg.alpha = 0.7;
		add(bg);

		final maxWidth:Float = bg.width;
        final nonSongSize:Int = 16;
        final offsetY:Int = 2;

        var lastY:Float = offsetY;

		var songText:FlxText = new FlxText(startX, lastY, maxWidth, song, 36);
		songText.setFormat(Paths.font('komika.ttf'), 36, FlxColor.BLACK, LEFT, OUTLINE, FlxColor.WHITE);
		add(songText);

        lastY += 36 + offsetY;

        if (composer != null)
        {
            var composeText:String = 'Composed by: ';

            if (originalComposer != null)
                composeText = 'Remixed by: ';

            var composerText:FlxText = new FlxText(startX, lastY, maxWidth, composeText + composer, nonSongSize);
            composerText.setFormat(Paths.font('komika.ttf'), nonSongSize, FlxColor.BLACK, LEFT, OUTLINE, FlxColor.WHITE);
            add(composerText);

            lastY += nonSongSize + offsetY;
        }

		if (originalComposer != null)
		{
			var originalComposerText:FlxText = new FlxText(startX, lastY, maxWidth, 'Composed by: ' + originalComposer, nonSongSize);
			originalComposerText.setFormat(Paths.font('komika.ttf'), nonSongSize, FlxColor.BLACK, LEFT, OUTLINE, FlxColor.WHITE);
			add(originalComposerText);

			lastY += nonSongSize + offsetY;
		}

		if (originalMod != null)
		{
			var originalModText:FlxText = new FlxText(startX, lastY, maxWidth, 'Original Song from: ' + originalMod, nonSongSize);
			originalModText.setFormat(Paths.font('komika.ttf'), nonSongSize, FlxColor.BLACK, LEFT, OUTLINE, FlxColor.WHITE);
			add(originalModText);

			lastY += nonSongSize + offsetY;
		}

		bg.setGraphicSize(maxWidth, lastY + 5);
		bg.updateHitbox();
	}

	function set_disappearTime(value:Float):Float
	{
		if (disappearTmr != null && disappearTmr.active)
		{
			disappearTmr.reset(value);
		}
		else
		{
			disappearTmr = new FlxTimer().start(value, (tmr:FlxTimer) ->
			{
				disappear(0.2);
			});
		}

		return disappearTime = value;
	}

	function disappear(time:Float = 0.2):Void
	{
		FlxTween.tween(this, {x: x - (x + bg.width)}, 0.2, {
			onComplete: (twn:FlxTween) ->
			{
				destroy();
			}
		});
	}

	function getComposer(song:String = 'Unknown'):String
	{
		return switch (song)
		{
			case 'im-edging' | 'abstinence': 'K E T C H Y';
			case 'bonehead': '5yl';
			case 'tinkle' | 'daniel-my-beloved': 'Pine';
			case 'burnt' | 'slurp': 'SoapyDX';
			case 'infinibeaner': 'Decks'; // I copied and pasted this i swear to god
			default: null;
		}
	}

	function getOriginalComposer(song:String = 'Unknown'):String
	{
		return switch (song)
		{
			case 'infinibeaner': 'B.O. Eszett'; // once again I copied and pasted this istg
			default: null;
		}
	}

	function getOriginalMod(song:String = 'Unknown'):String
	{
		return switch (song)
		{
			case 'infinibeaner': "VS. /v/"; // once ONCE again I copied and pasted this istg
			default: null;
		}
	}
}
