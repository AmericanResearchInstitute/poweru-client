package net.poweru.components.dialogs.code
{
	import mx.controls.DataGrid;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseDialog;
	import net.poweru.components.interfaces.IReportDialog;
	import net.poweru.model.DataSet;
	
	public class BulkAssignmentResultsCode extends BaseDialog implements IReportDialog
	{
		public var grid:DataGrid;
		
		public function BulkAssignmentResultsCode()
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
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			grid.dataProvider = new DataSet();
		}
	}
}