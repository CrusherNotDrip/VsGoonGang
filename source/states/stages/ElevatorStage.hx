package states.stages;

class ElevatorStage extends BaseStage
{
    override public function create():Void
    {
        var elevator:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('elevator'));
		elevator.antialiasing = false;
        elevator.active = false;
		add(elevator);
    }
}