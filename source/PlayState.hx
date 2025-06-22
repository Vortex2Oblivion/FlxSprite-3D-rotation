package;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState {
	var dumb:FlxSprite3D;
	override public function create() {
		super.create();
		dumb = new FlxSprite3D();
		dumb.frames = FlxAtlasFrames.fromSparrow("assets/images/DADDY_DEAREST.png", "assets/images/DADDY_DEAREST.xml");
		for(anim in ["idle", "singDOWN", "singUP", "singLEFT", "singRIGHT"]){
			dumb.animation.addByPrefix(anim, anim, 24, false);
		}
		FlxG.camera.zoom = 0.5;
		dumb.screenCenter();
		dumb.antialiasing = true;
		add(dumb);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		dumb.angle3D.x = (FlxG.mouse.viewY / FlxG.height) * 180 - 90;
		dumb.angle3D.y = -(FlxG.mouse.viewX / FlxG.width) * 180 + 90;
		/*dumb.angle3D.x = Math.cos(FlxG.game.ticks / 1000) * 45;
		dumb.angle3D.y = Math.sin(FlxG.game.ticks / 1000) * 45;*/
		if(FlxG.keys.pressed.UP){
			dumb.animation.play("singUP", false);
		}
		else if(FlxG.keys.pressed.DOWN){
			dumb.animation.play("singDOWN", false);
		}
		else if(FlxG.keys.pressed.RIGHT){
			dumb.animation.play("singRIGHT", false);
		}
		else if(FlxG.keys.pressed.LEFT){
			dumb.animation.play("singLEFT", false);
		}
		else{
			dumb.animation.play("idle", false);
		}
	}
}
