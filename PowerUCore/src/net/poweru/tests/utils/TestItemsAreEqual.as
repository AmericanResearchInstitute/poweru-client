package net.poweru.tests.utils
{
	import net.poweru.utils.ItemsAreEqual;
	
	import org.flexunit.Assert;

	[RunWith("org.flexunit.runners.Parameterized")]
	public class TestItemsAreEqual
	{
		public static var EQUAL_DATES:Array = [
			[new Date(2010, 2, 15, 9, 30), new Date(2010, 2, 15, 9, 30)],
			[new Date(2010, 2, 15, 9, 30), new Date(2010, 2, 15, 9, 30, 0)],
			[new Date(2010, 2, 15), new Date(2010, 2, 15)]
		];
		
		public static var NOT_EQUAL_DATES:Array = [
			[new Date(2010, 2, 15, 9, 30), new Date(2011, 2, 15, 9, 30)],
			[new Date(2010, 2, 15, 9, 30), new Date(2010, 3, 15, 9, 30)],
			[new Date(2010, 2, 15, 9, 30), new Date(2010, 2, 16, 9, 30)],
			[new Date(2010, 2, 15, 9, 30), new Date(2010, 2, 15, 9, 31)],
			[new Date(2010, 2, 15, 9, 30), new Date(2010, 2, 15, 9, 30, 2)],
			[new Date(2010, 2, 15, 9, 30), new Date(2010, 2, 15, 9, 30, 0, 2)],
			[new Date(2010, 2, 15), new Date(2009, 2, 15)]
		];
		
		public static var EQUAL_NUMBERS:Array = [
			[23, 23],
			[-23, -23],
			[4, 4.0],
			[0, 0]
		];
		
		public static var NOT_EQUAL_NUMBERS:Array = [
			[23, -23],
			[-23, 0],
			[0, -1],
			[4, 4.2]
		];
		
		public static var EQUAL_STRINGS:Array = [
			['hello', 'hello'],
			['', ''],
			['Hello!!!', 'Hello!!!']
		];
		
		public static var NOT_EQUAL_STRINGS:Array = [
			['hello', 'Hello'],
			['hello', 'h'],
			['Hello!!!', 'Hello'],
			['Hello', 'Hello '],
			['hello', null],
			['hello', '']
		];

		public function TestItemsAreEqual()
		{
		}
		
		[Test(dataProvider="EQUAL_DATES", description = 'Test with equal dates')]
		public function testEqualDates(date1:Date, date2:Date):void
		{
			Assert.assertTrue(ItemsAreEqual(date1, date2));
		}
		
		[Test(dataProvider="NOT_EQUAL_DATES", description = 'Test with not equal dates')]
		public function testNotEqualDates(date1:Date, date2:Date):void
		{
			Assert.assertFalse(ItemsAreEqual(date1, date2));
		}
		
		[Test(dataProvider="EQUAL_NUMBERS", description = 'Test with equal numbers')]
		public function testEqualNumbers(item1:Number, item2:Number):void
		{
			Assert.assertTrue(ItemsAreEqual(item1, item2));
		}
		
		[Test(dataProvider="NOT_EQUAL_NUMBERS", description = 'Test with not equal numbers')]
		public function testNotEqualNumbers(item1:Number, item2:Number):void
		{
			Assert.assertFalse(ItemsAreEqual(item1, item2));
		}
		
		[Test(dataProvider="EQUAL_STRINGS", description = 'Test with equal strings')]
		public function testEqualStrings(item1:String, item2:String):void
		{
			Assert.assertTrue(ItemsAreEqual(item1, item2));
		}
		
		[Test(dataProvider="NOT_EQUAL_STRINGS", description = 'Test with not equal strings')]
		public function testNotEqualStrings(item1:String, item2:String):void
		{
			Assert.assertFalse(ItemsAreEqual(item1, item2));
		}
	}
}