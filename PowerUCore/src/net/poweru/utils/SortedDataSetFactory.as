package net.poweru.utils
{
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	
	import net.poweru.model.DataSet;

	public class SortedDataSetFactory
	{
		public function SortedDataSetFactory()
		{
		}
		
		/*	Return a DataSet which sorts the specified field name with default
			sorting options. This uses the compareFunction from Sort, which is
			fairly generic and should auto-detect the type. */
		public static function singleFieldSort(fieldName:String):DataSet
		{
			var ret:DataSet = new DataSet();
			ret.sort = new Sort();
			ret.sort.fields = [new NestedSortField(fieldName)];
			return ret;
		}
	}
}