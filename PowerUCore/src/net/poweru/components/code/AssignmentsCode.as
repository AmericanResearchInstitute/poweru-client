package net.poweru.components.code
{
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;

	public class AssignmentsCode extends BasePopulatedComponentCode
	{
		public function AssignmentsCode()
		{
			super();
		}
		
		protected function labelFromUser(item:Object, column:AdvancedDataGridColumn):String
		{
			return item['user'][column.dataField] as String;
		}
		
		protected function labelFromTask(item:Object, column:AdvancedDataGridColumn):String
		{
			return item['task'][column.dataField] as String;
		}
	}
}