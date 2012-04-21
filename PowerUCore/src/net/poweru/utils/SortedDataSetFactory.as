package net.poweru.utils
{
	import com.adobe.utils.DateUtil;
	
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
			if (fieldName.length)
			{
				ret.sort = new Sort();
				ret.sort.fields = [new NestedSortField(fieldName, true)];
			}
			return ret;
		}
		
		public static function singleFieldDateSort(fieldName:String):DataSet
		{
			var ret:DataSet = new DataSet();
			ret.sort = new Sort();
			ret.sort.fields = [new NestedSortField(fieldName)];
			ret.sort.fields[0].pureCompareFunction = compareDatesFixed;
			return ret;
		}
		
		/*	This method inverts the return value of DateUtil.compareDates
			so it can be used with Flex's sort framework. */
		public static function compareDatesFixed(a:Object, b:Object):int
		{
			return -DateUtil.compareDates(a as Date, b as Date);
		}
	}
}