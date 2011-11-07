package net.poweru.components.dialogs.code
{
	import mx.controls.TextArea;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateDialog;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	
	public class CreateExamCode extends BaseCRUDDialog implements ICreateDialog
	{
		public var nameInput:IGeneratedTextInput;
		public var titleInput:IGeneratedTextInput;
		public var descriptionInput:TextArea;
		
		public function CreateExamCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function getData():Object
		{
			return {
				'name' : nameInput.text,
				'title' : titleInput.text,
				'description' : descriptionInput.text
			};
		}
		
		public function clear():void
		{
			nameInput.text = '';
			titleInput.text = '';
			descriptionInput.text = '';
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			focusManager.setFocus(nameInput);
			validators = [nameInput.validator, titleInput.validator];
		}
	}
}