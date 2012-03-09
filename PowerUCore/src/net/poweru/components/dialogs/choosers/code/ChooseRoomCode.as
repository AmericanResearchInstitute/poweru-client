package net.poweru.components.dialogs.choosers.code
{
	import flash.events.Event;
	
	import mx.controls.AdvancedDataGrid;
	import mx.controls.List;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;
	
	import net.poweru.components.dialogs.BaseDialog;
	import net.poweru.components.dialogs.choosers.interfaces.IChooseRoom;
	import net.poweru.components.dialogs.choosers.interfaces.IChooser;
	import net.poweru.events.ViewEvent;
	import net.poweru.model.DataSet;
	import net.poweru.utils.SortedDataSetFactory;
	
	public class ChooseRoomCode extends BaseDialog implements IChooseRoom
	{
		[Bindable]
		public var grid:AdvancedDataGrid;
		[Bindable]
		public var roomList:List;
		
		[Bindable]
		protected var addressString:String;
		[Bindable]
		protected var session:Object;
		
		
		public function ChooseRoomCode()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
		}
		
		//	args[0] must be a session object
		public function populate(data:Array, ...args):void
		{
			grid.dataProvider.source = data;
			grid.dataProvider.refresh();
			session = args[0];
			roomList.dataProvider.source = [];
			roomList.dataProvider.refresh();
		}
		
		public function clear():void
		{
			populate([]);
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
		
		protected function onCreationComplete(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			
			grid.dataProvider = SortedDataSetFactory.singleFieldSort('name');
			roomList.dataProvider = SortedDataSetFactory.singleFieldSort('name');
		}
		
		protected function onVenueSelected(event:ListEvent):void
		{
			roomList.dataProvider.source = [];
			roomList.dataProvider.refresh();
			dispatchEvent(new ViewEvent(ViewEvent.FETCH, (event.target as AdvancedDataGrid).selectedItem['rooms']));
			
			var address:Object = grid.selectedItem.address;
			addressString = address.label + '\n' + address.locality + ', ' + address.region + ' ' + address.postal_code + ' ' + address.country;
		}
	}
}