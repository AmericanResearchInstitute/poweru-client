package net.poweru.components.code
{
	import mx.controls.CheckBox;
	import mx.controls.DataGrid;
	import mx.controls.List;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	
	import net.poweru.components.interfaces.IVenues;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.utils.SortedDataSetFactory;
	
	public class VenuesCode extends BaseComponent implements IVenues
	{
		[Bindable]
		public var grid:DataGrid;
		[Bindable]
		public var roomList:List;
		[Bindable]
		public var blackoutGrid:DataGrid;
		[Bindable]
		public var showInactiveInput:CheckBox;
		[Bindable]
		protected var addressString:String;
		
		
		public function VenuesCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		public function populate(data:Array):void
		{
			grid.dataProvider.source = data;
			grid.dataProvider.refresh();
			roomList.dataProvider.source = [];
			roomList.dataProvider.refresh();
			addressString = '';
		}
		
		public function clear():void
		{
			populate([]);
			setBlackoutPeriods([]);
			roomList.dataProvider.source = [];
			roomList.dataProvider.refresh();
			addressString = '';
		}
		
		public function setBlackoutPeriods(data:Array):void
		{
			blackoutGrid.dataProvider.source = data;
			blackoutGrid.dataProvider.refresh();
		}
		
		public function setRooms(data:Array):void
		{
			if (grid.selectedItem != null)
			{
				var dataMatchesCurrentSelection:Boolean = true;
				var currentID:Number = grid.selectedItem['id'];
				
				// make sure data we receive is the data we currently want
				for each (var item:Object in data)
				{
					if (item['venue'] != currentID)
					{
						dataMatchesCurrentSelection = false;
						break;
					}
				}
				
				if (dataMatchesCurrentSelection)
				{
					var currentData:DataSet = new DataSet(roomList.dataProvider.toArray());
					currentData.mergeData(data);
					roomList.dataProvider.source = currentData.toArray();
					roomList.dataProvider.refresh();
				}
			}
		}
		
		protected function filterInactive(item:Object):Boolean
		{
			if (showInactiveInput != null && showInactiveInput.selected == true)
				return true;
			else
				return !(item.hasOwnProperty('active') && item.active == false);
		}
		
		protected function onVenueSelected(event:ListEvent):void
		{
			roomList.dataProvider.source = [];
			roomList.dataProvider.refresh();
			blackoutGrid.dataProvider.source = [];
			blackoutGrid.dataProvider.refresh();
			dispatchEvent(new ViewEvent(ViewEvent.FETCH, (event.target as DataGrid).selectedItem['id']));
			
			var address:Object = grid.selectedItem.address;
			addressString = address.label + '\n' + address.locality + ', ' + address.region + ' ' + address.postal_code + ' ' + address.country;
		}
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			grid.dataProvider = SortedDataSetFactory.singleFieldSort('name');
			grid.dataProvider.filterFunction = filterInactive;
			roomList.dataProvider = SortedDataSetFactory.singleFieldSort('name');
			roomList.dataProvider.filterFunction = filterInactive;
			blackoutGrid.dataProvider = SortedDataSetFactory.singleFieldDateSort('start');
		}
	}
}