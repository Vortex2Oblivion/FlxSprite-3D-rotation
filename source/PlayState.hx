package;

import flixel.util.FlxColor;
import flixel.addons.display.FlxGridOverlay;
import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState {
	var dumb:FlxSprite3D;

	override public function create() {
		super.create();
		bgColor = FlxColor.WHITE;
		dumb = new FlxSprite3D();
		dumb.loadGraphic(FlxGridOverlay.createGrid(100, 100, 200, 200, true, FlxColor.BLACK, FlxColor.MAGENTA));
		dumb.screenCenter();
		dumb.antialiasing = true;
		add(dumb);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		dumb.angle3D.x = (FlxG.mouse.viewY / FlxG.height) * 180 - 90;
		dumb.angle3D.y = -(FlxG.mouse.viewX / FlxG.width) * 180 + 90;
		dumb.angle3D.z += FlxG.mouse.wheel * 15;
		//dumb.scale.set(Math.sin(FlxG.game.ticks / 1000) * 0.5 + 1, Math.sin(FlxG.game.ticks / 1000) * 0.5 + 1);

		if (FlxG.keys.pressed.E) {
			FlxG.camera.zoom += elapsed;
		}
		if (FlxG.keys.pressed.Q) {
			FlxG.camera.zoom -= elapsed;
		}
		if (FlxG.keys.pressed.LEFT) {
			dumb.angle3D.y -= elapsed * 25;
		}
		if (FlxG.keys.pressed.RIGHT) {
			dumb.angle3D.y += elapsed * 25;
		}
		if (FlxG.keys.pressed.DOWN) {
			dumb.angle3D.x -= elapsed * 25;
		}
		if (FlxG.keys.pressed.UP) {
			dumb.angle3D.x += elapsed * 25;
		}
		if (FlxG.keys.pressed.W) {
			dumb.skew.y += elapsed * 25;
		}
		if (FlxG.keys.pressed.S) {
			dumb.skew.y -= elapsed * 25;
		}
		if (FlxG.keys.pressed.A) {
			dumb.skew.x -= elapsed * 25;
		}
		if (FlxG.keys.pressed.D) {
			dumb.skew.x += elapsed * 25;
		}
	}
}
