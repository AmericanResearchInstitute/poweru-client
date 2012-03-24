package net.poweru.components.code
{
	import net.poweru.components.interfaces.ICurriculumEnrollments;
	import net.poweru.model.DataSet;
	import net.poweru.utils.SortedDataSetFactory;
	
	public class CurriculumEnrollmentsCode extends BasePopulatedComponentCode implements ICurriculumEnrollments
	{
		
		public function CurriculumEnrollmentsCode()
		{
			super();
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