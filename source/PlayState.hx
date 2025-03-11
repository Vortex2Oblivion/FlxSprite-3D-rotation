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
		dumb.antialiasing = true;
		add(dumb);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		dumb.angle = 45;
	}
}
