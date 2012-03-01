package net.poweru.components.dialogs.code
{
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseDialog;
	import net.poweru.components.interfaces.IArrayPopulatedComponent;
	import net.poweru.model.DataSet;
	
	public class TranscriptCode extends BaseDialog implements IArrayPopulatedComponent
	{
		[Bindable]
		protected var dataSet:DataSet;
		
		public function TranscriptCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function populate(data:Array):void
		{
			dataSet.source = data;
			dataSet.refresh();
		}
		
		public function clear():void
		{
			populate([]);
		}
		
		protected function getLabelFromTask(item:Object, column:DataGridColumn):String
		{
			return item['task'][column.dataField] as String;
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			dataSet = new DataSet();
		}
	}
}