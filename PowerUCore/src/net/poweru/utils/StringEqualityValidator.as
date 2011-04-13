package net.poweru.utils
{
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

	public class StringEqualityValidator extends Validator
	{
		[Bindable]
		public var foreignObject:Object;
		
		[Bindable]
		public var foreignProperty:String;
		
		public function StringEqualityValidator()
		{
			super();
		}
		
		override protected function doValidation(value:Object):Array
		{
			var ret:Array = [];
			if (source[property] != foreignObject[foreignProperty])
				ret.push(new ValidationResult(true, '', '', 'Values must match.'));
			return ret;
		}
		
	}
}