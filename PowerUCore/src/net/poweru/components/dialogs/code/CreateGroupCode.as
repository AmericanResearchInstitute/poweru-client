package net.poweru.components.dialogs.code
{
	import net.poweru.components.interfaces.ICreateDialog;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	
	import mx.events.FlexEvent;
	
	import net.poweru.generated.interfaces.IGeneratedTextInput;

	public class CreateGroupCode extends BaseCRUDDialog implements ICreateDialog
	{
		public var nameInput:IGeneratedTextInput;
		
		public function CreateGroupCode()
		{
			super();
		}
		
		override public function getData():Object
		{
			return {'name' : nameInput.text};
		}
		
		public function clear():void
		{
			nameInput.text = '';
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			focusManager.setFocus(nameInput);
			validators = [nameInput.validator];
		}
		
	}
}