/*
Feathers
Copyright 2012-2015 Bowler Hat LLC. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.utils.geom;
import openfl.geom.Matrix;

/**
 * Extracts the x scale value from a <code>openfl.geom.Matrix</code>
 *
 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/geom/Matrix.html openfl.geom.Matrix
 */
public function matrixToScaleX(matrix:Matrix):Float
{
	var a:Float = matrix.a;
	var b:Float = matrix.b;
	return Math.sqrt(a * a + b * b);
}
