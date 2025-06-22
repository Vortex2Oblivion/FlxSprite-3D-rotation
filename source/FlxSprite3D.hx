package;

import flixel.graphics.frames.FlxFrame;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import openfl.geom.Vector3D;

/**
 * Performs 3D rotations on a 2D FlxSprite
 * @see https://math.stackexchange.com/questions/62182/how-do-i-rotate-a-matrix-transformation-with-a-centered-origin
 * @see https://github.com/raysan5/raylib/blob/7f8bf2233c29ebbd98566962bb3730095b11a4e2/src/raymath.h#L1790
 */
class FlxSprite3D extends FlxSprite {
	public var angle3D(default, null):Vector3D;

	override function initVars() {
		super.initVars();
		angle3D = new Vector3D(0, 0, 0);
	}

	override function set_angle(Value:Float):Float {
		angle3D.z = Value;
		return super.set_angle(Value);
	}

	override function drawFrameComplex(frame:FlxFrame, camera:FlxCamera) {
		//super.drawFrameComplex(frame, camera);
		frame.prepareMatrix(_matrix, FlxFrameAngle.ANGLE_0, checkFlipX(), checkFlipY());
		_matrix.translate(-origin.x, -origin.y);

		var _animOffset:FlxPoint = animation.curAnim?.offset ?? FlxPoint.weak();
		if (frameOffsetAngle != null && frameOffsetAngle != angle3D.z) {
			var angleOff = (-angle3D.z + frameOffsetAngle) * FlxAngle.TO_RAD;
			_matrix.rotate(-angleOff);
			_matrix.translate(-(frameOffset.x + _animOffset.x), -(frameOffset.y + _animOffset.y));
			_matrix.rotate(angleOff);
		} else
			_matrix.translate(-(frameOffset.x + _animOffset.x), -(frameOffset.y + _animOffset.y));

		if (bakedRotationAngle <= 0) {
			updateTrig();

			rotateXYZ(angle3D);

			//https://math.stackexchange.com/questions/62182/how-do-i-rotate-a-matrix-transformation-with-a-centered-origin
			var xr:Float = -(_matrix.a * origin.x + _matrix.c * origin.y) + origin.x;
			var yr:Float = -(_matrix.b * origin.x + _matrix.d * origin.y) + origin.y;

			_matrix.translate(xr, yr);
		}

		_matrix.scale(scale.x, scale.y);

		getScreenPosition(_point, camera).subtract(offset);
		_point.add(origin.x, origin.y);
		_matrix.translate(_point.x, _point.y);

		if (isPixelPerfectRender(camera)) {
			_matrix.tx = Math.floor(_matrix.tx);
			_matrix.ty = Math.floor(_matrix.ty);
		}

		camera.drawPixels(_frame, framePixels, _matrix, colorTransform, blend, antialiasing, shader);
		_animOffset.putWeak();
	}

	/**
	 * Rotates a matrix based on X Y and Z angles
	 * @param angle 
	 * @see https://github.com/raysan5/raylib/blob/7f8bf2233c29ebbd98566962bb3730095b11a4e2/src/raymath.h#L1790
	 */
	private function rotateXYZ(angle:Vector3D) {
		var cosz:Float = Math.cos(FlxAngle.asRadians(-angle.z - frame.angle));
		var sinz:Float = Math.sin(FlxAngle.asRadians(-angle.z - frame.angle));

		var cosy:Float = Math.cos(FlxAngle.asRadians(-angle.y));
		var siny:Float = Math.sin(FlxAngle.asRadians(-angle.y));

		var cosx:Float = Math.cos(FlxAngle.asRadians(-angle.x));
		var sinx:Float = Math.sin(FlxAngle.asRadians(-angle.x));

		_matrix.a = cosz * cosy;
		_matrix.b = (cosz * siny * sinx) - (sinz * cosx);

		_matrix.c = sinz * cosy;
		_matrix.d = (sinz * siny * sinx) + (cosz * cosx);
	}
}
