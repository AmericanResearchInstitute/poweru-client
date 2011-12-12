package net.poweru.components.code
{
	import mx.containers.HBox;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.DataGrid;
	import mx.events.FlexEvent;
	
	import net.poweru.components.interfaces.IAchievements;
	import net.poweru.model.DataSet;
	
	public class AchievementsCode extends HBox implements IAchievements
	{
		[Bindable]
		public var grid:DataGrid;
		
		public function AchievementsCode()
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