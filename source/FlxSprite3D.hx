package;

import math.FlxPoint3D;
import flixel.addons.effects.FlxSkewedSprite;
import flixel.util.FlxDestroyUtil;
import flixel.math.FlxMatrix;
import flixel.graphics.frames.FlxFrame;
import flixel.FlxCamera;
import flixel.math.FlxAngle;

/**
 * @see https://math.stackexchange.com/questions/62182/how-do-i-rotate-a-matrix-transformation-with-a-centered-origin
 * @see https://github.com/raysan5/raylib/blob/7f8bf2233c29ebbd98566962bb3730095b11a4e2/src/raymath.h#L1790
 */
class FlxSprite3D extends FlxSkewedSprite {
	/**
	 * The 3D angle of the sprite.
	 */
	public var angle3D(default, null):FlxPoint3D;

	private var _rotationMatrix(default, null):FlxMatrix;

	override function initVars() {
		super.initVars();
		_rotationMatrix = new FlxMatrix();
		angle3D = FlxPoint3D.get();
	}

	override function destroy() {
		angle3D = FlxDestroyUtil.put(angle3D);
		_skewMatrix = null;
		_rotationMatrix = null;
		super.destroy();
	}

	override function drawComplex(camera:FlxCamera) {
		_frame.prepareMatrix(_matrix, FlxFrameAngle.ANGLE_0, checkFlipX(), checkFlipY());

		// https://math.stackexchange.com/questions/62182/how-do-i-rotate-a-matrix-transformation-with-a-centered-origin
		// offset
		var xr:Float = -(_matrix.a * origin.x + _matrix.c * origin.y) + origin.x;
		var yr:Float = -(_matrix.b * origin.x + _matrix.d * origin.y) + origin.y;
		_matrix.translate(-xr, -yr);

		if (matrixExposed) {
			_matrix.concat(transformMatrix);
		} else {
			if (bakedRotationAngle <= 0) {
				updateTrig();

				if (angle != 0)
					_matrix.rotateWithTrig(_cosAngle, _sinAngle);
			}

			updateSkewMatrix();
			_matrix.concat(_skewMatrix);
		}

		rotateXYZ(angle3D);
		// move back after doing rotations
		xr = -(_matrix.a * origin.x + _matrix.c * origin.y) + origin.x;
		yr = -(_matrix.b * origin.x + _matrix.d * origin.y) + origin.y;
		_matrix.translate(xr, yr);

		getScreenPosition(_point, camera);
		_point -= offset;
		_point += origin;
		if (isPixelPerfectRender(camera))
			_point.floor();

		_matrix.translate(_point.x / scale.x, _point.y / scale.y);
		_matrix.translate(-origin.x, -origin.y);
		_matrix.scale(scale.x, scale.y);

		camera.drawPixels(_frame, framePixels, _matrix, colorTransform, blend, antialiasing, shader);
	}

	/**
	 * Rotates a matrix based on X Y and Z angles
	 * @param angle 
	 * @see https://github.com/raysan5/raylib/blob/7f8bf2233c29ebbd98566962bb3730095b11a4e2/src/raymath.h#L1790
	 */
	private function rotateXYZ(angle:FlxPoint3D) {
		var cosz = Math.cos(-FlxAngle.asRadians(angle.z));
		var sinz = Math.sin(-FlxAngle.asRadians(angle.z));
		var cosy = Math.cos(-FlxAngle.asRadians(angle.y));
		var siny = Math.sin(-FlxAngle.asRadians(angle.y));
		var cosx = Math.cos(-FlxAngle.asRadians(angle.x));
		var sinx = Math.sin(-FlxAngle.asRadians(angle.x));

		_rotationMatrix.a = cosz * cosy;
		_rotationMatrix.b = (cosz * siny * sinx) - (sinz * cosx);

		_rotationMatrix.c = sinz * cosy;
		_rotationMatrix.d = (sinz * siny * sinx) + (cosz * cosx);

		_matrix.concat(_rotationMatrix);
	}
}
