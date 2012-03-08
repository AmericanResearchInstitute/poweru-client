package net.poweru.utils
{
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	
	import net.poweru.model.DataSet;

	public class SortedDataSetFactory
	{
		public function SortedDataSetFactory()
		{
		}
		
		/*	Return a DataSet which sorts the specified field name as a string
			with default sorting options. */
		public static function stringSort(fieldName:String):DataSet
		{
			var ret:DataSet = new DataSet();
			ret.sort = new Sort();
			ret.sort.fields = [new SortField(fieldName)];
			return ret;
		}
	}
}