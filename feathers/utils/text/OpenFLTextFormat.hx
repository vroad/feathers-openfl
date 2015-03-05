package feathers.utils.text;
import openfl.text.TextFormatAlign;
#if flash
import openfl.text.engine.TextBaseline;
import openfl.text.engine.TextRotation;
#end

class OpenFLTextFormat
{

	public static function toOpenFLTextAlign(align:String):TextFormatAlign
	{
		switch(align)
		{
			case "center":
				return TextFormatAlign.CENTER;
			case "end":
				return TextFormatAlign.LEFT;    // Not implemented
			case "justify":
				return TextFormatAlign.JUSTIFY;
			case "left":
				return TextFormatAlign.LEFT;
			case "right":
				return TextFormatAlign.RIGHT;
			case "start":
				return TextFormatAlign.LEFT;    // Not implemented
			default:
				return TextFormatAlign.LEFT;
		}
	}
	
#if flash
	public static function toOpenFLTextBaseline(baseline:String):TextBaseline
	{
		switch(baseline)
		{
			case "roman":
				return TextBaseline.ROMAN;
			default:
				return TextBaseline.ROMAN;
		}
	}
	
	public static function toOpenFLTextRotation(textRotation:String):TextRotation
	{
		switch(textRotation)
		{
			case "rotate_0":
				return TextRotation.ROTATE_0;
			case "rotate_90":
				return TextRotation.ROTATE_90;
			case "rotate_180":
				return TextRotation.ROTATE_180;
			case "rotate_270":
				return TextRotation.ROTATE_270;
		}
	}
#end
}