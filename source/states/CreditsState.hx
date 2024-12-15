package states;

import objects.TextBox;
import objects.AttachedSprite;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var bg:FlxSprite;
	var intendedColor:FlxColor;
	var colorTween:FlxTween;
	var descBox:TextBox;

	var offsetThing:Float = -75;

	override function create()
	{
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = true;
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);
		bg.screenCenter();

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		#if MODS_ALLOWED
		for (mod in Mods.parseList().enabled) pushModCreditsToList(mod);
		#end

		var defaultList:Array<Array<String>> = [
			['Goon Gang Gooners'],
			['Lazibones',			'lazi',				'Director\nCharted all songs',						 		 'https://twitter.com/lazibones73',		'B2001C'],
			['CrusherNotDrip',		'crusher',			'Co-Director\nCoded basically everything',					 'https://crushernotdrip.github.io/',	'B2001C'],
			['OmegaRuby',			'ruby',				'Co-Director\nSprites for FNFEDGER49 + FNFBONER13\'s Sprites & Icons','https://bsky.app/profile/omegarubyy.bsky.social','B2001C'],
			['Pine',				'pine',				'Co-Director\nComposed Tinkle & Daniel My Beloved',		 	 'https://www.youtube.com/@pineeeeeeeeeee','B2001C'],
			[''],
			['Goon Gang Devs'],
			['Bonnie_FiveNight',	'bonnie',			'NEVERGOON Minion Icons',				 					 'https://youtu.be/IsLPoQB_j6o',		'F28700'],
			['DaniDoodles',			'dani',				'Gooning Convention Stage + FNFEDGER49 Icon + Goon Gang Logo','https://twitter.com/DaniDoodles9', 	'F28700'],
			['Decks',				'deck',				'Composed Menu Theme + Remix of the Vs /v/ song',  		 	 'https://youtu.be/IsLPoQB_j6o',		'F28700'],
			['DustBunny91',			'dusty',			'Art for Goon Week cutscene',					 		 	 'https://twitter.com/dust_bunny91',	'F28700'],
			['GiannaHart',			'gianna',	 		'FnfFreaker47\'s Sprites & Icons + Skibidifunkin456 & fnfbackshotter87 Stage + Banner for Goon Week + Charted part of Slurp + Voiced acted Goon Week Cutscene','https://twitter.com/giaisall','F28700'],
			['K E T C H Y',			'ketchy',			'Composed Im Edging & Abstinence + NEVERGOON Minion Sprites','https://www.youtube.com/channel/UCcJHRKXfMpNoEkttlpC4Jbw','F28700'],
			['MiamiPoopGamer122',	'peepee83', 		'FNFPEEPEE83\'s Sprites & Icons + Background for Vs /v/ Remix','https://twitter.com/ChinoMorenoPoo', 'F28700'],
			['Mooonz',				'mooon',			'Moral Support :)',											 'https://twitter.com/mooon7127',		'F28700'],
			['shopcart',			'shopcart',			'Sprites and Icons for FNFBURNER73 & Daniel Vincent Stevens\'','https://twitter.com/shoppingcart_r','F28700'],
			['SoapyDX',				'soapy',			'Composed Burnt and Slurp',									 'https://twitter.com/FluffyFX__',		'F28700'],
			['TateNewG',			'tate',				'Main Menu Background',										 'https://twitter.com/TateNewG',		'F28700'],
			['5yl',					'sylv',				'Composed Bonehead',										 'https://e-z.bio/5yl',					'F28700'],
			[''],
			['Goon Gang Special Thanks'],
			['Daniel Vincent Stevens', 'dvs', 			'Opponent featured in Daniel My Beloved.',					 'https://twitter.com/3330DVS0333',		'F2D055'],
			['ZkyeTZ',				'skibid',			'Creator of Skibidifunkin456',								 'https://twitter.com/ZkyeTZ',			'F2D055'],
			['Mr. Anonymous',		'backshot',			'Creator of fnfbackshotter87',								 'https://youtu.be/mdxh-zHEe3Y?si=2VCXd7xHafSKm4Cq&t=3','F2D055'],
			[''],
			['Psych Engine Team'],
			['Shadow Mario',		'shadowmario',		'Main Programmer and Head of Psych Engine',					 'https://ko-fi.com/shadowmario',		'444444'],
			['Riveren',				'riveren',			'Main Artist/Animator of Psych Engine',						 'https://twitter.com/riverennn',		'14967B'],
			[''],
			['Former Engine Members'],
			['bb-panzu',			'bb',				'Ex-Programmer of Psych Engine',							 'https://twitter.com/bbsub3',			'3E813A'],
			['shubs',				'',					'Ex-Programmer of Psych Engine\nI don\'t support them.',	 '',									'A1A1A1'],
			[''],
			['Engine Contributors'],
			['CrowPlexus',			'crowplexus',		'Input System v3, Major Help and Other PRs',				 'https://twitter.com/crowplexus',		'A1A1A1'],
			['Keoiki',				'keoiki',			'Note Splash Animations and Latin Alphabet',				 'https://twitter.com/Keoiki_',			'D2D2D2'],
			['SqirraRNG',			'sqirra',			'Crash Handler and Base code for\nChart Editor\'s Waveform', 'https://twitter.com/gedehari',		'E1843A'],
			['EliteMasterEric',		'mastereric',		'Runtime Shaders support',									 'https://twitter.com/EliteMasterEric',	'FFBD40'],
			['PolybiusProxy',		'proxy',			'.MP4 Video Loader Library (hxCodec)',						 'https://twitter.com/polybiusproxy',	'DCD294'],
			['Tahir',				'tahir',			'Implementing & Maintaining SScript and Other PRs',			 'https://twitter.com/tahirk618',		'A04397'],
			['iFlicky',				'flicky',			'Composer of Psync and Tea Time\nMade the Dialogue Sounds',	 'https://twitter.com/flicky_i',		'9E29CF'],
			['KadeDev',				'kade',				'Fixed some issues on Chart Editor and Other PRs',			 'https://twitter.com/kade0912',		'64A250'],
			['superpowers04',		'superpowers04',	'LUA JIT Fork',												 'https://twitter.com/superpowers04',	'B957ED'],
			['CheemsAndFriends',	'face',	'Creator of FlxAnimate\n(Icon will be added later, merry christmas!)',	 'https://twitter.com/CheemsnFriendos',	'A1A1A1'],
			[''],
			["Funkin' Crew"],
			['ninjamuffin99',		'ninjamuffin99',	"Programmer of Friday Night Funkin'",						 'https://twitter.com/ninja_muffin99',	'CF2D2D'],
			['PhantomArcade',		'phantomarcade',	"Animator of Friday Night Funkin'",							 'https://twitter.com/PhantomArcade3K',	'FADC45'],
			['evilsk8r',			'evilsk8r',			"Artist of Friday Night Funkin'",							 'https://twitter.com/evilsk8r',		'5ABD4B'],
			['kawaisprite',			'kawaisprite',		"Composer of Friday Night Funkin'",							 'https://twitter.com/kawaisprite',		'378FC7']
		];

		for(i in defaultList) {
			creditsStuff.push(i);
		}

		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(FlxG.width / 2, 300, creditsStuff[i][0], !isSelectable);
			optionText.isMenuItem = true;
			optionText.targetY = i;
			optionText.changeX = false;
			optionText.snapToPosition();
			grpOptions.add(optionText);

			if(isSelectable) {
				if(creditsStuff[i][5] != null)
				{
					Mods.currentModDirectory = creditsStuff[i][5];
				}

				var str:String = 'credits/missing_icon';
				if(creditsStuff[i][1] != null && creditsStuff[i][1].length > 0)
				{
					var fileName = 'credits/' + creditsStuff[i][1];
					if (Paths.fileExists('images/$fileName.png', IMAGE)) str = fileName;
					else if (Paths.fileExists('images/$fileName-pixel.png', IMAGE)) str = fileName + '-pixel';
				}

				var icon:AttachedSprite = new AttachedSprite(str);
				if(str.endsWith('-pixel')) icon.antialiasing = false;
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;

				iconArray.push(icon);
				add(icon);
				Mods.currentModDirectory = '';

				if(curSelected == -1) curSelected = i;
			}
			else optionText.alignment = CENTERED;
		}

		descBox = new TextBox(50, FlxG.height + offsetThing - 25, Math.floor(FlxG.width / 1.084), 32, CENTER, FlxColor.BLACK);
		add(descBox);

		bg.color = CoolUtil.colorFromString(creditsStuff[curSelected][4]);
		intendedColor = bg.color;
		changeSelection();
		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if(!quitting)
		{
			if(creditsStuff.length > 1)
			{
				var shiftMult:Int = 1;
				if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

				var upP = controls.UI_UP_P;
				var downP = controls.UI_DOWN_P;

				if (upP)
				{
					changeSelection(-shiftMult);
					holdTime = 0;
				}
				if (downP)
				{
					changeSelection(shiftMult);
					holdTime = 0;
				}

				if(controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}

			if(controls.ACCEPT && (creditsStuff[curSelected][3] == null || creditsStuff[curSelected][3].length > 4)) {
				CoolUtil.browserLoad(creditsStuff[curSelected][3]);
			}
			if (controls.BACK)
			{
				if(colorTween != null) {
					colorTween.cancel();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				quitting = true;
			}
		}

		for (item in grpOptions.members)
		{
			if(!item.bold)
			{
				var lerpVal:Float = Math.exp(-elapsed * 12);
				if(item.targetY == 0)
				{
					var lastX:Float = item.x;
					item.screenCenter(X);
					item.x = FlxMath.lerp(item.x - 70, lastX, lerpVal);
				}
				else
				{
					item.x = FlxMath.lerp(200 + -40 * Math.abs(item.targetY), item.x, lerpVal);
				}
			}
		}
		super.update(elapsed);
	}

	var moveTween:FlxTween = null;
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:FlxColor = CoolUtil.colorFromString(creditsStuff[curSelected][4]);

		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}

		var descText:FlxText = descBox.textObj;

		descBox.text = creditsStuff[curSelected][2];
		descText.y = FlxG.height - descText.height + offsetThing - 60;

		if(moveTween != null) moveTween.cancel();
		moveTween = FlxTween.tween(descText, {y : descText.y + 75}, 0.25, {ease: FlxEase.sineOut});

	}

	#if MODS_ALLOWED
	function pushModCreditsToList(folder:String)
	{
		var creditsFile:String = null;
		if(folder != null && folder.trim().length > 0) creditsFile = Paths.mods(folder + '/data/credits.txt');
		else creditsFile = Paths.mods('data/credits.txt');

		if (FileSystem.exists(creditsFile))
		{
			var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
			for(i in firstarray)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split("::");
				if(arr.length >= 5) arr.push(folder);
				creditsStuff.push(arr);
			}
			creditsStuff.push(['']);
		}
	}
	#end

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
