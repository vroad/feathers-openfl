package feathers.utils.geom;
import openfl.geom.Matrix;

class FeathersMatrixUtil
{

/**
 * Extracts the rotation value (in radians) from a <code>openfl.geom.Matrix</code>
 *
 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/geom/Matrix.html openfl.geom.Matrix
 */
public static function matrixToRotation(matrix:Matrix):Float
{
	var c:Float = matrix.c;
	var d:Float = matrix.d;
	return -Math.atan(c / d);
}

/**
 * Extracts the x scale value from a <code>openfl.geom.Matrix</code>
 *
 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/geom/Matrix.html openfl.geom.Matrix
 */
public static function matrixToScaleX(matrix:Matrix):Float
{
	var a:Float = matrix.a;
	var b:Float = matrix.b;
	return Math.sqrt(a * a + b * b);
}

/**
 * Extracts the y scale value from a <code>openfl.geom.Matrix</code>
 *
 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/geom/Matrix.html openfl.geom.Matrix
 */
public static function matrixToScaleY(matrix:Matrix):Float
{
	var c:Float = matrix.c;
	var d:Float = matrix.d;
	return Math.sqrt(c * c + d * d);
}

	
}