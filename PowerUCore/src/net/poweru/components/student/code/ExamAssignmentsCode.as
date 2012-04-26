package net.poweru.components.student.code
{
	import flash.events.Event;
	
	import net.poweru.components.code.BasePopulatedComponentCode;
	import net.poweru.components.student.interfaces.IExamAssignments;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.utils.SortedDataSetFactory;
	
	public class ExamAssignmentsCode extends BasePopulatedComponentCode implements IExamAssignments
	{
		[Bindable]
		protected var examSessions:DataSet;
		
		public function ExamAssignmentsCode()
		{
			super();
			init();
		}
		
		private function init():void
		{
			examSessions = SortedDataSetFactory.singleFieldDateSort('date_completed');
		}
		
		public function setExamSessions(data:Array):void
		{
			examSessions.source = data;
			examSessions.refresh();
		}
		
		override public function populate(data:Array):void
		{
			super.populate(data);
			setExamSessions([]);
		}
		
		override protected function getNewDataSet():DataSet
		{
			return SortedDataSetFactory.singleFieldSort('name');
		}
		
		protected function onExamSelected(event:Event):void
		{
			if (grid.selectedItem != null)
			{
				setExamSessions([]);
				dispatchEvent(new ViewEvent(ViewEvent.FETCH, grid.selectedItem));
			}
		}
	}
}