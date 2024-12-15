package objects;

class TextBox extends FlxTypedSpriteGroup<FlxSprite>
{
    public var text(default, set):String;

    public var textObj:FlxText;
    public var boxObj:AttachedSprite;

    public function new(x:Float = 0, y:Float = 0, maxWidth:Float = 0, textSize:Int = 8, alignment:FlxTextAlign = LEFT, bgColor:FlxColor = 0xFF000000)
    {
        super();

        boxObj = new AttachedSprite();
        boxObj.makeGraphic(1, 1, bgColor);
		boxObj.xAdd = -10;
		boxObj.yAdd = -10;
		boxObj.alphaMult = 0.6;
		boxObj.alpha = 0.6;
        add(boxObj);


		textObj = new FlxText(x, y, maxWidth, "", textSize);
		textObj.setFormat(Paths.font("komika.ttf"), textSize, FlxColor.WHITE, alignment);
		boxObj.sprTracker = textObj;
		add(textObj);
    }

    public function set_text(value:String):String
    {
        text = value;

        textObj.text = text;
        updateBoxSize();

        return text;
    }

    public function updateBoxSize():Void
    {
        boxObj.setGraphicSize(Std.int(textObj.width + 20), Std.int(textObj.height + 25));
		boxObj.updateHitbox();
    }
}