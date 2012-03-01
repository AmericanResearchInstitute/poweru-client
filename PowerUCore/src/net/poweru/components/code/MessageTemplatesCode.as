package net.poweru.components.code
{
	import mx.containers.HBox;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.events.FlexEvent;
	
	import net.poweru.components.interfaces.IArrayPopulatedComponent;
	import net.poweru.model.DataSet;
	
	public class MessageTemplatesCode extends HBox implements IArrayPopulatedComponent
	{
		[Bindable]
		public var grid:AdvancedDataGrid;
		
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
		
		protected function labelFromMessageType(item:Object, column:AdvancedDataGridColumn):String
		{
			return item['message_type'][column.dataField] as String;
		}
		
		protected function labelFromMessageFormat(item:Object, column:AdvancedDataGridColumn):String
		{
			return item['message_format'][column.dataField] as String;
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			grid.dataProvider = new DataSet();
		}
	}
}