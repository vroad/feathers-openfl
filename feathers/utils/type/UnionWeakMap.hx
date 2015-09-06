package feathers.utils.type;
import haxe.ds.WeakMap;

class UnionWeakMap<V>
{
	#if flash
	private var strMap:WeakMap<String, V> = new WeakMap();
	private var objMap:WeakMap<{}, V> = new WeakMap();
	#else
	private var strMap:Map<String, V> = new Map();
	private var objMap:Map<{}, V> = new Map();
	#end

	public function new()
	{
	}
	
	public function get(key:Dynamic):V
	{
		if (Std.is(key, String))
			return strMap.get(key);
		else if (key != null)
			return objMap.get(key);
		else
			return null;
	}
	
	public function set(key:Dynamic, value:V)
	{
		if (Std.is(key, String))
			strMap.set(key, value);
		else if (key != null)
			objMap.set(key, value);
	}
	
	public function remove(key:Dynamic)
	{
		if (Std.is(key, String))
			strMap.remove(key);
		else if (key != null)
			objMap.remove(key);
	}
	
}