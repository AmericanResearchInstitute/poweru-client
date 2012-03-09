package net.poweru.components.code
{
	import mx.containers.HBox;
	import mx.controls.DataGrid;
	import mx.events.FlexEvent;
	
	import net.poweru.components.interfaces.IArrayPopulatedComponent;
	import net.poweru.utils.SortedDataSetFactory;
	
	public class MessageTemplatesCode extends HBox implements IArrayPopulatedComponent
	{
		[Bindable]
		public var grid:DataGrid;
		
		public function MessageTemplatesCode()
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
			grid.dataProvider = SortedDataSetFactory.singleFieldSort('message_type.name');
		}
	}
}