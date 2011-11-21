package net.poweru.components.student.code
{
	import mx.containers.HBox;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.List;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.events.FlexEvent;
	
	import net.poweru.components.student.interfaces.IExamAssignments;
	import net.poweru.model.DataSet;
	
	public class ExamAssignmentsCode extends HBox implements IExamAssignments
	{
		[Bindable]
		public var grid:AdvancedDataGrid;
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
		
		protected function labelFromTask(item:Object, column:AdvancedDataGridColumn):String
		{
			return item.task[column.dataField];
		}
	}
}