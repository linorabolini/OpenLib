package openlib.ebook.action;
import flash.Assets;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.Lib;
import openlib.entity.SpriteEntity;
import openlib.entity.BitmapEntity;
import openlib.entityManager;
import openlib.tasks.Func;
import openlib.tasks.Task;
import openlib.ui.UIUtil;

/**
 * ...
 * @author Carlos Baute
 */
 typedef CreateBitmapActionFormat = {
	id:String,
	layer:String,
	position: { x:Float, y:Float },
	root:String,
	visible:Bool
 }
 
class CreateBitmapAction extends Func
{
	
	private static var centerAdjust = 0;

	public function new(data:CreateBitmapActionFormat) 
	{
		super(cast createBitmap, data);
		
		ActionFormatUtil.fixDefaults(data);
	}
	
	private function createBitmap(data:CreateBitmapActionFormat):Void {
		var container = cast(EntityManager.getEntity(data.layer, "layers"), SpriteEntity);
		
		var bitmap = new Bitmap(Assets.getBitmapData(data.root));
		var bitmapSprite = new Sprite();
		bitmapSprite.addChild(bitmap);
		var bitmapSpriteEntity = new SpriteEntity();
		bitmapSpriteEntity.addChild(bitmapSprite);
		
		var dataClone = { x: data.position.x, y: data.position.y };
		
		bitmapSpriteEntity.x = dataClone.x / UIUtil.getHeightRatio();
		bitmapSpriteEntity.y = dataClone.y / UIUtil.getHeightRatio();
		
		if (!data.visible)
		{
			bitmapSpriteEntity.visible = false;
			bitmapSpriteEntity.alpha = 0;
		}
		
		EntityManager.addEntity(data.id, bitmapSpriteEntity);
		container.addChild(bitmapSpriteEntity);
	}
}