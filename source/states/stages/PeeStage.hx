package states.stages;

class PeeStage extends BaseStage
{
    override public function create():Void
    {
        var pee:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('thepee'));
		pee.antialiasing = false;
        pee.active = false;
		add(pee);
    }
}