package net.poweru.components.dialogs.code
{
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateDialog;
	import net.poweru.generated.model.Achievement.NameInput;
	
	public class CreateAchievementCode extends BaseCRUDDialog implements ICreateDialog
	{
		public var nameInput:NameInput;
		public var descriptionInput:TextArea;
		
		public function CreateAchievementCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function clear():void
		{
			nameInput.text = '';
			descriptionInput.text = '';
		}
		
		override public function getData():Object
		{
			return {
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