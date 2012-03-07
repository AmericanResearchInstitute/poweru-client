package net.poweru.tests.validators
{
	import mx.controls.TextInput;
	import mx.events.ValidationResultEvent;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	
	import net.poweru.components.validators.URLValidator;
	
	import org.flexunit.Assert;
	import org.flexunit.runners.Parameterized;
	
	[RunWith("org.flexunit.runners.Parameterized")]
	public class TestURLValidator
	{
		public static var validURLs:Array = [
			['http://slashdot.org'],
			['http://slashdot.org/'],
			['http://slashdot.org/webcasts'],
			['https://google.com'],
			['http://openassign.org:80/'],
			['http://openassign/'],
			['http://openassign/index.php'],
			['http://openassign/index.php#marker'],
			['http://openassign/index.php?a=1&b=2'],
			['http://www.debian-administration.org/'],
		];
		
		public static var invalidURLs:Array = [
			['ftp://slashdot.org'],
			['mailto:nobody@openassign.org'],
			['http:/slashdot.org'],
			['http//slashdot.org'],
			['htt://slashdot.org'],
			['http://slashdot.org/not cool'],
			['http:\\openassign.org'],
			['lsfjdsf'],
			[' '],
			[null],
		];
		
		protected var validator:URLValidator;
		private var foo:Parameterized;
		
		public function TestURLValidator()
		{
			validator = new URLValidator();
		}
		
		[Test(dataProvider="validURLs")]
		public function testValid(url:String):void
		{
			var result:ValidationResultEvent = validator.validate(url);
			expectValid(result);
		}
		
		[Test(dataProvider="invalidURLs")]
		public function testInvalid(url:String):void
		{
			var result:ValidationResultEvent = validator.validate(url);
			expectInvalid(result);
		}
		
		protected function expectValid(resultEvent:ValidationResultEvent):void
		{
			Assert.assertNull(resultEvent.results);
		}
		
		protected function expectInvalid(resultEvent:ValidationResultEvent):void
		{
			// This should be an array with members if there are any errors present
			Assert.assertNotNull(resultEvent.results);
			Assert.assertTrue(resultEvent.results.length > 0);
			
			for each (var result:ValidationResult in resultEvent.results)
			{
				Assert.assertEquals(result.isError, true);
			}
		}
	}
}