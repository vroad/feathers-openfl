package feathers.utils.type;
// http://jasono.co/2014/01/09/accept-either-string-or-int-without-resorting-to-dynamic/
// http://try.haxe.org/#b6b6a

abstract AcceptEither<A,B> (Either<A,B>) {
	
	public inline function new( e:Either<A,B> ) this = e;
	
	public var value(get,never):Dynamic;
	public var type(get,never):Either<A,B>;

	inline function get_value() switch this { case Left(v) | Right(v): return v; }
	@:to inline function get_type() return this;
	
	@:from static function fromA<A,B>( v:A ):AcceptEither<A,B> return new AcceptEither( Left(v) );
	@:from static function fromB<A,B>( v:B ):AcceptEither<A,B> return new AcceptEither( Right(v) );
}

enum Either<A,B> {
  Left( v:A );
  Right( v:B );
}