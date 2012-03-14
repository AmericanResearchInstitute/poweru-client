package net.poweru.components.dialogs.code
{
	import mx.controls.TextArea;
	import mx.events.FlexEvent;
	import mx.validators.Validator;
	
	import net.poweru.components.dialogs.BaseCRUDDialog;
	import net.poweru.components.interfaces.ICreateDialog;
	import net.poweru.components.interfaces.ICreateVenue;
	import net.poweru.components.widgets.AddressInput;
	import net.poweru.generated.interfaces.IGeneratedTextInput;
	
	public class CreateVenueCode extends BaseCRUDDialog implements ICreateVenue
	{
		public var nameInput:IGeneratedTextInput;
		public var phoneInput:IGeneratedTextInput;
		public var contactInput:IGeneratedTextInput;
		public var hoursInput:IGeneratedTextInput;
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
		
		override public function clear():void
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