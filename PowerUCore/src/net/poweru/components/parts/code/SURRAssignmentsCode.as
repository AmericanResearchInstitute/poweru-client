package net.poweru.components.parts.code
{
	import mx.containers.VBox;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	
	import net.poweru.model.DataSet;
	
	public class SURRAssignmentsCode extends VBox
	{
		public var enrollmentGrid:DataGrid;
		
		public var surr:Object;
		[Bindable]
		public var assignments:DataSet = new DataSet();
		
		public function SURRAssignmentsCode()
		{
			super();
		}
		
		protected function userLabel(item:Object, column:DataGridColumn):String
		{
			return item['user'][column.dataField] as String;
		}
	}
}