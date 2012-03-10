package net.poweru.components.student.code
{
	import net.poweru.components.code.BasePopulatedComponentCode;
	import net.poweru.components.interfaces.IArrayPopulatedComponent;
	import net.poweru.model.DataSet;
	import net.poweru.utils.SortedDataSetFactory;
	
	public class FileDownloadAssignmentsCode extends BasePopulatedComponentCode implements IArrayPopulatedComponent
	{
		public function FileDownloadAssignmentsCode()
		{
			super();
		}
		
		override protected function getNewDataSet():DataSet
		{
			return SortedDataSetFactory.singleFieldSort('name');
		}
	}
}