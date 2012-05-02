package net.poweru.components.dialogs.code
{
	import mx.controls.CheckBox;
	import mx.events.FlexEvent;
	import mx.validators.Validator;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.components.widgets.AddressInput;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	
	public class EditVenueCode extends BaseCRUDDialog implements IEditDialog
	{
		public var nameInput:IGeneratedTextInput;
		public var phoneInput:IGeneratedTextInput;
		public var contactInput:IGeneratedTextInput;
		public var hoursInput:IGeneratedTextInput;
		public var addressInput:AddressInput;
		[Bindable]
		public var activeInput:CheckBox;
		
		protected var activeInputWasPopulated:Boolean;
		
		protected var pk:Number;
		
		public function EditVenueCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function clear():void
		{
			nameInput.text = '';
			phoneInput.text = '';
			contactInput.text = '';
			hoursInput.text = '';
			addressInput.clear();
			activeInput.selected = true;
			activeInputWasPopulated = false;
		}
		
		override public function getData():Object
		{
			var ret:Object = {
				'id' : pk,
				'name' : nameInput.text,
				'phone' : phoneInput.text,
				'contact' : contactInput.text,
				'hours_of_operation' : hoursInput.text,
				'address' : addressInput.addressDict
			};
			if (activeInputWasPopulated)
				ret['active'] = activeInput.selected;
			return ret;
		}
		
		public function populate(data:Object, ...args):void
		{
			pk = data['id'];
			nameInput.text = data['name'];
			phoneInput.text = data['phone'];
			contactInput.text = data['contact'];
			hoursInput.text = data['hours_of_operation'];
			addressInput.populate(data['address']);
			if (data.hasOwnProperty('active'))
			{
				activeInput.selected = data['active'];
				activeInputWasPopulated = true;
			}
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			validators = [
				nameInput.validator,
				phoneInput.validator,
				contactInput.validator,
				hoursInput.validator
			];
			
			for each (var validator:Validator in addressInput.validators)
				validators.push(validator);
		}
	}
}