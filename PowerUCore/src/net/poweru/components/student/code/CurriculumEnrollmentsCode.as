package net.poweru.components.student.code
{
	import flash.events.Event;
	
	import mx.containers.HBox;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.FlexEvent;
	
	import net.poweru.components.code.BaseComponent;
	import net.poweru.components.student.interfaces.ICurriculumEnrollments;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.utils.SortedDataSetFactory;
	
	public class CurriculumEnrollmentsCode extends BaseComponent implements ICurriculumEnrollments
	{
		[Bindable]
		public var grid:AdvancedDataGrid;
		public var assignmentGrid:DataGrid;
		
		public function CurriculumEnrollmentsCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function populate(data:Array):void
		{
			grid.dataProvider.source = data;
			grid.dataProvider.refresh();
			setAssignments([]);
		}
		
		public function clear():void
		{
			populate([]);
			setAssignments([]);
		}
		
		public function setAssignments(data:Array):void
		{
			assignmentGrid.dataProvider.source = data;
			assignmentGrid.dataProvider.refresh();
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			grid.dataProvider = SortedDataSetFactory.singleFieldDateSort('start');
			assignmentGrid.dataProvider = SortedDataSetFactory.singleFieldSort('name');
		}
		
		protected function onSelect(event:Event):void
		{
			dispatchEvent(new ViewEvent(ViewEvent.FETCH, grid.selectedItem['id']));
		}
	}
}