package math;

import openfl.geom.Point;
import flixel.util.FlxPool;
import flixel.util.FlxStringUtil;
import openfl.geom.Matrix;
import openfl.geom.Vector3D;
import flixel.math.*;


/**
 * 2-dimensional Point class
 * 
 * ## Pooling
 * To avoid creating new instances, unnecessarily, used Point3Ds can be
 * for later use. Rather than creating a new instance directly, call
 * `FlxPoint3D.get(x, y)` and it will retrieve a Point from the pool, if
 * one exists, otherwise it will create a new instance. Similarly, when
 * you're done using a Point, call `myPoint3D.put()` to place it back.
 * 
 * You can disable Point pooling entirely with `FLX_NO_Point3D_POOL`.
 * 
 * ## Weak Point3Ds
 * Weak Point3Ds are Point3Ds meant for a singular use, rather than calling
 * `put` on every Point you `get`, you can create a weak Point, and have
 * it placed back once used. All `FlxPoint3D` methods and Flixel utilities
 * automatically call `putWeak()` on every Point passed in.
 * 
 * In the following example, a weak Point is created, and passed into
 * `p.degreesTo` where `putWeak` is called on it, putting it back in the pool.
 *
 * ```haxe
 * var angle = p.degreesTo(FlxPoint3D.weak(FlxG.mouse.x, FlxG.mouse.y));
 * ```
 * 
 * ## Overloaded Operators
 * 
 * - `A += B` adds the value of `B` to `A`
 * - `A -= B` subtracts the value of `B` from `A`
 * - `A *= k` scales `A` by float `k` in both x and y components
 * - `A + B` returns a new Point that is sum of `A` and `B`
 * - `A - B` returns a new Point that is difference of `A` and `B`
 * - `A * k` returns a new Point that is `A` scaled with coefficient `k`
 *
 * Note: also accepts `openfl.geom.Point`, but always returns a FlxPoint3D.
 *
 * Note: that these operators get Point3Ds from the pool, but do not put
 * Point3Ds back in the pool, unless they are weak.
 * 
 * Example: 4 total Point3Ds are created, but only 3 are put into the pool
 * ```haxe
 * var a = FlxPoint3D.get(1, 1);
 * var b = FlxPoint3D.get(1, 1);
 * var c = (a * 2.0) + b;
 * a.put();
 * b.put();
 * c.put();
 * ```
 * 
 * To put all 4 back, it should look like this:
 * ```haxe
 * var a = FlxPoint3D.get(1, 1);
 * var b = FlxPoint3D.get(1, 1);
 * var c = a * 2.0;
 * var d = c + b;
 * a.put();
 * b.put();
 * c.put();
 * d.put();
 * ```
 * 
 * Otherwise, the remainging Point3Ds will become garbage, adding to the
 * heap, potentially triggering a garbage collection when you don't want.
 */
