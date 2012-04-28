package net.poweru.components.code
{
	import mx.events.ListEvent;
	import mx.formatters.DateFormatter;
	
	import net.poweru.components.interfaces.ICurriculumEnrollments;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.utils.SortedDataSetFactory;
	
	public class CurriculumEnrollmentsCode extends BasePopulatedComponentCode implements ICurriculumEnrollments
	{
		[Bindable]
		public var dateFormatter:DateFormatter;
		
		[Bindable]
		protected var tasks:DataSet;
		
		public function CurriculumEnrollmentsCode()
		{
			super();
			init();
		}
		
		private function init():void
		{
			dateFormatter = new DateFormatter();
			dateFormatter.formatString = "MM/DD/YYYY";
			tasks = SortedDataSetFactory.singleFieldSort('name');
		}
		
		public function setTasks(data:Array):void
		{
			if (tasks != null)
			{
				tasks.source = data;
				tasks.refresh();
			}
		}
		
		override public function clear():void
		{
			super.clear();
			setTasks([]);
		}
		
		override protected function getNewDataSet():DataSet
		{
			return SortedDataSetFactory.singleFieldDateSort('start');
		}
		
		protected function onChange(event:ListEvent):void
		{
			if (grid.selectedItem != null)
				dispatchEvent(new ViewEvent(ViewEvent.FETCH, grid.selectedItem.curriculum));
		}
	}
}