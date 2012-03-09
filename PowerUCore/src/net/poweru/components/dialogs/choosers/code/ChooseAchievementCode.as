package net.poweru.components.dialogs.choosers.code
{
	import mx.controls.DataGrid;
	import mx.events.FlexEvent;
	
	import net.poweru.components.dialogs.BaseDialog;
	import net.poweru.components.dialogs.choosers.interfaces.IChooser;
	import net.poweru.model.DataSet;
	import net.poweru.utils.SortedDataSetFactory;
	
	public class ChooseAchievementCode extends BaseDialog implements IChooser
	{
		[Bindable]
		public var grid:DataGrid;
		
		public function ChooseAchievementCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function populate(data:Array, ...args):void
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
			grid.dataProvider = SortedDataSetFactory.singleFieldSort('name');
		}
	}
}