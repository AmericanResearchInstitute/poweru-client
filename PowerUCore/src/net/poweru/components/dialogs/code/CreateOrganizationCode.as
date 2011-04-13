package net.poweru.components.dialogs.code
{
	import net.poweru.components.interfaces.ICreateDialog;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	
	import mx.controls.TextInput;

	public class CreateOrganizationCode extends BaseCRUDDialog implements ICreateDialog
	{
		public var nameInput:TextInput;
		
		public function CreateOrganizationCode()
		{
			super();
		}
		
		override public function getData():Object
		{
			return {'name' : nameInput.text};
		}
		
		public function clear():void
		{
		}
		
	}
}