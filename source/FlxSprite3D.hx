package;

import flixel.FlxG;
import flixel.util.FlxDestroyUtil;
import lime.math.Vector2;
import flixel.math.FlxMatrix;
import flixel.graphics.frames.FlxFrame;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import openfl.geom.Vector3D;

/**
 * Performs 3D rotations on a 2D FlxSprite
 * Also has skew capabilities (2D)
 * @see https://math.stackexchange.com/questions/62182/how-do-i-rotate-a-matrix-transformation-with-a-centered-origin
 * @see https://github.com/raysan5/raylib/blob/7f8bf2233c29ebbd98566962bb3730095b11a4e2/src/raymath.h#L1790
 * @author Vortex
 */
class FlxSprite3D extends FlxSprite {

	/**
	 * The 3D angle of the sprite.
	 */
	public var angle3D(default, null):Vector3D;

	/**
	 * The 2D skew of the sprite.
	 */
	public var skew(default, null):FlxPoint;
	
	private var _rotationMatrix(default, null):FlxMatrix;
	private var _skewMatrix(default, null):FlxMatrix;

	override function initVars() {
		super.initVars();
		_rotationMatrix = new FlxMatrix();
		_skewMatrix = new FlxMatrix();
		angle3D = new Vector3D();
		skew = FlxPoint.get();
	}

	override function set_angle(Value:Float):Float {
		angle3D.z = Value;
		return super.set_angle(Value);
	}

	override function destroy() {
		skew = FlxDestroyUtil.put(skew);
		angle3D = null;
		_skewMatrix = null;
		_rotationMatrix = null;
		super.destroy();
	}

	override function drawFrameComplex(frame:FlxFrame, camera:FlxCamera) {
		final matrix = this._matrix; // TODO: Just use local?
		frame.prepareMatrix(matrix, FlxFrameAngle.ANGLE_0, checkFlipX(), checkFlipY());
		if (bakedRotationAngle <= 0) {
			updateTrig();

			if (angle != 0) {
				matrix.rotateWithTrig(_cosAngle, _sinAngle);
			}
			if (skew.x != 0 || skew.y != 0) {
				_skewMatrix.b = Math.tan(skew.y * FlxAngle.TO_RAD);
				_skewMatrix.c = Math.tan(skew.x * FlxAngle.TO_RAD);
				//_skewMatrix.d = Math.tan(skew3D.z * FlxAngle.TO_RAD);
			}
			// https://math.stackexchange.com/questions/62182/how-do-i-rotate-a-matrix-transformation-with-a-centered-origin
			// offset
			var xr:Float = -(matrix.a * origin.x + matrix.c * origin.y) + origin.x;
			var yr:Float = -(matrix.b * origin.x + matrix.d * origin.y) + origin.y;
			matrix.translate(-xr, -yr);
			rotateXYZ(angle3D);
			matrix.concat(_skewMatrix);
			// move back after doing rotations
			xr = -(matrix.a * origin.x + matrix.c * origin.y) + origin.x;
			yr = -(matrix.b * origin.x + matrix.d * origin.y) + origin.y;
			matrix.translate(xr, yr);
		}
		matrix.translate(-origin.x, -origin.y);
		var _animOffset:FlxPoint = animation.curAnim?.offset ?? FlxPoint.weak();
		if (frameOffsetAngle != null && frameOffsetAngle != angle) {
			var angleOff = (-angle + frameOffsetAngle) * FlxAngle.TO_RAD;
			matrix.rotate(-angleOff);
			matrix.translate(-(frameOffset.x + _animOffset.x), -(frameOffset.y + _animOffset.y));
			matrix.rotate(angleOff);
		} else
			matrix.translate(-(frameOffset.x + _animOffset.x), -(frameOffset.y + _animOffset.y));
		matrix.scale(scale.x, scale.y);

		getScreenPosition(_point, camera).subtract(offset);
		_point.add(origin.x, origin.y);
		matrix.translate(_point.x, _point.y);

		if (isPixelPerfectRender(camera)) {
			matrix.tx = Math.floor(matrix.tx);
			matrix.ty = Math.floor(matrix.ty);
		}

		camera.drawPixels(frame, framePixels, matrix, colorTransform, blend, antialiasing, shader);
		_animOffset.putWeak();
	}

	/**
	 * Rotates a matrix based on X Y and Z angles
	 * @param angle 
	 * @see https://github.com/raysan5/raylib/blob/7f8bf2233c29ebbd98566962bb3730095b11a4e2/src/raymath.h#L1790
	 */
	private function rotateXYZ(angle:Vector3D) {
		var cosz:Float = Math.cos(FlxAngle.asRadians(-angle.z));
		var sinz:Float = Math.sin(FlxAngle.asRadians(-angle.z));

		var cosy:Float = Math.cos(FlxAngle.asRadians(-angle.y));
		var siny:Float = Math.sin(FlxAngle.asRadians(-angle.y));

		var cosx:Float = Math.cos(FlxAngle.asRadians(-angle.x));
		var sinx:Float = Math.sin(FlxAngle.asRadians(-angle.x));

		_rotationMatrix.a = cosz * cosy;
		_rotationMatrix.b = (cosz * siny * sinx) - (sinz * cosx);

		_rotationMatrix.c = sinz * cosy;
		_rotationMatrix.d = (sinz * siny * sinx) + (cosz * cosx);
		_matrix.concat(_rotationMatrix);
	}
}
