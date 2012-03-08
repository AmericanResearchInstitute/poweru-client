package net.poweru.tests.components.parts
{
	import net.poweru.components.parts.NestedDataGridColumn;
	
	import org.flexunit.Assert;

	public class TestNestedDataGridColumn
	{
		protected var column:NestedDataGridColumn;
		protected static const ITEM:Object = {
			'user' : {'status' : 'active'}
		};
		
		public function TestNestedDataGridColumn()
		{
		}
		
		[Before]
		public function setUp():void
		{
			column = new NestedDataGridColumn();
			column.nestedName = 'user.status';
		}
		
		[After]
		public function tearDown():void
		{
			column = null;
		}
		
		[Test(description='test NestedDataGridColumn.itemToLabel()')]
		public function testItemToLabel():void
		{
			var ret:String = column.itemToLabel(ITEM);
			Assert.assertEquals(ret, 'active');
		}
	}
}