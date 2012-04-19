package net.poweru.components.code
{
	import mx.formatters.DateFormatter;
	
	import net.poweru.components.interfaces.ICurriculumEnrollments;
	import net.poweru.model.DataSet;
	import net.poweru.utils.SortedDataSetFactory;
	
	public class CurriculumEnrollmentsCode extends BasePopulatedComponentCode implements ICurriculumEnrollments
	{
		[Bindable]
		public var dateFormatter:DateFormatter;
		
		public function CurriculumEnrollmentsCode()
		{
			super();
			dateFormatter = new DateFormatter();
			dateFormatter.formatString = "MM/DD/YYYY";
		}
		
		override protected function getNewDataSet():DataSet
		{
			return SortedDataSetFactory.singleFieldDateSort('start');
		}
		
		protected function formatName(item:Object):String
		{
			var ret:String = '';
			ret += item.last_name;
			ret += ', ';
			ret += item.first_name;
			return ret;
		}
	}
}