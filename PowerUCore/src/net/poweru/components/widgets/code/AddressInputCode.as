package net.poweru.components.widgets.code
{
	import mx.containers.VBox;
	import mx.controls.TextArea;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.validators.StringValidator;
	
	import net.poweru.generated.model.Address.CountryInput;
	import net.poweru.generated.model.Address.LocalityInput;
	import net.poweru.generated.model.Address.PostalCodeInput;
	import net.poweru.generated.model.Address.RegionInput;
	
	public class AddressInputCode extends VBox
	{
		public var labelInput:TextArea;
		public var localityInput:LocalityInput;
		public var regionInput:RegionInput;
		public var postalCodeInput:PostalCodeInput;
		public var countryInput:CountryInput;
		
		public var validators:Array = [];
		
		public function AddressInputCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			(countryInput.validator as StringValidator).minLength = 2;
			countryInput.text = 'US';
			
			validators = [
				localityInput.validator,
				regionInput.validator,
				postalCodeInput.validator,
				countryInput.validator
			];
		}
		
		public function get addressDict():Object
		{
			return {
				'label' : labelInput.text,
				'locality' : localityInput.text,
				'region' : regionInput.text,
				'postal_code' : postalCodeInput.text,
				'country' : countryInput.text
			};
		}
		
		public function clear():void
		{
			labelInput.text = '';
			localityInput.text = '';
			regionInput.text = '';
			postalCodeInput.text = '';
			countryInput.text = 'US';
		}
	}
}