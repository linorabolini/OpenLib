package openlib.ebook;

typedef EBookPageFormat = {
	layers:Array<String>,
	actions:Array<Dynamic>,
	styles:Array<TextStyleManager.TextStyleFormat>,
}

typedef Obj = {
	id:String,
	layer:String,
	view:View
}

typedef View = {
	type:String,
	data:String
}

typedef ActionData = {
	type:String,
	data:Dynamic
}