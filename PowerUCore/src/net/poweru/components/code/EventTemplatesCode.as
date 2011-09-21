package net.poweru.components.code
{
	import mx.containers.HBox;
	import mx.controls.AdvancedDataGrid;
	import mx.events.FlexEvent;
	
	import net.poweru.components.interfaces.IEventTemplates;
	import net.poweru.model.DataSet;
	
	public class EventTemplatesCode extends HBox implements IEventTemplates
	{
		[Bindable]
		public var grid:AdvancedDataGrid;
		
		public function EventTemplatesCode()
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