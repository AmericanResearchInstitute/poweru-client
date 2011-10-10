package net.poweru.components.dialogs.code
{
	import mx.controls.TextArea;
	import mx.events.FlexEvent;
	import mx.validators.Validator;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateDialog;
	import net.poweru.components.interfaces.ICreateVenue;
	import net.poweru.components.widgets.AddressInput;
	import net.poweru.generated.model.Venue.ContactInput;
	import net.poweru.generated.model.Venue.HoursOfOperationInput;
	import net.poweru.generated.model.Venue.NameInput;
	import net.poweru.generated.model.Venue.PhoneInput;
	
	public class CreateVenueCode extends BaseCRUDDialog implements ICreateVenue
	{
		public var nameInput:NameInput;
		public var phoneInput:PhoneInput;
		public var contactInput:ContactInput;
		public var hoursInput:HoursOfOperationInput;
		public var addressInput:AddressInput;
		
		protected var regionID:Number;
		
		public function CreateVenueCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		override public function getData():Object
		{
			return {
				'name' : nameInput.text,
				'phone' : phoneInput.text,
				'contact' : contactInput.text,
				'hours_of_operation' : hoursInput.text,
				'region' : regionID,
				'address' : addressInput.addressDict
			};
		}
		
		public function clear():void
		{
			nameInput.text = '';
			phoneInput.text = '';
			contactInput.text = '';
			hoursInput.text = '';
			addressInput.clear();
		}
		
		public function setRegion(region:Object):void
		{
			regionID = region['id'];
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			focusManager.setFocus(nameInput);
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