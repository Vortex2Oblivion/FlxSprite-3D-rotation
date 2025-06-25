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
		for (anim in ["idle", "singDOWN", "singUP", "singLEFT", "singRIGHT"]) {
			dumb.animation.addByPrefix(anim, anim, 24, false);
		}
		dumb.screenCenter();
		dumb.antialiasing = true;
		add(dumb);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		/*dumb.angle3D.x = (FlxG.mouse.viewY / FlxG.height) * 180 - 90;
		dumb.angle3D.y = -(FlxG.mouse.viewX / FlxG.width)* 180 + 90;*/
		dumb.angle3D.z += FlxG.mouse.wheel;
		dumb.animation.play("idle", false);
		if(FlxG.keys.pressed.E){
			FlxG.camera.zoom += elapsed;
		}
		if(FlxG.keys.pressed.Q){
			FlxG.camera.zoom -= elapsed;
		}
		if(FlxG.keys.pressed.LEFT){
			dumb.angle3D.y -= elapsed * 25;
		}
		if(FlxG.keys.pressed.RIGHT){
			dumb.angle3D.y += elapsed * 25;
		}
		if(FlxG.keys.pressed.DOWN){
			dumb.angle3D.x -= elapsed * 25;
		}
		if(FlxG.keys.pressed.UP){
			dumb.angle3D.x += elapsed * 25;
		}
		if(FlxG.keys.pressed.W){
			dumb.skew3D.y += elapsed * 25;
		}
		if(FlxG.keys.pressed.S){
			dumb.skew3D.y -= elapsed * 25;
		}
		if(FlxG.keys.pressed.A){
			dumb.skew3D.x -= elapsed * 25;
		}
		if(FlxG.keys.pressed.D){
			dumb.skew3D.x += elapsed * 25;
		}
	}
}