@:forward abstract FlxPoint3D(FlxBasePoint3D) to FlxBasePoint3D from FlxBasePoint3D {
	/**
	 * Vector components less than this are considered zero, to account for rounding errors
	 */
	public static inline var EPSILON:Float = 0.0000001;

	public static inline var EPSILON_SQUARED:Float = EPSILON * EPSILON;

	/**
	 * Vector lengths less than this are considered zero, to account for rounding errors
	 */
	public static inline var EPSILON_LENGTH:Float = EPSILON * FlxMath.SQUARE_ROOT_OF_TWO;

	static var _Point3D1 = new FlxPoint3D();

	/**
	 * Recycle or create new FlxPoint3D.
	 * Be sure to put() them back into the pool after you're done with them!
	 *
	 * @param   x  The X-coordinate of the Point in space.
	 * @param   y  The Y-coordinate of the Point in space.
	 */
	public static inline function get(x:Float = 0, y:Float = 0, z:Float = 0):FlxPoint3D {
		return FlxBasePoint3D.get(x, y, z);
	}

	/**
	 * Recycle or create a new FlxPoint3D which will automatically be released
	 * to the pool when passed into a flixel function.
	 *
	 * @param   x  The X-coordinate of the Point in space.
	 * @param   y  The Y-coordinate of the Point in space.
	 * @since 4.6.0
	 */
	public static inline function weak(x:Float = 0, y:Float = 0, z:Float = 0):FlxPoint3D {
		return FlxBasePoint3D.weak(x, y, z);
	}

	/**
	 * Operator that adds two Point3Ds, returning a new Point.
	 */
	@:noCompletion
	@:op(A + B)
	static inline function plusOp(a:FlxPoint3D, b:FlxPoint3D):FlxPoint3D {
		var result = get(a.x + b.x, a.y + b.y, a.z + b.z);
		a.putWeak();
		b.putWeak();
		return result;
	}

	/**
	 * Operator that subtracts two Point3Ds, returning a new Point.
	 */
	@:noCompletion
	@:op(A - B)
	static inline function minusOp(a:FlxPoint3D, b:FlxPoint3D):FlxPoint3D {
		var result = get(a.x - b.x, a.y - b.y, a.z - b.z);
		a.putWeak();
		b.putWeak();
		return result;
	}

	/**
	 * Operator that scales a Point by float, returning a new Point.
	 */
	@:noCompletion
	@:op(A * B)
	@:commutative
	static inline function scaleOp(a:FlxPoint3D, b:Float):FlxPoint3D {
		var result = get(a.x * b, a.y * b, a.z * b);
		a.putWeak();
		return result;
	}

	/**
	 * Operator that divides a Point by float, returning a new Point.
	 */
	@:noCompletion
	@:op(A / B)
	static inline function divideOp(a:FlxPoint3D, b:Float):FlxPoint3D {
		var result = get(a.x / b, a.y / b, a.z / b);
		a.putWeak();
		return result;
	}

	/**
	 * Operator that adds the right Point to the left Point, returning the left Point instance.
	 */
	@:noCompletion
	@:op(A += B)
	static inline function plusEqualOp(a:FlxPoint3D, b:FlxPoint3D):FlxPoint3D {
		return a.add(b);
	}

	/**
	 * Operator that subtracts the right Point from the left Point, returning the left Point instance.
	 */
	@:noCompletion
	@:op(A -= B)
	static inline function minusEqualOp(a:FlxPoint3D, b:FlxPoint3D):FlxPoint3D {
		return a.subtract(b);
	}

	/**
	 * Operator that scales a Point by float, returning the same Point instance.
	 */
	@:noCompletion
	@:op(A *= B)
	static inline function scaleEqualOp(a:FlxPoint3D, b:Float):FlxPoint3D {
		return a.scale(b);
	}

	/**
	 * Operator that adds two Point3Ds, returning a new Point.
	 */
	@:noCompletion
	@:op(A + B)
	@:commutative
	static inline function plusFlashOp(a:FlxPoint3D, b:Vector3D):FlxPoint3D {
		var result = get(a.x + b.x, a.y + b.y, a.z + b.z);
		a.putWeak();
		return result;
	}

	/**
	 * Operator that subtracts two Point3Ds, returning a new Point.
	 */
	@:noCompletion
	@:op(A - B)
	static inline function minusFlashOp(a:FlxPoint3D, b:Vector3D):FlxPoint3D {
		var result = get(a.x - b.x, a.y -  b.y, a.z + b.z);
		a.putWeak();
		return result;
	}

	/**
	 * Operator that subtracts two Point3Ds, returning a new Point.
	 */
	@:noCompletion
	@:op(A - B)
	static inline function minusFlashOp2(a:Vector3D, b:FlxPoint3D):FlxPoint3D {
		var result = get(a.x - b.x, a.y - b.y, a.z - b.z);
		b.putWeak();
		return result;
	}

	/**
	 * Operator that adds the right Point to the left Point, returning the left Point instance.
	 */
	@:noCompletion
	@:op(A += B)
	static inline function plusEqualFlashOp(a:FlxPoint3D, b:Vector3D):FlxPoint3D {
		return a.add(b.x, b.y, b.z);
	}

	/**
	 * Operator that subtracts the right Point from the left Point, returning the left Point instance.
	 */
	@:noCompletion
	@:op(A -= B)
	static inline function minusEqualFlashOp(a:FlxPoint3D, b:Vector3D):FlxPoint3D {
		return a.subtract(b.x, b.y, b.z);
	}

	// Without these delegates we have to say `this.x` everywhere.
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var z(get, set):Float;

	/**
	 * The horizontal component of the unit Point
	 */
	public var dx(get, never):Float;

	/**
	 * The vertical component of the unit Point
	 */
	public var dy(get, never):Float;

	public var dz(get, never):Float;

	/**
	 * Length of the Point
	 */
	public var length(get, set):Float;

	/**
	 * length of the Point squared
	 */
	public var lengthSquared(get, never):Float;

	/**
	 * The angle formed by the Point with the horizontal axis (in degrees)
	 */
	public var degrees(get, set):Float;

	/**
	 * The angle formed by the Point with the horizontal axis (in radians)
	 */
	public var radians(get, set):Float;

	/**
	 * The horizontal component of the right normal of the Point
	 */
	public var rx(get, never):Float;

	/**
	 * The vertical component of the right normal of the Point
	 */
	public var ry(get, never):Float;

	/**
	 * The horizontal component of the left normal of the Point
	 */
	public var lx(get, never):Float;

	/**
	 * The vertical component of the left normal of the Point
	 */
	public var ly(get, never):Float;

	public inline function new(x:Float = 0, y:Float = 0, z:Float = 0) {
		this = FlxPoint3D.get(x, y, z);
	}

	/**
	 * Set the coordinates of this Point object.
	 *
	 * @param   n  The X and Y coordinate of the Point in space.
	 */
	public inline function setXYZ(n:Float):FlxPoint3D {
		return set(n, n, n);
	}

	/**
	 * Set the coordinates of this Point object.
	 *
	 * @param   x  The X-coordinate of the Point in space.
	 * @param   y  The Y-coordinate of the Point in space.
	 */
	overload public inline extern function set(x:Float, y:Float, z:Float):FlxPoint3D {
		return this.set(x, y, z);
	}

	overload public inline extern function set(x:Float, y:Float):FlxPoint3D {
		return this.set(x, y, 0);
	}

	/**
	 * Sets the x coordinate of this Point and zeroes the y coordinate.
	 *
	 * @param   x  The X-coordinate of the Point in space.
	 */
	@:deprecated("set(n) with one arg, is deprecated, use the two-arged set(n, 0), instead") // 6.2.0
	overload public inline extern function set(x:Float):FlxPoint3D {
		return set(x, 0, 0);
	}

	/**
	 * Set the coordinates of this Point to zero.
	 */
	// @:deprecated("set() with no args, is deprecated, use the two-arged set(0, 0), setXY(0) or zero(), instead")
	overload public inline extern function set():FlxPoint3D {
		return set(0, 0, 0);
	}

	/**
	 * Adds to the coordinates of this Point.
	 *
	 * @param   x  Amount to add to x
	 * @param   y  Amount to add to y
	 * @return  This Point.
	 */
	public overload extern inline function add(x:Float = 0, y:Float = 0, z:Float = 0):FlxPoint3D {
		return set(this.x + x, this.y + y, this.z + z);
	}

	/**
	 * Adds the coordinates of another Point to the coordinates of this Point.
	 * @since 6.0.0
	 *
	 * @param   Point  The Point to add to this Point
	 * @return  This Point.
	 */
	public overload inline extern function add(Point:FlxPoint3D):FlxPoint3D {
		add(Point.x, Point.y, Point.z);
		Point.putWeak();
		return this;
	}

	/**
	 * Adds the coordinates of another Point to the coordinates of this Point.
	 * @since 6.0.0
	 *
	 * @param   p  Any Point.
	 * @return  A reference to the altered Point parameter.
	 */
	public overload inline extern function add(p:Vector3D):FlxPoint3D {
		return add(p.x, p.y, p.z);
	}

	/**
	 * Adds the coordinates of another Point to the coordinates of this Point.
	 *
	 * @param   Point  The Point to add to this Point
	 * @return  This Point.
	 */
	@:deprecated("addPoint3D is deprecated, use add(Point), instead") // 6.1.2
	public inline function addPoint3D(Point:FlxPoint3D):FlxPoint3D {
		return add(Point);
	}

	/**
	 * Subtracts from the coordinates of this Point.
	 *
	 * @param   x  Amount to subtract from x
	 * @param   y  Amount to subtract from y
	 * @return  This Point.
	 */
	public overload inline extern function subtract(x:Float = 0, y:Float = 0, z:Float = 0):FlxPoint3D {
		return set(this.x - x, this.y - y, this.z - z);
	}

	/**
	 * Subtracts the coordinates of another Point from the coordinates of this Point.
	 * @since 6.0.0
	 *
	 * @param   Point  The Point to subtract from this Point
	 * @return  This Point.
	 */
	public overload inline extern function subtract(Point:FlxPoint3D):FlxPoint3D {
		subtract(Point.x, Point.y, Point.z);
		Point.putWeak();
		return this;
	}

	/**
	 * Subtracts the coordinates of another Point from the coordinates of this Point.
	 * @since 6.0.0
	 *
	 * @param   Point  The Point to subtract from this Point
	 * @return  This Point.
	 */
	public overload inline extern function subtract(point:Vector3D):FlxPoint3D {
		subtract(point.x, point.y, point.z);
		return this;
	}

	/**
	 * Subtracts the coordinates of another Point from the coordinates of this Point.
	 *
	 * @param   Point  The Point to subtract from this Point
	 * @return  This Point.
	 */
	@:deprecated("subtractPoint3D is deprecated, use subtract(Point), instead") // 6.1.2
	public inline function subtractPoint3D(Point:FlxPoint3D):FlxPoint3D {
		subtract(Point.x, Point.y, Point.z);
		Point.putWeak();
		return this;
	}

	/**
	 * Scale this Point.
	 *
	 * @param   x  The x scale coefficient
	 * @param   y  The y scale coefficient
	 * @return  this Point
	 */
	public overload inline extern function scale(x:Float, y:Float, z:Float):FlxPoint3D {
		return set(this.x * x, this.y * y, this.z * z);
	}

	/**
	 * Scale this Point.
	 * @since 6.0.0
	 *
	 * @param   amount  The scale coefficient
	 * @return  this Point
	 */
	public overload inline extern function scale(amount:Float):FlxPoint3D {
		return scale(amount, amount, amount);
	}

	/**
	 * Scale this Point by another Point.
	 * @since 6.0.0
	 *
	 * @param   Point  The x and y scale coefficient
	 * @return  this Point
	 */
	public overload inline extern function scale(Point:FlxPoint3D):FlxPoint3D {
		return scale(Point.x, Point.y, Point.z);
	}

	/**
	 * Scale this Point by another Point.
	 * @since 6.0.0
	 *
	 * @param   Point  The x and y scale coefficient
	 * @return  this Point
	 */
	public overload inline extern function scale(point:Vector3D):FlxPoint3D {
		return scale(point.x, point.y, point.z);
	}

	/**
	 * Scale this Point by another Point.
	 *
	 * @param   Point  The x and y scale coefficient
	 * @return  scaled Point
	 */
	@:deprecated("scalePoint3D is deprecated, use scale(Point), instead") // 6.1.2
	public inline function scalePoint3D(point:FlxPoint3D):FlxPoint3D {
		scale(point.x, point.y, point.z);
		point.putWeak();
		return this;
	}

	/**
	 * Returns scaled copy of this Point.
	 *
	 * @param   k - scale coefficient
	 * @return  scaled Point
	 */
	public inline function scaleNew(k:Float):FlxPoint3D {
		return clone().scale(k);
	}

	/**
	 * Return new Point which equals to sum of this Point and passed p Point.
	 *
	 * @param   p  Point to add
	 * @return  addition result
	 */
	public inline function addNew(p:FlxPoint3D):FlxPoint3D {
		return clone().add(p);
	}

	/**
	 * Returns new Point which is result of subtraction of p Point from this Point.
	 *
	 * @param   p  Point to subtract
	 * @return  subtraction result
	 */
	public inline function subtractNew(p:FlxPoint3D):FlxPoint3D {
		return clone().subtract(p);
	}

	/**
	 * Helper function, just copies the values from the specified Point.
	 *
	 * @param   p  Any FlxPoint3D.
	 * @return  A reference to itself.
	 */
	public overload inline extern function copyFrom(p:FlxPoint3D):FlxPoint3D {
		set(p.x, p.y, p.z);
		p.putWeak();
		return this;
	}

	/**
	 * Helper function, just copies the values from the specified Flash Point.
	 * @since 6.0.0
	 *
	 * @param   p  Any Point.
	 * @return  A reference to itself.
	 */
	public overload inline extern function copyFrom(p:Vector3D):FlxPoint3D {
		return set(p.x, p.y, p.z);
	}

	/**
	 * Helper function, just copies the values from the specified Flash Point.
	 *
	 * @param   p  Any Point.
	 * @return  A reference to itself.
	 */
	@:deprecated("copyFromFlash is deprecated, use copyFrom, instead") // 6.1.2
	public inline function copyFromFlash(p:Vector3D):FlxPoint3D {
		return set(p.x, p.y, p.z);
	}

	/**
	 * Helper function, just copies the values from this Point to the specified Point.
	 *
	 * @param   p  An optional Point to copy this Point to
	 * @return  The new Point
	 */
	public overload inline extern function copyTo(?p:FlxPoint3D):FlxPoint3D {
		if (p == null) {
			p = get();
		}
		return p.set(x, y, z);
	}

	/**
	 * Helper function, just copies the values from this Point to the specified Flash Point.
	 * @since 6.0.0
	 *
	 * @param   p  The Point to copy this Point to
	 * @return  The new Point
	 */
	public overload inline extern function copyTo(p:Vector3D):Vector3D {
		p.x = x;
		p.y = y;
        p.z = z;
		return p;
	}

	/**
	 * Helper function, just copies the values from this Point to the specified Flash Point.
	 *
	 * @param   p  Any Point.
	 * @return  A reference to the altered Point parameter.
	 */
	@:deprecated("copyToFlash is deprecated, use copyTo, instead") // 6.1.2
	public inline function copyToFlash(?p:Vector3D):Vector3D {
		return copyTo(p != null ? p : new Vector3D());
	}

	/**
	 * Helper function, just increases the values of the specified Flash Point by the values of this Point.
	 *
	 * @param   p  Any Point.
	 * @return  A reference to the altered Point parameter.
	 */
	public inline function addToFlash(p:Vector3D):Vector3D {
		p.x += x;
		p.y += y;
        p.z += z;

		return p;
	}

	/**
	 * Helper function, just decreases the values of the specified Flash Point by the values of this Point.
	 *
	 * @param   p  Any Point.
	 * @return  A reference to the altered Point parameter.
	 */
	public inline function subtractFromFlash(p:Vector3D):Vector3D {
		p.x -= x;
		p.y -= y;
        p.z -= z;

		return p;
	}

	/**
	 * Rounds x and y using Math.floor()
	 */
	public inline function floor():FlxPoint3D {
		return set(Math.floor(x), Math.floor(y), Math.floor(z));
	}

	/**
	 * Rounds x and y using Math.ceil()
	 */
	public inline function ceil():FlxPoint3D {
		return set(Math.ceil(x), Math.ceil(y), Math.ceil(z));
	}

	/**
	 * Rounds x and y using Math.round()
	 */
	public inline function round():FlxPoint3D {
		return set(Math.round(x), Math.round(y), Math.round(z));
	}

	/**
	 * Returns true if this Point is within the given rectangular bounds
	 *
	 * @param	x       The X value of the region to test within
	 * @param	y       The Y value of the region to test within
	 * @param	width   The width of the region to test within
	 * @param	height  The height of the region to test within
	 * @return	True if the Point is within the region, otherwise false
	 */
	public inline function inCoords(x:Float, y:Float, width:Float, height:Float):Bool {
		return FlxMath.pointInCoordinates(this.x, this.y, x, y, width, height);
	}

	/**
	 * Returns true if this Point is within the given rectangular block
	 *
	 * @param	rect	The FlxRect to test within
	 * @return	True if Point3DX/Point3DY is within the FlxRect, otherwise false
	 */
	public inline function inRect(rect:FlxRect):Bool {
		return FlxMath.pointInFlxRect(x, y, rect);
	}

	/**
	 * Rotates this Point clockwise in 2D space around another Point by the given radians.
	 * Note: To rotate a Point around 0,0 you can use `p.radians += angle`
	 * @since 5.0.0
	 *
	 * @param   pivot    The pivot you want to rotate this Point around
	 * @param   radians  Rotate the Point by this many radians clockwise.
	 * @return  A FlxPoint3D containing the coordinates of the rotated Point.
	 */
	public function pivotRadians(pivot:FlxPoint3D, radians:Float):FlxPoint3D {
		_Point3D1.copyFrom(this).subtract(pivot);
		_Point3D1.radians += radians;
		set(_Point3D1.x + pivot.x, _Point3D1.y + pivot.y, _Point3D1.z + pivot.z);
		pivot.putWeak();
		return this;
	}

	/**
	 * Rotates this Point clockwise in 2D space around another Point by the given degrees.
	 * Note: To rotate a Point around 0,0 you can use `p.degrees += angle`
	 * @since 5.0.0
	 *
	 * @param   pivot    The pivot you want to rotate this Point around
	 * @param   degrees  Rotate the Point by this many degrees clockwise.
	 * @return  A FlxPoint3D containing the coordinates of the rotated Point.
	 */
	public inline function pivotDegrees(pivot:FlxPoint3D, degrees:Float):FlxPoint3D {
		return pivotRadians(pivot, degrees * FlxAngle.TO_RAD);
	}

	/**
	 * Calculate the distance to another Point.
	 *
	 * @param   Point  A FlxPoint3D object to calculate the distance to.
	 * @return  The distance between the two Point3Ds as a Float.
	 */
	public overload inline extern function distanceTo(Point:FlxPoint3D):Float {
		final result = distanceTo(Point.x, Point.y);
		Point.putWeak();
		return result;
	}

	/**
	 * Calculate the distance to another position
	 * @since 6.0.0
	 *
	 * @return  The distance between the two positions as a Float.
	 */
	public overload inline extern function distanceTo(x:Float, y:Float):Float {
		return Math.sqrt(distanceSquaredTo(x, y));
	}

	/**
	 * Calculate the squared distance to another Point.
	 * @since 6.0.0
	 *
	 * @param   Point  A FlxPoint3D object to calculate the distance to.
	 * @return  The distance between the two Point3Ds as a Float.
	 */
	public overload inline extern function distanceSquaredTo(Point:FlxPoint3D):Float {
		final result = distanceSquaredTo(Point.x, Point.y);
		Point.putWeak();
		return result;
	}

	/**
	 * Calculate the distance to another position
	 * @since 6.0.0
	 *
	 * @return  The distance between the two positions as a Float.
	 */
	public overload inline extern function distanceSquaredTo(x:Float, y:Float):Float {
		return (this.x - x) * (this.x - x) + (this.y - y) * (this.y - y);
	}

	/**
	 * Calculates the angle from this to another Point.
	 * If the Point is straight right of this, 0 is returned.
	 * @since 5.0.0
	 *
	 * @param   Point  The other Point.
	 * @return  The angle, in radians, between -PI and PI
	 */
	public inline function radiansTo(Point:FlxPoint3D):Float {
		return FlxAngle.radiansFromOrigin(Point.x - x, Point.y - y);
	}

	/**
	 * Calculates the angle from another Point to this.
	 * If this is straight right of the Point, 0 is returned.
	 * @since 5.0.0
	 *
	 * @param   Point  The other Point.
	 * @return  The angle, in radians, between -PI and PI
	 */
	public inline function radiansFrom(Point:FlxPoint3D):Float {
		return Point.radiansTo(this);
	}

	/**
	 * Calculates the angle from this to another Point.
	 * If the Point is straight right of this, 0 is returned.
	 * @since 5.0.0
	 *
	 * @param   Point  The other Point.
	 * @return  The angle, in degrees, between -180 and 180
	 */
	public inline function degreesTo(Point:FlxPoint3D):Float {
		return FlxAngle.degreesFromOrigin(Point.x - x, Point.y - y);
	}

	/**
	 * Calculates the angle from another Point to this.
	 * If this is straight right of the Point, 0 is returned.
	 * @since 5.0.0
	 *
	 * @param   Point  The other Point.
	 * @return  The angle, in degrees, between -180 and 180
	 */
	public inline function degreesFrom(Point:FlxPoint3D):Float {
		return Point.degreesTo(this);
	}

	/**
	 * Applies transformation matrix to this Point
	 * @param   matrix  transformation matrix
	 * @return  transformed Point
	 */
	public inline function transform(matrix:Matrix):FlxPoint3D {
		var x1 = x * matrix.a + y * matrix.c + matrix.tx;
		var y1 = x * matrix.b + y * matrix.d + matrix.ty;

		return set(x1, y1);
	}

	/**
	 * Short for dot product.
	 *
	 * @param   p  Point to multiply
	 * @return  dot product of two Point3Ds
	 */
	public inline function dot(p:FlxPoint3D):Float {
		return dotProduct(p);
	}

	/**
	 * Dot product between two Point3Ds.
	 *
	 * @param   p  Point to multiply
	 * @return  dot product of two Point3Ds
	 */
	public inline function dotProduct(p:FlxPoint3D):Float {
		var dp = dotProductWeak(p);
		p.putWeak();
		return dp;
	}

	/**
	 * Dot product between two Point3Ds.
	 * Meant for internal use, does not call putWeak.
	 *
	 * @param   p  Point to multiply
	 * @return  dot product of two Point3Ds
	 */
	inline function dotProductWeak(p:FlxPoint3D):Float {
		return dotProductXY(p.x, p.y);
	}

	inline function dotProductXY(x:Float, y:Float):Float {
		return this.x * x + this.y * y;
	}

	/**
	 * Dot product of Point3Ds with normalization of the second Point.
	 *
	 * @param   p  Point to multiply
	 * @return  dot product of two Point3Ds
	 */
	public inline function dotProdWithNormalizing(p:FlxPoint3D):Float {
		final length = p.length;
		final result = length < EPSILON_LENGTH ? 0 : dotProductXY(p.x / length, p.y / length);
		p.putWeak();
		return result;
	}

	/**
	 * Check the perpendicularity of two Point3Ds.
	 *
	 * @param   p  Point to check
	 * @return  true - if they are perpendicular
	 */
	public inline function isPerpendicular(p:FlxPoint3D):Bool {
		return Math.abs(dotProduct(p)) < EPSILON_SQUARED;
	}

	/**
	 * Find the length of cross product between two Point3Ds.
	 *
	 * @param   p  Point to multiply
	 * @return  the length of cross product of two Point3Ds
	 */
	public inline function crossProductLength(p:FlxPoint3D):Float {
		var cp = crossProductLengthWeak(p);
		p.putWeak();
		return cp;
	}

	/**
	 * Find the length of cross product between two Point3Ds.
	 * Meant for internal use, does not call putWeak.
	 *
	 * @param   p  Point to multiply
	 * @return  the length of cross product of two Point3Ds
	 */
	inline function crossProductLengthWeak(p:FlxPoint3D):Float {
		return x * p.y - y * p.x;
	}

	/**
	 * Check for parallelism of two Point3Ds.
	 *
	 * @param   p  Point to check
	 * @return  true - if they are parallel
	 */
	public inline function isParallel(p:FlxPoint3D):Bool {
		var pp = isParallelWeak(p);
		p.putWeak();
		return pp;
	}

	/**
	 * Check for parallelism of two Point3Ds.
	 * Meant for internal use, does not call putWeak.
	 *
	 * @param   p  Point to check
	 * @return  true - if they are parallel
	 */
	inline function isParallelWeak(p:FlxPoint3D):Bool {
		return Math.abs(crossProductLengthWeak(p)) < EPSILON_SQUARED;
	}

	/**
	 * Check if this Point has zero length.
	 *
	 * @return  true - if the Point is zero
	 */
	public inline function isZero():Bool {
		// i.e: x*x < EPSILON_SQUARED && y*y < EPSILON_SQUARED;
		return lengthSquared < 2 * EPSILON_SQUARED;
	}

	/**
	 * Point reset
	 */
	public inline function zero():FlxPoint3D {
		return set(0, 0);
	}

	/**
	 * Normalization of the Point (reduction to unit length)
	 */
	public function normalize():FlxPoint3D {
		if (isZero()) {
			return this;
		}
		return scale(1 / length);
	}

	/**
	 * Check the Point for unit length
	 */
	public inline function isNormalized():Bool {
		return Math.abs(lengthSquared - 1) < EPSILON_SQUARED;
	}

	/**
	 * Rotate the Point for a given angle.
	 *
	 * @param   rads  angle to rotate
	 * @return  rotated Point
	 */
	public inline function rotateByRadians(rads:Float):FlxPoint3D {
		var s:Float = Math.sin(rads);
		var c:Float = Math.cos(rads);
		return set(x * c - y * s, x * s + y * c);
	}

	/**
	 * Rotate the Point for a given angle.
	 *
	 * @param   degs  angle to rotate
	 * @return  rotated Point
	 */
	public inline function rotateByDegrees(degs:Float):FlxPoint3D {
		return rotateByRadians(degs * FlxAngle.TO_RAD);
	}

	/**
	 * Rotate the Point with the values of sine and cosine of the angle of rotation.
	 *
	 * @param   sin  the value of sine of the angle of rotation
	 * @param   cos  the value of cosine of the angle of rotation
	 * @return  rotated Point
	 */
	public inline function rotateWithTrig(sin:Float, cos:Float):FlxPoint3D {
		return set(x * cos - y * sin, x * sin + y * cos);
	}

	/**
	 * Sets the polar coordinates of the Point
	 *
	 * @param   length   The length to set the Point
	 * @param   radians  The angle to set the Point, in radians
	 * @return  The rotated Point
	 * 
	 * @since 4.10.0
	 */
	public function setPolarRadians(length:Float, radians:Float):FlxPoint3D {
		return set(length * Math.cos(radians), length * Math.sin(radians));
	}

	/**
	 * Sets the polar coordinates of the Point
	 *
	 * @param   length  The length to set the Point
	 * @param   degrees The angle to set the Point, in degrees
	 * @return  The rotated Point
	 * 
	 * @since 4.10.0
	 */
	public inline function setPolarDegrees(length:Float, degrees:Float):FlxPoint3D {
		return setPolarRadians(length, degrees * FlxAngle.TO_RAD);
	}

	/**
	 * Right normal of the Point
	 */
	public function rightNormal(?p:FlxPoint3D):FlxPoint3D {
		if (p == null) {
			p = get();
		}
		p.set(rx, ry);
		return p;
	}

	/**
	 * Left normal of the Point
	 */
	public function leftNormal(?p:FlxPoint3D):FlxPoint3D {
		if (p == null) {
			p = get();
		}
		p.set(lx, ly);
		return p;
	}

	/**
	 * Change direction of the Point to opposite
	 */
	public inline function negate():FlxPoint3D {
		return set(x * -1, y * -1);
	}

	public inline function negateNew(?result:FlxPoint3D):FlxPoint3D {
		return clone(result).negate();
	}

	/**
	 * The projection of this Point to Point that is passed as an argument
	 * (without modifying the original Point!).
	 *
	 * @param   p     Point to project
	 * @param   proj  optional argument - result Point
	 * @return  projection of the Point
	 */
	public function projectTo(p:FlxPoint3D, ?proj:FlxPoint3D):FlxPoint3D {
		var dp:Float = dotProductWeak(p);
		var lenSq:Float = p.lengthSquared;

		if (proj == null) {
			proj = get();
		}

		proj.set(dp * p.x / lenSq, dp * p.y / lenSq);
		p.putWeak();
		return proj;
	}

	/**
	 * Projecting this Point on the normalized Point p.
	 *
	 * @param   p     this Point has to be normalized, ie have unit length
	 * @param   proj  optional argument - result Point
	 * @return  projection of the Point
	 */
	public function projectToNormalized(p:FlxPoint3D, ?proj:FlxPoint3D):FlxPoint3D {
		proj = projectToNormalizedWeak(p, proj);
		p.putWeak();
		return proj;
	}

	/**
	 * Projecting this Point on the normalized Point p.
	 * Meant for internal use, does not call putWeak.
	 *
	 * @param   p     this Point has to be normalized, ie have unit length
	 * @param   proj  optional argument - result Point
	 * @return  projection of the Point
	 */
	inline function projectToNormalizedWeak(p:FlxPoint3D, ?proj:FlxPoint3D):FlxPoint3D {
		var dp:Float = dotProductWeak(p);

		if (proj == null) {
			proj = get();
		}

		return proj.set(dp * p.x, dp * p.y);
	}

	/**
	 * Dot product of left the normal Point and Point p.
	 */
	public inline function perpProduct(p:FlxPoint3D):Float {
		var pp:Float = perpProductWeak(p);
		p.putWeak();
		return pp;
	}

	/**
	 * Dot product of left the normal Point and Point p.
	 * Meant for internal use, does not call putWeak.
	 */
	inline function perpProductWeak(p:FlxPoint3D):Float {
		return perpProductXY(p.x, p.y);
	}

	inline function perpProductXY(x:Float, y:Float):Float {
		return lx * x + ly * y;
	}

	/**
	 * Find the ratio between the perpProducts of this Point and p Point. This helps to find the intersection Point.
	 *
	 * @param   a  start Point of the Point
	 * @param   b  start Point of the p Point
	 * @param   p  the second Point
	 * @return  the ratio between the perpProducts of this Point and p Point
	 */
	public inline function ratio(a:FlxPoint3D, b:FlxPoint3D, p:FlxPoint3D):Float {
		var r = ratioWeak(a, b, p);
		a.putWeak();
		b.putWeak();
		p.putWeak();
		return r;
	}

	/**
	 * Find the ratio between the perpProducts of this Point and p Point. This helps to find the intersection Point.
	 * Meant for internal use, does not call putWeak.
	 *
	 * @param   a  start Point of the Point
	 * @param   b  start Point of the p Point
	 * @param   p  the second Point
	 * @return  the ratio between the perpProducts of this Point and p Point
	 */
	inline function ratioWeak(a:FlxPoint3D, b:FlxPoint3D, p:FlxPoint3D):Float {
		if (isParallelWeak(p))
			return Math.NaN;
		if (lengthSquared < EPSILON_SQUARED || p.lengthSquared < EPSILON_SQUARED)
			return Math.NaN;

		_Point3D1 = b.clone(_Point3D1);
		_Point3D1.subtract(a.x, a.y);

		return _Point3D1.perpProductWeak(p) / perpProductWeak(p);
	}

	/**
	 * Finding the Point of intersection of Point3Ds.
	 *
	 * @param   a  start Point of the Point
	 * @param   b  start Point of the p Point
	 * @param   p  the second Point
	 * @return the Point of intersection of Point3Ds
	 */
	public function findIntersection(a:FlxPoint3D, b:FlxPoint3D, p:FlxPoint3D, ?intersection:FlxPoint3D):FlxPoint3D {
		var t:Float = ratioWeak(a, b, p);

		if (intersection == null) {
			intersection = get();
		}

		if (Math.isNaN(t)) {
			intersection.set(Math.NaN, Math.NaN);
		} else {
			intersection.set(a.x + t * x, a.y + t * y);
		}

		a.putWeak();
		b.putWeak();
		p.putWeak();
		return intersection;
	}

	/**
	 * Finding the Point of intersection of Point3Ds if it is in the "bounds" of the Point3Ds.
	 *
	 * @param   a   start Point of the Point
	 * @param   b   start Point of the p Point
	 * @param   p   the second Point
	 * @return the Point of intersection of Point3Ds if it is in the "bounds" of the Point3Ds
	 */
	public function findIntersectionInBounds(a:FlxPoint3D, b:FlxPoint3D, p:FlxPoint3D, ?intersection:FlxPoint3D):FlxPoint3D {
		if (intersection == null) {
			intersection = get();
		}

		var t1:Float = ratioWeak(a, b, p);
		var t2:Float = p.ratioWeak(b, a, this);
		if (!Math.isNaN(t1) && !Math.isNaN(t2) && t1 > 0 && t1 <= 1 && t2 > 0 && t2 <= 1) {
			intersection.set(a.x + t1 * x, a.y + t1 * y);
		} else {
			intersection.set(Math.NaN, Math.NaN);
		}

		a.putWeak();
		b.putWeak();
		p.putWeak();
		return intersection;
	}

	/**
	 * Limit the length of this Point.
	 *
	 * @param   max  maximum length of this Point
	 */
	public inline function truncate(max:Float):FlxPoint3D {
		length = Math.min(max, length);
		return this;
	}

	/**
	 * Get the angle between Point3Ds (in radians).
	 *
	 * @param   p   second Point, which we find the angle
	 * @return  the angle in radians
	 */
	public inline function radiansBetween(p:FlxPoint3D):Float {
		var rads = Math.acos(dotProductWeak(p) / (length * p.length));
		p.putWeak();
		return rads;
	}

	/**
	 * The angle between Point3Ds (in degrees).
	 *
	 * @param   p   second Point, which we find the angle
	 * @return  the angle in degrees
	 */
	public inline function degreesBetween(p:FlxPoint3D):Float {
		return radiansBetween(p) * FlxAngle.TO_DEG;
	}

	/**
	 * The sign of half-plane of Point with respect to the Point through the a and b Point3Ds.
	 *
	 * @param   a  start Point of the wall-Point
	 * @param   b  end Point of the wall-Point
	 */
	public function sign(a:FlxPoint3D, b:FlxPoint3D):Int {
		var signFl:Float = (a.x - x) * (b.y - y) - (a.y - y) * (b.x - x);
		a.putWeak();
		b.putWeak();
		if (signFl == 0) {
			return 0;
		}
		return Math.round(signFl / Math.abs(signFl));
	}

	/**
	 * The distance between Point3Ds
	 * @since 6.0.0
	 */
	public overload inline extern function dist(x:Float, y:Float):Float {
		return distanceTo(x, y);
	}

	/**
	 * The distance between Point3Ds
	 */
	public overload inline extern function dist(p:FlxPoint3D):Float {
		return distanceTo(p);
	}

	/**
	 * The squared distance between Point3Ds
	 */
	public overload inline extern function distSquared(p:FlxPoint3D):Float {
		return distanceSquaredTo(p);
	}

	/**
	 * The squared distance between positions
	 * @since 6.0.0
	 */
	public overload inline extern function distSquared(x:Float, y:Float):Float {
		return distanceSquaredTo(x, y);
	}

	/**
	 * Reflect the Point with respect to the normal of the "wall".
	 *
	 * @param   normal      left normal of the "wall". It must be normalized (no checks)
	 * @param   bounceCoeff bounce coefficient (0 <= bounceCoeff <= 1)
	 * @return  reflected Point (angle of incidence equals to angle of reflection)
	 */
	public inline function bounce(normal:FlxPoint3D, bounceCoeff:Float = 1):FlxPoint3D {
		var d:Float = (1 + bounceCoeff) * dotProductWeak(normal);
		set(x - d * normal.x, y - d * normal.y);
		normal.putWeak();
		return this;
	}

	/**
	 * Reflect the Point with respect to the normal. This operation takes "friction" into account.
	 *
	 * @param   normal      left normal of the "wall". It must be normalized (no checks)
	 * @param   bounceCoeff bounce coefficient (0 <= bounceCoeff <= 1)
	 * @param   friction    friction coefficient
	 * @return  reflected Point
	 */
	public inline function bounceWithFriction(normal:FlxPoint3D, bounceCoeff:Float = 1, friction:Float = 0):FlxPoint3D {
		final dp = dotProductWeak(normal);
		final bounceX = -normal.x * dp;
		final bounceY = -normal.y * dp;
		final pp = perpProductWeak(normal);
		final frictionX = normal.rx * pp;
		final frictionY = normal.ry * pp;

		normal.putWeak();

		return set(bounceX * bounceCoeff + frictionX * friction, bounceY * bounceCoeff + frictionY * friction);
	}

	/**
	 * Checking if this is a valid Point.
	 *
	 * @return  true - if the Point is valid
	 */
	public inline function isValid():Bool {
		return !Math.isNaN(x) && !Math.isNaN(y) && Math.isFinite(x) && Math.isFinite(y);
	}

	/**
	 * Copies this Point.
	 *
	 * @param   p  An optional Point to copy this Point to
	 * @return  The new Point
	 */
	public inline function clone(?p:FlxPoint3D):FlxPoint3D {
		return copyTo(p);
	}

	inline function get_x():Float {
		return this.x;
	}

	inline function set_x(x:Float):Float {
		return this.x = x;
	}

	inline function get_y():Float {
		return this.y;
	}

	inline function set_y(y:Float):Float {
		return this.y = y;
	}

	inline function get_z():Float {
		return this.z;
	}

	inline function set_z(z:Float):Float {
		return this.z = z;
	}

	inline function get_dx():Float {
		if (isZero())
			return 0;

		return x / length;
	}

	inline function get_dy():Float {
		if (isZero())
			return 0;

		return y / length;
	}

	inline function get_dz():Float {
		if (isZero())
			return 0;

		return z / length;
	}

	inline function get_length():Float {
		return Math.sqrt(lengthSquared);
	}

	inline function set_length(l:Float):Float {
		if (!isZero()) {
			var a:Float = radians;
			set(l * Math.cos(a), l * Math.sin(a));
		}
		return l;
	}

	inline function get_lengthSquared():Float {
		return x * x + y * y;
	}

	inline function get_degrees():Float {
		return radians * FlxAngle.TO_DEG;
	}

	inline function set_degrees(degs:Float):Float {
		radians = degs * FlxAngle.TO_RAD;
		return degs;
	}

	function get_radians():Float {
		return FlxAngle.radiansFromOrigin(x, y);
	}

	inline function set_radians(rads:Float):Float {
		var len:Float = length;

		set(len * Math.cos(rads), len * Math.sin(rads));
		return rads;
	}

	inline function get_rx():Float {
		return -y;
	}

	inline function get_ry():Float {
		return x;
	}

	inline function get_lx():Float {
		return y;
	}

	inline function get_ly():Float {
		return -x;
	}
}

