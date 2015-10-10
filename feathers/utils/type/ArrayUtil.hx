package feathers.utils.type;

class ArrayUtil
{   
    public static function resize<T>(arr:Array<T>, newLength:Int, defaultValue:T = null):Void
    {
        var length:Int = arr.length;
        if (newLength < length)
            arr.splice(newLength, length - newLength);
        else if (newLength > length)
        {
            for (i in length ... newLength)
                arr[i] = defaultValue;
        }
    }
}