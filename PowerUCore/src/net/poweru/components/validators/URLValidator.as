package net.poweru.components.validators
{
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
	public class URLValidator extends Validator
	{
		public function URLValidator()
		{
			super();
		}
		
		override protected function doValidation(value:Object):Array
		{
			var results:Array = super.doValidation(value);
			if (value && String(value).length > 0 && !isUrl(String(value)))
			{
				results.push(new ValidationResult(true, '', 'invalidUrl', 'Invalid URL'));
			}
			return results;
		}
		
		protected function isUrl(s:String):Boolean {
			var regexp:RegExp = /https?:\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?$/;
			return regexp.test(s);
		}
	}
}