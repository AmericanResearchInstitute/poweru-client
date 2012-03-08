package net.poweru.tests.components.parts
{
	import net.poweru.components.parts.NestedAdvancedDataGridColumn;
	import net.poweru.model.DataSet;
	
	import org.flexunit.Assert;

	public class TestNestedAdvancedDataGridColumn
	{
		protected var column:NestedAdvancedDataGridColumn;
		protected static const ITEM:Object = {
			'user' : {'status' : 'active'}
		};
		
		public function TestNestedAdvancedDataGridColumn()
		{
		}
		
		[Before]
		public function setUp():void
		{
			column = new NestedAdvancedDataGridColumn();
			column.nestedName = 'user.status';
		}
		
		[After]
		public function tearDown():void
		{
			column = null;
		}
		
		[Test(description='test NestedAdvancedDataGridColumn.itemToLabel()')]
		public function testItemToLabel():void
		{
			var ret:String = column.itemToLabel(ITEM);
			Assert.assertEquals(ret, 'active');
		}
	}
}