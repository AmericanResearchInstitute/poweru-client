package net.poweru.components.dialogs.code
{
	import mx.events.FlexEvent;
	import mx.validators.Validator;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.IEditDialog;
	import net.poweru.components.widgets.AddressInput;
	import net.poweru.generated.model.Venue.ContactInput;
	import net.poweru.generated.model.Venue.HoursOfOperationInput;
	import net.poweru.generated.model.Venue.NameInput;
	import net.poweru.generated.model.Venue.PhoneInput;
	
	public class EditVenueCode extends BaseCRUDDialog implements IEditDialog
	{
		public var nameInput:NameInput;
		public var phoneInput:PhoneInput;
		public var contactInput:ContactInput;
		public var hoursInput:HoursOfOperationInput;
		public var addressInput:AddressInput;
		
		protected var pk:Number;
		
		public function EditVenueCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function clear():void
		{
			nameInput.text = '';
			phoneInput.text = '';
			contactInput.text = '';
			hoursInput.text = '';
			addressInput.clear();
		}
		
		override public function getData():Object
		{
			return {
				'id' : pk,
				'name' : nameInput.text,
				'phone' : phoneInput.text,
				'contact' : contactInput.text,
				'hours_of_operation' : hoursInput.text,
				'address' : addressInput.addressDict
			}
		}
		
		public function populate(data:Object, ...args):void
		{
			var categoryChoices:Array = args[0];
			
			pk = data['id'];
			nameInput.text = data['name'];
			phoneInput.text = data['phone'];
			contactInput.text = data['contact'];
			hoursInput.text = data['hours_of_operation'];
			addressInput.populate(data['address']);
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