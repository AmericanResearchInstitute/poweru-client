package net.poweru.components.parts.code
{
	import flash.events.MouseEvent;
	
	import mx.containers.VBox;
	import mx.controls.DataGrid;
	import mx.events.FlexEvent;
	
	import net.poweru.Places;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.ChooserResult;
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
		
		protected var chosenGroup:Object;
		
		public function UserFiltersCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function receiveChoice(choice:ChooserResult, type:String):void
		{
			switch (type)
			{
				case Places.CHOOSEGROUP:
					chosenGroup = choice.value;
					var item:Object = availableDataSet.findByKey('name', 'Group');
					availableDataSet.removeByKey('name', 'Group');
					item['constraint'] = chosenGroup['name'];
					activeDataSet.addItem(item);
					activeDataSet.refresh();
					break;
			}
		}
		
		public function filterFunction(item:Object):Boolean
		{
			var ret:Boolean = filterByGroup(item);
			return ret;
		}
		
		protected function filterByGroup(item:Object):Boolean
		{
			var ret:Boolean = true;
			if (chosenGroup != null)
			{
				ret = false;
				for each (var group:Object in item.groups)
				{
					if (group.name == chosenGroup.name)
					{
						ret = true;
						break;
					}
				}
			}
			return ret;
		}
		
		protected function launchChooser(filterName:String):void
		{
			switch (filterName)
			{
				case 'Group':
					dispatchEvent(new ViewEvent(ViewEvent.FETCH, Places.CHOOSEGROUP));
					break;
			}
		}
		
		protected function removeChosenItemByName(name:String):void
		{
			switch (name)
			{
				case 'Group':
					chosenGroup = null;
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
			launchChooser(availableGrid.selectedItem.name);
		}
		
		protected function onClickRemove(event:MouseEvent):void
		{
			var item:Object = activeGrid.selectedItem;
			if (item != null)
			{
				activeDataSet.removeByKey('name', item.name);
				activeDataSet.refresh();
				removeChosenItemByName(item.name);
				item.constraint = null;
				availableDataSet.addItem(item);
				availableDataSet.refresh();
			}
		}
	}
}