package net.poweru.components.dialogs.code
{
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseDialog;
	import net.poweru.components.interfaces.IReportDialog;
	import net.poweru.model.DataSet;
	
	public class ViewFileDownloadAssignmentsCode extends BaseDialog implements IReportDialog
	{
		public var grid:DataGrid;
		
		public function ViewFileDownloadAssignmentsCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function populate(data:Array):void
		{
			grid.dataProvider.source = data;
			grid.dataProvider.refresh();
		}
		
		public function clear():void
		{
			populate([]);
		}
		
		protected function labelFromTask(item:Object, column:DataGridColumn):String
		{
			return item['task'][column.dataField];
		}
		
		protected function userLastFirstLabel(item:Object, column:DataGridColumn):String
		{
			return item['user']['last_name'] + ', ' + item['user']['first_name'];
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			grid.dataProvider = new DataSet();
		}
	}
}