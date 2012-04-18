package net.poweru.components.dialogs.code
{
	import mx.controls.DateField;
	import mx.utils.ObjectUtil;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.utils.PKArrayCollection;
	
	public class EditCredentialCode extends BaseCRUDDialog implements IEditDialog
	{
		public var expirationInput:DateField;
		
		[Bindable]
		protected var credential:Object;
		
		public function EditCredentialCode()
		{
			super();
			validators = [];
		}
		
		public function populate(data:Object, ...args):void
		{
			
			credential = data;
			expirationInput.selectedDate = data.date_expires;
		}
		
		override public function clear():void
		{
			credential = null;
			expirationInput.selectedDate = null;
		}
		
		override public function getData():Object
		{
			return {
				'id': credential.id,
				'date_expires' : expirationInput.selectedDate
			};
		}
	}
}