/**
 * The base class of FlxPoint3D, just use FlxPoint3D instead.
 * 
 * Note to contributors: don't worry about adding functionality to the base class.
 * it's all mostly inlined anyway so there's no runtime definitions for
 * reflection or anything.
 */
@:noCompletion
@:noDoc
@:allow(flixel.math.FlxPoint3D)
class FlxBasePoint3D implements IFlxPooled {
	#if FLX_Point3D_POOL
	static var pool:FlxPool<FlxBasePoint3D> = new FlxPool(FlxBasePoint3D.new.bind(0, 0, 0));
	#end

	/**
	 * Recycle or create a new FlxBasePoint3D.
	 * Be sure to put() them back into the pool after you're done with them!
	 *
	 * @param   x  The X-coordinate of the Point in space.
	 * @param   y  The Y-coordinate of the Point in space.
	 * @return  This Point.
	 */
	public static inline function get(x:Float = 0, y:Float = 0, z:Float = 0):FlxBasePoint3D {
		#if FLX_Point3D_POOL
		var Point = pool.get().set(x, y, z);
		Point._inPool = false;
		return Point;
		#else
		return new FlxBasePoint3D(x, y, z);
		#end
	}

	/**
	 * Recycle or create a new FlxBasePoint3D which will automatically be released
	 * to the pool when passed into a flixel function.
	 *
	 * @param   x  The X-coordinate of the Point in space.
	 * @param   y  The Y-coordinate of the Point in space.
	 * @return  This Point.
	 */
	public static inline function weak(x:Float = 0, y:Float = 0, z:Float = 0):FlxBasePoint3D {
		var Point = get(x, y, z);
		#if FLX_Point3D_POOL
		Point._weak = true;
		#end
		return Point;
	}

