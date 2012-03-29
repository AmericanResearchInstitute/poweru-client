package net.poweru.components.parts.code
{
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.controls.DataGrid;
	import mx.events.FlexEvent;
	
	import net.poweru.Places;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.utils.SortedDataSetFactory;
	
	public class UserFiltersCode extends VBox
	{
		public static var filterObjects:Array = [
			{'name': 'Group', 'constraint' : null},
			{'name': 'Status', 'constraint' : null},
			{'name': 'Credential', 'constraint' : null},
			{'name': 'Achievement', 'constraint' : null},
			{'name': 'Organization', 'constraint' : null},
			{'name': 'Org Role', 'constraint' : null}
		];
		
		[Bindable]
		public var availableGrid:DataGrid;
		[Bindable]
		public var activeGrid:DataGrid;
		[Bindable]
		protected var availableDataSet:DataSet;
		[Bindable]
		protected var activeDataSet:DataSet;
		
		public function UserFiltersCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		protected function launchChooser(filterName:String):void
		{
			switch (filterName)
			{
				case 'Group':
					dispatchEvent(new ViewEvent(ViewEvent.SHOWDIALOG, Places.CHOOSEGROUP, null, true));
					break;
					
				case 'Achievement':
					dispatchEvent(new ViewEvent(ViewEvent.SHOWDIALOG, Places.CHOOSEACHIEVEMENT, null, true));
					break;
			}
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			availableDataSet = SortedDataSetFactory.singleFieldSort('name');
			availableDataSet.source = filterObjects;
			availableDataSet.refresh();
			activeDataSet = SortedDataSetFactory.singleFieldSort('name');
		}
		
		protected function onClickActivate(event:MouseEvent):void
		{
			
		}
		
		protected function onClickRemove(event:MouseEvent):void
		{
			var item:Object = activeGrid.selectedItem;
			if (item != null)
			{
				activeDataSet.removeItemAt(activeDataSet.getItemIndex(item));
				activeDataSet.refresh();
				item.constraint = null;
				availableDataSet.addItem(item);
				availableDataSet.refresh();
			}
		}
	}
}