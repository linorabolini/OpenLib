package openlib.animation.spritesheet;

typedef SpriteSheetFormat = {
	frames:Array<SpriteSheetFrame>,
	meta:SpriteSheetMetaData,
}

typedef SpriteSheetFrame = {
	filename:String,
	frame:SourceSize,
	rotated:Bool,
	trimmed:Bool,
	spriteSourceSize:SourceSize,
	sourceSize:Size,
}

typedef SourceSize = {
	x:Int,
	y:Int,
	w:Int,
	h:Int,
}

typedef SpriteSheetMetaData = {
	app:String,
	version:String,
	image:String,
	format:String,
	size:Size,
	scale: Int,
}

typedef Size = {
	w:Int,
	h:Int,
}