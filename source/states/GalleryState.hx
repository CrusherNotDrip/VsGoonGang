package states;

import backend.PsychCamera;
import objects.AttachedSprite;
import objects.TextBox;
import flixel.FlxObject;
import tjson.TJSON;

class GalleryState extends MusicBeatState
{
    static var curSelected:Int = 0;

    var bg:FlxSprite = null;

    var nameTag:TextBox = null;
    var descBox:TextBox = null;

    var galleryImages:FlxTypedSpriteGroup<FlxSprite> = null;
    var galleryImagesData:Array<GalleryImage> = [];

    var camGame:PsychCamera = null;
    var camGallery:PsychCamera = null;

    var camFollow:FlxObject = null;

    override public function create():Void
    {
        initCameras();

        initBG();
        initializeImages();
        initializeTags();

        changeGallerySelection();

        super.create();
    }

    function initCameras():Void
    {
        camGame = initPsychCamera();

        camGallery = new PsychCamera();
        camGallery.bgColor.alpha = 0;
        FlxG.cameras.add(camGallery, false);

        camFollow = new FlxObject(0, 0, 1, 1);
        camFollow.screenCenter(Y);
        add(camFollow);

        camGallery.follow(camFollow, null, 9);
    }

    function initBG():Void
    {
        bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
        bg.scrollFactor.set();
        bg.screenCenter();
        bg.color = 0x00FF80;
		add(bg);
    }

    function initializeImages():Void
    {
        galleryImagesData = getGalleryImagesData();

        galleryImages = new FlxTypedSpriteGroup<FlxSprite>();
        galleryImages.camera = camGallery;
        add(galleryImages);

        var curImageX:Float = 0;

        var imageID:Int = 0;

        for (image in galleryImagesData)
        {
            if (image.chance != null && !FlxG.random.bool(image.chance))
                continue;

            var gallerySprite:FlxSprite = new FlxSprite().loadGraphic(Paths.image('gallery/' + image.file));
            gallerySprite.antialiasing = ClientPrefs.data.antialiasing;
            gallerySprite.setGraphicSize(0, 500);
            gallerySprite.scrollFactor.set(1, 0);
            gallerySprite.updateHitbox();
            gallerySprite.screenCenter(Y);
            gallerySprite.camera = camGallery;
            gallerySprite.ID = imageID;
            galleryImages.add(gallerySprite);

            gallerySprite.x = curImageX;
            curImageX = (gallerySprite.width + gallerySprite.x) + 15;

            imageID++;
        }
    }

    function initializeTags():Void
    {
        nameTag = new TextBox(0, 0, 0, 16, LEFT, 0xFF000000);
        add(nameTag);

		descBox = new TextBox(50, FlxG.height - 25, Math.floor(FlxG.width / 1.084), 24, CENTER, FlxColor.BLACK);
		add(descBox);
    }

    override public function update(elapsed:Float):Void
    {
        handleInputs();

        if (revertGooner)
        {
            ohNoItsGooner(false);
        }

        if (transitioningToGooner)
        {
            bg.alpha =  FlxMath.lerp(0, bg.alpha, Math.exp(-elapsed * 9));
            descBox.alpha = FlxMath.lerp(0, descBox.alpha, Math.exp(-elapsed * 9));

            for (image in galleryImages.members)
            {
                if (image.ID != curSelected)
                {
                    image.alpha = FlxMath.lerp(0, descBox.alpha, Math.exp(-elapsed * 9));
                }
            }
        }

        super.update(elapsed);
    }

    var holdTimer:Float = 0;
    var timeOut:Float = 0;

    function handleInputs():Void
    {
        if (controls.UI_LEFT || controls.UI_RIGHT)
        {
            if (galleryImagesData[curSelected].name != '(him)')
                revertGooner = true;

            holdTimer += FlxG.elapsed;
            timeOut -= FlxG.elapsed;

			if ((controls.UI_LEFT_P || controls.UI_RIGHT_P) || holdTimer >= 0.5 && timeOut <= 0)
			{
				if (controls.UI_LEFT)
                    changeGallerySelection(-1);
				else if (controls.UI_RIGHT)
                    changeGallerySelection(1);

                timeOut = 0.1;
			}
        }

        if (controls.UI_LEFT_R || controls.UI_RIGHT_R)
        {
            holdTimer = 0;
            timeOut = 0;
        }

        if (controls.BACK)
        {
            MusicBeatState.switchState(new MainMenuState());
        }
    }

    function changeGallerySelection(change:Int = 0):Void
    {
        curSelected += change;

        if (curSelected >= galleryImages.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = galleryImages.length - 1;

        for (image in galleryImages.members)
        {
            if (image.ID == curSelected)
            {
                image.alpha = 1;
                image.setGraphicSize(0, 500);
                camFollow.x = image.getMidpoint().x;
            }
            else
            {
                image.alpha = 0.6;
                image.setGraphicSize(0, 450);
            }
        }

        var curName:String = galleryImagesData[curSelected].name;
        if (curName != null && curName != '')
        {
            nameTag.text = curName;
            nameTag.textObj.screenCenter(X);
            nameTag.textObj.y = galleryImages.members[curSelected].y - 50;
            nameTag.alpha = 1;
        }
        else
        {
            nameTag.alpha = 0;
        }

        if (curName == '(him)')
        {
            ohNoItsGooner(true);
        }

        var curDesc:String = galleryImagesData[curSelected].description;
        if (curDesc != null && curDesc != '')
        {
            descBox.text = curDesc;
            descBox.textObj.y = FlxG.height - descBox.textObj.height - 25;
            descBox.alpha = 1;
        }
        else
        {
            descBox.alpha = 0;
        }
    }

    function getGalleryImagesData():Array<GalleryImage>
    {
        final path:String = 'images/gallery/gallery.json';

        var leGalleryImages:Array<GalleryImage> = [];

        if (Paths.fileExists(path, TEXT, true))
        {
            var galleryJsonArray:Array<GalleryImage> = cast TJSON.parse(Paths.getTextFromFile(path, true));

            for (galleryImg in galleryJsonArray)
            {
                leGalleryImages.push(galleryImg);
            }
        }

        #if MODS_ALLOWED
        var getModImage:Null<String>->Void = (folder:String) -> {
            final modFilePath = Paths.mods((folder == null ? '' : folder + '/') + '$path');
            trace(modFilePath);

            if (FileSystem.exists(modFilePath))
            {
                var galleryJsonArray:Array<GalleryImage> = cast TJSON.parse(File.getContent(modFilePath));

                for (galleryImg in galleryJsonArray)
                {
                    leGalleryImages.push(galleryImg);
                }
            }
        };

        getModImage(null);

        for (mod in Mods.parseList().enabled)
        {
            getModImage(mod);
        }
        #end

        return leGalleryImages;
    }

    var transitioningToGooner:Bool = false;
    var revertGooner:Bool = true;

    function ohNoItsGooner(isGooner:Bool = true):Void
    {
        transitioningToGooner = isGooner;
        FlxG.sound.music.volume = (isGooner) ? 0 : 1;

        if (!isGooner)
        {
            bg.alpha = 1;
            descBox.alpha = 1;

            for (image in galleryImages.members)
            {
                image.alpha = (image.ID != curSelected) ? 0.6 : 1;
            }
        }

        revertGooner = false;
    }
}

typedef GalleryImage = {
    var name:String;
    @:optional var ?description:String;
    var file:String;
    @:optional var ?chance:Float;
}