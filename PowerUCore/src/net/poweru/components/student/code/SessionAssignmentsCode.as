package net.poweru.components.student.code
{
	import mx.containers.HBox;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.List;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	
	import net.poweru.components.student.interfaces.ISessionAssignments;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	
	public class SessionAssignmentsCode extends HBox implements ISessionAssignments
	{
		[Bindable]
		public var grid:AdvancedDataGrid;
		
		public function SessionAssignmentsCode()
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
		
		protected function labelFromSession(item:Object, column:AdvancedDataGridColumn):String
		{
			var ret:Object = item.task.session[column.dataField];
			if ((ret as Date) != null)
				return (ret as Date).toDateString();
			else
				return ret as String;
		}
	}
}