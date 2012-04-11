package net.poweru.components.dialogs.code
{
	import mx.controls.ComboBox;
	import mx.controls.TextInput;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateDialog;
	import net.poweru.components.widgets.TitleComboBox;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	import net.poweru.model.ChooserResult;
	import net.poweru.model.DataSet;

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
		
		[Bindable]
		protected var chosenOrganization:Object;
		
		
		public function CreateUserCode()
		{
			super();
		}
		
		override public function getData():Object
		{
			var ret:Object = {
				'first_name' : first.text,
				'last_name' : last.text,
				'email' : email.text,
				'title' : titleInput.text,
				'phone' : phone.text,
				'username' : username.text,
				'password' : password.text,
				'status' : statusInput.selectedItem
			};
			if (chosenOrganization != null)
				ret['organizations'] = [chosenOrganization.id];
			return ret;
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
			chosenOrganization = null;
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
		
		override public function receiveChoice(choice:ChooserResult, chooserName:String):void
		{
			if (chooserRequestTracker.doIWantThis(chooserName, choice.requestID))
				chosenOrganization = choice.value;
			else
				super.receiveChoice(choice, chooserName);
		}
	}
}