	public var x(default, set):Float = 0;
	public var y(default, set):Float = 0;
	public var z(default, set):Float = 0;

	#if FLX_POINT_POOL
	var _weak:Bool = false;
	var _inPool:Bool = false;
	#end

	@:keep
	public inline function new(x:Float = 0, y:Float = 0, z:Float = 0) {
		set(x, y, z);
	}

	/**
	 * Set the coordinates of this Point object.
	 *
	 * @param   x  The X-coordinate of the Point in space.
	 * @param   y  The Y-coordinate of the Point in space.
	 */
	public function set(x:Float = 0, y:Float = 0, z:Float = 0):FlxBasePoint3D {
		this.x = x;
		this.y = y;
		this.z = z;
		return this;
	}

	/**
	 * Add this FlxBasePoint3D to the recycling pool.
	 */
	public function put():Void {
		#if FLX_Point3D_POOL
		if (!_inPool) {
			_inPool = true;
			_weak = false;
			pool.putUnsafe(this);
		}
		#end
	}

	/**
	 * Add this FlxBasePoint3D to the recycling pool if it's a weak reference (allocated via weak()).
	 */
	public inline function putWeak():Void {
		#if FLX_Point3D_POOL
		if (_weak) {
			put();
		}
		#end
	}

	/**
	 * Function to compare this FlxBasePoint3D to another.
	 *
	 * @param   Point  The other FlxBasePoint3D to compare to this one.
	 * @return  True if the FlxBasePoint3Ds have the same x and y value, false otherwise.
	 */
	public inline function equals(Point:FlxBasePoint3D):Bool {
		var result = FlxMath.equal(x, Point.x) && FlxMath.equal(y, Point.y) && FlxMath.equal(z, Point.z);
		Point.putWeak();
		return result;
	}

