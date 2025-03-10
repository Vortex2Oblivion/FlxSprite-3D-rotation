package;

import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState {
	var dumb:FlxSprite3D;
	override public function create() {
		super.create();
		dumb = new FlxSprite3D();
		dumb.loadGraphic("assets/images/image.png");
		dumb.screenCenter();
		add(dumb);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		dumb.angle3D.x = Math.sin(FlxG.game.ticks / 1000) * 180;
		dumb.angle3D.y = Math.cos(FlxG.game.ticks / 1000) * 180;
		dumb.angle3D.z = Math.tan(FlxG.game.ticks / 1000) * 180;
	}
}
