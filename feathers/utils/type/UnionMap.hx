package feathers.utils.type;

class UnionMap<V>
{
	private var strMap:Map<String, V> = new Map();
	private var objMap:Map<{}, V> = new Map();

	public function new()
	{
	}
	
	public function get(key:Dynamic):V
	{
		if (Std.is(key, String))
			return strMap[key];
		else if (key != null)
			return objMap[key];
		else
			return null;
	}
	
	public function set(key:Dynamic, value:V):Void
	{
		if (Std.is(key, String))
			strMap[key] = value;
		else if (key != null)
			objMap[key] = value;
	}
	
	public function remove(key:Dynamic)
	{
		if (Std.is(key, String))
			strMap.remove(key);
		else if (key != null)
			objMap.remove(key);
	}
	
}