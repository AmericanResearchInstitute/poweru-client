package net.poweru.components.student.code
{
	import mx.containers.HBox;
	import mx.controls.DataGrid;
	import mx.controls.List;
	import mx.events.FlexEvent;
	
	import net.poweru.components.interfaces.IArrayPopulatedComponent;
	import net.poweru.model.DataSet;
	
	public class ExamAssignmentsCode extends HBox implements IArrayPopulatedComponent
	{
		[Bindable]
		public var grid:DataGrid;
		public var attemptList:List;
		
		public function ExamAssignmentsCode()
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