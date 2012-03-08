package net.poweru.tests.utils
{
	import net.poweru.utils.NestedDataUtils;
	
	import org.flexunit.Assert;

	public class TestNestedDateUtils
	{
		public var namePieces:Array = ['user', 'status'];
		public var item:Object = {'user': {'status' : 'active'}};
		
		public function TestNestedDateUtils()
		{
		}
		
		[Test(description = 'Test NestedDataUtils.getFinalObject()')]
		public function testGetFinalObject():void
		{
			var ret:String = NestedDataUtils.getFinalObject(item, namePieces) as String;
			// make sure the recursion algorithm didn't modify the original Array.
			Assert.assertEquals(namePieces.length, 2);
			Assert.assertEquals(ret, 'active');
		}
	}
}