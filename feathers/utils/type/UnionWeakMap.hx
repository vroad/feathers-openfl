package feathers.utils.type;
import haxe.ds.WeakMap;

class UnionWeakMap<V>
{
	private var strMap:WeakMap<String, V> = new WeakMap();
	private var objMap:WeakMap<{}, V> = new WeakMap();

	public function new()
	{
	}
	
	public function get(key:Dynamic):V
	{
		if (Std.is(key, String))
			return strMap.get(key);
		else
			return objMap.get(key);
	}
	
	public function set(key:Dynamic, value:V)
	{
		if (Std.is(key, String))
			strMap.set(key, value);
		else
			objMap.set(key, value);
	}
	
	public function remove(key:Dynamic)
	{
		if (Std.is(key, String))
			strMap.remove(key);
		else
			objMap.remove(key);
	}
	
}