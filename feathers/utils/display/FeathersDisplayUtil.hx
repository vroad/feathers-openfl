package feathers.utils.display;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Stage;

class FeathersDisplayUtil
{

/**
 * Calculates a scale value to maintain aspect ratio and fill the required
 * bounds (with the possibility of cutting of the edges a bit).
 */
public static function calculateScaleRatioToFill(originalWidth:Float, originalHeight:Float, targetWidth:Float, targetHeight:Float):Float
{
	var widthRatio:Float = targetWidth / originalWidth;
	var heightRatio:Float = targetHeight / originalHeight;
	if(widthRatio > heightRatio)
	{
		return widthRatio;
	}
	return heightRatio;
}

/**
 * Calculates a scale value to maintain aspect ratio and fit inside the
 * required bounds (with the possibility of a bit of empty space on the
 * edges).
 */
public static function calculateScaleRatioToFit(originalWidth:Float, originalHeight:Float, targetWidth:Float, targetHeight:Float):Float
{
	var widthRatio:Float = targetWidth / originalWidth;
	var heightRatio:Float = targetHeight / originalHeight;
	if(widthRatio < heightRatio)
	{
		return widthRatio;
	}
	return heightRatio;
}

/**
 * Calculates how many levels deep the target object is on the display list,
 * starting from the Starling stage. If the target object is the stage, the
 * depth will be <code>0</code>. A direct child of the stage will have a
 * depth of <code>1</code>, and it increases with each new level. If the
 * object does not have a reference to the stage, the depth will always be
 * <code>-1</code>, even if the object has a parent.
 */
public static function getDisplayObjectDepthFromStage(target:DisplayObject):Int
{
	if(target.stage == null)
	{
		return -1;
	}
	var count:Int = 0;
	while(target.parent != null)
	{
		target = target.parent;
		count++;
	}
	return count;
}

public static function stageToStarling(stage:Stage):Starling
{
	for (starling in Starling.all)
	{
		if(starling.stage == stage)
		{
			return starling;
		}
	}
	return null;
}
	
}