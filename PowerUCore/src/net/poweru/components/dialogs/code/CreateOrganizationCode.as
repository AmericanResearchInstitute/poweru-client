package net.poweru.components.dialogs.code
{
	import mx.controls.TextInput;
	
	import net.poweru.Places;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateDialog;
	import net.poweru.model.ChooserResult;

	public class CreateOrganizationCode extends BaseCRUDDialog implements ICreateDialog
	{
		public var nameInput:TextInput;
		[Bindable]
		protected var chosenOrganization:Object;
		
		public function CreateOrganizationCode()
		{
			super();
		}
		
		override public function getData():Object
		{
			var ret:Object = {'name' : nameInput.text};
			if (chosenOrganization != null)
				ret['parent'] = chosenOrganization.id;
			return ret;
		}
		
		override public function clear():void
		{
			nameInput.text = '';
			chosenOrganization = null;
		}
		
		override public function receiveChoice(choice:ChooserResult, chooserName:String):void
		{
			if (chooserName == Places.CHOOSEORGANIZATION && chooserRequestTracker.doIWantThis(chooserName, choice.requestID))
				chosenOrganization = choice.value;
		}
		
	}
}