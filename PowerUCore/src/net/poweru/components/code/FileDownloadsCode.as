package net.poweru.components.code
{
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.DataGrid;
	import mx.events.FlexEvent;
	
	import net.poweru.components.interfaces.IFileDownloads;
	
	public class FileDownloadsCode extends HBox implements IFileDownloads
	{
		[Bindable]
		public var grid:AdvancedDataGrid;
		
		public function FileDownloadsCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function populate(tasks:Array):void
		{
			grid.dataProvider.source = tasks;
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