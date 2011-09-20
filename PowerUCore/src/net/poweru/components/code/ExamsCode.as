package net.poweru.components.code
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.controls.AdvancedDataGrid;
	import mx.events.FlexEvent;
	
	import net.poweru.components.interfaces.IExams;
	import net.poweru.model.DataSet;
	
	public class ExamsCode extends HBox implements IExams
	{
		[Bindable]
		public var grid:AdvancedDataGrid;
		
		public function ExamsCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function populate(exams:Array):void
		{
			grid.dataProvider.source = exams;
			grid.dataProvider.refresh();
		}
		
		public function clear():void
		{
			populate([]);
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			grid.dataProvider = new ArrayCollection();
		}
	}
}