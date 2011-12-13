package net.poweru.components.dialogs.code
{
	import mx.controls.TextArea;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.generated.model.Achievement.NameInput;
	
	public class EditAchievementCode extends BaseCRUDDialog implements IEditDialog
	{
		public var nameInput:NameInput;
		public var descriptionInput:TextArea;
		protected var pk:Number;
		
		public function EditAchievementCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function clear():void
		{
			nameInput.text = '';
			descriptionInput.text = '';
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			nameInput.text = data['name'];
			descriptionInput.text = data['description'];
		}
		
		override public function getData():Object
		{
			return {
				'id' : pk,
				'component_achievements' : [],
				'name' : nameInput.text,
				'description' : descriptionInput.text
			};
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			focusManager.setFocus(nameInput);
			validators = [nameInput.validator];
		}
	}
}