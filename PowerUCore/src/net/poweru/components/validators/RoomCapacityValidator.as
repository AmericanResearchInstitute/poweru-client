package net.poweru.components.validators
{
	import mx.validators.NumberValidator;
	import mx.validators.NumberValidatorDomainType;
	
	public class RoomCapacityValidator extends NumberValidator
	{
		public function RoomCapacityValidator()
		{
			super();
			allowNegative = false;
			minValue = 1;
			required = true;
			domain = NumberValidatorDomainType.INT;
		}
	}
}