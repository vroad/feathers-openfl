package feathers.examples.todos;
class TodoItem
{
	public function TodoItem(description:String, isCompleted:Bool = false)
	{
		this.description = description;
		this.isCompleted = isCompleted;
	}

	public var description:String;
	public var isCompleted:Bool;
}
