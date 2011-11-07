package net.poweru.components.dialogs.code
{
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateDialog;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	
	public class CreateSessionUserRoleCode extends BaseCRUDDialog implements ICreateDialog
	{
		public var nameInput:IGeneratedTextInput;
		
		public function CreateSessionUserRoleCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function clear():void
		{
			nameInput.text = '';
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			validators = [nameInput.validator];
			focusManager.setFocus(nameInput);
		}
		
		override public function getData():Object
		{
			return {'name' : nameInput.text};
		}
	}
}