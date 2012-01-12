package net.poweru.components.dialogs.code
{
	import mx.containers.TabNavigator;
	import mx.controls.DataGrid;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseDialog;
	import net.poweru.components.interfaces.IReportDialog;
	import net.poweru.components.parts.BulkAssignmentResultsGrid;
	import net.poweru.model.DataSet;
	
	public class BulkAssignmentResultsCode extends BaseDialog implements IReportDialog
	{
		public var tabNavigator:TabNavigator;
		
		public function BulkAssignmentResultsCode()
		{
			super();
		}
		
		public function populate(data:Array):void
		{
			clear();
			for each (var resultSet:Array in data)
			{
				var grid:BulkAssignmentResultsGrid = new BulkAssignmentResultsGrid();
				grid.results = resultSet;
				tabNavigator.addChild(grid);
			}
		}
		
		public function clear():void
		{
			tabNavigator.removeAllChildren();
		}
	}
}