	/**
	 * Necessary for IFlxDestroyable.
	 */
	public function destroy() {}

	/**
	 * Convert object to readable string name. Useful for debugging, save games, etc.
	 */
	public inline function toString():String {
		return FlxStringUtil.getDebugString([LabelValuePair.weak("x", x), LabelValuePair.weak("y", y), LabelValuePair.weak("z", z)]);
	}

	/**
	 * Necessary for FlxCallbackPoint3D.
	 */
	function set_x(Value:Float):Float {
		return x = Value;
	}

	/**
	 * Necessary for FlxCallbackPoint3D.
	 */
	function set_y(Value:Float):Float {
		return y = Value;
	}

	function set_z(Value:Float):Float {
		return z = Value;
	}
}

/**
 * A Point that, once set, cannot be changed. Useful for objects
 * that want to expose a readonly `x` and `y` value
 * @since 6.0.0
 */
@:forward
@:forward.new
abstract FlxReadOnlyPoint3D(FlxPoint3D) from FlxPoint3D {
	public var x(get, never):Float;
	public var y(get, never):Float;
	public var z(get, never):Float;

	/** Length of the Point */
	public var length(get, never):Float;

	/** The angle formed by the Point with the horizontal axis (in degrees) */
	public var degrees(get, never):Float;

	/** The angle formed by the Point with the horizontal axis (in radians) */
	public var radians(get, never):Float;

	inline function get_x():Float
		return this.x;

	inline function get_y():Float
		return this.y;

	inline function get_z():Float
		return this.z;

	inline function get_length():Float
		return this.length;

	inline function get_radians():Float
		return this.radians;

	inline function get_degrees():Float
		return this.degrees;

	// hide underlying mutators
	overload inline extern function set(x, y, z):FlxReadOnlyPoint3D
		return this.set(x, y, z);

	overload inline extern function set(x, y):FlxReadOnlyPoint3D
		return this.set(x, y);

	overload inline extern function set(x):FlxReadOnlyPoint3D
		return this.set(x);

	overload inline extern function set():FlxReadOnlyPoint3D
		return this.set();

	inline function add(x = 0, y = 0, z = 0):FlxReadOnlyPoint3D
		return this.add(x, y, z);

	inline function addPoint3D(Point):FlxReadOnlyPoint3D
		return this.add(Point);

	inline function subtract(x = 0, y = 0, z = 0):FlxReadOnlyPoint3D
		return this.subtract(x, y, z);

	inline function subtractPoint3D(Point):FlxReadOnlyPoint3D
		return this.subtract(Point);

	inline function scale(x = 0, y = 0, z = 0):FlxReadOnlyPoint3D
		return this.scale(x, y, z);

	inline function scalePoint3D(Point):FlxReadOnlyPoint3D
		return this.scale(Point);

	inline function copyFrom(Point):FlxReadOnlyPoint3D
		return this.copyFrom(Point);

	inline function copyFromFlash(Point):FlxReadOnlyPoint3D
		return this.copyFrom(Point);

	inline function floor():FlxReadOnlyPoint3D
		return this.floor();

	inline function ceil():FlxReadOnlyPoint3D
		return this.ceil();

	inline function round():FlxReadOnlyPoint3D
		return this.round();

	inline function rotate(pivot, degrees):FlxReadOnlyPoint3D
		return this.pivotDegrees(pivot, degrees);

	inline function pivotRadians(pivot, radians):FlxReadOnlyPoint3D
		return this.pivotRadians(pivot, radians);

	inline function pivotDegrees(pivot, degrees):FlxReadOnlyPoint3D
		return this.pivotDegrees(pivot, degrees);

	inline function transform(matrix):FlxReadOnlyPoint3D
		return this.transform(matrix);

	inline function zero():FlxReadOnlyPoint3D
		return this.zero();

	inline function normalize():FlxReadOnlyPoint3D
		return this.normalize();

	inline function rotateByRadians(rads):FlxReadOnlyPoint3D
		return this.rotateByRadians(rads);

	inline function rotateByDegrees(degs):FlxReadOnlyPoint3D
		return this.rotateByDegrees(degs);

	inline function rotateWithTrig(sin, cos):FlxReadOnlyPoint3D
		return this.rotateWithTrig(sin, cos);

	inline function setPolarRadians(length, radians):FlxReadOnlyPoint3D
		return this.setPolarRadians(length, radians);

	inline function setPolarDegrees(length, degrees):FlxReadOnlyPoint3D
		return this.setPolarDegrees(length, degrees);

	inline function negate():FlxReadOnlyPoint3D
		return this.negate();

	inline function truncate(max):FlxReadOnlyPoint3D
		return this.truncate(max);

	inline function bounce(normal, coeff = 1.0):FlxReadOnlyPoint3D
		return this.bounce(normal, coeff);

	inline function bounceWithFriction(normal, coeff = 1.0, friction = 0.0):FlxReadOnlyPoint3D
		return this.bounce(normal, coeff);
}

