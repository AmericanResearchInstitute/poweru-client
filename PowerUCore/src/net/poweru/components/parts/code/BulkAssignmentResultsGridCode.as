package net.poweru.components.parts.code
{
	import mx.containers.HBox;
	import mx.controls.DataGrid;
	import mx.events.FlexEvent;
	
	import net.poweru.model.DataSet;
	
	public class BulkAssignmentResultsGridCode extends HBox
	{
		public var results:Array;
		public var grid:DataGrid;
		
		public function BulkAssignmentResultsGridCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			grid.dataProvider = new DataSet(results);
			grid.dataProvider.refresh();
		}
	}
}