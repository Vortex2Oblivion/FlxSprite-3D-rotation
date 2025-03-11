package;

import Math.*;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.math.FlxAngle;
import flixel.math.FlxMatrix;
import flixel.math.FlxPoint;
import openfl.Vector;
import openfl.geom.Matrix3D;
import openfl.geom.Vector3D;

class FlxSprite3D extends FlxSprite {
	public var angle3D:Vector3D;

	override function initVars() {
		super.initVars();
		angle3D = new Vector3D(0, 0, 0);
	}

	override function set_angle(angle:Float):Float {
		angle3D.z = angle;
		return super.set_angle(angle);
	}

	override function drawComplex(camera:FlxCamera) {
		_frame.prepareMatrix(_matrix, FlxFrameAngle.ANGLE_0, checkFlipX(), checkFlipY());
		if (bakedRotationAngle <= 0) {
			updateTrig();

			rotateXYZ(angle3D);
		}

		
		_matrix.translate(-origin.x, -origin.y);
		

		var _animOffset:FlxPoint = animation.curAnim?.offset ?? FlxPoint.weak();
		if (frameOffsetAngle != null && frameOffsetAngle != angle) {
			var angleOff = (-angle + frameOffsetAngle) * FlxAngle.TO_RAD;
			_matrix.rotate(-angleOff);
			_matrix.translate(-(frameOffset.x + _animOffset.x), -(frameOffset.y + _animOffset.y));
			_matrix.rotate(angleOff);
		} else
			_matrix.translate(-(frameOffset.x + _animOffset.x), -(frameOffset.y + _animOffset.y));

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
	 * Converts a 3D matrix to a 2D matrix
	 * @param m 
	 * @see https://github.com/Dot-Stuff/flxanimate/blob/7da385ca7fd8d8067aac03bc39798d37c5598e45/flxanimate/geom/FlxMatrix3D.hx#L43
	 */
	private inline function toMatrix(m:Matrix3D) {
		return new FlxMatrix(m.rawData[0], m.rawData[1], m.rawData[4], m.rawData[5], m.rawData[12], m.rawData[13]);
	}

	/**
	 * Converts a 2D matrix to a 3D matrix
	 * @param m 
	 * @see https://github.com/Dot-Stuff/flxanimate/blob/7da385ca7fd8d8067aac03bc39798d37c5598e45/flxanimate/geom/FlxMatrix3D.hx#L48
	 */
	public static function fromMatrix(m:FlxMatrix) {
		return new Matrix3D(new Vector([m.a, m.b, 0.0, m.c, m.d, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, m.tx, m.ty, 0.0, 0.0, 1.0]));
	}

	/**
	 * Rotates a matrix based on X Y and Z angles
	 * @param angle 
	 * @see https://github.com/raysan5/raylib/blob/7f8bf2233c29ebbd98566962bb3730095b11a4e2/src/raymath.h#L1790
	 */
	private function rotateXYZ(angle:Vector3D) {
		var cosz:Float = cos(FlxAngle.asRadians(-angle.z));
		var sinz:Float = sin(FlxAngle.asRadians(-angle.z));

		var cosy:Float = cos(FlxAngle.asRadians(-angle.y));
		var siny:Float = sin(FlxAngle.asRadians(-angle.y));

		var cosx:Float = cos(FlxAngle.asRadians(-angle.x));
		var sinx:Float = sin(FlxAngle.asRadians(-angle.x));

		_matrix.a = cosz * cosy;
		_matrix.b = (cosz * siny * sinx) - (sinz * cosx);

		_matrix.c = sinz * cosy;
		_matrix.d = (sinz * siny * sinx) + (cosz * cosx);
	}
}