/**
 * A FlxPoint3D that calls a function when set_x(), set_y() or set() is called. Used in FlxSpriteGroup.
 * IMPORTANT: Calling set(x, y); is MUCH FASTER than setting x and y separately. Needs to be destroyed unlike simple FlxPoint3Ds!
 */
class FlxCallbackPoint3D extends FlxBasePoint3D {
	var _setXCallback:FlxPoint3D->Void;
	var _setYCallback:Null<FlxPoint3D->Void>;
	var _setZCallback:Null<FlxPoint3D->Void>;
	var _setXYCallback:Null<FlxPoint3D->Void>;
	var _setXYZCallback:Null<FlxPoint3D->Void>;

	/**
	 * If you only specify one callback function, then the remaining two will use the same.
	 *
	 * @param	setXCallback	Callback for set_x()
	 * @param	setYCallback	Callback for set_y()
	 * @param	setXYCallback	Callback for set()
	 */
	public function new(setXCallback:FlxPoint3D->Void, ?setYCallback:FlxPoint3D->Void, ?setZCallback:FlxPoint3D->Void, ?setXYCallback:FlxPoint3D->Void,
			?setXYZCallback:FlxPoint3D->Void) {
		super();

		// TODO: operator overloading?
		if (setXCallback != null && setYCallback == null && setXYCallback == null) {
			_setXYZCallback = _setXYCallback = setXCallback;
		} else {
			_setXCallback = setXCallback;
			_setYCallback = setYCallback;
			_setZCallback = setZCallback;
			_setXYCallback = setXYCallback;
			_setXYZCallback = setXYZCallback;
		}
	}

