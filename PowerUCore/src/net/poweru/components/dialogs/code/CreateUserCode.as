package net.poweru.components.dialogs.code
{
	import net.poweru.components.interfaces.ICreateDialog;
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.widgets.TitleComboBox;
	import net.poweru.model.DataSet;
	
	import mx.controls.ComboBox;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import net.poweru.generated.interfaces.IGeneratedTextInput;

	public class CreateUserCode extends BaseCRUDDialog implements ICreateDialog
	{
		public var first:IGeneratedTextInput;
		public var last:IGeneratedTextInput;
		public var email:IGeneratedTextInput;
		public var titleInput:TitleComboBox;
		public var phone:TextInput;
		[Bindable]
		public var password:TextInput;
		public var username:IGeneratedTextInput;
		public var statusInput:ComboBox;
		
		
		public function CreateUserCode()
		{
			super();
		}
		
		override public function getData():Object
		{
			return {
				'first_name' : first.text,
				'last_name' : last.text,
				'email' : email.text,
				'title' : titleInput.text,
				'phone' : phone.text,
				'username' : username.text,
				'password' : password.text,
				'status' : statusInput.selectedItem
			};
		}
		
		override public function clear():void
		{
			first.text = '';
			last.text = '';
			titleInput.text = '';
			email.text = '';
			phone.text = '';
			username.text = '';
			password.text = '';
			statusInput.selectedItem = null;
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			focusManager.setFocus(titleInput);
			
			statusInput.dataProvider = new DataSet();
			
			validators.push(first.validator, last.validator, email.validator, username.validator);
		}
		
		override public function setChoices(choices:Object):void
		{
			super.setChoices(choices);
			statusInput.dataProvider.source = choices['status'];
			statusInput.dataProvider.refresh();
		}
	}
}