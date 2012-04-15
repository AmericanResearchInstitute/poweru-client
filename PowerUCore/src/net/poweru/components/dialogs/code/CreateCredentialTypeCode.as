package net.poweru.components.dialogs.code
{
	import mx.controls.TextArea;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateDialog;
	import net.poweru.components.widgets.DaysInput;
	import net.poweru.generated.model.CredentialType.NameInput;
	
	public class CreateCredentialTypeCode extends BaseCRUDDialog implements ICreateDialog
	{
		public var nameInput:NameInput;
		public var descriptionInput:TextArea;
		public var daysInput:DaysInput;
		
		public function CreateCredentialTypeCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function clear():void
		{
			nameInput.text = '';
			descriptionInput.text = '';
			daysInput.clear();
		}
		
		override public function getData():Object
		{
			return {
				'name' : nameInput.text,
				'duration' : daysInput.days,
				'description' : descriptionInput.text
			};
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			focusManager.setFocus(nameInput);
			validators = [
				daysInput.validator,
				nameInput.validator
			];
		}
	}
}