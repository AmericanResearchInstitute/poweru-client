package net.poweru.tests.utils
{
	import mx.collections.SortField;
	
	import net.poweru.model.DataSet;
	import net.poweru.utils.SortedDataSetFactory;
	
	import org.flexunit.Assert;

	public class TestSortedDataSetFactory
	{
		public function TestSortedDataSetFactory()
		{
		}
		
		[Test( description = 'Test SortedDataSetFactory.stringSort()' )]
		public function testStringSorted():void 
		{
			var dataSet:DataSet = SortedDataSetFactory.stringSort('name');
			Assert.assertNotNull(dataSet);
			Assert.assertNotNull(dataSet.sort);
			Assert.assertTrue(dataSet.sort.fields);
			Assert.assertEquals(dataSet.sort.fields.length, 1);
			var sortField:SortField = dataSet.sort.fields[0] as SortField;
			Assert.assertEquals(sortField.name, 'name');
		}
	}
}