	override function set(x:Float = 0, y:Float = 0, z:Float = 0) {
		@:bypassAccessor this.x = x;
		@:bypassAccessor this.y = y;
		@:bypassAccessor this.z = z;

		if (_setXCallback != null)
			_setXCallback(this);

		if (_setYCallback != null)
			_setYCallback(this);

		if (_setZCallback != null)
			_setXCallback(this);

		if (_setXYCallback != null)
			_setXYCallback(this);
		if (_setXYZCallback != null)
			_setXYZCallback(this);
		return this;
	}

	override function set_x(value:Float):Float {
		super.set_x(value);

		if (_setXCallback != null)
			_setXCallback(this);

		if (_setXYCallback != null)
			_setXYCallback(this);

		if (_setXYZCallback != null)
			_setXYZCallback(this);

		return value;
	}

	override function set_y(value:Float):Float {
		super.set_y(value);

		if (_setYCallback != null)
			_setYCallback(this);

		if (_setXYCallback != null)
			_setXYCallback(this);

		if (_setXYZCallback != null)
			_setXYZCallback(this);

		return value;
	}

	override function set_z(value:Float):Float {
		super.set_z(value);

		if (_setZCallback != null)
			_setZCallback(this);

		if (_setXYCallback != null)
			_setXYCallback(this);

		if (_setXYZCallback != null)
			_setXYZCallback(this);

		return value;
	}

	override public function destroy():Void {
		super.destroy();
		_setXCallback = null;
		_setYCallback = null;
		_setZCallback = null;

		_setXYCallback = null;
		_setXYZCallback = null;
	}

	override public function put():Void {} // don't pool FlxCallbackPoint3Ds
}
