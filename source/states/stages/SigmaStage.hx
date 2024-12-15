package states.stages;

class SigmaStage extends BaseStage
{
    override public function create():Void
    {
        var sigma:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('sigma'));
		sigma.antialiasing = false;
        sigma.active = false;
		add(sigma);
    }
}