package openlib.ebook.action;

import openlib.entity.SpriteEntity;
import openlib.entityManager;
import openlib.tasks.Task;
import openlib.ui.UIUtil;

typedef SetAttributesActionFormat = {
	id:String,
	values:Dynamic
}

class SetAttributesAction extends Task
{
	
	private var data:SetAttributesActionFormat;
	
	public function new(data:SetAttributesActionFormat)
	{
		super();
		this.data = data;
	}

	/**
	 * @inheritDoc
	 */
	public override function start():Void
	{
		super.start();
		
		var item:Dynamic = EntityManager.getEntity(data.id);
		
		for (field in Reflect.fields(data.values))
		{
			var value = Reflect.getProperty(data.values, field);
			
			if (field == "x")
				value = UIUtil.percToPixelX(value);
			if (field == "y")
				value = UIUtil.percToPixelY(value);
			
			Reflect.setProperty(item, field, value);
		}

		super.taskComplete();
	}
	
}
