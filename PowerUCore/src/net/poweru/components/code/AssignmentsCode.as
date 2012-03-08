package net.poweru.components.code
{
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	
	import net.poweru.model.DataSet;
	import net.poweru.utils.SortedDataSetFactory;

	public class AssignmentsCode extends BasePopulatedComponentCode
	{
		public function AssignmentsCode()
		{
			super();
		}
		
		override protected function getNewDataSet():DataSet
		{
			return SortedDataSetFactory.singleFieldSort('user.last_name');
		}
	}
}