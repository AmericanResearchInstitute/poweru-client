package net.poweru.components.dialogs.code
{
	import mx.controls.TextArea;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateDialog;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	
	public class CreateCurriculumCode extends BaseCRUDDialog implements ICreateDialog
	{
		[Bindable]
		public var nameInput:IGeneratedTextInput;
		public var descriptionInput:TextArea;
		
		public function CreateCurriculumCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function getData():Object
		{
			return {
				'name' : nameInput.text,
				'description' : descriptionInput.text,
				'organization' : null
			};
		}
		
		override public function clear():void
		{
			nameInput.text = '';
			descriptionInput.text = '';
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			focusManager.setFocus(nameInput);
			validators = [nameInput.validator];
		}
	}
}